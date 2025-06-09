import 'package:flutter/material.dart';
import 'package:flutter_sketchpad/flutter_sketchpad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sketchpad',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display', // iOS-style font
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const SketchpadExamplePage(),
    );
  }
}

class SketchpadExamplePage extends StatefulWidget {
  const SketchpadExamplePage({super.key});

  @override
  State<SketchpadExamplePage> createState() => _SketchpadExamplePageState();
}

class _SketchpadExamplePageState extends State<SketchpadExamplePage> {
  List<SketchInsert> inserts = [];

  // Single unified controller handles everything - much simpler!
  late final MultiCanvasSketchController controller;

  // Sketch mode state - now controlled by the widget
  bool isSketchMode = false;

  // Scroll control - set to true when specific annotation tools are active (drawing, text, highlight)
  bool isAnnotationToolActive = false;

  @override
  void initState() {
    super.initState();

    // Single unified controller setup
    controller = MultiCanvasSketchController(
      initialColor: Colors.blue,
      initialStrokeWidth: 4.0,
      initialFontSize: 16.0,
      maxHistorySteps: 50,
    );

    // Only need to listen to one controller
    controller.addListener(_onControllerChanged);

    // Test the eraser serialization fix
    _testEraserSerialization();
  }

  @override
  void dispose() {
    controller.dispose(); // Single dispose call
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {
      // Sync inserts from controller for display purposes
      inserts.clear();
      inserts.addAll(controller.inserts);
    });
  }

  void _undo() {
    controller.undo(); // Controller handles state internally
    _showSuccessHaptic();
  }

  void _redo() {
    controller.redo(); // Controller handles state internally
    _showSuccessHaptic();
  }

  bool get canUndo => controller.canUndo;
  bool get canRedo => controller.canRedo;

  /// Test function to demonstrate proper eraser serialization
  void _testEraserSerialization() {
    // Create a drawing insert
    const drawingInsert = SketchInsert(
      id: 'drawing-1',
      sectionId: 'test',
      type: SketchInsertType.drawing,
      points: [Offset(0, 0), Offset(10, 10)],
      color: Colors.red,
      strokeWidth: 2.0,
    );

    // Create an eraser insert (no color should be saved)
    const eraserInsert = SketchInsert(
      id: 'eraser-1',
      sectionId: 'test',
      type: SketchInsertType.eraser,
      points: [Offset(5, 5), Offset(15, 15)],
      color: null, // Eraser doesn't need color
      strokeWidth: 10.0,
    );

    // Test JSON serialization
    final drawingJson = drawingInsert.toJson();
    final eraserJson = eraserInsert.toJson();

    print('Drawing JSON: $drawingJson');
    print('Eraser JSON: $eraserJson');

    // Verify that eraser JSON doesn't contain color
    assert(!eraserJson.containsKey('color'), 'Eraser should not save color!');
    assert(drawingJson.containsKey('color'), 'Drawing should save color!');

    print('✅ Eraser serialization test passed!');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showInsertsList(context),
          child: Text(
            'Unified Sketchpad',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 28,
            ),
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        elevation: 0,
        centerTitle: false,
        actions: [
          // Sketch mode toggle
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isSketchMode = !isSketchMode;
                });
              },
              icon: Icon(
                isSketchMode ? Icons.edit_off : Icons.edit,
                color: isSketchMode ? Colors.orange[600] : Colors.grey[600],
                size: 24,
              ),
              style: IconButton.styleFrom(
                backgroundColor: isSketchMode
                    ? (isDark
                        ? Colors.orange[600]?.withValues(alpha: 0.1)
                        : Colors.orange[50])
                    : Colors.transparent,
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(40, 40),
              ),
              tooltip: isSketchMode ? 'Exit Sketch Mode' : 'Enter Sketch Mode',
            ),
          ),

          // Undo button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: canUndo ? _undo : null,
              icon: Icon(
                Icons.undo_rounded,
                color: canUndo ? Colors.orange[600] : Colors.grey[400],
                size: 24,
              ),
              style: IconButton.styleFrom(
                backgroundColor: canUndo
                    ? (isDark
                        ? Colors.orange[600]?.withValues(alpha: 0.1)
                        : Colors.orange[50])
                    : Colors.transparent,
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(40, 40),
              ),
              tooltip: 'Undo',
            ),
          ),

          // Redo button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: canRedo ? _redo : null,
              icon: Icon(
                Icons.redo_rounded,
                color: canRedo ? Colors.orange[600] : Colors.grey[400],
                size: 24,
              ),
              style: IconButton.styleFrom(
                backgroundColor: canRedo
                    ? (isDark
                        ? Colors.orange[600]?.withValues(alpha: 0.1)
                        : Colors.orange[50])
                    : Colors.transparent,
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(40, 40),
              ),
              tooltip: 'Redo',
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        // Disable scrolling when annotation tools are active
        physics: isAnnotationToolActive
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Main sketchpad content
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.5)
                          : Colors.grey.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      MultiCanvasSketchWrapper(
                        controller: controller, // Use unified controller
                        isEnabled: isSketchMode,
                        child: MultiCanvasRegion(
                          sectionId: "0",
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: inserts.isEmpty
                                ? _buildEmptyState(isDark)
                                : Container(),
                          ),
                        ),
                      ),
                      // Standalone toolbar - can be positioned anywhere!
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SketchToolbar(
                            controller: controller,
                            isEnabled: isSketchMode,
                            enableAnimation: true,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            animationCurve: Curves.easeInOut,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.draw_rounded,
                size: 60,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Start Creating',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Use the toolbar to draw, add text,\nor highlight content',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: Colors.blue,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tap to activate sketch mode',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessHaptic() {
    // Add haptic feedback for better UX
    // HapticFeedback.lightImpact();
  }

  void _showInsertsList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sketch Elements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${inserts.length} total elements across all sections',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.view_list_rounded, color: Colors.blue),
              ),
              title: const Text('View All Elements'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.of(context).pop();
                _showDetailedInsertsList(context);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.refresh_rounded, color: Colors.blue),
              ),
              title: Text(
                'Refresh All',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  inserts.clear();
                });
                _showSuccessHaptic();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDetailedInsertsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SketchElementsListPage(
          inserts: inserts,
          onInsertDeleted: (index) {
            setState(() {
              inserts.removeAt(index);
            });
            _showSuccessHaptic();
          },
          onRefreshAll: () {
            setState(() {
              inserts.clear();
            });
            _showSuccessHaptic();
          },
        ),
      ),
    );
  }
}

