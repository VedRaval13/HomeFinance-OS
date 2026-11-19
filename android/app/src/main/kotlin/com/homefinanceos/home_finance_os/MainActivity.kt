package com.homefinanceos.home_finance_os

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Prevent screen capture, recents thumbnails, and screenshot data leakage (OWASP MASVS-STORAGE-2)
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
