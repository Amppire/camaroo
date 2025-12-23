import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/camera_service.dart';
import '../models/camera_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<CameraService>(
        builder: (context, cameraService, child) {
          final settings = cameraService.settings;
          
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Camera Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Shutter Speed
              ListTile(
                title: const Text('Shutter Speed'),
                subtitle: Text('1/${(1 / settings.shutterSpeed).round()}s'),
              ),
              Slider(
                value: settings.shutterSpeed,
                min: 1 / 8000,
                max: 1 / 30,
                onChanged: (value) {
                  cameraService.updateShutterSpeed(value);
                },
              ),
              
              // ISO
              ListTile(
                title: const Text('ISO'),
                subtitle: Text(settings.iso.round().toString()),
              ),
              Slider(
                value: settings.iso,
                min: 100,
                max: 3200,
                divisions: 10,
                onChanged: (value) {
                  cameraService.updateISO(value);
                },
              ),
              
              // Exposure
              ListTile(
                title: const Text('Exposure'),
                subtitle: Text('${settings.exposureTime.toStringAsFixed(2)}s'),
              ),
              Slider(
                value: settings.exposureTime,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  cameraService.updateExposureTime(value);
                },
              ),
              
              // White Balance
              ListTile(
                title: const Text('White Balance'),
                subtitle: Text('${settings.whiteBalance.round()}K'),
              ),
              Slider(
                value: settings.whiteBalance,
                min: 2000,
                max: 10000,
                onChanged: (value) {
                  cameraService.updateWhiteBalance(value);
                },
              ),
              
              // Focal Length
              ListTile(
                title: const Text('Focal Length'),
                subtitle: Text('${settings.focalLength.round()}mm'),
              ),
              Slider(
                value: settings.focalLength,
                min: 10,
                max: 200,
                onChanged: (value) {
                  cameraService.updateFocalLength(value);
                },
              ),
              
              const Divider(),
              
              // Focus Mode
              ListTile(
                title: const Text('Focus Mode'),
                trailing: DropdownButton<FocusMode>(
                  value: settings.focusMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      cameraService.setFocusMode(mode);
                    }
                  },
                  items: FocusMode.values.map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(mode.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
              
              // Flash Mode
              ListTile(
                title: const Text('Flash Mode'),
                trailing: DropdownButton<FlashMode>(
                  value: settings.flashMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      cameraService.setFlashMode(mode);
                    }
                  },
                  items: FlashMode.values.map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(mode.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
              
              const Divider(),
              
              // Toggle Settings
              SwitchListTile(
                title: const Text('Grid Overlay'),
                value: settings.gridOverlay,
                onChanged: (_) => cameraService.toggleGrid(),
              ),
              
              SwitchListTile(
                title: const Text('Show Histogram'),
                value: settings.showHistogram,
                onChanged: (_) => cameraService.toggleHistogram(),
              ),
              
              SwitchListTile(
                title: const Text('Portrait Mode'),
                value: settings.portraitMode,
                onChanged: (_) => cameraService.togglePortraitMode(),
              ),
              
              const Divider(),
              
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const ListTile(
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              
              const ListTile(
                title: Text('Camaroo'),
                subtitle: Text('Professional Camera Application'),
              ),
            ],
          );
        },
      ),
    );
  }
}
