package com.example.TinnQuizQEHS
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import org.devio.flutter.splashscreen.SplashScreen

class MainActivity : FlutterActivity() {
    private val KEY_APP_INSTALLED = "app_installed"

    override fun onCreate(savedInstanceState: Bundle?) {
        SplashScreen.show(this, R.style.SplashScreenTheme)
        super.onCreate(savedInstanceState)
        this.flutterEngine?.let { GeneratedPluginRegistrant.registerWith(it) }
    }

    companion object {
        private const val TAG = "MainActivity"
    }
}
