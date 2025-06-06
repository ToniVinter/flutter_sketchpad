/// Enum to define different sketch modes
enum SketchMode {
  /// No sketching - normal interaction
  none,

  /// Drawing mode for freehand sketching
  drawing,

  /// Highlighting mode for semi-transparent annotations
  highlighting,

  /// Text mode for adding text annotations
  text,

  /// Eraser mode for pixel-by-pixel erasing of drawings and text
  eraser,
}
