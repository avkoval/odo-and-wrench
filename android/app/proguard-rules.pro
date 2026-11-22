# google_mlkit_text_recognition references the optional Chinese, Devanagari, Japanese and Korean recognisers;
# the app uses only Latin script, so those classes are absent on purpose.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
