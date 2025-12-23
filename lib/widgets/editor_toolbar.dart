import 'package:flutter/material.dart';
import '../screens/editor_screen.dart';

class EditorToolbar extends StatelessWidget {
  final EditorMode currentMode;
  final Function(EditorMode) onModeChanged;

  const EditorToolbar({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ToolButton(
            icon: Icons.tune,
            label: 'Adjust',
            isSelected: currentMode == EditorMode.adjust,
            onTap: () => onModeChanged(
              currentMode == EditorMode.adjust ? EditorMode.none : EditorMode.adjust,
            ),
          ),
          _ToolButton(
            icon: Icons.filter,
            label: 'Filter',
            isSelected: currentMode == EditorMode.filter,
            onTap: () => onModeChanged(
              currentMode == EditorMode.filter ? EditorMode.none : EditorMode.filter,
            ),
          ),
          _ToolButton(
            icon: Icons.crop,
            label: 'Crop',
            isSelected: currentMode == EditorMode.crop,
            onTap: () => onModeChanged(
              currentMode == EditorMode.crop ? EditorMode.none : EditorMode.crop,
            ),
          ),
          _ToolButton(
            icon: Icons.brush,
            label: 'Draw',
            isSelected: currentMode == EditorMode.draw,
            onTap: () => onModeChanged(
              currentMode == EditorMode.draw ? EditorMode.none : EditorMode.draw,
            ),
          ),
          _ToolButton(
            icon: Icons.text_fields,
            label: 'Text',
            isSelected: currentMode == EditorMode.text,
            onTap: () => onModeChanged(
              currentMode == EditorMode.text ? EditorMode.none : EditorMode.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.white,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
