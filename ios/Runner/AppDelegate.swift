import Flutter
import UIKit
import Network
import BackgroundTasks

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let networkMonitor = NWPathMonitor()
  private let networkQueue = DispatchQueue(label: "NetworkMonitor")
  private let weatherService = WeatherBackgroundService.shared
  private var methodChannel: FlutterMethodChannel?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 手动注册天气服务插件
    WeatherServicePlugin.register(with: self.registrar(forPlugin: "WeatherServicePlugin")!)
    
    // 启动网络监控
    startNetworkMonitoring()
    
    // 启动后台天气服务
    weatherService.startBackgroundService()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
  
  // 设置方法通道
  func setupMethodChannel(with messenger: FlutterBinaryMessenger) {
    methodChannel = FlutterMethodChannel(name: "weather_service", binaryMessenger: messenger)
    methodChannel?.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "startBackgroundService":
        self?.weatherService.startBackgroundService()
        result(true)
      case "stopBackgroundService":
        self?.weatherService.stopBackgroundService()
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func startNetworkMonitoring() {
    networkMonitor.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        if path.status == .satisfied {
          print("网络连接可用")
          // 网络可用时可以进行网络请求
        } else {
          print("网络连接不可用")
        }
      }
    }
    networkMonitor.start(queue: networkQueue)
  }
  
  // 应用进入后台
  override func applicationDidEnterBackground(_ application: UIApplication) {
    super.applicationDidEnterBackground(application)
    print("应用进入后台，启动后台天气服务")
    weatherService.startBackgroundService()
  }
  
  // 应用进入前台
  override func applicationWillEnterForeground(_ application: UIApplication) {
    super.applicationWillEnterForeground(application)
    print("应用进入前台")
  }
  
  // 应用即将终止
  override func applicationWillTerminate(_ application: UIApplication) {
    super.applicationWillTerminate(application)
    print("应用即将终止，停止后台天气服务")
    weatherService.stopBackgroundService()
  }
  
  deinit {
    networkMonitor.cancel()
  }
}

