import 'package:flutter/material.dart';

import 'controls/sketch_settings_overlay.dart';

class SketchStrokeWidthButton extends StatelessWidget {
  const SketchStrokeWidthButton({
    required this.width,
    required this.selectedStrokeWidth,
    required this.onStrokeWidthSelected,
    this.isHighlightMode = false,
    super.key,
  });

  final double width;
  final double selectedStrokeWidth;
  final ValueChanged<double> onStrokeWidthSelected;
  final bool isHighlightMode;

  @override
  Widget build(BuildContext context) {
    const strokeWidths = [2.0, 4.0, 6.0, 8.0, 12.0];

    return SketchSettingsOverlay<double>(
      targetAnchor: Alignment.topCenter,
      followerAnchor: Alignment.bottomCenter,
      offset: const Offset(-32, -24),
      anchorBuilder: (ctx, toggleOverlay) => Tooltip(
        message:
            isHighlightMode ? 'Select Highlight Width' : 'Select Stroke Width',
        child: GestureDetector(
          onTap: toggleOverlay,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
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
                  width: width.clamp(2.0, 16.0),
                  height: width.clamp(2.0, 16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      options: strokeWidths,
      selectedOption: selectedStrokeWidth,
      onOptionSelected: onStrokeWidthSelected,
      optionBuilder: (ctx, strokeWidth, isSelected) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(ctx).colorScheme.primary.withAlpha(51)
              : Colors.grey.withAlpha(51),
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
            width: strokeWidth.clamp(2.0, 16.0),
            height: strokeWidth.clamp(2.0, 16.0),
            decoration: BoxDecoration(
              color:
                  isSelected ? Theme.of(ctx).colorScheme.primary : Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
