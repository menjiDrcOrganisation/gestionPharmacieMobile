pluginManagement {
    val properties = java.util.Properties()
    file("local.properties").inputStream().use { properties.load(it) }
    val flutterSdkPath = properties.getProperty("flutter.sdk")
        ?: throw GradleException("flutter.sdk not set in local.properties")

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        // maven { url = uri("https://maven.aliyun.com/repository/public") } // optionnel mirror
    }
}

plugins {
    // NE PAS inclure dev.flutter.flutter-plugin-loader ici : Flutter s'en occupe via includeBuild(...)
    id("com.android.application") version "8.7.3" apply false
    // Kotlin : rester en 1.9.x (2.x casse la compatibilité actuelle)
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}

include(":app")
