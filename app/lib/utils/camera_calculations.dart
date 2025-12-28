// class CameraCalculations {
//     /// Calculate digital zoom needed for a camera to reach target effective focal length
//   static double? calculateDigitalZoomForTargetFocalLength({
//     required String cameraName,
//     required double targetEffectiveFocalLength,
//   }) {
//     return effectiveFocalLengthToDigitalZoom(
//       cameraName: cameraName,
//       effectiveFocalLength: targetEffectiveFocalLength,
//     );
//   }

//     /// Convert digital zoom to effective focal length
//   ///
//   /// Formula: Effective Focal Length = Base Focal Length × Digital Zoom
//   ///
//   /// Example:
//   ///   Wide camera: 4.25mm base, 1.5x digital zoom
//   ///   Effective = 4.25mm × 1.5 = 6.375mm
//   double? digitalZoomToEffectiveFocalLength({
//     required String cameraName,
//     required double digitalZoom,
//   }) {
//     final props = _cameraProperties[cameraName];
//     if (props?.focalLength == null) return null;

//     final baseFocalLength = props!.focalLength!;
//     return baseFocalLength * digitalZoom;
//   }

//   /// Convert effective focal length to digital zoom for a camera
//   ///
//   /// Formula: Digital Zoom = Effective Focal Length / Base Focal Length
//   ///
//   /// Example:
//   ///   Want 8.5mm effective focal length
//   ///   Wide camera: 4.25mm base
//   ///   Digital zoom = 8.5mm / 4.25mm = 2.0x
//   double? effectiveFocalLengthToDigitalZoom({
//     required String cameraName,
//     required double effectiveFocalLength,
//   }) {
//     final props = _cameraProperties[cameraName];
//     if (props?.focalLength == null || props!.focalLength! <= 0) return null;

//     return effectiveFocalLength / props.focalLength!;
//   }

//   /// Convert total zoom (what user wants) to effective focal length
//   ///
//   /// Formula: Effective Focal Length = Wide Camera Focal Length × Total Zoom
//   ///
//   /// Example:
//   ///   User wants 2.0x total zoom
//   ///   Wide camera: 4.25mm
//   ///   Effective = 4.25mm × 2.0 = 8.5mm
//   double? totalZoomToEffectiveFocalLength(double totalZoom) {
//     // Find wide camera focal length
//     double? wideFocalLength;

//     for (final camera in _cameras) {
//       if (camera.lensType == CameraLensType.wide &&
//           camera.lensDirection == CameraLensDirection.back) {
//         final props = _cameraProperties[camera.name];
//         wideFocalLength = props?.focalLength;
//         break;
//       }
//     }

//     // Fallback: use shortest focal length
//     if (wideFocalLength == null) {
//       for (final props in _cameraProperties.values) {
//         if (props.focalLength != null) {
//           if (wideFocalLength == null ||
//               props.focalLength! < wideFocalLength!) {
//             wideFocalLength = props.focalLength;
//           }
//         }
//       }
//     }

//     if (wideFocalLength == null || wideFocalLength! <= 0) return null;

//     return wideFocalLength * totalZoom;
//   }

// }