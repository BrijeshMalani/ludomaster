package com.gamewarrier.gamechanger.ludomaster

import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import kotlin.let
import kotlin.run

class ListTileNativeAdFactory(private val layoutInflater: LayoutInflater) :
    GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.medium_template, null) as NativeAdView

        adView.headlineView = adView.findViewById(R.id.native_ad_headline)
        adView.bodyView = adView.findViewById(R.id.native_ad_body)
        adView.callToActionView = adView.findViewById(R.id.native_ad_button)
        adView.iconView = adView.findViewById(R.id.native_ad_icon)
        adView.advertiserView = adView.findViewById(R.id.native_ad_advertiser)
        adView.mediaView = adView.findViewById(R.id.native_ad_media)

        (adView.headlineView as TextView).text = nativeAd.headline
        nativeAd.body?.let {
            adView.bodyView?.visibility = View.VISIBLE
            (adView.bodyView as TextView).text = it
        } ?: run {
            adView.bodyView?.visibility = View.INVISIBLE
        }

        nativeAd.callToAction?.let {
            adView.callToActionView?.visibility = View.VISIBLE
            (adView.callToActionView as TextView).text = it
        } ?: run {
            adView.callToActionView?.visibility = View.INVISIBLE
        }

        nativeAd.icon?.let {
            adView.iconView?.visibility = View.VISIBLE
            (adView.iconView as ImageView).setImageDrawable(it.drawable)
        } ?: run {
            adView.iconView?.visibility = View.INVISIBLE
        }

        nativeAd.advertiser?.let {
            adView.advertiserView?.visibility = View.VISIBLE
            (adView.advertiserView as TextView).text = it
        } ?: run {
            adView.advertiserView?.visibility = View.INVISIBLE
        }

        adView.setNativeAd(nativeAd)

        return adView
    }
}