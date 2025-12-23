import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/editor_service.dart';

class FilterPanel extends StatelessWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final editorService = context.read<EditorService>();

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        children: [
          _FilterButton(
            label: 'None',
            onTap: () => editorService.resetImage(),
          ),
          _FilterButton(
            label: 'Grayscale',
            onTap: () => editorService.applyGrayscale(),
          ),
          _FilterButton(
            label: 'Sepia',
            onTap: () => editorService.applySepia(),
          ),
          _FilterButton(
            label: 'Vintage',
            onTap: () => editorService.applyVintage(),
          ),
          _FilterButton(
            label: 'Blur',
            onTap: () => editorService.applyBlur(5),
          ),
          _FilterButton(
            label: 'Sharpen',
            onTap: () => editorService.applySharpen(),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Center(
                child: Text(
                  label[0],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
