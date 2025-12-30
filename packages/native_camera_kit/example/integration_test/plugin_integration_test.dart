import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_camera_kit/native_camera_kit.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Can get available cameras', (tester) async {
    final controller = NativeCameraController();
    
    try {
      final cameras = await controller.getAvailableCameras();
      expect(cameras, isNotEmpty);
      expect(cameras.first.id, isNotEmpty);
      expect(cameras.first.name, isNotEmpty);
    } finally {
      await controller.dispose();
    }
  });

  testWidgets('Can initialize camera', (tester) async {
    final controller = NativeCameraController();
    
    try {
      await controller.initializeDefault();
      
      // Wait for initialization
      await tester.pumpAndSettle();
      
      expect(controller.status.value, CameraStatus.ready);
      expect(controller.textureId.value, isNotNull);
    } finally {
      await controller.dispose();
    }
  });
}
