import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/editor_service.dart';
import '../widgets/editor_toolbar.dart';
import '../widgets/adjustment_panel.dart';
import '../widgets/filter_panel.dart';

class EditorScreen extends StatefulWidget {
  final String imagePath;

  const EditorScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  EditorMode _currentMode = EditorMode.none;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final editorService = context.read<EditorService>();
    await editorService.loadImage(widget.imagePath);
  }

  Future<void> _saveImage() async {
    final editorService = context.read<EditorService>();
    
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final directory = Directory(widget.imagePath).parent;
      final outputPath = '${directory.path}/edited_$timestamp.jpg';
      
      await editorService.saveImage(outputPath);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Photo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<EditorService>().resetImage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveImage,
          ),
        ],
      ),
      body: Consumer<EditorService>(
        builder: (context, editorService, child) {
          if (editorService.isProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          final imageBytes = editorService.getImageBytes();
          
          return Column(
            children: [
              // Image preview
              Expanded(
                child: Center(
                  child: imageBytes != null
                      ? InteractiveViewer(
                          panEnabled: true,
                          scaleEnabled: true,
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Image.memory(
                            imageBytes,
                            fit: BoxFit.contain,
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
              
              // Editor panels
              if (_currentMode == EditorMode.adjust)
                const AdjustmentPanel()
              else if (_currentMode == EditorMode.filter)
                const FilterPanel(),
              
              // Editor toolbar
              EditorToolbar(
                currentMode: _currentMode,
                onModeChanged: (mode) {
                  setState(() {
                    _currentMode = mode;
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

enum EditorMode {
  none,
  adjust,
  filter,
  crop,
  draw,
  text,
}
