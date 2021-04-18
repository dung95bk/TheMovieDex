import android.graphics.Color
import android.view.LayoutInflater
import android.widget.TextView
import com.app.themoviedex.R
import com.google.android.gms.ads.formats.UnifiedNativeAd
import com.google.android.gms.ads.formats.UnifiedNativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory


class NativeAdFactoryExample( private var layoutInflater: LayoutInflater? = null) : NativeAdFactory {

    override fun createNativeAd(nativeAd: UnifiedNativeAd?, customOptions: MutableMap<String, Any>?): UnifiedNativeAdView {
        val adView : UnifiedNativeAdView  = layoutInflater?.inflate(R.layout.my_native_ad, null) as UnifiedNativeAdView
        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        val bodyView = adView.findViewById<TextView>(R.id.ad_body)

        headlineView?.text = nativeAd!!.headline
        bodyView?.text = nativeAd.body

        adView.setBackgroundColor(Color.YELLOW)

        adView.setNativeAd(nativeAd)
        adView.bodyView = bodyView
        adView.headlineView = headlineView
        return adView
    }


}
