import 'dart:ui';

import 'package:flutter/material.dart';

class SketchSettingsOverlay<T> extends StatefulWidget {
  const SketchSettingsOverlay({
    required this.anchorBuilder,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.optionBuilder,
    this.targetAnchor = Alignment.center,
    this.followerAnchor = Alignment.center,
    this.offset = Offset.zero,
    this.preferredDirection = AxisDirection.up,
    super.key,
  });

  final Widget Function(BuildContext context, VoidCallback toggleOverlay)
      anchorBuilder;
  final List<T> options;
  final T selectedOption;
  final ValueChanged<T> onOptionSelected;
  final Widget Function(BuildContext context, T option, bool isSelected)
      optionBuilder;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Offset offset;
  final AxisDirection preferredDirection;

  @override
  State<SketchSettingsOverlay<T>> createState() =>
      _SketchSettingsOverlayState<T>();
}

class _SketchSettingsOverlayState<T> extends State<SketchSettingsOverlay<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _anchorKey = GlobalKey();

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    // Calculate smart positioning based on screen bounds
    final positioning = _calculateSmartPositioning();

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background overlay to dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Positioned overlay content
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: positioning.targetAnchor,
              followerAnchor: positioning.followerAnchor,
              offset: positioning.offset,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surface.withAlpha(204),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withAlpha(51),
                        width: 0.5,
                      ),
                    ),
                    child: Wrap(
                      spacing: 12,
                      children: widget.options
                          .map(
                            (option) => GestureDetector(
                              onTap: () {
                                widget.onOptionSelected(option);
                                _removeOverlay();
                              },
                              child: widget.optionBuilder(
                                context,
                                option,
                                option == widget.selectedOption,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayPositioning _calculateSmartPositioning() {
    final context = _anchorKey.currentContext;
    if (context == null) {
      // Fallback to original positioning if context is unavailable
      return OverlayPositioning(
        targetAnchor: widget.targetAnchor,
        followerAnchor: widget.followerAnchor,
        offset: widget.offset,
      );
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return OverlayPositioning(
        targetAnchor: widget.targetAnchor,
        followerAnchor: widget.followerAnchor,
        offset: widget.offset,
      );
    }

    // Get the position of the anchor button on screen
    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    // Estimate overlay size based on content
    // More accurate estimates based on typical content
    final optionCount = widget.options.length;
    final estimatedWidth =
        (optionCount * 44.0) + 24.0; // ~44px per option + padding
    const estimatedHeight = 68.0; // Single row height + padding

    // Add safety margins
    const safetyMargin = 16.0;

    // Calculate button center
    final buttonCenter = Offset(
      buttonPosition.dx + buttonSize.width / 2,
      buttonPosition.dy + buttonSize.height / 2,
    );

    // Calculate available space in each direction
    final spaceAbove = buttonPosition.dy - safetyMargin;
    final spaceBelow = screenSize.height -
        (buttonPosition.dy + buttonSize.height) -
        safetyMargin;
    final spaceLeft = buttonCenter.dx - safetyMargin;
    final spaceRight = screenSize.width - buttonCenter.dx - safetyMargin;

    // Determine optimal positioning
    Alignment targetAnchor;
    Alignment followerAnchor;
    Offset offset;

    // Vertical positioning logic
    bool showAbove;
    if (widget.preferredDirection == AxisDirection.up) {
      // Prefer showing above, but only if there's enough space or it's better than below
      showAbove = spaceAbove >= estimatedHeight ||
          (spaceAbove >= spaceBelow && spaceAbove > estimatedHeight / 2);
    } else {
      // Prefer showing below, but switch to above if not enough space below
      showAbove = spaceBelow < estimatedHeight && spaceAbove >= estimatedHeight;
    }

    // Horizontal positioning logic - ensure overlay stays within screen
    double horizontalOffset = 0;
    final overlayHalfWidth = estimatedWidth / 2;

    if (spaceLeft < overlayHalfWidth) {
      // Too close to left edge - shift overlay right
      horizontalOffset = overlayHalfWidth - spaceLeft;
    } else if (spaceRight < overlayHalfWidth) {
      // Too close to right edge - shift overlay left
      horizontalOffset = -(overlayHalfWidth - spaceRight);
    }

    // Apply positioning
    if (showAbove) {
      targetAnchor = Alignment.topCenter;
      followerAnchor = Alignment.bottomCenter;
      offset = Offset(horizontalOffset, -12); // Small gap above button
    } else {
      targetAnchor = Alignment.bottomCenter;
      followerAnchor = Alignment.topCenter;
      offset = Offset(horizontalOffset, 12); // Small gap below button
    }

    return OverlayPositioning(
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      offset: offset,
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _anchorKey,
        child: widget.anchorBuilder(context, _toggleOverlay),
      ),
    );
  }
}

class OverlayPositioning {
  const OverlayPositioning({
    required this.targetAnchor,
    required this.followerAnchor,
    required this.offset,
  });

  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Offset offset;
}
