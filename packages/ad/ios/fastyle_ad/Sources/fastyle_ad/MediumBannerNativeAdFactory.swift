import GoogleMobileAds
import google_mobile_ads

class MediumBannerNativeAdFactory : FLTNativeAdFactory {

    let nibName:String = "MediumBannerNativeAdView"
    let bundleName:String = "FastAdFramework.bundle"

    func createNativeAd(_ nativeAd: NativeAd,
                        customOptions: [AnyHashable : Any]? = nil) -> NativeAdView? {
        
        #if SWIFT_PACKAGE
        let bundle: Bundle? = Bundle.module
        #else
        let frameworkBundle = Bundle(for: MediumBannerNativeAdFactory.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent(self.bundleName)
        let bundle = Bundle(url: bundleURL!)
        #endif
        let nibView = bundle!.loadNibNamed(self.nibName, owner: nil, options: nil)!.first

        let nativeAdView = nibView as! NativeAdView

        (nativeAdView.headlineView as! UILabel).text = nativeAd.headline

        (nativeAdView.bodyView as! UILabel).text = nativeAd.body
        nativeAdView.bodyView!.isHidden = nativeAd.body == nil

        (nativeAdView.iconView as! UIImageView).image = nativeAd.icon?.image
        nativeAdView.iconView!.isHidden = nativeAd.icon == nil

        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        nativeAdView.nativeAd = nativeAd

        return nativeAdView
    }
}