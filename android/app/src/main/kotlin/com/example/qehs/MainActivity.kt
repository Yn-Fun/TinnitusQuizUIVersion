package com.example.qehs
import android.content.SharedPreferences
import java.io.File
import android.os.Bundle
import android.util.Log
// import androidx.appcompat.app.AppCompatActivity
import com.example.QEHS.R
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import org.devio.flutter.splashscreen.SplashScreen


class MainActivity: FlutterActivity() {
    private val KEY_APP_INSTALLED = "app_installed"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        SplashScreen.show(this, R.style.SplashScreenTheme ) // here//R.style.SplashScreenTheme //true
        super.onCreate(savedInstanceState)
        this.flutterEngine?.let { GeneratedPluginRegistrant.registerWith(it) }
        
        // 获取已安装 APK 文件的路径
        val apkPath = packageManager.getPackageInfo(packageName, 0).applicationInfo.sourceDir
        val apkFile = File(apkPath)

        // 获取应用的 SharedPreferences 实例
        val sharedPreferences: SharedPreferences =
            getSharedPreferences(packageName, MODE_PRIVATE)

        // 判断是否已经执行过安装操作
        if (!sharedPreferences.getBoolean(KEY_APP_INSTALLED, false)) {
            // 首次安装应用，不需要删除已安装 APK 文件
            sharedPreferences.edit().putBoolean(KEY_APP_INSTALLED, true).apply()
        } else if (apkFile.exists()) {
            // 执行手动更新操作，删除已安装 APK 文件
            if (apkFile.delete()) {
                Log.d(TAG, "已删除已安装 APK 文件")
            } else {
                Log.e(TAG, "删除已安装 APK 文件失败")
            }
        }
         // 前面是对内部存储器，下面是对外部路径（一般可以触及的）
        //  删除已安装 APK 文件之后，再删除已下载的 APK 文件
        // val apkName = "app-release.apk"
        // val downloadedApkFile = File(getExternalFilesDir(null), apkName)
        // if (downloadedApkFile.exists()) {
        //     if (downloadedApkFile.delete()) {
        //         Log.d(TAG, "已删除已下载的 APK 文件")
        //     } else {
        //         Log.e(TAG, "删除已下载的 APK 文件失败")
        //     }
        // }

        val file = File("/storage/emulated/0/app-release.apk")
        if (file.exists()) {
            file.delete()
            print("已删除已下载的 APK 文件")
        }


    }
    
    companion object {
        private const val TAG = "MainActivity"
    }
}
