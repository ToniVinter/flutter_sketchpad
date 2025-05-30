# 🎨 Flutter Sketchpad

[![Pub Version](https://img.shields.io/pub/v/flutter_sketchpad?color=blue&logo=dart)](https://pub.dev/packages/flutter_sketchpad)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter)](https://flutter.dev)

A powerful and flexible Flutter package for adding sketch and annotation capabilities to any widget. Perfect for note-taking apps, document annotation, drawing apps, and interactive content.

## ✨ Features

- 🖊️ **Drawing & Sketching**: Smooth drawing with customizable stroke width and colors
- 🖍️ **Highlighting**: Semi-transparent highlighting mode for markup
- 📝 **Text Annotations**: Add, edit, and move text annotations
- 🗑️ **Eraser Tool**: Precision erasing with adjustable size
- 🎨 **Color Picker**: Built-in color selection with preset colors
- ⚙️ **Customizable Toolbar**: Flexible toolbar positioning and styling
- 📱 **Touch Optimized**: Smooth touch interactions and gesture handling
- 💾 **Serializable**: JSON serialization support for saving/loading sketches
- 🔧 **Section-Based**: Organize annotations by content sections
- 🎯 **Performance**: Optimized for smooth drawing experience

## 🎥 Live Demo

<div align="center">
  <img src="./example/demo_assets/demo.gif" alt="Flutter Sketchpad Demo" width="350"/>
</div>

*Experience smooth drawing, text annotations, highlighting, and undo/redo functionality*

## 🚀 Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_sketchpad: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### Basic Usage

```dart
import 'package:flutter_sketchpad/flutter_sketchpad.dart';

class MySketchApp extends StatefulWidget {
  @override
  _MySketchAppState createState() => _MySketchAppState();
}

class _MySketchAppState extends State<MySketchApp> {
  List<SketchInsert> inserts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SketchWrapper(
        sectionIndex: 0,
        inserts: inserts,
        isSketchMode: true,
        onSaveInsert: (sectionIndex, points) {
          // Handle drawing insert
          final insert = SketchInsert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            sectionIndex: sectionIndex,
            points: points,
            color: Colors.blue,
            strokeWidth: 3.0,
          );
          setState(() {
            inserts.add(insert);
          });
        },
        onSaveTextInsert: (sectionIndex, text, position) {
          // Handle text insert
          final insert = SketchInsert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            sectionIndex: sectionIndex,
            points: [],
            color: Colors.black,
            strokeWidth: 1.0,
            type: SketchInsertType.text,
            text: text,
            textPosition: position,
            fontSize: 16.0,
          );
          setState(() {
            inserts.add(insert);
          });
        },
        onUpdateTextInsert: (id, text) {
          // Update text content
          setState(() {
            final index = inserts.indexWhere((i) => i.id == id);
            if (index != -1) {
              inserts[index] = inserts[index].copyWith(text: text);
            }
          });
        },
        onUpdateTextPosition: (id, position) {
          // Update text position
          setState(() {
            final index = inserts.indexWhere((i) => i.id == id);
            if (index != -1) {
              inserts[index] = inserts[index].copyWith(textPosition: position);
            }
          });
        },
        onEraseInsertAt: (sectionIndex, position, size) {
          // Handle erasing
          setState(() {
            inserts.removeWhere((insert) {
              return insert.points.any((point) {
                final distance = (point - position).distance;
                return distance < size;
              });
            });
          });
        },
        child: YourContentWidget(),
      ),
    );
  }
}
```

## 🎛️ Advanced Usage

### Custom Toolbar Positioning

```dart
SketchWrapper(
  // ... other properties
  toolbarPosition: SketchToolbarPosition.topRight,
  child: YourContent(),
)
```

### Separate Canvas and Toolbar

For more control, use the canvas and toolbar separately:

```dart
Stack(
  children: [
    SketchCanvas(
      sectionIndex: 0,
      inserts: inserts,
      isSketchMode: true,
      isDrawingMode: isDrawingMode,
      isTextMode: isTextMode,
      // ... other properties
      child: YourContent(),
    ),
    Positioned(
      top: 50,
      right: 20,
      child: SketchToolbar(
        isEnabled: true,
        isDrawingMode: isDrawingMode,
        isTextMode: isTextMode,
        // ... other properties
        onToggleDrawingMode: () {
          setState(() {
            isDrawingMode = !isDrawingMode;
          });
        },
        // ... other callbacks
      ),
    ),
  ],
)
```

### Custom Colors and Styling

```dart
SketchWrapper(
  // ... other properties
  initialColor: Colors.purple,
  initialStrokeWidth: 5.0,
  initialFontSize: 18.0,
  child: YourContent(),
)
```

### Section-Based Organization

Organize your annotations by content sections:

```dart
// Different sections can have different annotations
SketchWrapper(
  sectionIndex: 0, // First section
  inserts: section0Inserts,
  // ... properties
)

SketchWrapper(
  sectionIndex: 1, // Second section
  inserts: section1Inserts,
  // ... properties
)
```

## 📚 API Reference

### Core Widgets

#### SketchWrapper
The main widget that provides complete sketch functionality with built-in toolbar.

#### SketchCanvas
The drawing canvas without toolbar - use for custom implementations.

#### SketchToolbar
Standalone toolbar component for controlling sketch modes.

### Data Models

#### SketchInsert
Represents a single sketch element (drawing or text annotation).

```dart
class SketchInsert {
  final String id;
  final String? sketchId;
  final int sectionIndex;
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final SketchInsertType type;
  final String? text;
  final Offset? textPosition;
  final double? fontSize;
  final DateTime? createdAt;
}
```

#### SketchInsertType
Enum defining the type of sketch insert:
- `SketchInsertType.drawing` - Drawing/line annotations
- `SketchInsertType.text` - Text annotations

### Toolbar Positions

```dart
enum SketchToolbarPosition {
  topCenter,
  topLeft,
  topRight,
  bottomCenter,
  bottomLeft,
  bottomRight,
}
```

## 💾 Persistence

All sketch data is JSON serializable for easy persistence:

```dart
// Save to JSON
final json = sketchInsert.toJson();
final jsonString = jsonEncode(json);

// Load from JSON
final json = jsonDecode(jsonString);
final sketchInsert = SketchInsert.fromJson(json);
```

## 🎨 Customization

### Custom Colors

The package includes a default color palette, but you can provide your own:

- Black
- White  
- Orange (#FF9500)
- Green (#4CD964)
- Blue (#5AC8FA)
- Purple (#5856D6)
- Red (#FF2D55)

### Stroke Widths

Default stroke width options: 2.0, 4.0, 6.0, 8.0, 12.0

### Font Sizes

Default font size options: 12.0, 16.0, 20.0, 24.0, 28.0

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Clone the repository
2. Run `flutter pub get`
3. Make your changes
4. Run tests: `flutter test`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with ❤️ using Flutter
- Inspired by modern drawing and annotation tools
- Thanks to the Flutter community for feedback and contributions

## 📞 Support

- 📧 **Email**: [antonio.vinterr@gmail.com]
- 🐛 **Issues**: [GitHub Issues](https://github.com/yourusername/flutter_sketchpad/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourusername/flutter_sketchpad/discussions)

---

**Made with ❤️ by the Flutter Sketchpad Team** 