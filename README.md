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
- 🔧 **Multi-Canvas**: Support for multiple annotation areas with shared toolbar
- 🎯 **Performance**: Optimized for smooth drawing experience
- ⏪ **Undo/Redo**: Built-in history controller with automatic state management

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
  late final MultiCanvasSketchController controller;
  bool isSketchMode = false; // Widget controls sketch mode

  @override
  void initState() {
    super.initState();
    controller = MultiCanvasSketchController(
      initialColor: Colors.blue,
      initialStrokeWidth: 4.0,
      initialFontSize: 16.0,
      maxHistorySteps: 50,
    );
    controller.addListener(() {
      setState(() {}); // Rebuild when controller state changes
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSketchMode = !isSketchMode;
              });
            },
            icon: Icon(isSketchMode ? Icons.edit_off : Icons.edit),
          ),
          IconButton(
            onPressed: controller.canUndo ? () => controller.undo() : null,
            icon: Icon(Icons.undo),
          ),
          IconButton(
            onPressed: controller.canRedo ? () => controller.redo() : null,
            icon: Icon(Icons.redo),
          ),
        ],
      ),
      body: Stack(
        children: [
          MultiCanvasSketchWrapper(
            controller: controller,
            isEnabled: isSketchMode,
            child: MultiCanvasRegion(
              sectionId: "0",
              child: YourContentWidget(),
            ),
          ),
          // Toolbar - position it anywhere!
          Positioned(
            bottom: 20,
            left: 20,
            child: SketchToolbar(
              controller: controller,
              isEnabled: isSketchMode,
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🎛️ Advanced Usage

### Multiple Canvas Regions

Create multiple annotation areas that share a single toolbar:

```dart
Stack(
  children: [
    MultiCanvasSketchWrapper(
      controller: controller,
      isEnabled: isSketchMode,
      child: Column(
        children: [
          Expanded(
            child: MultiCanvasRegion(
              sectionId: "0",
              child: Container(
                color: Colors.blue[50],
                child: Center(child: Text('First Section')),
              ),
            ),
          ),
          Expanded(
            child: MultiCanvasRegion(
              sectionId: "1",
              child: Container(
                color: Colors.green[50],
                child: Center(child: Text('Second Section')),
              ),
            ),
          ),
        ],
      ),
    ),
    // Toolbar positioned at top right
    Positioned(
      top: 20,
      right: 20,
      child: SketchToolbar(
        controller: controller,
        isEnabled: isSketchMode,
      ),
    ),
  ],
)
```

### Custom Toolbar Positioning

Position the toolbar anywhere in your widget tree:

```dart
Stack(
  children: [
    MultiCanvasSketchWrapper(
      controller: controller,
      isEnabled: isSketchMode,
      child: YourContent(),
    ),
         // Position toolbar anywhere you want!
     Positioned(
       top: 50,    // Top right corner
       right: 20,
       child: SketchToolbar(
         controller: controller,
         isEnabled: isSketchMode,
         enableAnimation: true,
         animationDuration: Duration(milliseconds: 300),
         animationCurve: Curves.easeInOut,
       ),
     ),
  ],
)
```

### Separate Canvas and Toolbar

For more control, use the canvas and toolbar separately:

```dart
Stack(
  children: [
    SketchCanvas(
      sectionId: "0",
      inserts: controller.inserts,
      mode: isSketchMode ? controller.mode : SketchMode.none,
      selectedColor: controller.selectedColor,
      selectedStrokeWidth: controller.selectedStrokeWidth,
      selectedFontSize: controller.selectedFontSize,
      onSaveInsert: (insert) => controller.upsertInsert(insert),
      onUpdateTextInsert: (id, text, position) {
        // Handle text updates
      },
      child: YourContent(),
    ),
    Positioned(
      top: 50,
      right: 20,
      child: SketchToolbar(
        isEnabled: isSketchMode,
        mode: controller.mode,
        initialColor: controller.initialColor,
        initialStrokeWidth: controller.initialStrokeWidth,
        initialFontSize: controller.initialFontSize,
        onModeChanged: controller.setMode,
        onColorSelected: controller.setColor,
        onStrokeWidthSelected: controller.setStrokeWidth,
        onFontSizeSelected: controller.setFontSize,
      ),
    ),
  ],
)
```

### Custom Colors and Styling

```dart
MultiCanvasSketchController(
  initialColor: Colors.purple,
  initialStrokeWidth: 5.0,
  initialFontSize: 18.0,
  maxHistorySteps: 100,
)
```

### Working with Insert Data

Access and manipulate sketch data:

```dart
// Get all inserts
List<SketchInsert> allInserts = controller.inserts;

// Get inserts for specific region
List<SketchInsert> regionInserts = controller.getInsertsForSection(0);

// Add insert programmatically
controller.upsertInsert(SketchInsert(
  id: 'unique-id',
  sectionId: "0",
  type: SketchInsertType.text,
  text: 'Programmatic text',
  textPosition: Offset(100, 100),
  color: Colors.red,
  fontSize: 16.0,
));

// Remove insert
controller.removeInsert('unique-id');

// Clear all inserts
controller.clearInserts();
```

## 📚 API Reference

### Core Widgets

#### MultiCanvasSketchWrapper
The main widget that provides complete sketch functionality with built-in toolbar and support for multiple canvas regions.

#### MultiCanvasRegion
A region widget that connects to the parent MultiCanvasSketchWrapper for annotation functionality.

#### SketchCanvas
The drawing canvas without toolbar - use for custom implementations.

#### SketchToolbar
Standalone toolbar component for controlling sketch modes.

### Controllers

#### MultiCanvasSketchController
Unified controller that manages sketch state, insert data, and history.

### Data Models

#### SketchInsert
Represents a single sketch element (drawing or text annotation).

```dart
class SketchInsert {
  final String id;
  final String? sketchId;
  final String sectionId;
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

#### SketchMode
Enum defining the current drawing mode:
- `SketchMode.none` - No drawing
- `SketchMode.drawing` - Drawing/line mode
- `SketchMode.text` - Text annotation mode
- `SketchMode.highlighter` - Highlighter mode

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

## 🎯 Multi-Canvas with Shared Toolbar

For apps with multiple pages/sections (like PageView), use the multi-canvas approach:

```dart
class MyMultiPageApp extends StatefulWidget {
  @override
  _MyMultiPageAppState createState() => _MyMultiPageAppState();
}

class _MyMultiPageAppState extends State<MyMultiPageApp> {
  List<SketchInsert> inserts = [];
  late final MultiCanvasSketchController controller;
  bool isSketchMode = false; // Widget controls sketch mode
  final PageController pageController = PageController();
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = MultiCanvasSketchController(
      initialColor: Colors.red,
      initialStrokeWidth: 4.0,
      initialFontSize: 16.0,
      maxHistorySteps: 50,
    );
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiCanvasSketchWrapper(
      controller: controller,
      isEnabled: isSketchMode, // Pass widget state
      toolbarPosition: SketchToolbarPosition.bottomCenter,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // Toggle sketch mode
            IconButton(
              onPressed: () {
                setState(() {
                  isSketchMode = !isSketchMode;
                });
              },
              icon: Icon(isSketchMode ? Icons.edit_off : Icons.edit),
            ),
            // Undo/Redo buttons
            IconButton(
              onPressed: controller.canUndo ? () => controller.undo() : null,
              icon: Icon(Icons.undo),
            ),
            IconButton(
              onPressed: controller.canRedo ? () => controller.redo() : null,
              icon: Icon(Icons.redo),
            ),
          ],
        ),
        body: PageView.builder(
          controller: pageController,
          onPageChanged: (index) {
            setState(() => currentPageIndex = index);
          },
          itemCount: 3,
          itemBuilder: (context, index) {
            return MultiCanvasRegion(
              sectionId: "page_$index",
              child: PageContent("Page ${index + 1} Content"),
            );
          },
        ),
      ),
    );
  }
}
```

---

**Made with ❤️ by the Flutter Sketchpad Team** 