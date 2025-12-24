import 'package:flutter/material.dart';
import 'package:camaroo/utils/app_constants.dart';
import 'package:camaroo/utils/theme_constants.dart';
import 'package:camaroo/ui/camera.dart'; // Your new simple camera screen
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:camaroo/core/models/camera_model.dart';
import 'package:camaroo/adapters/camera_adapter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Cameroo());
}

class Cameroo extends StatelessWidget {
   Cameroo({super.key}){
    cameraApi = CameraApiModel();
    cameraAdapter = CameraAdapter(cameraApi);
  }

  late final CameraApi cameraApi;
  late final CameraAdapter cameraAdapter;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ThemeConstants.primaryColor),
      ),
      home: Camera(cameraApi: cameraApi, cameraAdapter: cameraAdapter), // Use the new simple camera
    );
  }
}