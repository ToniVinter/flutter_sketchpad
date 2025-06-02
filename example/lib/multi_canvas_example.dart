import 'package:flutter/material.dart';
import 'package:flutter_sketchpad/flutter_sketchpad.dart';

void main() {
  runApp(const MultiCanvasExampleApp());
}

class MultiCanvasExampleApp extends StatelessWidget {
  const MultiCanvasExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Canvas Sketch Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const MultiCanvasExamplePage(),
    );
  }
}

/// Example demonstrating multiple canvas sections on a single scrollable page
/// Perfect for documents, notes, or multi-section annotation apps
class MultiCanvasExamplePage extends StatefulWidget {
  const MultiCanvasExamplePage({super.key});

  @override
  State<MultiCanvasExamplePage> createState() => _MultiCanvasExamplePageState();
}

class _MultiCanvasExamplePageState extends State<MultiCanvasExamplePage> {
  // SINGLE unified controller handles everything - much simpler!
  late final MultiCanvasSketchController controller;
  final List<SketchInsert> inserts = []; // This will be synced from controller

  // Sketch mode state - now controlled by the widget
  bool isSketchMode = false;

  // Sample sections content
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Meeting Notes',
      'subtitle': 'Q4 Planning Session',
      'content':
          'Team meeting to discuss quarterly goals and objectives.\n\n• Review current progress\n• Set new targets\n• Assign responsibilities',
      'color': Colors.blue[50],
      'icon': Icons.meeting_room,
    },
    {
      'title': 'Design Ideas',
      'subtitle': 'App Mockups',
      'content':
          'Brainstorming session for the new app design.\n\n• User interface concepts\n• Color schemes\n• Navigation patterns',
      'color': Colors.green[50],
      'icon': Icons.palette,
    },
    {
      'title': 'Technical Notes',
      'subtitle': 'Architecture Planning',
      'content':
          'Technical implementation details and decisions.\n\n• Database schema\n• API endpoints\n• Performance considerations',
      'color': Colors.orange[50],
      'icon': Icons.code,
    },
    {
      'title': 'Action Items',
      'subtitle': 'Follow-up Tasks',
      'content':
          'List of tasks and deadlines from today\'s discussions.\n\n• Update documentation\n• Schedule reviews\n• Prepare presentations',
      'color': Colors.purple[50],
      'icon': Icons.task_alt,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Controller with default inserts (could load from database/storage)
    controller = MultiCanvasSketchController(
      initialColor: Colors.red,
      initialStrokeWidth: 4.0,
      initialFontSize: 16.0,
      maxHistorySteps: 30,
      defaultInserts: inserts, // Preload existing inserts
    );

    // Listen to controller changes to sync when needed
    controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    controller.dispose(); // Single dispose call
    super.dispose();
  }

  void _onControllerChanged() {
    // Could sync here in real-time, or only when exiting sketch mode
    // For now, we'll sync only when explicitly requested
    if (!isSketchMode) {
      // Auto-sync when exiting sketch mode
      _syncFromController();
    }
    setState(() {}); // Update UI for other changes (undo/redo buttons, etc.)
  }

  // Sync app state from controller (call when save button pressed, etc.)
  void _syncFromController() {
    setState(() {
      inserts
        ..clear()
        ..addAll(controller.inserts);
    });
    // Here you could save to database, call API, etc.
    debugPrint('Synced ${inserts.length} inserts from controller');
  }

  // Simple undo - no external coordination needed
  void _undo() {
    controller.undo(); // Controller handles state internally
  }

  // Simple redo - no external coordination needed
  void _redo() {
    controller.redo(); // Controller handles state internally
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiCanvasSketchWrapper(
      controller: controller, // Single unified controller
      isEnabled: isSketchMode,
      toolbarPosition: SketchToolbarPosition.bottomCenter,
      child: Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          title: const Text('Multi-Section Annotations'),
          backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
          elevation: 0,
          actions: [
            // Manual sync button
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () => _syncFromController(),
                icon: Icon(
                  Icons.save_rounded,
                  color: Colors.green[600],
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green[50],
                ),
                tooltip: 'Save Current State',
              ),
            ),

            // Sketch mode toggle - single controller
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
                ),
                style: IconButton.styleFrom(
                  backgroundColor:
                      isSketchMode ? Colors.orange[50] : Colors.transparent,
                ),
                tooltip:
                    isSketchMode ? 'Exit Sketch Mode' : 'Enter Sketch Mode',
              ),
            ),

            // History controls - single controller
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: controller.canUndo ? () => _undo() : null,
                icon: Icon(
                  Icons.undo_rounded,
                  color:
                      controller.canUndo ? Colors.blue[600] : Colors.grey[400],
                ),
                tooltip: 'Undo',
              ),
            ),

            // Redo button
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: controller.canRedo ? () => _redo() : null,
                icon: Icon(
                  Icons.redo_rounded,
                  color:
                      controller.canRedo ? Colors.blue[600] : Colors.grey[400],
                ),
                tooltip: 'Redo',
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Controller-Managed Demo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Controller stores inserts internally. App syncs when needed.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Sections
              ...sections.asMap().entries.map((entry) {
                final index = entry.key;
                final section = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: section['color'] as Color?,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: MultiCanvasRegion(
                    regionIndex: index,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 200),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  section['icon'] as IconData,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      section['title'] as String,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      section['subtitle'] as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            section['content'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // Bottom spacing for toolbar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
