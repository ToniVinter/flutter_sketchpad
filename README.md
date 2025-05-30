# Flutter Sketchpad

A Flutter package for adding text, drawings, and highlighter annotations to any widget.

## Features

- **Drawing annotations**: Free-hand drawing with customizable colors and stroke widths
- **Text annotations**: Add, edit, and move text annotations with customizable font sizes and colors
- **Highlight annotations**: Highlight areas with semi-transparent colors
- **Eraser tool**: Remove specific annotations
- **Customizable toolbar**: Position the toolbar anywhere on screen
- **Section-based**: Support for multiple sections with independent annotations

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_sketchpad:
    path: ../flutter_sketchpad
```

## Usage

### Basic Usage

Wrap any widget with `AnnotationWrapper` to add annotation functionality:

```dart
import 'package:flutter_sketchpad/flutter_sketchpad.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<AnnotationInsert> _inserts = [];
  bool _isAnnotationMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Annotations Demo'),
        actions: [
          IconButton(
            icon: Icon(_isAnnotationMode ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isAnnotationMode = !_isAnnotationMode;
              });
            },
          ),
        ],
      ),
      body: AnnotationWrapper(
        sectionIndex: 0,
        inserts: _inserts,
        isAnnotationMode: _isAnnotationMode,
        toolbarPosition: AnnotationToolbarPosition.bottomCenter,
        onSaveInsert: _onSaveInsert,
        onSaveTextInsert: _onSaveTextInsert,
        onUpdateTextInsert: _onUpdateTextInsert,
        onUpdateTextPosition: _onUpdateTextPosition,
        onEraseInsertAt: _onEraseInsertAt,
        child: Container(
          width: double.infinity,
          height: 400,
          color: Colors.grey[200],
          child: Center(
            child: Text('Your content here'),
          ),
        ),
      ),
    );
  }

  void _onSaveInsert(int sectionIndex, List<Offset> points) {
    final insert = AnnotationInsert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sectionIndex: sectionIndex,
      points: points,
      color: Colors.black,
      strokeWidth: 4.0,
      type: AnnotationInsertType.drawing,
    );
    setState(() {
      _inserts.add(insert);
    });
  }

  void _onSaveTextInsert(int sectionIndex, String text, Offset position) {
    final insert = AnnotationInsert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sectionIndex: sectionIndex,
      points: [],
      color: Colors.black,
      strokeWidth: 4.0,
      type: AnnotationInsertType.text,
      text: text,
      textPosition: position,
      fontSize: 16.0,
    );
    setState(() {
      _inserts.add(insert);
    });
  }

  void _onUpdateTextInsert(String id, String text) {
    setState(() {
      final index = _inserts.indexWhere((insert) => insert.id == id);
      if (index != -1) {
        _inserts[index] = _inserts[index].copyWith(text: text);
      }
    });
  }

  void _onUpdateTextPosition(String id, Offset position) {
    setState(() {
      final index = _inserts.indexWhere((insert) => insert.id == id);
      if (index != -1) {
        _inserts[index] = _inserts[index].copyWith(textPosition: position);
      }
    });
  }

  void _onEraseInsertAt(int sectionIndex, Offset position, double size) {
    setState(() {
      _inserts.removeWhere((insert) {
        if (insert.sectionIndex != sectionIndex) return false;
        
        if (insert.type == AnnotationInsertType.drawing) {
          return insert.points.any((point) {
            final distance = (point - position).distance;
            return distance <= size;
          });
        } else if (insert.type == AnnotationInsertType.text && insert.textPosition != null) {
          final distance = (insert.textPosition! - position).distance;
          return distance <= size;
        }
        
        return false;
      });
    });
  }
}
```

### Customization

#### Toolbar Position

You can position the toolbar in different locations:

```dart
AnnotationWrapper(
  toolbarPosition: AnnotationToolbarPosition.topRight,
  // ... other properties
)
```

Available positions:
- `topCenter`
- `topLeft`
- `topRight`
- `bottomCenter`
- `