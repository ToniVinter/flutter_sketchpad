import 'dart:math';
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

class _MultiCanvasExamplePageState extends State<MultiCanvasExamplePage>
    with SingleTickerProviderStateMixin {
  // Controller will be initialized after loading inserts from server
  MultiCanvasSketchController? controller;
  final List<SketchInsert> inserts = []; // This will be synced from controller

  // Sketch mode state - now controlled by the widget
  bool isSketchMode = false;

  // Loading state for async inserts
  bool isLoadingInserts = true;

  // Animation configuration state
  Duration _animationDuration = const Duration(milliseconds: 350);
  Curve _animationCurve = Curves.easeOutBack;
  SketchToolbarPosition _toolbarPosition = SketchToolbarPosition.bottomCenter;

  // Animation presets for demo
  final List<Map<String, dynamic>> _animationPresets = [
    {
      'name': 'Bounce',
      'duration': const Duration(milliseconds: 600),
      'curve': Curves.elasticOut,
    },
    {
      'name': 'Quick',
      'duration': const Duration(milliseconds: 200),
      'curve': Curves.easeOut,
    },
    {
      'name': 'Smooth',
      'duration': const Duration(milliseconds: 350),
      'curve': Curves.easeOutBack,
    },
    {
      'name': 'Slow',
      'duration': const Duration(milliseconds: 800),
      'curve': Curves.easeInOutCubic,
    },
  ];

  int _currentPresetIndex = 2; // Start with 'Smooth'

  // Animation for fade-in effect
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

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

    // Initialize fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Load sample inserts asynchronously and initialize controller with them
    _loadInsertsFromServer();
  }

  /// Simulate loading inserts from server with delay, then initialize controller
  Future<void> _loadInsertsFromServer() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Create sample inserts
    final sampleInserts = _createSampleInserts();

    // Initialize controller with loaded inserts
    controller = MultiCanvasSketchController(
      initialColor: Colors.red,
      initialStrokeWidth: 4.0,
      initialFontSize: 16.0,
      maxHistorySteps: 30,
      defaultInserts: sampleInserts, // Pass loaded inserts directly
    );

    // Listen to controller changes to sync when needed
    controller!.addListener(_onControllerChanged);

    // Update loading state
    setState(() {
      isLoadingInserts = false;
    });

    // Start fade-in animation
    _fadeAnimationController.forward();

    debugPrint(
        'Loaded ${sampleInserts.length} inserts from server and initialized controller');
  }

  /// Create sample sketch inserts to demonstrate preloaded content
  List<SketchInsert> _createSampleInserts() {
    final now = DateTime.now();
    final List<SketchInsert> sampleInserts = [];

    // Sample inserts for section 0 (Meeting Notes)
    sampleInserts.addAll([
      // Drawing: Simple arrow pointing to "Review current progress"
      SketchInsert(
        id: 'arrow_1',
        sectionId: '0',
        points: const [
          Offset(50, 80),
          Offset(80, 80),
          Offset(75, 75),
          Offset(80, 80),
          Offset(75, 85),
        ],
        color: Colors.red,
        strokeWidth: 3.0,
        type: SketchInsertType.drawing,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),

      // Text annotation
      SketchInsert(
        id: 'note_1',
        sectionId: '0',
        points: const [], // Empty for text inserts
        color: Colors.blue,
        strokeWidth: 2.0,
        type: SketchInsertType.text,
        text: 'Priority!',
        textPosition: const Offset(100, 75),
        fontSize: 14.0,
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
    ]);

    // Sample inserts for section 1 (Design Ideas)
    sampleInserts.addAll([
      // Drawing: Simple circle highlighting "Color schemes"
      SketchInsert(
        id: 'circle_1',
        sectionId: '1',
        points: _generateCirclePoints(const Offset(120, 110), 25),
        color: Colors.green,
        strokeWidth: 2.5,
        type: SketchInsertType.drawing,
        createdAt: now.subtract(const Duration(minutes: 45)),
      ),

      // Text annotation for design ideas
      SketchInsert(
        id: 'design_note_1',
        sectionId: '1',
        points: const [],
        color: Colors.purple,
        strokeWidth: 2.0,
        type: SketchInsertType.text,
        text: 'Consider dark mode',
        textPosition: const Offset(200, 130),
        fontSize: 12.0,
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
    ]);

    // Sample inserts for section 2 (Technical Notes)
    sampleInserts.addAll([
      // Drawing: Underline for "Database schema"
      SketchInsert(
        id: 'underline_1',
        sectionId: '2',
        points: const [
          Offset(40, 95),
          Offset(140, 95),
        ],
        color: Colors.orange,
        strokeWidth: 3.0,
        type: SketchInsertType.drawing,
        createdAt: now.subtract(const Duration(minutes: 20)),
      ),

      // Text annotation
      SketchInsert(
        id: 'tech_note_1',
        sectionId: '2',
        points: const [],
        color: Colors.red,
        strokeWidth: 2.0,
        type: SketchInsertType.text,
        text: 'Review this!',
        textPosition: const Offset(150, 90),
        fontSize: 13.0,
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
    ]);

    // Sample inserts for section 3 (Action Items)
    sampleInserts.addAll([
      // Drawing: Checkmark next to "Update documentation"
      SketchInsert(
        id: 'checkmark_1',
        sectionId: '3',
        points: const [
          Offset(20, 85),
          Offset(25, 90),
          Offset(35, 75),
        ],
        color: Colors.green,
        strokeWidth: 4.0,
        type: SketchInsertType.drawing,
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),

      // Text showing deadline
      SketchInsert(
        id: 'deadline_1',
        sectionId: '3',
        points: const [],
        color: Colors.red,
        strokeWidth: 2.0,
        type: SketchInsertType.text,
        text: 'Due: Dec 15',
        textPosition: const Offset(250, 120),
        fontSize: 11.0,
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
    ]);

    return sampleInserts;
  }

  /// Helper method to generate points for a circle
  List<Offset> _generateCirclePoints(Offset center, double radius) {
    List<Offset> points = [];
    const int numPoints = 36; // 10 degree increments

    for (int i = 0; i <= numPoints; i++) {
      double angle = (i * 2 * 3.14159) / numPoints;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      points.add(Offset(x, y));
    }

    return points;
  }

  void _onControllerChanged() {
    // Only update if mounted and not already rebuilding
    if (!mounted) return;

    // Auto-sync when exiting sketch mode (deferred to avoid setState during build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Could sync here in real-time, or only when exiting sketch mode
        // For now, we'll sync only when explicitly requested
        if (!isSketchMode) {
          // Auto-sync when exiting sketch mode
          _syncFromController();
        }
        setState(
            () {}); // Update UI for other changes (undo/redo buttons, etc.)
      }
    });
  }

  // Sync app state from controller (call when save button pressed, etc.)
  void _syncFromController() {
    if (controller == null) return;

    setState(() {
      inserts
        ..clear()
        ..addAll(controller!.inserts);
    });
    // Here you could save to database, call API, etc.
    debugPrint('Synced ${inserts.length} inserts from controller');
  }

  // Simple undo - no external coordination needed
  void _undo() {
    controller?.undo(); // Safe call with null check
  }

  // Simple redo - no external coordination needed
  void _redo() {
    controller?.redo(); // Safe call with null check
  }

  // Cycle through animation presets
  void _cycleAnimationPreset() {
    setState(() {
      _currentPresetIndex =
          (_currentPresetIndex + 1) % _animationPresets.length;
      final preset = _animationPresets[_currentPresetIndex];
      _animationDuration = preset['duration'] as Duration;
      _animationCurve = preset['curve'] as Curve;
    });
  }

  // Cycle through toolbar positions
  void _cycleToolbarPosition() {
    const positions = SketchToolbarPosition.values;
    final currentIndex = positions.indexOf(_toolbarPosition);
    setState(() {
      _toolbarPosition = positions[(currentIndex + 1) % positions.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiCanvasSketchWrapper(
      controller: controller ??
          MultiCanvasSketchController(), // Provide fallback controller
      isEnabled: isSketchMode &&
          !isLoadingInserts &&
          controller != null, // Disable while loading or null
      toolbarPosition: _toolbarPosition,

      // Animation configuration
      enableToolbarAnimation: true,
      toolbarAnimationDuration: _animationDuration,
      toolbarAnimationCurve: _animationCurve,

      child: Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          title: const Text('Multi-Section Annotations'),
          backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
          elevation: 0,
          actions: [
            // Loading indicator
            if (isLoadingInserts)
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.blue,
                  ),
                ),
              ),

            // Manual sync button
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed:
                    isLoadingInserts ? null : () => _syncFromController(),
                icon: Icon(
                  Icons.save_rounded,
                  color:
                      isLoadingInserts ? Colors.grey[400] : Colors.green[600],
                ),
                style: IconButton.styleFrom(
                  backgroundColor:
                      isLoadingInserts ? Colors.grey[100] : Colors.green[50],
                ),
                tooltip: isLoadingInserts ? 'Loading...' : 'Save Current State',
              ),
            ),

            // Animation preset cycle button
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed:
                    isLoadingInserts ? null : () => _cycleAnimationPreset(),
                icon: Icon(
                  Icons.animation,
                  color:
                      isLoadingInserts ? Colors.grey[400] : Colors.purple[600],
                ),
                style: IconButton.styleFrom(
                  backgroundColor:
                      isLoadingInserts ? Colors.grey[100] : Colors.purple[50],
                ),
                tooltip: isLoadingInserts
                    ? 'Loading...'
                    : 'Animation: ${_animationPresets[_currentPresetIndex]['name']}',
              ),
            ),

            // Toolbar position cycle button
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed:
                    isLoadingInserts ? null : () => _cycleToolbarPosition(),
                icon: Icon(
                  Icons.dock,
                  color:
                      isLoadingInserts ? Colors.grey[400] : Colors.indigo[600],
                ),
                style: IconButton.styleFrom(
                  backgroundColor:
                      isLoadingInserts ? Colors.grey[100] : Colors.indigo[50],
                ),
                tooltip: isLoadingInserts
                    ? 'Loading...'
                    : 'Position: ${_toolbarPosition.name}',
              ),
            ),

            // Sketch mode toggle - single controller
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: isLoadingInserts
                    ? null
                    : () {
                        setState(() {
                          isSketchMode = !isSketchMode;
                        });
                      },
                icon: Icon(
                  isSketchMode ? Icons.edit_off : Icons.edit,
                  color: isLoadingInserts
                      ? Colors.grey[400]
                      : (isSketchMode ? Colors.orange[600] : Colors.grey[600]),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: isLoadingInserts
                      ? Colors.grey[100]
                      : (isSketchMode ? Colors.orange[50] : Colors.transparent),
                ),
                tooltip: isLoadingInserts
                    ? 'Loading...'
                    : (isSketchMode ? 'Exit Sketch Mode' : 'Enter Sketch Mode'),
              ),
            ),

            // History controls - single controller
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: (controller?.canUndo == true && !isLoadingInserts)
                    ? () => _undo()
                    : null,
                icon: Icon(
                  Icons.undo_rounded,
                  color: (controller?.canUndo == true && !isLoadingInserts)
                      ? Colors.blue[600]
                      : Colors.grey[400],
                ),
                tooltip: isLoadingInserts ? 'Loading...' : 'Undo',
              ),
            ),

            // Redo button
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: (controller?.canRedo == true && !isLoadingInserts)
                    ? () => _redo()
                    : null,
                icon: Icon(
                  Icons.redo_rounded,
                  color: (controller?.canRedo == true && !isLoadingInserts)
                      ? Colors.blue[600]
                      : Colors.grey[400],
                ),
                tooltip: isLoadingInserts ? 'Loading...' : 'Redo',
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
                          Text(
                            isLoadingInserts
                                ? 'Loading Annotations...'
                                : 'Animated Toolbar Demo',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isLoadingInserts
                                ? 'Fetching annotations from server...'
                                : 'Animation: ${_animationPresets[_currentPresetIndex]['name']} • Position: ${_toolbarPosition.name}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                          if (isLoadingInserts) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Loading 8 annotations...',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                  child: FadeInMultiCanvasRegion(
                    sectionId: index.toString(),
                    fadeAnimation: _fadeAnimation,
                    isLoadingInserts: isLoadingInserts,
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

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    controller?.dispose(); // Safe dispose with null check
    super.dispose();
  }
}

/// MultiCanvasRegion with fade-in animation support
class FadeInMultiCanvasRegion extends StatelessWidget {
  const FadeInMultiCanvasRegion({
    required this.sectionId,
    required this.fadeAnimation,
    required this.isLoadingInserts,
    required this.child,
    super.key,
  });

  final String sectionId;
  final Animation<double> fadeAnimation;
  final bool isLoadingInserts;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, _) {
        return Stack(
          children: [
            // Always show the content (text, etc.)
            child,
            // Show sketch layer with opacity animation
            if (!isLoadingInserts)
              Positioned.fill(
                child: Opacity(
                  opacity: fadeAnimation.value,
                  child: MultiCanvasRegion(
                    sectionId: sectionId,
                    child: Container(
                      // Transparent container that covers the entire area
                      // This ensures the sketch overlay covers the entire area
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
