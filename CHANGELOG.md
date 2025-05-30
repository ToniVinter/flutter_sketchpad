# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- 🎨 **Initial Release**: Complete sketch and annotation system
- 🖊️ **Drawing Mode**: Smooth drawing with customizable stroke width and colors
- 🖍️ **Highlighting Mode**: Semi-transparent highlighting for markup
- 📝 **Text Annotations**: Add, edit, move, and delete text annotations
- 🗑️ **Eraser Tool**: Precision erasing with adjustable size
- 🎨 **Color Picker**: Built-in color selection with 7 preset colors
- ⚙️ **Flexible Toolbar**: Customizable toolbar with 6 positioning options
- 📱 **Touch Optimized**: Smooth touch interactions and gesture handling
- 💾 **JSON Serialization**: Complete serialization support for persistence
- 🔧 **Section-Based Organization**: Organize annotations by content sections
- 🎯 **Performance Optimized**: Efficient rendering and memory management

### Core Widgets
- `SketchWrapper`: All-in-one widget with built-in toolbar
- `SketchCanvas`: Drawing canvas for custom implementations
- `SketchToolbar`: Standalone toolbar component
- `SketchColorButton`: Color selection control
- `SketchStrokeWidthButton`: Stroke width selection control
- `SketchFontSizeButton`: Font size selection control
- `SketchSettingsOverlay`: Customizable settings overlay

### Data Models
- `SketchInsert`: Core data model for sketch elements
- `SketchInsertType`: Enum for drawing vs text annotations
- `SketchToolbarPosition`: Enum for toolbar positioning

### Features
- Smooth drawing with optimized path rendering
- Real-time eraser with collision detection
- Draggable and editable text annotations
- Multi-section support for complex documents
- Complete undo/redo capabilities
- Bounds checking for drawing areas
- Auto-save functionality
- Cross-platform compatibility

## [Unreleased]

### Planned Features
- 📷 **Image Annotations**: Support for image overlays
- 🔍 **Zoom & Pan**: Canvas zoom and pan capabilities
- 🎭 **Shape Tools**: Predefined shapes (circles, rectangles, arrows)
- 🌈 **Custom Brushes**: Additional brush types and effects
- 📊 **Layer System**: Multi-layer annotation support
- 🔒 **Read-Only Mode**: View-only mode for published content
- 🎬 **Animation**: Animated drawing playback
- 📤 **Export Options**: Export to PNG, SVG, PDF formats 