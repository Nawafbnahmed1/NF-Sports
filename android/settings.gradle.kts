pluginManagement {
    val flutterSdkVersion = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }
 
    includeBuild("$flutterSdkVersion/packages/flutter_tools/gradle")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // 🚀 الترقية الجراحية لـ AGP إلى 8.9.1 لتلبية شروط مكتبات AndroidX الحديثة لعام 2026
    id("com.android.application") version "8.9.1" apply false
    // ✓ الإبقاء على إصدار لغة الكوتلن المستقر 2.2.20 بدون تغيير بناءً على خطة المساعد
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
