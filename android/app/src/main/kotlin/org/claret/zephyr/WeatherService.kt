package org.claret.zephyr

import android.app.*
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit
import android.content.Context

class WeatherService : Service() {
    companion object {
        private const val TAG = "WeatherService"
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "weather_service_channel"
        private const val CHANNEL_NAME = "天气服务"
    }

    private var scheduler: ScheduledExecutorService? = null
    private var isRunning = false
    private var methodChannel: io.flutter.plugin.common.MethodChannel? = null

    override fun onCreate() {
        super.onCreate()
        try {
            createNotificationChannel()
            Log.d(TAG, "WeatherService created")
        } catch (e: Exception) {
            Log.e(TAG, "WeatherService onCreate failed", e)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "WeatherService started")
        
        try {
            when (intent?.action) {
                "START_SERVICE" -> startWeatherFetching()
                "STOP_SERVICE" -> stopWeatherFetching()
            }
        } catch (e: Exception) {
            Log.e(TAG, "WeatherService onStartCommand failed", e)
        }
        
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun startWeatherFetching() {
        if (isRunning) {
            Log.d(TAG, "Service is already running")
            return
        }

        try {
            isRunning = true
            startForeground(NOTIFICATION_ID, createNotification())
            
            scheduler = Executors.newScheduledThreadPool(1)
            scheduler?.scheduleAtFixedRate({
                try {
                    Log.d(TAG, "执行定时天气获取任务")
                    fetchWeatherData()
                } catch (e: Exception) {
                    Log.e(TAG, "天气获取失败", e)
                }
            }, 0, 15, TimeUnit.MINUTES)
            
            Log.d(TAG, "天气获取服务已启动")
        } catch (e: Exception) {
            Log.e(TAG, "启动天气获取服务失败", e)
            isRunning = false
        }
    }

    private fun stopWeatherFetching() {
        try {
            isRunning = false
            scheduler?.shutdown()
            scheduler = null
            stopForeground(Service.STOP_FOREGROUND_REMOVE)
            stopSelf()
            Log.d(TAG, "天气获取服务已停止")
        } catch (e: Exception) {
            Log.e(TAG, "停止天气获取服务失败", e)
        }
    }

    private fun fetchWeatherData() {
        try {
            Log.d(TAG, "准备发送天气获取请求")
            val intent = Intent("WEATHER_FETCH_EVENT")
            intent.setPackage(packageName)
            sendBroadcast(intent)
            Log.d(TAG, "已发送天气获取请求广播")
        } catch (e: Exception) {
            Log.e(TAG, "发送天气获取请求失败", e)
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_LOW
                ).apply {
                    description = "用于保持天气获取服务运行"
                    setShowBadge(false)
                }
                
                val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.createNotificationChannel(channel)
            } catch (e: Exception) {
                Log.e(TAG, "创建通知渠道失败", e)
            }
        }
    }

    private fun createNotification(): Notification {
        try {
            val intent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            
            val pendingIntentFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
            
            val pendingIntent = PendingIntent.getActivity(
                this, 0, intent, pendingIntentFlags
            )

            return NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("天气服务运行中")
                .setContentText("每15分钟自动获取天气数据")
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentIntent(pendingIntent)
                .setOngoing(true)
                .setAutoCancel(false)
                .build()
        } catch (e: Exception) {
            Log.e(TAG, "创建通知失败", e)
            return NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("天气服务运行中")
                .setContentText("每15分钟自动获取天气数据")
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setOngoing(true)
                .setAutoCancel(false)
                .build()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            stopWeatherFetching()
            Log.d(TAG, "WeatherService destroyed")
        } catch (e: Exception) {
            Log.e(TAG, "WeatherService onDestroy failed", e)
        }
    }
} 