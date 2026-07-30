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
    id("com.android.application") version "8.6.0" apply false
    // 🚀 تحديث صارم ومستقر للكوتلن إلى 2.2.20 بناءً على نصيحة المساعد الذكية لمنع تحذيرات فلاتر
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
