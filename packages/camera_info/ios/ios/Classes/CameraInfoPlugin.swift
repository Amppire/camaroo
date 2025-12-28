import Flutter
import UIKit
import AVFoundation

public class CameraInfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "camera_info", binaryMessenger: registrar.messenger())
    let instance = CameraInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getCameraProperties":
      guard let args = call.arguments as? [String: Any],
            let cameraId = args["cameraId"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "cameraId is required", details: nil))
        return
      }
      getCameraProperties(cameraId: cameraId, result: result)
      
    case "getAllCameraProperties":
      getAllCameraProperties(result: result)
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func getCameraProperties(cameraId: String, result: @escaping FlutterResult) {
    let devices = AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera, .builtInTelephotoCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInTripleCamera],
      mediaType: .video,
      position: .unspecified
    ).devices
    
    guard let device = devices.first(where: { $0.uniqueID == cameraId }) else {
      result(FlutterError(
        code: "CAMERA_NOT_FOUND",
        message: "Camera with id \(cameraId) not found",
        details: nil
      ))
      return
    }
    
    let properties = getPropertiesForDevice(device: device)
    result(properties)
  }
  
  private func getAllCameraProperties(result: @escaping FlutterResult) {
    let devices = AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera, .builtInTelephotoCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInTripleCamera],
      mediaType: .video,
      position: .unspecified
    ).devices
    
    var allProperties: [String: [String: Any]] = [:]
    
    for device in devices {
      let properties = getPropertiesForDevice(device: device)
      allProperties[device.uniqueID] = properties
    }
    
    result(allProperties)
  }
  
private func getPropertiesForDevice(device: AVCaptureDevice) -> [String: Any] {
  var properties: [String: Any] = [
    "cameraId": device.uniqueID
  ]
  
  // Get active format
  let format = device.activeFormat
  
  // Field of View (in degrees)
  if format.videoFieldOfView > 0 {
    properties["fieldOfView"] = Double(format.videoFieldOfView)
  }
  
  // Focal length (in mm) - approximate calculation
  // iOS doesn't directly expose focal length, but we can estimate from FOV
  // FOV = 2 * arctan(sensor_width / (2 * focal_length))
  // focal_length = sensor_width / (2 * tan(FOV / 2))
  
  // Sensor dimensions (approximate, varies by device)
  let sensorWidth: Double? = format.videoMaxZoomFactor > 0 ? 
    Double(format.videoMaxZoomFactor * 36.0) / 10.0 : nil
  
  if let sensorWidth = sensorWidth, format.videoFieldOfView > 0 {
    // Convert Float to Double for calculations
    let fovDegrees = Double(format.videoFieldOfView)
    let fovRadians = fovDegrees * Double.pi / 180.0
    let focalLength = sensorWidth / (2.0 * tan(fovRadians / 2.0))
    properties["focalLength"] = focalLength
  }
  
  // Sensor size (approximate)
  if let sensorWidth = sensorWidth {
    let sensorHeight = sensorWidth * 0.75 // Approximate aspect ratio
    properties["sensorSize"] = [
      "width": sensorWidth,
      "height": sensorHeight
    ]
  }
  
  return properties
}
}