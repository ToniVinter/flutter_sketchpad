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
- 🔧 **Multi-Canvas Support**: Multiple annotation areas with shared toolbar
- 🎯 **Performance Optimized**: Efficient rendering and memory management
- ⏪ **Built-in History**: Automatic undo/redo with configurable limits

### Core Widgets
- `MultiCanvasSketchWrapper`: Main widget with multi-canvas support and built-in toolbar
- `MultiCanvasRegion`: Individual annotation regions that connect to the wrapper
- `SketchCanvas`: Drawing canvas for custom implementations
- `SketchToolbar`: Standalone toolbar component

### Controllers
- `MultiCanvasSketchController`: Unified controller for sketch state and history management

### Data Models
- `SketchInsert`: Core data model for sketch elements
- `SketchInsertType`: Enum for drawing vs text annotations
- `SketchMode`: Enum for drawing modes (none, drawing, text, highlighter)
- `SketchToolbarPosition`: Enum for toolbar positioning

### Features
- Smooth drawing with optimized path rendering
- Real-time eraser with collision detection
- Draggable and editable text annotations
- Multi-canvas support for complex documents
- Built-in undo/redo with automatic state management
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