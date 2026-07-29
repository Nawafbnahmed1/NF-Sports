plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nf_sports"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // 🛡️ حقن مصفوفة التوقيع الافتراضية لحل تعارض الـ Release ومنع توقف السيرفر كلياً
    signingConfigs {
        create("release") {
            val isRunOnCI = System.getenv("CI") != null
            if (isRunOnCI) {
                // استخدام توقيع افتراضي مدمج بداخل بيئة GitHub ليمر البناء بسلام ويخرج السهم
                initWith(getByName("debug"))
            }
        }
    }

    defaultConfig {
        applicationId = "com.example.nf_sports"
        minSdk = 21 // تحديد حد أدنى مستقر وثابت لدعم كافة الجوالات
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // ربط الحزمة بالتوقيع الصحيح المجهز بالأعلى لمنع الكراش
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
