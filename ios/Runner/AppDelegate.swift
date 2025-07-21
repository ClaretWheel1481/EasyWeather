import Flutter
import UIKit
import Network
import BackgroundTasks

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let networkMonitor = NWPathMonitor()
  private let networkQueue = DispatchQueue(label: "NetworkMonitor")
  private var eventSink: FlutterEventSink?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 设置方法通道和事件通道
    setupChannels()
    
    // 注册后台任务
    registerBackgroundTasks()
    
    // 启动网络监控
    startNetworkMonitoring()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func setupChannels() {
    guard let controller = window?.rootViewController as? FlutterViewController else { return }
    
    let methodChannel = FlutterMethodChannel(name: "weather_service", binaryMessenger: controller.binaryMessenger)
    let eventChannel = FlutterEventChannel(name: "weather_service_events", binaryMessenger: controller.binaryMessenger)
    
    // 设置方法通道处理器
    methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "startBackgroundService":
        self?.startBackgroundService()
        result(true)
      case "stopBackgroundService":
        self?.stopBackgroundService()
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    // 设置事件通道处理器
    eventChannel.setStreamHandler(self)
  }
  
  private func registerBackgroundTasks() {
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: "com.zephyr.weather.refresh",
      using: nil
    ) { task in
      self.handleWeatherRefresh(task: task as! BGAppRefreshTask)
    }
    print("iOS: 后台任务已注册")
  }
  
  private func handleWeatherRefresh(task: BGAppRefreshTask) {
    print("iOS: 开始处理天气刷新任务")
    
    task.expirationHandler = {
      print("iOS: 天气刷新任务已过期")
      task.setTaskCompleted(success: false)
    }
    
    // 发送事件到Flutter端
    DispatchQueue.main.async {
      self.eventSink?("FETCH_WEATHER")
      print("iOS: 已发送天气获取事件到Flutter端")
    }
    
    // 调度下一次任务
    scheduleWeatherRefresh()
    task.setTaskCompleted(success: true)
  }
  
  private func scheduleWeatherRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "com.zephyr.weather.refresh")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
    
    do {
      try BGTaskScheduler.shared.submit(request)
      print("iOS: 天气刷新任务已调度，将在15分钟后执行")
    } catch {
      print("iOS: 调度天气刷新任务失败: \(error)")
    }
  }
  
  private func startBackgroundService() {
    print("iOS: 启动后台天气服务")
    scheduleWeatherRefresh()
  }
  
  private func stopBackgroundService() {
    print("iOS: 停止后台天气服务")
    BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.zephyr.weather.refresh")
  }
  
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
  
  private func startNetworkMonitoring() {
    networkMonitor.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        if path.status == .satisfied {
          print("网络连接可用")
        } else {
          print("网络连接不可用")
        }
      }
    }
    networkMonitor.start(queue: networkQueue)
  }
  
  override func applicationDidEnterBackground(_ application: UIApplication) {
    super.applicationDidEnterBackground(application)
    print("应用进入后台")
  }
  
  override func applicationWillEnterForeground(_ application: UIApplication) {
    super.applicationWillEnterForeground(application)
    print("应用进入前台")
  }
  
  override func applicationWillTerminate(_ application: UIApplication) {
    super.applicationWillTerminate(application)
    print("应用即将终止")
  }
  
  deinit {
    networkMonitor.cancel()
  }
}

// 扩展AppDelegate实现FlutterStreamHandler
extension AppDelegate: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }
}

