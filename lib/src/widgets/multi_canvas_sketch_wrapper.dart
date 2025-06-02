import 'package:flutter/material.dart';
import '../controllers/multi_canvas_sketch_controller.dart';
import '../models/sketch_insert.dart';
import '../models/sketch_mode.dart';
import 'sketch_canvas.dart';
import 'sketch_toolbar.dart';
import 'dart:async';

/// A wrapper widget that provides multi-canvas annotation functionality with built-in history.
///
/// Use this wrapper with `MultiCanvasRegion` widgets anywhere below to create
/// annotation areas that share a single toolbar and automatic history management.
class MultiCanvasSketchWrapper extends StatefulWidget {
  const MultiCanvasSketchWrapper({
    required this.controller,
    required this.child,
    this.isEnabled = false,
    this.toolbarPosition = SketchToolbarPosition.bottomCenter,
    super.key,
  });

  /// The unified controller managing both sketch state and history
  final MultiCanvasSketchController controller;

  /// Child widget that contains MultiCanvasRegion widgets
  final Widget child;

  /// Whether annotation mode is currently active
  final bool isEnabled;

  /// Position of the annotation toolbar
  final SketchToolbarPosition toolbarPosition;

  @override
  State<MultiCanvasSketchWrapper> createState() =>
      _MultiCanvasSketchWrapperState();
}

class _MultiCanvasSketchWrapperState extends State<MultiCanvasSketchWrapper> {
  Timer? _historyDebounceTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _historyDebounceTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(MultiCanvasSketchWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update listener if controller changed
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() {
    // Defer setState to avoid calling it during build
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  // Handle save insert - delegate directly to controller
  void _handleSaveInsert(SketchInsert insert) {
    widget.controller.upsertInsert(insert);

    // Auto-save to history after the insert is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.saveState(widget.controller.inserts);
    });
  }

  // Handle text update - delegate directly to controller
  void _handleUpdateTextInsert(String id, String text, Offset position) {
    final insertIndex =
        widget.controller.inserts.indexWhere((insert) => insert.id == id);

    if (insertIndex != -1) {
      final updatedInsert = widget.controller.inserts[insertIndex].copyWith(
        text: text,
        textPosition: position,
      );
      widget.controller.upsertInsert(updatedInsert);

      // Smart history saving - debounce rapid updates from dragging
      _debounceHistorySave();
    }
  }

  void _debounceHistorySave() {
    // Cancel previous timer
    _historyDebounceTimer?.cancel();

    // Set new timer - only save if no updates happen for 100ms
    _historyDebounceTimer = Timer(const Duration(milliseconds: 100), () {
      widget.controller.saveState(widget.controller.inserts);
    });
  }

  Widget _buildToolbar() {
    return SketchToolbar(
      isEnabled: widget.isEnabled,
      mode: widget.controller.mode,
      initialColor: widget.controller.initialColor,
      initialStrokeWidth: widget.controller.initialStrokeWidth,
      initialFontSize: widget.controller.initialFontSize,
      onModeChanged: widget.controller.setMode,
      onColorSelected: widget.controller.setColor,
      onStrokeWidthSelected: widget.controller.setStrokeWidth,
      onFontSizeSelected: widget.controller.setFontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _MultiCanvasProvider(
      controller: widget.controller,
      multiCanvasWrapper: this,
      child: Stack(
        children: [
          widget.child,
          if (widget.isEnabled) _buildPositionedToolbar(),
        ],
      ),
    );
  }

  Widget _buildPositionedToolbar() {
    switch (widget.toolbarPosition) {
      case SketchToolbarPosition.topCenter:
        return Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(child: _buildToolbar()),
        );
      case SketchToolbarPosition.topLeft:
        return Positioned(
          top: 16,
          left: 16,
          child: _buildToolbar(),
        );
      case SketchToolbarPosition.topRight:
        return Positioned(
          top: 16,
          right: 16,
          child: _buildToolbar(),
        );
      case SketchToolbarPosition.bottomCenter:
        return Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(child: _buildToolbar()),
        );
      case SketchToolbarPosition.bottomLeft:
        return Positioned(
          bottom: 16,
          left: 16,
          child: _buildToolbar(),
        );
      case SketchToolbarPosition.bottomRight:
        return Positioned(
          bottom: 16,
          right: 16,
          child: _buildToolbar(),
        );
    }
  }
}

/// A region that connects to MultiCanvasSketchWrapper when it's in provider mode
class MultiCanvasRegion extends StatefulWidget {
  const MultiCanvasRegion({
    required this.regionIndex,
    required this.child,
    super.key,
  });

  /// Unique index for this region
  final int regionIndex;

  /// Child widget to wrap with sketch functionality
  final Widget child;

  @override
  State<MultiCanvasRegion> createState() => _MultiCanvasRegionState();
}

class _MultiCanvasRegionState extends State<MultiCanvasRegion> {
  _MultiCanvasProvider? _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newProvider = _MultiCanvasProvider.of(context);
    if (newProvider != _provider) {
      // Unregister from old controller
      _provider?.controller.unregisterRegion(widget.regionIndex);

      // Register with new controller
      _provider = newProvider;
      _provider?.controller.registerRegion(widget.regionIndex);
    }
  }

  @override
  void dispose() {
    _provider?.controller.unregisterRegion(widget.regionIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = _MultiCanvasProvider.of(context);
    if (provider == null) {
      return widget.child; // Fallback to regular child if no provider
    }

    final controller = provider.controller;
    final wrapper = provider.multiCanvasWrapper;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        // Enable drawing on all sections when sketch mode is active
        final mode =
            wrapper.widget.isEnabled ? controller.mode : SketchMode.none;

        // Get inserts for this specific region from the controller
        final regionInserts =
            controller.getInsertsForSection(widget.regionIndex);

        Widget child = SketchCanvas(
          sectionIndex: widget.regionIndex,
          child: widget.child,
          inserts: regionInserts,
          mode: mode,
          selectedColor: controller.selectedColor,
          selectedStrokeWidth: controller.selectedStrokeWidth,
          selectedFontSize: controller.selectedFontSize,
          onSaveInsert: wrapper._handleSaveInsert,
          onUpdateTextInsert: wrapper._handleUpdateTextInsert,
        );

        // Remove the InkWell tap functionality since we don't need active canvas selection
        return child;
      },
    );
  }
}

/// Internal provider for the wrapper when in provider mode
class _MultiCanvasProvider extends InheritedWidget {
  const _MultiCanvasProvider({
    required this.controller,
    required this.multiCanvasWrapper,
    required super.child,
  });

  final MultiCanvasSketchController controller;
  final _MultiCanvasSketchWrapperState multiCanvasWrapper;

  static _MultiCanvasProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MultiCanvasProvider>();
  }

  @override
  bool updateShouldNotify(_MultiCanvasProvider oldWidget) {
    return oldWidget.controller != controller;
  }
}

/// Enum for toolbar positioning options
enum SketchToolbarPosition {
  topCenter,
  topLeft,
  topRight,
  bottomCenter,
  bottomLeft,
  bottomRight,
}
