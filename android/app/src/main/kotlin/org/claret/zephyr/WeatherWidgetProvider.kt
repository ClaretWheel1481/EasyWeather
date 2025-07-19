package org.claret.zephyr

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.util.Log

class WeatherWidgetProvider : AppWidgetProvider() {
    
    companion object {
        private const val TAG = "WeatherWidget"
        
        fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            try {
                // 从SharedPreferences获取天气数据
                val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                
                // 从SharedPreferences获取天气数据
                val widgetDataStr = prefs.getString("flutter.flutter.weather_widget_data", null)
                
                var cityName = "--"
                var weatherDesc = "--"
                var temperature = "--"
                var weatherCode = 0
                
                if (widgetDataStr != null && widgetDataStr.isNotEmpty()) {
                    try {
                        val widgetData = org.json.JSONObject(widgetDataStr)
                        cityName = widgetData.optString("city_name", "--")
                        weatherDesc = widgetData.optString("weather_desc", "--")
                        temperature = widgetData.optString("temperature", "--")
                        weatherCode = widgetData.optInt("weather_code", 0)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error parsing widget data: $e")
                    }
                }
                
                // 创建RemoteViews
                val views = RemoteViews(context.packageName, R.layout.weather_widget)
                
                // 设置文本
                views.setTextViewText(R.id.city_name, cityName)
                views.setTextViewText(R.id.weather_desc, weatherDesc)
                views.setTextViewText(R.id.temperature, temperature)
                
                // 根据天气代码设置背景
                setWidgetBackground(views, weatherCode)
                
                // 创建点击意图
                val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                val pendingIntent = PendingIntent.getActivity(
                    context, 0, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
                
                // 更新小部件
                appWidgetManager.updateAppWidget(appWidgetId, views)
            } catch (e: Exception) {
                Log.e(TAG, "Error updating widget", e)
            }
        }
        
        private fun setWidgetBackground(views: RemoteViews, weatherCode: Int) {
            when (weatherCode) {
                0 -> {
                    // 晴天 - 蓝色渐变
                    views.setInt(R.id.widget_container, "setBackgroundResource", R.drawable.widget_gradient_background)
                }
                1, 2, 3 -> {
                    // 多云 - 浅蓝色渐变
                    views.setInt(R.id.widget_container, "setBackgroundResource", R.drawable.widget_gradient_background)
                }
                45, 48 -> {
                    // 雾天 - 浅灰色
                    views.setInt(R.id.widget_container, "setBackgroundColor", Color.parseColor("#ECEFF1"))
                }
                51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82 -> {
                    // 雨天 - 深蓝色渐变
                    views.setInt(R.id.widget_container, "setBackgroundResource", R.drawable.widget_rainy_gradient)
                }
                71, 73, 75, 77, 85, 86 -> {
                    // 雪天 - 浅蓝色渐变
                    views.setInt(R.id.widget_container, "setBackgroundResource", R.drawable.widget_snowy_gradient)
                }
                95, 96, 99 -> {
                    // 雷暴 - 深灰色渐变
                    views.setInt(R.id.widget_container, "setBackgroundResource", R.drawable.widget_thunder_gradient)
                }
                else -> {
                    // 默认 - 蓝色渐变
                    views.setInt(R.id.widget_container, "setBackgroundResource", R.drawable.widget_gradient_background)
                }
            }
        }
    }
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }
    
    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        Log.d(TAG, "Weather widget enabled")
    }
    
    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        Log.d(TAG, "Weather widget disabled")
    }
} 