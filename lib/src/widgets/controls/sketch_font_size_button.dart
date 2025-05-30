import 'package:flutter/material.dart';

import 'sketch_settings_overlay.dart';

class SketchFontSizeButton extends StatelessWidget {
  const SketchFontSizeButton({
    required this.fontSize,
    required this.selectedFontSize,
    required this.onFontSizeSelected,
    super.key,
  });

  final double fontSize;
  final double selectedFontSize;
  final ValueChanged<double> onFontSizeSelected;

  @override
  Widget build(BuildContext context) {
    const fontSizes = [12.0, 16.0, 20.0, 24.0, 28.0];

    return SketchSettingsOverlay<double>(
      targetAnchor: Alignment.topCenter,
      followerAnchor: Alignment.bottomCenter,
      offset: const Offset(-32, -24),
      anchorBuilder: (ctx, toggleOverlay) => Tooltip(
        message: 'Select Font Size',
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
            child: Center(
              child: Text(
                '${fontSize.toInt()}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      options: fontSizes,
      selectedOption: selectedFontSize,
      onOptionSelected: onFontSizeSelected,
      optionBuilder: (ctx, size, isSelected) => Container(
        width: 40,
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
          child: Material(
            color: Colors.transparent,
            child: Text(
              '${size.toInt()}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(ctx).colorScheme.primary
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
