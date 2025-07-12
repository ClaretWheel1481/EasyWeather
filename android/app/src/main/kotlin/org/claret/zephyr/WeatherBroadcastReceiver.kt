package org.claret.zephyr

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class WeatherBroadcastReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "WeatherBroadcastReceiver"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d(TAG, "WeatherBroadcastReceiver收到事件: ${intent?.action}")
        
        if (intent?.action == "WEATHER_FETCH_EVENT") {
            Log.d(TAG, "WeatherBroadcastReceiver收到天气获取请求")

            MainActivity.sendWeatherFetchEventStatic()
            Log.d(TAG, "已调用MainActivity的天气获取方法")
        }
    }
} 