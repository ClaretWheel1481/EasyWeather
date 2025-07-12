import Foundation
import BackgroundTasks
import UIKit

@objc class WeatherBackgroundService: NSObject {
    static let shared = WeatherBackgroundService()
    private let backgroundTaskIdentifier = "com.zephyr.weather.refresh"
    private var eventSink: FlutterEventSink?
    
    override init() {
        super.init()
        registerBackgroundTasks()
    }
    
    // 设置事件通道
    func setEventSink(_ sink: FlutterEventSink?) {
        self.eventSink = sink
    }
    
    // 注册后台任务
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: backgroundTaskIdentifier,
            using: nil
        ) { task in
            self.handleWeatherRefresh(task: task as! BGAppRefreshTask)
        }
        print("iOS: 后台任务已注册")
    }
    
    // 处理天气刷新任务
    func handleWeatherRefresh(task: BGAppRefreshTask) {
        print("iOS: 开始处理天气刷新任务")
        
        // 设置任务过期处理
        task.expirationHandler = {
            print("iOS: 天气刷新任务已过期")
            task.setTaskCompleted(success: false)
        }
        
        // 通过事件通道发送通知到Flutter端
        DispatchQueue.main.async {
            self.eventSink?("FETCH_WEATHER")
            print("iOS: 已发送天气获取事件到Flutter端")
        }
        
        // 调度下一次任务
        scheduleWeatherRefresh()
        task.setTaskCompleted(success: true)
    }
    
    // 调度天气刷新任务
    func scheduleWeatherRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60) // 5分钟后
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("iOS: 天气刷新任务已调度，将在5分钟后执行")
        } catch {
            print("iOS: 调度天气刷新任务失败: \(error)")
        }
    }
    
    // 启动后台服务
    func startBackgroundService() {
        print("iOS: 启动后台天气服务")
        scheduleWeatherRefresh()
        print("iOS: 后台天气服务已启动")
    }
    
    // 停止后台服务
    func stopBackgroundService() {
        print("iOS: 停止后台天气服务")
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: backgroundTaskIdentifier)
        print("iOS: 后台天气服务已停止")
    }
} 