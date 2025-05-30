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

  @override
  State<SketchSettingsOverlay<T>> createState() =>
      _SketchSettingsOverlayState<T>();
}

class _SketchSettingsOverlayState<T>
    extends State<SketchSettingsOverlay<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
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
                  targetAnchor: widget.targetAnchor,
                  followerAnchor: widget.followerAnchor,
                  offset: widget.offset,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withAlpha(204),
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
                          children:
                              widget.options
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
      child: widget.anchorBuilder(context, _toggleOverlay),
    );
  }
}
