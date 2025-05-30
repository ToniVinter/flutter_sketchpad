import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'controls/sketch_color_button.dart';
import 'controls/sketch_font_size_button.dart';
import 'sketch_stroke_width_button.dart';

/// A toolbar that provides sketch tools for marking up content.
class SketchToolbar extends StatelessWidget {
  /// Creates a sketch toolbar.
  const SketchToolbar({
    required this.isEnabled,
    required this.isDrawingMode,
    required this.isEraserMode,
    required this.isHighlightMode,
    required this.isTextMode,
    required this.selectedColor,
    required this.selectedStrokeWidth,
    required this.selectedFontSize,
    required this.onToggleDrawingMode,
    required this.onToggleEraserMode,
    required this.onToggleHighlightMode,
    required this.onToggleTextMode,
    required this.onStrokeWidthSelected,
    required this.onColorSelected,
    required this.onFontSizeSelected,
    super.key,
  });

  /// Whether the sketch toolbar is enabled
  final bool isEnabled;

  /// Whether drawing mode is active
  final bool isDrawingMode;

  /// Whether eraser mode is active
  final bool isEraserMode;

  /// Whether highlight mode is active
  final bool isHighlightMode;

  /// Whether text mode is active
  final bool isTextMode;

  /// The currently selected color
  final Color selectedColor;

  /// The currently selected stroke width
  final double selectedStrokeWidth;

  /// The currently selected font size
  final double selectedFontSize;

  /// Callback when drawing mode is toggled
  final VoidCallback onToggleDrawingMode;

  /// Callback when eraser mode is toggled
  final VoidCallback onToggleEraserMode;

  /// Callback when highlight mode is toggled
  final VoidCallback onToggleHighlightMode;

  /// Callback when text mode is toggled
  final VoidCallback onToggleTextMode;

  /// Callback when stroke width is selected
  final ValueChanged<double> onStrokeWidthSelected;

  /// Callback when color is selected
  final ValueChanged<Color> onColorSelected;

  /// Callback when font size is selected
  final ValueChanged<double> onFontSizeSelected;

  @override
  Widget build(BuildContext context) {
    // Only show the toolbar when enabled
    if (!isEnabled) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withAlpha(204),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.white.withAlpha(51),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drawing mode toggle (pen icon)
              _buildToolbarButton(
                icon: LucideIcons.pen,
                isSelected: isDrawingMode && !isEraserMode,
                tooltip: 'Toggle Drawing Mode',
                onPressed: () {
                  if (!isDrawingMode) {
                    onToggleDrawingMode();
                  } else if (isEraserMode) {
                    onToggleEraserMode();
                  } else {
                    onToggleDrawingMode();
                  }
                },
                context: context,
              ),

              const SizedBox(width: 12),
              // Highlight mode toggle
              _buildToolbarButton(
                icon: LucideIcons.highlighter,
                isSelected: isHighlightMode,
                tooltip: 'Toggle Highlight Mode',
                onPressed: onToggleHighlightMode,
                context: context,
              ),

              const SizedBox(width: 12),
              // Text mode toggle (text icon)
              _buildToolbarButton(
                icon: LucideIcons.type,
                isSelected: isTextMode,
                tooltip: 'Toggle Text Mode',
                onPressed: onToggleTextMode,
                context: context,
              ),

              // Drawing mode controls: color & stroke width only
              if (isDrawingMode) ...[
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchColorButton(
                  color: selectedColor,
                  selectedColor: selectedColor,
                  onColorSelected: onColorSelected,
                ),
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchStrokeWidthButton(
                  width: selectedStrokeWidth,
                  selectedStrokeWidth: selectedStrokeWidth,
                  isHighlightMode: isHighlightMode,
                  onStrokeWidthSelected: onStrokeWidthSelected,
                ),
              ],

              // Highlight mode controls: color & stroke width
              if (isHighlightMode) ...[
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchColorButton(
                  color: selectedColor,
                  selectedColor: selectedColor,
                  onColorSelected: onColorSelected,
                ),
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchStrokeWidthButton(
                  width: selectedStrokeWidth + 4.0,
                  selectedStrokeWidth: selectedStrokeWidth,
                  isHighlightMode: isHighlightMode,
                  onStrokeWidthSelected: onStrokeWidthSelected,
                ),
              ],

              // Text mode controls: color & font size
              if (isTextMode) ...[
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchColorButton(
                  color: selectedColor,
                  selectedColor: selectedColor,
                  onColorSelected: onColorSelected,
                ),
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchFontSizeButton(
                  fontSize: selectedFontSize,
                  selectedFontSize: selectedFontSize,
                  onFontSizeSelected: onFontSizeSelected,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a toolbar button with consistent styling.
  Widget _buildToolbarButton({
    required IconData icon,
    required bool isSelected,
    required String tooltip,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withAlpha(51)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey.withAlpha(77),
    );
  }
}
