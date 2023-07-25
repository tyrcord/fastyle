package com.tyrcord.fastyle_ad

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class FastAdPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var flutterEngine: FlutterEngine
    private lateinit var channel: MethodChannel
    private lateinit var context: Context


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "fastyle_ad")
        flutterEngine = binding.getFlutterEngine()
        context = binding.getApplicationContext()
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(binding.getFlutterEngine(), "mediumBanner")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                GoogleMobileAdsPlugin.registerNativeAdFactory(
                    flutterEngine, "mediumBanner", MediumBannerNativeAdFactory(context)
                )
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }
}