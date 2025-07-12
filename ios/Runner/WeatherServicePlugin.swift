import Flutter
import UIKit

public class WeatherServicePlugin: NSObject, FlutterPlugin {
  private var eventSink: FlutterEventSink?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "weather_service", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "weather_service_events", binaryMessenger: registrar.messenger())
    let instance = WeatherServicePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "startBackgroundService":
      WeatherBackgroundService.shared.startBackgroundService()
      result(true)
    case "stopBackgroundService":
      WeatherBackgroundService.shared.stopBackgroundService()
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

// 事件通道
extension WeatherServicePlugin: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    // 将事件通道连接到后台服务
    WeatherBackgroundService.shared.setEventSink(events)
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    // 断开事件通道连接
    WeatherBackgroundService.shared.setEventSink(nil)
    return nil
  }
  
  // 发送事件到Flutter端
  func sendEvent(_ event: String) {
    eventSink?(event)
  }
} 