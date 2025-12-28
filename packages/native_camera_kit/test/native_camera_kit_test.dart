import 'package:flutter_test/flutter_test.dart';
import 'package:native_camera_kit/native_camera_kit.dart';

void main() {
  test('camera enums are defined', () {
    expect(CameraPosition.back, isNotNull);
    expect(CameraPosition.front, isNotNull);
    expect(FlashMode.off, isNotNull);
    expect(FlashMode.on, isNotNull);
    expect(FlashMode.auto, isNotNull);
    expect(FlashMode.torch, isNotNull);
    expect(CameraStatus.uninitialized, isNotNull);
    expect(CameraStatus.ready, isNotNull);
  });
}
