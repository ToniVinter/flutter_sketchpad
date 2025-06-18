import 'package:flutter/material.dart';

import 'controls/sketch_settings_overlay.dart';

class SketchStrokeWidthButton extends StatefulWidget {
  const SketchStrokeWidthButton({
    required this.onStrokeWidthSelected,
    this.strokeWidth = 4.0,
    this.isHighlightMode = false,
    this.isEraserMode = false,
    super.key,
  });

  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthSelected;
  final bool isHighlightMode;
  final bool isEraserMode;

  @override
  State<SketchStrokeWidthButton> createState() =>
      _SketchStrokeWidthButtonState();
}

class _SketchStrokeWidthButtonState extends State<SketchStrokeWidthButton> {
  late double _selectedStrokeWidth;

  @override
  void initState() {
    super.initState();
    _selectedStrokeWidth = _getValidStrokeWidth(widget.strokeWidth);
  }

  @override
  void didUpdateWidget(SketchStrokeWidthButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    final isModeChanged = oldWidget.isEraserMode != widget.isEraserMode ||
        oldWidget.isHighlightMode != widget.isHighlightMode;

    // If stroke width or mode changes, re-validate and update
    if (oldWidget.strokeWidth != widget.strokeWidth || isModeChanged) {
      final validStrokeWidth = _getValidStrokeWidth(widget.strokeWidth);

      if (validStrokeWidth != _selectedStrokeWidth) {
        setState(() {
          _selectedStrokeWidth = validStrokeWidth;
        });

        // Defer notification to after build phase completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onStrokeWidthSelected(_selectedStrokeWidth);
        });
      }
    }
  }

  double _getValidStrokeWidth(double currentWidth) {
    final strokeWidths = _getStrokeWidths();

    // If current width is in the list, use it
    if (strokeWidths.contains(currentWidth)) {
      return currentWidth;
    }

    // Otherwise, find the closest valid option
    double closest = strokeWidths.first;
    double minDifference = (currentWidth - closest).abs();

    for (final width in strokeWidths) {
      final difference = (currentWidth - width).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closest = width;
      }
    }

    return closest;
  }

  List<double> _getStrokeWidths() {
    return widget.isEraserMode
        ? [12.0, 16.0, 20.0, 26.0, 32.0] // Larger sizes for eraser
        : widget.isHighlightMode
            ? [
                6.0,
                8.0,
                10.0,
                12.0,
                16.0
              ] // Bigger sizes for highlighting (+4 from drawing)
            : [2.0, 4.0, 6.0, 8.0, 12.0]; // Original sizes for drawing
  }

  void _onStrokeWidthSelected(double strokeWidth) {
    setState(() {
      _selectedStrokeWidth = strokeWidth;
    });
    widget.onStrokeWidthSelected(strokeWidth);
  }

  @override
  Widget build(BuildContext context) {
    // Get stroke widths for current mode
    final strokeWidths = _getStrokeWidths();

    return SketchSettingsOverlay<double>(
      anchorBuilder: (ctx, toggleOverlay) => Tooltip(
        message: widget.isHighlightMode
            ? 'Select Highlight Width'
            : 'Select Stroke Width',
        child: GestureDetector(
          onTap: toggleOverlay,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withAlpha(77),
              ),
            ),
            child: Container(
              width: 16,
              height: 16,
              child: Center(
                child: Container(
                  width: widget.isEraserMode
                      ? _selectedStrokeWidth.clamp(12.0, 24.0)
                      : widget.isHighlightMode
                          ? _selectedStrokeWidth.clamp(6.0, 16.0)
                          : _selectedStrokeWidth.clamp(2.0, 12.0),
                  height: widget.isEraserMode
                      ? _selectedStrokeWidth.clamp(12.0, 24.0)
                      : widget.isHighlightMode
                          ? _selectedStrokeWidth.clamp(6.0, 16.0)
                          : _selectedStrokeWidth.clamp(2.0, 12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      options: strokeWidths,
      selectedOption: _selectedStrokeWidth,
      onOptionSelected: _onStrokeWidthSelected,
      optionBuilder: (ctx, strokeWidth, isSelected) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(ctx).colorScheme.primary.withAlpha(51)
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(ctx).colorScheme.primary
                : Colors.grey.withAlpha(77),
            width: 0.5,
          ),
        ),
        child: Center(
          child: Container(
            width: widget.isEraserMode
                ? strokeWidth.clamp(12.0, 24.0)
                : widget.isHighlightMode
                    ? strokeWidth.clamp(6.0, 16.0)
                    : strokeWidth.clamp(2.0, 12.0),
            height: widget.isEraserMode
                ? strokeWidth.clamp(12.0, 24.0)
                : widget.isHighlightMode
                    ? strokeWidth.clamp(6.0, 16.0)
                    : strokeWidth.clamp(2.0, 12.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(ctx).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
