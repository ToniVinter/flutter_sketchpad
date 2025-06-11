import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sketch_insert.dart';
import '../models/sketch_mode.dart';

/// Unified controller for managing multiple sketch canvases with built-in history.
/// Automatically saves state after drawing operations complete.
class MultiCanvasSketchController extends ChangeNotifier {
  MultiCanvasSketchController({
    this.initialColor = const Color(0xFF000000),
    this.initialStrokeWidth = 4.0,
    this.initialFontSize = 16.0,
    this.maxHistorySteps = 50,
    List<SketchInsert>? defaultInserts,
  }) {
    _color = initialColor;
    _strokeWidth = initialStrokeWidth;
    _fontSize = initialFontSize;

    // Load default inserts if provided
    if (defaultInserts != null) {
      _inserts.addAll(defaultInserts);
    }

    // Always save initial state to history (even if empty)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveState(_inserts);
    });
  }

  /// Configuration
  final Color initialColor;
  final double initialStrokeWidth;
  final double initialFontSize;
  final int maxHistorySteps;

  // ===== SKETCH STATE =====
  SketchMode _mode = SketchMode.none;
  late Color _color;
  late double _strokeWidth;
  late double _fontSize;

  // ===== INSERT MANAGEMENT =====
  final List<SketchInsert> _inserts = [];

  // Simple region tracking (no callbacks needed)
  final Set<String> _registeredRegions = {};

  // ===== HISTORY STATE =====
  final List<List<SketchInsert>> _history = [];
  int _historyIndex = -1;
  bool _isUndoRedoOperation = false;

  // ===== AUTO-SAVE STATE =====
  Timer? _autoSaveTimer;
  static const Duration _autoSaveDelay = Duration(milliseconds: 300);

  // ===== SKETCH GETTERS =====

  /// Current sketch mode
  SketchMode get mode => _mode;

  /// Currently selected color
  Color get selectedColor => _color;

  /// Currently selected stroke width
  double get selectedStrokeWidth => _strokeWidth;

  /// Currently selected font size
  double get selectedFontSize => _fontSize;

  // ===== INSERT GETTERS =====

  /// All current inserts (read-only)
  List<SketchInsert> get inserts => List.unmodifiable(_inserts);

  /// Get inserts for a specific section
  List<SketchInsert> getInsertsForSection(String sectionId) {
    return _inserts.where((insert) => insert.sectionId == sectionId).toList();
  }

  /// Total number of inserts
  int get insertCount => _inserts.length;

  // ===== HISTORY GETTERS =====

  /// Whether an undo operation is possible
  bool get canUndo => _historyIndex > 0;

  /// Whether a redo operation is possible
  bool get canRedo => _historyIndex < _history.length - 1;

  /// Current history index (for debugging)
  int get currentIndex => _historyIndex;

  /// Total history length (for debugging)
  int get historyLength => _history.length;

  // ===== SKETCH METHODS =====

  /// Register a region (simplified - no callbacks)
  void registerRegion(String regionId) {
    _registeredRegions.add(regionId);
  }

  /// Unregister a region
  void unregisterRegion(String regionId) {
    _registeredRegions.remove(regionId);
  }

  /// Check if a region is registered
  bool isRegionRegistered(String regionId) {
    return _registeredRegions.contains(regionId);
  }

  /// Change the current sketch mode
  void setMode(SketchMode mode) {
    _mode = mode;
    notifyListeners();
  }

  /// Change the selected color
  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }

  /// Change the selected stroke width
  void setStrokeWidth(double strokeWidth) {
    _strokeWidth = strokeWidth;
    notifyListeners();
  }

  /// Change the selected font size
  void setFontSize(double fontSize) {
    _fontSize = fontSize;
    notifyListeners();
  }

  // ===== INSERT MANAGEMENT METHODS =====

  /// Add or update an insert (upsert operation)
  void upsertInsert(SketchInsert insert) {
    final existingIndex = _inserts.indexWhere((i) => i.id == insert.id);
    if (existingIndex != -1) {
      _inserts[existingIndex] = insert;
    } else {
      _inserts.add(insert);
    }

    // Auto-save to history after drawing stops (debounced)
    if (!_isUndoRedoOperation) {
      _scheduleAutoSave();
    }
    notifyListeners();
  }

  /// Remove an insert by ID
  void removeInsert(String id) {
    _inserts.removeWhere((insert) => insert.id == id);
    notifyListeners();
  }

  /// Clear all inserts
  void clearInserts() {
    _inserts.clear();
    notifyListeners();
  }

  /// Force save current state to history (e.g., when save button is pressed)
  void saveCurrentState() {
    saveState(_inserts);
  }

  // ===== HISTORY METHODS =====

  /// Save the current state to history
  ///
  /// [inserts] - Current list of sketch inserts
  /// [skipDuplicates] - Whether to skip if the state is identical to the last saved state
  void saveState(List<SketchInsert> inserts, {bool skipDuplicates = true}) {
    // Don't save during undo/redo operations to avoid breaking the history chain
    if (_isUndoRedoOperation) return;

    // Skip if identical to last state (useful for preventing duplicate saves)
    if (skipDuplicates && _history.isNotEmpty && _historyIndex >= 0) {
      final lastState = _history[_historyIndex];
      if (_areStatesEqual(lastState, inserts)) return;
    }

    // Remove any future history if we're in the middle of the stack
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    // Add current state to history
    _history.add(List<SketchInsert>.from(inserts));
    _historyIndex++;

    // Limit history size to prevent memory issues
    if (_history.length > maxHistorySteps) {
      _history.removeAt(0);
      _historyIndex--;
    }

    notifyListeners();
  }

  /// Perform undo operation
  ///
  /// Returns the previous state, or null if undo is not possible
  List<SketchInsert>? undo() {
    if (!canUndo) return null;

    _isUndoRedoOperation = true;
    _historyIndex--;
    final state = List<SketchInsert>.from(_history[_historyIndex]);

    // Update the controller's internal state to match the history
    _inserts.clear();
    _inserts.addAll(state);

    _isUndoRedoOperation = false;

    notifyListeners();
    return state;
  }

  /// Perform redo operation
  ///
  /// Returns the next state, or null if redo is not possible
  List<SketchInsert>? redo() {
    if (!canRedo) return null;

    _isUndoRedoOperation = true;
    _historyIndex++;
    final state = List<SketchInsert>.from(_history[_historyIndex]);

    // Update the controller's internal state to match the history
    _inserts.clear();
    _inserts.addAll(state);

    _isUndoRedoOperation = false;

    notifyListeners();
    return state;
  }

  /// Clear all history
  void clearHistory() {
    _history.clear();
    _historyIndex = -1;
    notifyListeners();
  }

  /// Schedule auto-save with debouncing to avoid saving on every draw point
  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(_autoSaveDelay, () {
      if (!_isUndoRedoOperation) {
        saveState(_inserts);
      }
    });
  }

  /// Check if two states are equal (to avoid duplicate saves)
  bool _areStatesEqual(List<SketchInsert> state1, List<SketchInsert> state2) {
    if (state1.length != state2.length) return false;

    for (int i = 0; i < state1.length; i++) {
      final insert1 = state1[i];
      final insert2 = state2[i];

      // Quick comparison of key properties
      if (insert1.id != insert2.id ||
          insert1.type != insert2.type ||
          insert1.text != insert2.text ||
          insert1.textPosition != insert2.textPosition ||
          insert1.points.length != insert2.points.length) {
        return false;
      }
    }

    return true;
  }

  /// Reinitialize the entire controller state with new parameters
  ///
  /// [color] - New initial color (defaults to current initialColor)
  /// [strokeWidth] - New initial stroke width (defaults to current initialStrokeWidth)
  /// [fontSize] - New initial font size (defaults to current initialFontSize)
  /// [defaultInserts] - New default inserts to load (optional)
  void initWith({
    Color? color,
    double? strokeWidth,
    double? fontSize,
    List<SketchInsert>? defaultInserts,
  }) {
    // Cancel any pending auto-save operations
    _autoSaveTimer?.cancel();

    // Reset mode
    _mode = SketchMode.none;

    // Update state with new or existing values
    _color = color ?? initialColor;
    _strokeWidth = strokeWidth ?? initialStrokeWidth;
    _fontSize = fontSize ?? initialFontSize;

    // Clear all state
    _inserts.clear();
    _registeredRegions.clear();
    _history.clear();
    _historyIndex = -1;
    _isUndoRedoOperation = false;

    // Load new default inserts if provided
    if (defaultInserts != null) {
      _inserts.addAll(defaultInserts);
    }

    // Save initial state to history (after a frame to ensure proper initialization)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveState(_inserts);
    });

    notifyListeners();
  }

  /// Reset all settings to initial values
  void reset() {
    _mode = SketchMode.none;
    _color = initialColor;
    _strokeWidth = initialStrokeWidth;
    _fontSize = initialFontSize;
    _registeredRegions.clear();
    clearHistory();
    clearInserts();
    notifyListeners();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _history.clear();
    super.dispose();
  }
}
