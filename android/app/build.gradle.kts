import java.util.Properties // 👈 تم حقن الاستيراد الرسمي هنا في السطر الأول لحسم المشكلة للأبد

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nf_sports"
    
    // ✓ الترقية الجراحية الحاسمة لـ compileSdk لتلبية شرط المكتبات المحدثة لعام 2026
    compileSdk = 36

    // 🚀 حقن إصدار الـ NDK الأعلى والمطلوب رسمياً من السيرفر لتدمير تعارض مكتبة الـ jni للأبد
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
                // ✓ تم تصحيح السطر هنا ليعتمد على الـ Import الصافي بدون كلمات محجوزة
                val keystoreProperties = Properties()
                keystoreProperties.load(keystorePropertiesFile.inputStream())
                
                storeFile = rootProject.file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            } else {
                initWith(getByName("debug"))
            }
        }
    }

    defaultConfig {
        applicationId = "com.example.nf_sports"
        // ✓ الحد الأدنى المستقر المستهدف بناءً على خطة المساعد
        minSdk = 23
        // ✓ الإصدار المستهدف للمتجر بناءً على خطة المساعد
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
