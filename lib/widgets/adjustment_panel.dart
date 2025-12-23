import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/editor_service.dart';

class AdjustmentPanel extends StatefulWidget {
  const AdjustmentPanel({super.key});

  @override
  State<AdjustmentPanel> createState() => _AdjustmentPanelState();
}

class _AdjustmentPanelState extends State<AdjustmentPanel> {
  double _brightness = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;

  @override
  Widget build(BuildContext context) {
    final editorService = context.read<EditorService>();

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Adjustments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {
                  editorService.autoEnhance();
                },
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('Auto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Brightness
          _buildSlider(
            label: 'Brightness',
            value: _brightness,
            min: 0.5,
            max: 1.5,
            onChanged: (value) {
              setState(() => _brightness = value);
              editorService.adjustBrightness(value);
            },
          ),
          
          // Contrast
          _buildSlider(
            label: 'Contrast',
            value: _contrast,
            min: 0.5,
            max: 1.5,
            onChanged: (value) {
              setState(() => _contrast = value);
              editorService.adjustContrast(value);
            },
          ),
          
          // Saturation
          _buildSlider(
            label: 'Saturation',
            value: _saturation,
            min: 0.0,
            max: 2.0,
            onChanged: (value) {
              setState(() => _saturation = value);
              editorService.adjustSaturation(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
