# Flutter Wrapper rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Drift / SQLite native libraries
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Local Authentication & Biometrics
-keep class androidx.biometric.** { *; }

# Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Play Core & Deferred Components (unused in local-first offline architecture)
-dontwarn com.google.android.play.core.**

