pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
<<<<<<< HEAD
    // Pas besoin d’ajouter le plugin Flutter ici
    id("com.android.application") version "8.7.3" apply false

    //  Kotlin minimum recommandé (Flutter >= 3.24)
=======
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
>>>>>>> 35c40c3aa9ed4abd0174ccdc16473800fda08754
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
