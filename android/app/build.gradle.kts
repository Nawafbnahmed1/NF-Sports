import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nf_sports"
    
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
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
        minSdk = 24
        targetSdk = 36
        
        versionCode = 1
        versionName = "1.0.0"
        resValue("string", "app_name", "NF SPORTS")
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

// ✅ إضافة أمر الإجبار لبناء الأيقونات (الاسم الصحيح للمهمة)
tasks.whenTaskAdded {
    if (name == "assembleRelease") {
        dependsOn("processReleaseResources")
        dependsOn("compileFlutterBuildRelease") // ✅ تم التصحيح
    }
}
