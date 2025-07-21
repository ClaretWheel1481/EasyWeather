package org.claret.zephyr

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters

class WeatherWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {
    override fun doWork(): Result {
        try {
            Log.d("WeatherWorker", "WorkManager定时任务触发，准备发送天气获取广播")
            val intent = Intent("WEATHER_FETCH_EVENT")
            intent.setPackage(applicationContext.packageName)
            applicationContext.sendBroadcast(intent)
            Log.d("WeatherWorker", "已通过WorkManager发送天气获取广播")
        } catch (e: Exception) {
            Log.e("WeatherWorker", "发送天气获取广播失败", e)
            return Result.retry()
        }
        return Result.success()
    }
} 