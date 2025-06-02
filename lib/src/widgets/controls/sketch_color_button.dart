import 'package:flutter/material.dart';
import 'sketch_settings_overlay.dart';

class SketchColorButton extends StatefulWidget {
  const SketchColorButton({
    required this.onColorSelected,
    this.initialColor = Colors.black,
    super.key,
  });

  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  @override
  State<SketchColorButton> createState() => _SketchColorButtonState();
}

class _SketchColorButtonState extends State<SketchColorButton> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  void _onColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
    });
    widget.onColorSelected(color);
  }

  @override
  Widget build(BuildContext context) {
    const colors = [
      Colors.black,
      Colors.white,
      Color(0xFFFF9500),
      Color(0xFF4CD964),
      Color(0xFF5AC8FA),
      Color(0xFF5856D6),
      Color(0xFFFF2D55),
    ];

    return SketchSettingsOverlay<Color>(
      targetAnchor: Alignment.topCenter,
      followerAnchor: Alignment.bottomCenter,
      offset: const Offset(-32, -24),
      anchorBuilder: (ctx, toggleOverlay) => Tooltip(
        message: 'Select Color',
        child: GestureDetector(
          onTap: toggleOverlay,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withAlpha(77),
              ),
            ),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _selectedColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.withAlpha(77),
                ),
              ),
            ),
          ),
        ),
      ),
      options: colors,
      selectedOption: _selectedColor,
      onOptionSelected: _onColorSelected,
      optionBuilder: (ctx, c, isSelected) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.withAlpha(77),
            width: 0.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(ctx).colorScheme.surface,
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(230),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: c.computeLuminance() > 0.5 ? Colors.black : c,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
