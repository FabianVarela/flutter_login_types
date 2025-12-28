import java.util.Base64
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")

    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val dartEnvironmentVariables = mutableMapOf<String, String>()

if (project.hasProperty("dart-defines")) {
    (project.property("dart-defines") as String).split(",").forEach { entry ->
        val decodedEntry = String(Base64.getDecoder().decode(entry), Charsets.UTF_8)
        val pair = decodedEntry.split("=", limit = 2)

        if (pair.size == 2) {
            dartEnvironmentVariables[pair[0]] = pair[1]
        }
    }
}

android {
    namespace = "com.developer.fabian.login_types"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.developer.fabian.login_types"

        minSdk = flutter.minSdkVersion.coerceAtLeast(21)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true

        manifestPlaceholders += mapOf(
            "appAuthRedirectScheme" to (dartEnvironmentVariables["AZURE_REDIRECT_SCHEME"] ?: ""),
            "auth0Domain" to (dartEnvironmentVariables["AUTH0_DOMAIN"] ?: ""),
            "auth0Scheme" to (dartEnvironmentVariables["AUTH0_SCHEME_AND"] ?: "")
        )

        resValue("string", "facebook_app_id", dartEnvironmentVariables["FACEBOOK_APP_ID"] ?: "")
        resValue("string", "facebook_client_token", dartEnvironmentVariables["FACEBOOK_CLIENT_TOKEN"] ?: "")
        resValue("string", "twitter_callback_url", dartEnvironmentVariables["TWITTER_REDIRECT_URI"] ?: "")
    }

    buildTypes {
        getByName("release") {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    implementation("androidx.multidex:multidex:2.0.1")
    implementation("androidx.window:window:1.4.0")
    implementation("androidx.window:window-java:1.4.0")
}
