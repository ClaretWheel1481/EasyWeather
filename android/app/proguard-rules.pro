# Flutter 默认保留规则
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# 保留Kotlin相关
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**

# 保留你的主Activity和Service
-keep class org.claret.zephyr.MainActivity { *; }
-keep class org.claret.zephyr.WeatherService { *; }
-keep class org.claret.zephyr.WeatherBroadcastReceiver { *; }
-keep class org.claret.zephyr.WeatherWidgetProvider { *; }

# 其他常见保留
-keep class * extends android.app.Activity
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.appwidget.AppWidgetProvider

# 解决反射相关警告
-keepattributes *Annotation*,InnerClasses,EnclosingMethod


-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-dontwarn com.google.android.play.core.**