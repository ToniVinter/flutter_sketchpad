import 'dart:async';

import 'package:flutter/material.dart';
import '../models/sketch_insert.dart';
import '../models/sketch_painter.dart';

class SketchCanvas extends StatefulWidget {
  const SketchCanvas({
    required this.sectionIndex,
    required this.child,
    required this.inserts,
    required this.isSketchMode,
    required this.isDrawingMode,
    required this.isHighlightMode,
    required this.isTextMode,
    required this.isEraserMode,
    required this.selectedColor,
    required this.selectedStrokeWidth,
    required this.selectedFontSize,
    required this.onSaveInsert,
    required this.onSaveTextInsert,
    required this.onUpdateTextInsert,
    required this.onUpdateTextPosition,
    required this.onEraseInsertAt,
    super.key,
  });

  final int sectionIndex;
  final Widget child;
  final List<SketchInsert> inserts;
  final bool isSketchMode;
  final bool isDrawingMode;
  final bool isHighlightMode;
  final bool isTextMode;
  final bool isEraserMode;
  final Color selectedColor;
  final double selectedStrokeWidth;
  final double selectedFontSize;
  final void Function(int sectionIndex, List<Offset> points, double strokeWidth,
      Color color, SketchInsertType type) onSaveInsert;
  final void Function(int sectionIndex, String text, Offset position,
      Color color, double fontSize) onSaveTextInsert;
  final void Function(String id, String text) onUpdateTextInsert;
  final void Function(String id, Offset position) onUpdateTextPosition;
  final void Function(int sectionIndex, Offset position, double size)
      onEraseInsertAt;

  @override
  State<SketchCanvas> createState() => _SketchCanvasState();
}

class _SketchCanvasState extends State<SketchCanvas> {
  final List<Offset> _currentDrawingPoints = [];
  bool _isDrawing = false;
  bool _isOutsideBounds = false;

  String? _editingTextId;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  Offset? _newTextPosition;
  bool _isEditingText = false;
  Offset? _dragStartPosition;
  String? _draggingTextId;

