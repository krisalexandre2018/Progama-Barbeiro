# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Google Play Core (necessário para Flutter)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep class members for Firebase Firestore
-keepclassmembers class * {
    @com.google.firebase.firestore.PropertyName <fields>;
}

# General optimizations
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keepattributes Signature
-keepattributes Exceptions
