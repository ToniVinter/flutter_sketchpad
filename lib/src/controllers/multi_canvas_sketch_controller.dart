import 'package:flutter/material.dart';
import '../models/sketch_insert.dart';
import '../models/sketch_mode.dart';

/// Unified controller for managing multiple sketch canvases with built-in history.
///
/// This controller combines sketch state management and history functionality
/// into a single, convenient controller for easier usage.
class MultiCanvasSketchController extends ChangeNotifier {
  MultiCanvasSketchController({
    this.initialColor = const Color(0xFF000000),
    this.initialStrokeWidth = 4.0,
    this.initialFontSize = 16.0,
    this.maxHistorySteps = 50,
    List<SketchInsert>? defaultInserts,
  }) {
    _selectedColor = initialColor;
    _selectedStrokeWidth = initialStrokeWidth;
    _selectedFontSize = initialFontSize;

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
  late Color _selectedColor;
  late double _selectedStrokeWidth;
  late double _selectedFontSize;

  // ===== INSERT MANAGEMENT =====
  final List<SketchInsert> _inserts = [];

  // Simple region tracking (no callbacks needed)
  final Set<int> _registeredRegions = {};

  // ===== HISTORY STATE =====
  final List<List<SketchInsert>> _history = [];
  int _currentIndex = -1;
  bool _isUndoRedoOperation = false;

  // ===== SKETCH GETTERS =====

  /// Current sketch mode
  SketchMode get mode => _mode;

  /// Currently selected color
  Color get selectedColor => _selectedColor;

  /// Currently selected stroke width
  double get selectedStrokeWidth => _selectedStrokeWidth;

  /// Currently selected font size
  double get selectedFontSize => _selectedFontSize;

  // ===== INSERT GETTERS =====

  /// All current inserts (read-only)
  List<SketchInsert> get inserts => List.unmodifiable(_inserts);

  /// Get inserts for a specific section
  List<SketchInsert> getInsertsForSection(int sectionIndex) {
    return _inserts
        .where((insert) => insert.sectionIndex == sectionIndex)
        .toList();
  }

  /// Total number of inserts
  int get insertCount => _inserts.length;

  // ===== HISTORY GETTERS =====

  /// Whether an undo operation is possible
  bool get canUndo => _currentIndex > 0;

  /// Whether a redo operation is possible
  bool get canRedo => _currentIndex < _history.length - 1;

  /// Current history index (for debugging)
  int get currentIndex => _currentIndex;

  /// Total history length (for debugging)
  int get historyLength => _history.length;

  // ===== SKETCH METHODS =====

  /// Register a region (simplified - no callbacks)
  void registerRegion(int regionIndex) {
    _registeredRegions.add(regionIndex);
  }

  /// Unregister a region
  void unregisterRegion(int regionIndex) {
    _registeredRegions.remove(regionIndex);
  }

  /// Check if a region is registered
  bool isRegionRegistered(int regionIndex) {
    return _registeredRegions.contains(regionIndex);
  }

  /// Change the current sketch mode
  void setMode(SketchMode mode) {
    _mode = mode;
    notifyListeners();
  }

  /// Change the selected color
  void setColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  /// Change the selected stroke width
  void setStrokeWidth(double strokeWidth) {
    _selectedStrokeWidth = strokeWidth;
    notifyListeners();
  }

  /// Change the selected font size
  void setFontSize(double fontSize) {
    _selectedFontSize = fontSize;
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

    // Automatically save to history unless this is an undo/redo operation
    if (!_isUndoRedoOperation) {
      saveState(_inserts);
    }

    notifyListeners();
  }

  /// Remove an insert by ID
  void removeInsert(String id) {
    _inserts.removeWhere((insert) => insert.id == id);

    // Automatically save to history unless this is an undo/redo operation
    if (!_isUndoRedoOperation) {
      saveState(_inserts);
    }

    notifyListeners();
  }

  /// Clear all inserts
  void clearInserts() {
    _inserts.clear();

    // Automatically save to history unless this is an undo/redo operation
    if (!_isUndoRedoOperation) {
      saveState(_inserts);
    }

    notifyListeners();
  }

  /// Force save current state to history (e.g., when save button is pressed)
  /// Note: With automatic history saving, this method is rarely needed
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
    if (skipDuplicates && _history.isNotEmpty && _currentIndex >= 0) {
      final lastState = _history[_currentIndex];
      if (_areStatesEqual(lastState, inserts)) return;
    }

    // Remove any future history if we're in the middle of the stack
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    // Add current state to history
    _history.add(List<SketchInsert>.from(inserts));
    _currentIndex++;

    // Limit history size to prevent memory issues
    if (_history.length > maxHistorySteps) {
      _history.removeAt(0);
      _currentIndex--;
    }

    notifyListeners();
  }

  /// Perform undo operation
  ///
  /// Returns the previous state, or null if undo is not possible
  List<SketchInsert>? undo() {
    if (!canUndo) return null;

    _isUndoRedoOperation = true;
    _currentIndex--;
    final state = List<SketchInsert>.from(_history[_currentIndex]);

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
    _currentIndex++;
    final state = List<SketchInsert>.from(_history[_currentIndex]);

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
    _currentIndex = -1;
    notifyListeners();
  }

  /// Check if two states are equal (to avoid duplicate saves)
  bool _areStatesEqual(List<SketchInsert> state1, List<SketchInsert> state2) {
    if (state1.length != state2.length) return false;

    // Since SketchInsert is immutable and has proper == implementation from Freezed,
    // we can use direct object comparison
    for (int i = 0; i < state1.length; i++) {
      if (state1[i] != state2[i]) return false;
    }

    return true;
  }

  /// Reset all settings to initial values
  void reset() {
    _mode = SketchMode.none;
    _selectedColor = initialColor;
    _selectedStrokeWidth = initialStrokeWidth;
    _selectedFontSize = initialFontSize;
    _registeredRegions.clear();

    // Clear history manually to avoid double notifyListeners() call
    _history.clear();
    _currentIndex = -1;

    notifyListeners();
  }

  @override
  void dispose() {
    // Clear history and other resources before calling super.dispose()
    _history.clear();
    _registeredRegions.clear();
    _inserts.clear();

    super.dispose();
  }
}
