import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'controls/sketch_color_button.dart';
import 'controls/sketch_font_size_button.dart';
import 'sketch_stroke_width_button.dart';
import '../models/sketch_mode.dart';

/// A toolbar that provides sketch tools for marking up content with built-in animations.
class SketchToolbar extends StatefulWidget {
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
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
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

  /// Whether to animate show/hide transitions
  final bool enableAnimation;

  /// Duration of show/hide animations
  final Duration animationDuration;

  /// Curve for show/hide animations
  final Curve animationCurve;

  /// Callback when sketch mode changes
  final ValueChanged<SketchMode> onModeChanged;

  /// Callback when stroke width is selected
  final ValueChanged<double> onStrokeWidthSelected;

  /// Callback when color is selected
  final ValueChanged<Color> onColorSelected;

  /// Callback when font size is selected
  final ValueChanged<double> onFontSizeSelected;

  @override
  State<SketchToolbar> createState() => _SketchToolbarState();
}

class _SketchToolbarState extends State<SketchToolbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    );

    // Set initial state
    if (widget.isEnabled) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SketchToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation duration if changed
    if (widget.animationDuration != oldWidget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }

    // Update animation curve if changed
    if (widget.animationCurve != oldWidget.animationCurve) {
      _animation = CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      );
    }

    // Handle enabled state changes
    if (widget.isEnabled != oldWidget.isEnabled) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    if (!widget.enableAnimation) {
      _animationController.value = widget.isEnabled ? 1.0 : 0.0;
      return;
    }

    if (widget.isEnabled) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableAnimation) {
      // No animation - use simple conditional rendering
      return widget.isEnabled ? _buildToolbar() : const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Remove from widget tree when animation is complete and disabled
        if (!widget.isEnabled && _animation.value == 0.0) {
          return const SizedBox.shrink();
        }

        // Show animated toolbar during transitions
        return _buildAnimatedToolbar(_animation.value);
      },
    );
  }

  Widget _buildAnimatedToolbar(double animationValue) {
    // Create scale animation for polished effect
    final scaleValue = 0.8 + (0.2 * animationValue);

    // Clamp opacity to valid range (0.0 to 1.0) to handle overshooting curves
    final clampedOpacity = animationValue.clamp(0.0, 1.0);

    return Transform.scale(
      scale: scaleValue,
      child: Opacity(
        opacity: clampedOpacity,
        child: _buildToolbar(),
      ),
    );
  }

  Widget _buildToolbar() {
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
                isSelected: widget.mode == SketchMode.drawing,
                tooltip: 'Toggle Drawing Mode',
                onPressed: () => widget.onModeChanged(
                  widget.mode == SketchMode.drawing
                      ? SketchMode.none
                      : SketchMode.drawing,
                ),
                context: context,
              ),

              const SizedBox(width: 12),
              // Highlight mode toggle
              _buildToolbarButton(
                icon: LucideIcons.highlighter,
                isSelected: widget.mode == SketchMode.highlighting,
                tooltip: 'Toggle Highlight Mode',
                onPressed: () => widget.onModeChanged(
                  widget.mode == SketchMode.highlighting
                      ? SketchMode.none
                      : SketchMode.highlighting,
                ),
                context: context,
              ),

              const SizedBox(width: 12),
              // Text mode toggle (text icon)
              _buildToolbarButton(
                icon: LucideIcons.type,
                isSelected: widget.mode == SketchMode.text,
                tooltip: 'Toggle Text Mode',
                onPressed: () => widget.onModeChanged(
                  widget.mode == SketchMode.text
                      ? SketchMode.none
                      : SketchMode.text,
                ),
                context: context,
              ),

              // Drawing mode controls: color & stroke width only
              if (widget.mode == SketchMode.drawing) ...[
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchColorButton(
                  initialColor: widget.initialColor,
                  onColorSelected: widget.onColorSelected,
                ),
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchStrokeWidthButton(
                  initialStrokeWidth: widget.initialStrokeWidth,
                  isHighlightMode: false,
                  onStrokeWidthSelected: widget.onStrokeWidthSelected,
                ),
              ],

              // Highlight mode controls: color & stroke width
              if (widget.mode == SketchMode.highlighting) ...[
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchColorButton(
                  initialColor: widget.initialColor,
                  onColorSelected: widget.onColorSelected,
                ),
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchStrokeWidthButton(
                  initialStrokeWidth: widget.initialStrokeWidth,
                  isHighlightMode: true,
                  onStrokeWidthSelected: widget.onStrokeWidthSelected,
                ),
              ],

              // Text mode controls: color & font size
              if (widget.mode == SketchMode.text) ...[
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchColorButton(
                  initialColor: widget.initialColor,
                  onColorSelected: widget.onColorSelected,
                ),
                const SizedBox(width: 12),
                _buildDivider(),
                const SizedBox(width: 12),
                SketchFontSizeButton(
                  initialFontSize: widget.initialFontSize,
                  onFontSizeSelected: widget.onFontSizeSelected,
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
