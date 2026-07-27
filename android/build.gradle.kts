// 1. الطريقة الصحيحة لتعريف المتغيرات في ملفات الـ .kts الحديثة
val kotlinVersion by extra("1.9.0")

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0") // تأكد من مطابقة إصدار الجريدل لديك
        // 2. استدعاء المتغير بالصيغة البرمجية الصحيحة لـ Kotlin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
