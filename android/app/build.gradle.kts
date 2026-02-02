plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin
    id("dev.flutter.flutter-gradle-plugin")
    // Google Services Plugin (Connects to Firebase)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.grey_scaler"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        // Ensure this matches the package name in your google-services.json
        applicationId = "com.example.grey_scaler"
        
        // Firestore requires a minimum SDK of 21. If flutter.minSdkVersion is lower, 
        // you may need to hardcode `minSdk = 21` here.
        minSdk = flutter.minSdkVersion 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // specific signing config for release
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // 1. Firebase BoM (Bill of Materials) - Manages versions for you
    implementation(platform("com.google.firebase:firebase-bom:33.8.0"))

    // 2. Firebase Products (No version numbers needed because of BoM)
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
} 