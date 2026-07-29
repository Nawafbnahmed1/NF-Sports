plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nf_sports"
    
    // ⚙️ ترقية أرقام الـ SDK بشكل صريح لتتوافق بالملي مع ترقية الـ AGP 8.6.0 التي وضعها المطور
    compileSdk = 34

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
        minSdk = 21 // حد أدنى مستقر وثابت لدعم كافة الجوالات حياً
        targetSdk = 34 // متوافق بالملي مع شروط متجر جوجل بلاي الحديثة
        
        // جلب أرقام الإصدارات تلقائياً من نظام فلاتر المستقر
        val flutterVersionCode = project.property("flutter-version-code") as? String ?: "1"
        val flutterVersionName = project.property("flutter-version-name") as? String ?: "1.0.0"
        
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
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