class SketchElementsListPage extends StatefulWidget {
  final List<SketchInsert> inserts;
  final Function(int) onInsertDeleted;
  final VoidCallback onRefreshAll;

  const SketchElementsListPage({
    super.key,
    required this.inserts,
    required this.onInsertDeleted,
    required this.onRefreshAll,
  });

  @override
  State<SketchElementsListPage> createState() => _SketchElementsListPageState();
}

class _SketchElementsListPageState extends State<SketchElementsListPage> {
  late List<SketchInsert> localInserts;

  @override
  void initState() {
    super.initState();
    localInserts = List.from(widget.inserts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sketch Elements'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRefreshAll();
            },
            child: Text(
              'Refresh All',
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: localInserts.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No elements yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: localInserts.length,
                itemBuilder: (context, index) {
                  final insert = localInserts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: insert.color,
                        radius: 20,
                        child: Icon(
                          insert.type == SketchInsertType.text
                              ? Icons.text_fields_rounded
                              : insert.type == SketchInsertType.eraser
                                  ? Icons.cleaning_services_rounded
                                  : Icons.edit_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      title: Text(
                        insert.type == SketchInsertType.text
                            ? insert.text ?? 'Text Element'
                            : insert.type == SketchInsertType.eraser
                                ? 'Eraser (${insert.points.length} points)'
                                : 'Drawing (${insert.points.length} points)',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          // Find the original index in the main inserts list
                          final originalIndex = widget.inserts
                              .indexWhere((i) => i.id == insert.id);

                          if (originalIndex != -1) {
                            // Update the main state
                            widget.onInsertDeleted(originalIndex);

                            // Update local state
                            setState(() {
                              localInserts.removeAt(index);
                            });

                            // If no items left, go back to main page
                            if (localInserts.isEmpty) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
