package com.camaroo.camera_info_android

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.math.atan
import kotlin.math.tan

class CameraInfoPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private lateinit var cameraManager: CameraManager

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "camera_info")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "getCameraProperties" -> {
        val cameraId = call.argument<String>("cameraId")
        if (cameraId == null) {
          result.error("INVALID_ARGUMENT", "cameraId is required", null)
          return
        }
        getCameraProperties(cameraId, result)
      }
      "getAllCameraProperties" -> {
        getAllCameraProperties(result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun getCameraProperties(cameraId: String, result: MethodChannel.Result) {
    try {
      val characteristics = cameraManager.getCameraCharacteristics(cameraId)
      val properties = getPropertiesFromCharacteristics(cameraId, characteristics)
      result.success(properties)
    } catch (e: Exception) {
      result.error("CAMERA_NOT_FOUND", "Camera with id $cameraId not found: ${e.message}", null)
    }
  }

  private fun getAllCameraProperties(result: MethodChannel.Result) {
    try {
      val cameraIds = cameraManager.cameraIdList
      val allProperties = mutableMapOf<String, Map<String, Any?>>()
      
      for (cameraId in cameraIds) {
        try {
          val characteristics = cameraManager.getCameraCharacteristics(cameraId)
          val properties = getPropertiesFromCharacteristics(cameraId, characteristics)
          allProperties[cameraId] = properties
        } catch (e: Exception) {
          // Skip cameras that fail to load
          continue
        }
      }
      
      result.success(allProperties)
    } catch (e: Exception) {
      result.error("ERROR", "Failed to get camera properties: ${e.message}", null)
    }
  }

  private fun getPropertiesFromCharacteristics(
    cameraId: String,
    characteristics: CameraCharacteristics
  ): Map<String, Any?> {
    val properties = mutableMapOf<String, Any?>()
    properties["cameraId"] = cameraId

    // Get focal lengths
    val focalLengths = characteristics.get(CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS)
    if (focalLengths != null && focalLengths.isNotEmpty()) {
      val focalLength = focalLengths[0].toDouble()
      properties["focalLength"] = focalLength
    }

    // Get sensor size
    val sensorSize = characteristics.get(CameraCharacteristics.SENSOR_INFO_PIXEL_ARRAY_SIZE)
    if (sensorSize != null) {
      properties["sensorSize"] = mapOf(
        "width" to sensorSize.width.toDouble(),
        "height" to sensorSize.height.toDouble()
      )
    }

    // Calculate field of view from focal length and sensor size
    if (focalLengths != null && focalLengths.isNotEmpty() && sensorSize != null) {
      val focalLength = focalLengths[0].toDouble()
      
      // Get sensor physical size if available (in mm)
      val sensorPhysicalSize = characteristics.get(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)
      if (sensorPhysicalSize != null) {
        val physicalWidth = sensorPhysicalSize.width * 1000.0 // Convert to mm
        val fovRadians = 2.0 * atan(physicalWidth / (2.0 * focalLength))
        val fovDegrees = Math.toDegrees(fovRadians)
        properties["fieldOfView"] = fovDegrees
      } else {
        // Fallback: approximate FOV using pixel size (less accurate)
        val sensorWidth = sensorSize.width.toDouble()
        val approximateFOV = 2.0 * atan(sensorWidth / (2.0 * focalLength * 1000.0))
        properties["fieldOfView"] = Math.toDegrees(approximateFOV)
      }
    }

    return properties
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}