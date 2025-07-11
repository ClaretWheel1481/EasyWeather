import Flutter
import UIKit
import Network

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let networkMonitor = NWPathMonitor()
  private let networkQueue = DispatchQueue(label: "NetworkMonitor")
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 启动网络监控
    startNetworkMonitoring()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
  
  deinit {
    networkMonitor.cancel()
  }
}
