allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.aliyun.com/repository/public")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
 
