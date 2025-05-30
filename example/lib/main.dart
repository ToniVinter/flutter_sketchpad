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
          centerTitle: true,
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
  int currentSection = 0;

  // Undo/Redo functionality
  List<List<SketchInsert>> history = [];
  int historyIndex = -1;
  bool isUndoRedoOperation = false;

  @override
  void initState() {
    super.initState();
    _saveToHistory(); // Save initial empty state
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveToHistory() {
    if (isUndoRedoOperation) return; // Don't save during undo/redo operations

    // Remove any future history if we're in the middle of the stack
    if (historyIndex < history.length - 1) {
      history = history.sublist(0, historyIndex + 1);
    }

    // Add current state to history
    history.add(List<SketchInsert>.from(inserts));
    historyIndex++;

    // Limit history size to prevent memory issues
    if (history.length > 50) {
      history.removeAt(0);
      historyIndex--;
    }
  }

  void _undo() {
    if (historyIndex > 0) {
      isUndoRedoOperation = true;
      historyIndex--;
      setState(() {
        inserts = List<SketchInsert>.from(history[historyIndex]);
      });
      isUndoRedoOperation = false;
      _showSuccessHaptic();
    }
  }

  void _redo() {
    if (historyIndex < history.length - 1) {
      isUndoRedoOperation = true;
      historyIndex++;
      setState(() {
        inserts = List<SketchInsert>.from(history[historyIndex]);
      });
      isUndoRedoOperation = false;
      _showSuccessHaptic();
    }
  }

  bool get canUndo => historyIndex > 0;
  bool get canRedo => historyIndex < history.length - 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Sketchpad',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Toolbar below app bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                // Drawing Tools Section
                // Undo button
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  child: IconButton(
                    onPressed: canUndo ? _undo : null,
                    icon: Icon(
                      Icons.undo_rounded,
                      color: canUndo ? Colors.orange[600] : Colors.grey[400],
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: canUndo
                          ? (isDark
                              ? Colors.orange[600]?.withValues(alpha: 0.1)
                              : Colors.orange[50])
                          : Colors.transparent,
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(36, 36),
                    ),
                    tooltip: 'Undo',
                  ),
                ),

                // Redo button
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    onPressed: canRedo ? _redo : null,
                    icon: Icon(
                      Icons.redo_rounded,
                      color: canRedo ? Colors.orange[600] : Colors.grey[400],
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: canRedo
                          ? (isDark
                              ? Colors.orange[600]?.withValues(alpha: 0.1)
                              : Colors.orange[50])
                          : Colors.transparent,
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(36, 36),
                    ),
                    tooltip: 'Redo',
                  ),
                ),

                // Vertical divider
                Container(
                  height: 24,
                  width: 1,
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                ),

                // Section switcher button
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: _switchSection,
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'S${currentSection + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    tooltip: 'Switch Section',
                  ),
                ),

                // Spacer to push management tools to the right
                const Spacer(),

                // Management Tools Section
                // Inserts list button
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  child: IconButton(
                    onPressed: () => _showInsertsList(context),
                    icon: Icon(
                      Icons.list_rounded,
                      color: Colors.green[600],
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.green[600]?.withValues(alpha: 0.1)
                          : Colors.green[50],
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(36, 36),
                    ),
                    tooltip: 'View Elements',
                  ),
                ),

                // Clear all button
                Container(
                  margin: const EdgeInsets.only(right: 2),
                  child: IconButton(
                    onPressed: () => _showClearConfirmation(context),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red[400],
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.red[400]?.withValues(alpha: 0.1)
                          : Colors.red[50],
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(36, 36),
                    ),
                    tooltip: 'Clear All',
                  ),
                ),
              ],
            ),
          ),

          // Main sketchpad content
          Expanded(
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
                  child: SketchWrapper(
                    sectionIndex: currentSection,
                    inserts: inserts,
                    isSketchMode: true,
                    onSaveInsert:
                        (sectionIndex, points, strokeWidth, color, type) {
                      final insert = SketchInsert(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        sectionIndex: sectionIndex,
                        points: points,
                        color: color,
                        strokeWidth: strokeWidth,
                        type: type,
                      );
                      setState(() {
                        inserts.add(insert);
                      });
                      _saveToHistory(); // Save to history after adding
                      _showSuccessHaptic();
                    },
                    onSaveTextInsert:
                        (sectionIndex, text, position, color, fontSize) {
                      final insert = SketchInsert(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        sectionIndex: sectionIndex,
                        points: [],
                        color: color,
                        strokeWidth: 1.0,
                        type: SketchInsertType.text,
                        text: text,
                        textPosition: position,
                        fontSize: fontSize,
                      );
                      setState(() {
                        inserts.add(insert);
                      });
                      _saveToHistory(); // Save to history after adding
                      _showSuccessHaptic();
                    },
                    onUpdateTextInsert: (id, text) {
                      setState(() {
                        final index = inserts.indexWhere((i) => i.id == id);
                        if (index != -1) {
                          inserts[index] = inserts[index].copyWith(text: text);
                        }
                      });
                    },
                    onUpdateTextPosition: (id, position) {
                      setState(() {
                        final index = inserts.indexWhere((i) => i.id == id);
                        if (index != -1) {
                          inserts[index] =
                              inserts[index].copyWith(textPosition: position);
                        }
                      });
                    },
                    onEraseInsertAt: (sectionIndex, position, size) {
                      setState(() {
                        final removedCount = inserts.length;
                        inserts.removeWhere((insert) {
                          if (insert.sectionIndex != sectionIndex) return false;

                          if (insert.type == SketchInsertType.text &&
                              insert.textPosition != null) {
                            final distance =
                                (insert.textPosition! - position).distance;
                            return distance < size;
                          }

                          return insert.points.any((point) {
                            final distance = (point - position).distance;
                            return distance < size;
                          });
                        });
                        if (inserts.length < removedCount) {
                          _saveToHistory(); // Save to history after erasing
                          _showSuccessHaptic();
                        }
                      });
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: inserts
                              .where((i) => i.sectionIndex == currentSection)
                              .isEmpty
                          ? _buildEmptyState(isDark)
                          : Container(),
                    ),
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

  void _switchSection() {
    setState(() {
      currentSection = (currentSection + 1) % 3;
    });
    _showSuccessHaptic();
  }

  void _showSuccessHaptic() {
    // Add haptic feedback for better UX
    // HapticFeedback.lightImpact();
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Clear All',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to clear all sketches and annotations?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                inserts.clear();
              });
              _saveToHistory(); // Save to history after clearing
              Navigator.of(context).pop();
              _showSuccessHaptic();
            },
            child: const Text(
              'Clear',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
            if (inserts.isNotEmpty) ...[
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      color: Colors.red),
                ),
                title: const Text('Clear All'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.of(context).pop();
                  _showClearConfirmation(context);
                },
              ),
            ],
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
            _saveToHistory(); // Save to history after deleting
            _showSuccessHaptic();
          },
          onClearAll: () {
            _showClearConfirmation(context);
          },
        ),
      ),
    );
  }
}

class SketchElementsListPage extends StatefulWidget {
  final List<SketchInsert> inserts;
  final Function(int) onInsertDeleted;
  final VoidCallback onClearAll;

  const SketchElementsListPage({
    super.key,
    required this.inserts,
    required this.onInsertDeleted,
    required this.onClearAll,
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
              widget.onClearAll();
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: Colors.red[400],
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
                              : Icons.edit_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      title: Text(
                        insert.type == SketchInsertType.text
                            ? insert.text ?? 'Text Element'
                            : 'Drawing (${insert.points.length} points)',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text('Section ${insert.sectionIndex + 1}'),
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
