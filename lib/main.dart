import 'package:camaroo/ui/camera.dart' as camera_ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camaroo/utils/app_constants.dart';
import 'package:camaroo/utils/theme_constants.dart';

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final camerasList = await availableCameras();
    print('Found ${camerasList.length} cameras');
    
    // CRITICAL: Set cameras in camera.dart's _cameras variable
    camera_ui.cameras = camerasList;
    
  } on CameraException catch (e) {
    print('Error: ${e.code}\n${e.description}');
  }
  runApp(const camera_ui.CameraApp());
}

class Cameroo extends StatelessWidget {
  const Cameroo({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ThemeConstants.primaryColor),
      ),
      home: const camera_ui.CameraExampleHome(),
    );
  }
}