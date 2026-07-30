plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nf_sports"
    
    // 🚀 رفع إصدار الـ compileSdk إلى 36 لتلبية متطلبات مكتبات AndroidX الحديثة لعام 2026
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        create("release") {
            val isRunOnCI = System.getenv("CI") != null
            if (isRunOnCI) {
                initWith(getByName("debug"))
            }
        }
    }

    defaultConfig {
        applicationId = "com.example.nf_sports"
        // 🚀 رفع الـ minSdk إلى 23 لتقليل مشاكل التوافق وضمان استقرار أمان المتجر
        minSdk = 23
        // 🚀 رفع الـ targetSdk إلى 36 تماشياً مع متطلبات التجميع الحديثة
        targetSdk = 36
        
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
