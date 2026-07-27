buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // تثبيت النسخة الصريحة والنظامية المتوافقة مع الفلاتر الحديث لحل مشكلة Unresolved reference نهائياً
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val rootProjectBuildDir = project.rootProject.layout.buildDirectory.dir("../../build")
subprojects {
    project.layout.buildDirectory.set(rootProjectBuildDir.map { it.dir(project.name) })
}
subprojects {
    eval({
        project.evaluationDependsOn(":app")
    })
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
