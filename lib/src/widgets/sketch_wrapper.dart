import 'package:flutter/material.dart';
import '../models/sketch_insert.dart';
import 'sketch_canvas.dart';
import 'sketch_toolbar.dart';

/// A wrapper widget that provides annotation functionality to any child widget.
/// This is the main entry point for the annotations package.
class SketchWrapper extends StatefulWidget {
  const SketchWrapper({
    required this.child,
    required this.sectionIndex,
    required this.inserts,
    required this.onSaveInsert,
    required this.onSaveTextInsert,
    required this.onUpdateTextInsert,
    required this.onUpdateTextPosition,
    required this.onEraseInsertAt,
    this.isSketchMode = false,
    this.toolbarPosition = SketchToolbarPosition.bottomCenter,
    this.initialColor = Colors.black,
    this.initialStrokeWidth = 4.0,
    this.initialFontSize = 16.0,
    super.key,
  });

  /// The child widget to wrap with annotation functionality
  final Widget child;

  /// The section index for this annotation canvas
  final int sectionIndex;

  /// List of existing annotation inserts
  final List<SketchInsert> inserts;

  /// Whether annotation mode is currently active
  final bool isSketchMode;

  /// Position of the annotation toolbar
  final SketchToolbarPosition toolbarPosition;

  /// Initial color for annotations
  final Color initialColor;

  /// Initial stroke width for drawings
  final double initialStrokeWidth;

  /// Initial font size for text annotations
  final double initialFontSize;

  /// Callback when a drawing insert is saved
  final void Function(int sectionIndex, List<Offset> points, double strokeWidth,
      Color color, SketchInsertType type) onSaveInsert;

  /// Callback when a text insert is saved
  final void Function(int sectionIndex, String text, Offset position,
      Color color, double fontSize) onSaveTextInsert;

  /// Callback when a text insert is updated
  final void Function(String id, String text) onUpdateTextInsert;

  /// Callback when a text insert position is updated
  final void Function(String id, Offset position) onUpdateTextPosition;

  /// Callback when an insert is erased
  final void Function(int sectionIndex, Offset position, double size)
      onEraseInsertAt;

  @override
  State<SketchWrapper> createState() => _SketchWrapperState();
}

class _SketchWrapperState extends State<SketchWrapper> {
  bool _isDrawingMode = false;
  bool _isEraserMode = false;
  bool _isHighlightMode = false;
  bool _isTextMode = false;
  late Color _selectedColor;
  late double _selectedStrokeWidth;
  late double _selectedFontSize;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _selectedStrokeWidth = widget.initialStrokeWidth;
    _selectedFontSize = widget.initialFontSize;
  }

  void _toggleDrawingMode() {
    setState(() {
      _isDrawingMode = !_isDrawingMode;
      if (_isDrawingMode) {
        _isHighlightMode = false;
        _isTextMode = false;
        _isEraserMode = false;
      }
    });
  }

  void _toggleEraserMode() {
    setState(() {
      _isEraserMode = !_isEraserMode;
      if (_isEraserMode) {
        _isDrawingMode = true;
        _isHighlightMode = false;
        _isTextMode = false;
      }
    });
  }

  void _toggleHighlightMode() {
    setState(() {
      _isHighlightMode = !_isHighlightMode;
      if (_isHighlightMode) {
        _isDrawingMode = false;
        _isTextMode = false;
        _isEraserMode = false;
      }
    });
  }

  void _toggleTextMode() {
    setState(() {
      _isTextMode = !_isTextMode;
      if (_isTextMode) {
        _isDrawingMode = false;
        _isHighlightMode = false;
        _isEraserMode = false;
      }
    });
  }

  void _onColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _onStrokeWidthSelected(double strokeWidth) {
    setState(() {
      _selectedStrokeWidth = strokeWidth;
    });
  }

  void _onFontSizeSelected(double fontSize) {
    setState(() {
      _selectedFontSize = fontSize;
    });
  }

  Widget _buildToolbar() {
    return SketchToolbar(
      isEnabled: widget.isSketchMode,
      isDrawingMode: _isDrawingMode,
      isEraserMode: _isEraserMode,
      isHighlightMode: _isHighlightMode,
      isTextMode: _isTextMode,
      selectedColor: _selectedColor,
      selectedStrokeWidth: _selectedStrokeWidth,
      selectedFontSize: _selectedFontSize,
      onToggleDrawingMode: _toggleDrawingMode,
      onToggleEraserMode: _toggleEraserMode,
      onToggleHighlightMode: _toggleHighlightMode,
      onToggleTextMode: _toggleTextMode,
      onColorSelected: _onColorSelected,
      onStrokeWidthSelected: _onStrokeWidthSelected,
      onFontSizeSelected: _onFontSizeSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final annotationCanvas = SketchCanvas(
      sectionIndex: widget.sectionIndex,
      child: widget.child,
      inserts: widget.inserts,
      isSketchMode: widget.isSketchMode,
      isDrawingMode: _isDrawingMode,
      isHighlightMode: _isHighlightMode,
      isTextMode: _isTextMode,
      isEraserMode: _isEraserMode,
      selectedColor: _selectedColor,
      selectedStrokeWidth: _selectedStrokeWidth,
      selectedFontSize: _selectedFontSize,
      onSaveInsert: widget.onSaveInsert,
      onSaveTextInsert: widget.onSaveTextInsert,
      onUpdateTextInsert: widget.onUpdateTextInsert,
      onUpdateTextPosition: widget.onUpdateTextPosition,
      onEraseInsertAt: widget.onEraseInsertAt,
    );

    if (!widget.isSketchMode) {
      return annotationCanvas;
    }

    return Stack(
      children: [
        annotationCanvas,
        _buildPositionedToolbar(),
      ],
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

/// Enum for toolbar positioning options
enum SketchToolbarPosition {
  topCenter,
  topLeft,
  topRight,
  bottomCenter,
  bottomLeft,
  bottomRight,
}
