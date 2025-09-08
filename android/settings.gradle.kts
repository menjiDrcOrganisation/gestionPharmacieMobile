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
    }
}

plugins {
    // Pas besoin d’ajouter le plugin Flutter ici
    id("com.android.application") version "8.7.3" apply false

    //  Kotlin minimum recommandé (Flutter >= 3.24)
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
