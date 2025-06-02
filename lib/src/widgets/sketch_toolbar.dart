import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'controls/sketch_color_button.dart';
import 'controls/sketch_font_size_button.dart';
import 'sketch_stroke_width_button.dart';
import '../models/sketch_mode.dart';

/// A toolbar that provides sketch tools for marking up content.
class SketchToolbar extends StatelessWidget {
  /// Creates a sketch toolbar.
  const SketchToolbar({
    required this.isEnabled,
    required this.mode,
    required this.onModeChanged,
    required this.onStrokeWidthSelected,
    required this.onColorSelected,
    required this.onFontSizeSelected,
    this.initialColor = Colors.red,
    this.initialStrokeWidth = 4.0,
    this.initialFontSize = 16.0,
    super.key,
  });

  /// Whether the sketch toolbar is enabled
  final bool isEnabled;

  /// Current sketch mode
  final SketchMode mode;

  /// Initial color for color controls
  final Color initialColor;

  /// Initial stroke width for stroke controls
  final double initialStrokeWidth;

  /// Initial font size for font controls
  final double initialFontSize;

  /// Callback when sketch mode changes
  final ValueChanged<SketchMode> onModeChanged;

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
                isSelected: mode == SketchMode.drawing,
                tooltip: 'Toggle Drawing Mode',
                onPressed: () => onModeChanged(
                  mode == SketchMode.drawing
                      ? SketchMode.none
                      : SketchMode.drawing,
                ),
                context: context,
              ),

              const SizedBox(width: 12),
              // Highlight mode toggle
              _buildToolbarButton(
                icon: LucideIcons.highlighter,
                isSelected: mode == SketchMode.highlighting,
                tooltip: 'Toggle Highlight Mode',
                onPressed: () => onModeChanged(
                  mode == SketchMode.highlighting
                      ? SketchMode.none
                      : SketchMode.highlighting,
                ),
                context: context,
              ),

              const SizedBox(width: 12),
              // Text mode toggle (text icon)
              _buildToolbarButton(
                icon: LucideIcons.type,
                isSelected: mode == SketchMode.text,
                tooltip: 'Toggle Text Mode',
                onPressed: () => onModeChanged(
                  mode == SketchMode.text ? SketchMode.none : SketchMode.text,
                ),
                context: context,
              ),

              // Drawing mode controls: color & stroke width only
              if (mode == SketchMode.drawing) ...[
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchColorButton(
                  initialColor: initialColor,
                  onColorSelected: onColorSelected,
                ),
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchStrokeWidthButton(
                  initialStrokeWidth: initialStrokeWidth,
                  isHighlightMode: false,
                  onStrokeWidthSelected: onStrokeWidthSelected,
                ),
              ],

              // Highlight mode controls: color & stroke width
              if (mode == SketchMode.highlighting) ...[
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchColorButton(
                  initialColor: initialColor,
                  onColorSelected: onColorSelected,
                ),
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchStrokeWidthButton(
                  initialStrokeWidth: initialStrokeWidth,
                  isHighlightMode: true,
                  onStrokeWidthSelected: onStrokeWidthSelected,
                ),
              ],

              // Text mode controls: color & font size
              if (mode == SketchMode.text) ...[
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchColorButton(
                  initialColor: initialColor,
                  onColorSelected: onColorSelected,
                ),
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchFontSizeButton(
                  initialFontSize: initialFontSize,
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