  final GlobalKey _textFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _textFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // When the text field gains focus, scroll it into view.
    if (_textFocusNode.hasFocus && _isEditingText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _textFieldKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            alignment: 0.3,
          );
        }
      });
    }
    // When focus is lost, save the insert
    if (!_textFocusNode.hasFocus && _isEditingText) {
      _saveTextInsert();
    }
  }

  void _startDrawing(Offset position) {
    setState(() {
      _currentDrawingPoints
        ..clear()
        ..add(position);
      _isDrawing = true;
      _isOutsideBounds = false;
    });
  }

  void _continueDrawing(Offset position) {
    if (!_isDrawing) return;

    setState(() {
      _currentDrawingPoints.add(position);
    });
  }

  void _onPointerMoveForDrawing(Offset position) {
    if (!_isDrawing) return;

    // Check if the point is within bounds
    final isWithinBounds = _isWithinBounds(position, context);

    if (isWithinBounds && _isOutsideBounds) {
      // Coming back inside after being outside - save current drawing and start a new one
      _finishCurrentDrawing();
      _startDrawing(position);
    } else if (isWithinBounds) {
      // Normal drawing within bounds
      _continueDrawing(position);
    } else if (!_isOutsideBounds) {
      // Just went outside - save current drawing
      setState(() {
        _isOutsideBounds = true;
      });
      _finishCurrentDrawing();
    }
  }

  void _finishCurrentDrawing() {
    if (!_isDrawing || _currentDrawingPoints.isEmpty) return;

    // Save the drawing if there are points
    if (_currentDrawingPoints.length > 1) {
      final strokeWidth = widget.isHighlightMode
          ? widget.selectedStrokeWidth * 2
          : widget.selectedStrokeWidth;
      final color = widget.isHighlightMode
          ? widget.selectedColor.withValues(alpha: 0.3)
          : widget.selectedColor;
      final type = widget.isHighlightMode
          ? SketchInsertType.drawing // Could add highlight type later
          : SketchInsertType.drawing;

      widget.onSaveInsert(
        widget.sectionIndex,
        List<Offset>.from(_currentDrawingPoints),
        strokeWidth,
        color,
        type,
      );
    }

    setState(_currentDrawingPoints.clear);
  }

  void _finishDrawing() {
    if (!_isDrawing) return;

    _finishCurrentDrawing();

    setState(() {
      _isDrawing = false;
      _isOutsideBounds = false;
    });
  }

  void _eraseAtPosition(Offset position) {
    final eraserSize = widget.selectedStrokeWidth * 2;
    widget.onEraseInsertAt(
      widget.sectionIndex,
      position,
      eraserSize,
    );
  }

  void _startNewTextInsert(Offset position) {
    setState(() {
      _newTextPosition = position;
      _textController.clear();
      _isEditingText = true;
      _editingTextId = null;
    });

    // Focus the text field after the build cycle completes
    Future.delayed(
      const Duration(milliseconds: 50),
      _textFocusNode.requestFocus,
    );
  }

  void _editExistingTextInsert(SketchInsert insert) {
    setState(() {
      _newTextPosition = insert.textPosition;
      _textController.text = insert.text ?? '';
      _isEditingText = true;
      _editingTextId = insert.id;
    });

    // Focus the text field after the build cycle completes
    Future.delayed(
      const Duration(milliseconds: 50),
      _textFocusNode.requestFocus,
    );
  }

  void _saveTextInsert() {
    final text = _textController.text.trim();

    if (_editingTextId != null) {
      // Update existing text insert
      widget.onUpdateTextInsert(_editingTextId!, text);
    } else if (_newTextPosition != null) {
      // Create new text insert
      widget.onSaveTextInsert(
        widget.sectionIndex,
        text,
        _newTextPosition!,
        widget.selectedColor,
        widget.selectedFontSize,
      );
    }

    setState(() {
      _isEditingText = false;
      _newTextPosition = null;
      _editingTextId = null;
      _textController.clear();
    });
  }

  void _startDraggingText(String id, Offset position) {
    setState(() {
      _draggingTextId = id;
      _dragStartPosition = position;
    });
  }

  void _updateDraggingTextPosition(Offset position) {
    if (_draggingTextId == null || _dragStartPosition == null) return;
    // Ensure we have canvas bounds
    final size = context.size;
    if (size == null) return;

    // Find the insert
    final insertList = widget.inserts
        .where(
          (a) => a.id == _draggingTextId,
        )
        .toList();

    if (insertList.isEmpty) return;

    final insert = insertList.first;
    if (insert.textPosition == null) return;

    // Calculate the delta from drag start
    final delta = position - _dragStartPosition!;

    // Apply the delta to the text position
    final rawPosition = insert.textPosition! + delta;
    // Clamp to within canvas bounds
    final clampedDx = rawPosition.dx.clamp(0.0, size.width);
    final clampedDy = rawPosition.dy.clamp(0.0, size.height);
    final newPosition = Offset(clampedDx, clampedDy);

    // Update the drag start position for the next frame
    setState(() {
      _dragStartPosition = position;
    });

    // Update the position
    widget.onUpdateTextPosition(_draggingTextId!, newPosition);
  }

  void _stopDraggingText() {
    setState(() {
      _draggingTextId = null;
      _dragStartPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Unfocus (and trigger save via focus change) when text mode is turned off
    if (!widget.isTextMode && _isEditingText) {
      FocusScope.of(context).unfocus();
    }

    // Filter inserts for this specific section
    final sectionInserts = widget.inserts
        .where((a) => a.sectionIndex == widget.sectionIndex)
        .toList();

    // Main widget with text mode handling
    final Widget mainWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        // The wrapped child widget
        widget.child,

        // Drawing canvas layer - Always visible
        Positioned.fill(
          child: ClipRect(
            child: Stack(
              children: [
                // Always visible drawing layer
                CustomPaint(
                  painter: SketchInsertPainter(
                    inserts: sectionInserts,
                    currentPoints:
                        _isDrawing ? _currentDrawingPoints : const [],
                    currentStrokeWidth: widget.isHighlightMode
                        ? widget.selectedStrokeWidth * 2
                        : widget.selectedStrokeWidth,
                    currentColor: widget.isHighlightMode
                        ? widget.selectedColor.withAlpha(77)
                        : widget.selectedColor,
                  ),
                  child: Container(color: Colors.transparent),
                ),

                if (widget.isSketchMode &&
                    (widget.isDrawingMode ||
                        widget.isHighlightMode ||
                        widget.isTextMode))
                  Positioned.fill(
                    child: GestureDetector(
                      onPanStart:
                          (widget.isDrawingMode || widget.isHighlightMode) &&
                                  !widget.isTextMode
                              ? (details) {
                                  final localPosition = details.localPosition;
                                  // Ensure the point is within bounds
                                  if (_isWithinBounds(localPosition, context)) {
                                    if (widget.isEraserMode) {
                                      _eraseAtPosition(localPosition);
                                    } else {
                                      _startDrawing(localPosition);
                                    }
                                  }
                                }
                              : null,
                      onPanUpdate: (widget.isDrawingMode ||
                                  widget.isHighlightMode) &&
                              !widget.isTextMode
                          ? (details) {
                              final localPosition = details.localPosition;

                              if (widget.isEraserMode) {
                                // For eraser, only apply when within bounds
                                if (_isWithinBounds(localPosition, context)) {
                                  _eraseAtPosition(localPosition);
                                }
                              } else {
                                _onPointerMoveForDrawing(localPosition);
                              }
                            }
                          : null,
                      onPanEnd:
                          (widget.isDrawingMode || widget.isHighlightMode) &&
                                  !widget.isTextMode
                              ? (_) => _finishDrawing()
                              : null,
                      onTapDown: widget.isTextMode
                          ? (details) {
                              final localPosition = details.localPosition;
                              // If already editing text, just unfocus to save it
                              if (_isEditingText) {
                                // This will trigger _saveTextInsert via the focus listener
                                FocusScope.of(context).unfocus();
                                return;
                              }

                              // Only create new text when not already editing
                              // Ensure the text is created within bounds
                              if (_isWithinBounds(localPosition, context)) {
                                _startNewTextInsert(localPosition);
                              }
                            }
                          : null,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Display existing text inserts
        ...sectionInserts
            .where((a) => a.type == SketchInsertType.text)
            .map((textInsert) {
          if (_editingTextId == textInsert.id) {
            return const SizedBox.shrink(); // Don't show while editing
          }

          return Positioned(
            left: textInsert.textPosition?.dx ?? 0,
            top: textInsert.textPosition?.dy ?? 0,
            child: GestureDetector(
              // Only enable interaction when in text mode and sketch mode is on
              onTap: (widget.isSketchMode && widget.isTextMode)
                  ? () => _editExistingTextInsert(textInsert)
                  : null,
              onPanStart: (widget.isSketchMode && widget.isTextMode)
                  ? (details) => _startDraggingText(
                        textInsert.id,
                        details.globalPosition,
                      )
                  : null,
              onPanUpdate: (widget.isSketchMode &&
                      widget.isTextMode &&
                      _draggingTextId == textInsert.id)
                  ? (details) =>
                      _updateDraggingTextPosition(details.globalPosition)
                  : null,
              onPanEnd: (widget.isSketchMode && widget.isTextMode)
                  ? (_) => _stopDraggingText()
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  textInsert.text ?? '',
                  style: TextStyle(
                    color: textInsert.color,
                    fontSize: textInsert.fontSize ?? 16,
                  ),
                ),
              ),
            ),
          );
        }),

        // Text editing widget (shown when creating or editing text)
        if (widget.isSketchMode && _isEditingText && _newTextPosition != null)
          Positioned(
            left: _newTextPosition!.dx,
            top: _newTextPosition!.dy,
            child: IntrinsicWidth(
              child: Container(
                constraints: const BoxConstraints(minWidth: 20, maxWidth: 150),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  key: _textFieldKey,
                  controller: _textController,
                  focusNode: _textFocusNode,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: widget.selectedColor,
                    fontSize: widget.selectedFontSize,
                  ),
                  minLines: 1,
                  maxLines: 5,
                  onEditingComplete: _saveTextInsert,
                ),
              ),
            ),
          ),
      ],
    );

    // If in text mode, wrap with a gesture detector to handle taps anywhere
    if (widget.isSketchMode && widget.isTextMode && _isEditingText) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Unfocus any active text field when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: mainWidget,
      );
    }

    return mainWidget;
  }

  // Helper method to check if a point is within the section bounds
  bool _isWithinBounds(Offset position, BuildContext context) {
    final size = context.size;
    if (size == null) return false;

    return position.dx >= 0 &&
        position.dx <= size.width &&
        position.dy >= 0 &&
        position.dy <= size.height;
  }
}
