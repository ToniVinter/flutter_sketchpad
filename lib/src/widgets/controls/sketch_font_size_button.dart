import 'package:flutter/material.dart';

import 'sketch_settings_overlay.dart';

class SketchFontSizeButton extends StatefulWidget {
  const SketchFontSizeButton({
    required this.onFontSizeSelected,
    this.initialFontSize = 16.0,
    super.key,
  });

  final double initialFontSize;
  final ValueChanged<double> onFontSizeSelected;

  @override
  State<SketchFontSizeButton> createState() => _SketchFontSizeButtonState();
}

class _SketchFontSizeButtonState extends State<SketchFontSizeButton> {
  late double _selectedFontSize;

  @override
  void initState() {
    super.initState();
    _selectedFontSize = widget.initialFontSize;
  }

  void _onFontSizeSelected(double fontSize) {
    setState(() {
      _selectedFontSize = fontSize;
    });
    widget.onFontSizeSelected(fontSize);
  }

  @override
  Widget build(BuildContext context) {
    const fontSizes = [12.0, 16.0, 20.0, 24.0, 28.0];

    return SketchSettingsOverlay<double>(
      anchorBuilder: (ctx, toggleOverlay) => Tooltip(
        message: 'Select Font Size',
        child: GestureDetector(
          onTap: toggleOverlay,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withAlpha(77),
              ),
            ),
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    '${_selectedFontSize.toInt()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      options: fontSizes,
      selectedOption: _selectedFontSize,
      onOptionSelected: _onFontSizeSelected,
      optionBuilder: (ctx, size, isSelected) => Container(
        width: 33.5,
        height: 33.5,
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
          child: Material(
            color: Colors.transparent,
            child: Text(
              '${size.toInt()}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(ctx).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
