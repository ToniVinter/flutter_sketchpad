import 'package:flutter/material.dart';
import 'sketch_settings_overlay.dart';

class SketchColorButton extends StatefulWidget {
  const SketchColorButton({
    required this.onColorSelected,
    this.color = Colors.black,
    super.key,
  });

  final Color color;
  final ValueChanged<Color> onColorSelected;

  @override
  State<SketchColorButton> createState() => _SketchColorButtonState();
}

class _SketchColorButtonState extends State<SketchColorButton> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = _getValidColor(widget.color);
  }

  @override
  void didUpdateWidget(SketchColorButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If color changed, ensure it's valid
    if (oldWidget.color != widget.color) {
      final validColor = _getValidColor(widget.color);
      if (validColor != _selectedColor) {
        setState(() {
          _selectedColor = validColor;
        });
        // Defer notification to after build phase completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onColorSelected(_selectedColor);
        });
      }
    }
  }

  List<Color> _getColors() {
    return const [
      Colors.black,
      Colors.white,
      Color(0xFFFF9500),
      Color(0xFF4CD964),
      Color(0xFF5AC8FA),
      Color(0xFF5856D6),
      Color(0xFFFF2D55),
    ];
  }

  Color _getValidColor(Color currentColor) {
    final colors = _getColors();

    // If current color is in the list, use it
    if (colors.contains(currentColor)) {
      return currentColor;
    }

    // Otherwise, find the closest color by comparing RGB values
    Color closest = colors.first;
    double minDistance = _colorDistance(currentColor, closest);

    for (final color in colors) {
      final distance = _colorDistance(currentColor, color);
      if (distance < minDistance) {
        minDistance = distance;
        closest = color;
      }
    }

    return closest;
  }

  double _colorDistance(Color c1, Color c2) {
    // Simple RGB distance calculation
    final dr = c1.red - c2.red;
    final dg = c1.green - c2.green;
    final db = c1.blue - c2.blue;
    return (dr * dr + dg * dg + db * db).toDouble();
  }

  void _onColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
    });
    widget.onColorSelected(color);
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return SketchSettingsOverlay<Color>(
      anchorBuilder: (ctx, toggleOverlay) => Tooltip(
        message: 'Select Color',
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
            color: isSelected
                ? Theme.of(ctx).colorScheme.primary
                : Colors.grey.withAlpha(77),
            width: isSelected ? 2.0 : 0.5,
          ),
        ),
        child: isSelected
            ? Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }
}
