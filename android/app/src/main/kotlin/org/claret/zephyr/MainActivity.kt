package org.claret.zephyr

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.ExistingPeriodicWorkPolicy
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    companion object {
        private const val TAG = "MainActivity"
        private const val METHOD_CHANNEL = "weather_service"
        private const val EVENT_CHANNEL = "weather_service_events"
        
        private var staticInstance: MainActivity? = null
        
        fun sendWeatherFetchEventStatic() {
            staticInstance?.sendWeatherFetchEvent()
        }
    }

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "MainActivity onCreate")
        staticInstance = this
        startWeatherWorkManager()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        try {
            // 设置MethodChannel
            methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            methodChannel.setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        else -> {
                            result.notImplemented()
                        }
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "MethodChannel处理失败", e)
                    result.error("METHOD_ERROR", "方法调用失败", e.message)
                }
            }

            // 设置EventChannel
            eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    Log.d(TAG, "EventChannel监听已建立")
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    Log.d(TAG, "EventChannel监听已取消")
                }
            })

        } catch (e: Exception) {
            Log.e(TAG, "configureFlutterEngine失败", e)
        }
    }

    fun sendWeatherFetchEvent() {
        try {
            eventSink?.success("FETCH_WEATHER")
            Log.d(TAG, "天气获取事件已发送到Flutter")
        } catch (e: Exception) {
            Log.e(TAG, "发送天气获取事件失败", e)
        }
    }

    private fun startWeatherWorkManager() {
        val workRequest = PeriodicWorkRequestBuilder<WeatherWorker>(15, TimeUnit.MINUTES)
            .build()
        WorkManager.getInstance(applicationContext).enqueueUniquePeriodicWork(
            "WeatherFetchWork",
            ExistingPeriodicWorkPolicy.KEEP,
            workRequest
        )
    }

    override fun onDestroy() {
        super.onDestroy()
        staticInstance = null
    }
}
