import AVFoundation
import google_mobile_ads

class MediumBannerNativeAdFactory: FLTNativeAdFactory {

  let nibName: String = "MediumBannerNativeAdView"
  let bundleName: String = "FastAdFramework.bundle"
  var iconViewReference: UIImageView?

  func createNativeAd(
    _ nativeAd: GADNativeAd,
    customOptions: [AnyHashable: Any]? = nil
  ) -> GADNativeAdView? {

    let frameworkBundle = Bundle(for: MediumBannerNativeAdFactory.self)
    let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent(self.bundleName)
    let bundle = Bundle(url: bundleURL!)
    let nibView = bundle!.loadNibNamed(self.nibName, owner: nil, options: nil)!.first

    let nativeAdView = nibView as! GADNativeAdView

    (nativeAdView.headlineView as! UILabel).text = nativeAd.headline

    (nativeAdView.bodyView as! UILabel).text = nativeAd.body
    nativeAdView.bodyView!.isHidden = nativeAd.body == nil

    let mediaContent = nativeAd.mediaContent

    // if mediaContent.hasVideoContent {
    //   nativeAdView.iconView?.removeFromSuperview()
    //   nativeAdView.headlineView?.removeFromSuperview()
    //   nativeAdView.bodyView?.removeFromSuperview()

    //   iconViewReference = nativeAdView.iconView as? UIImageView
    //   (nativeAdView.mediaView as! GADMediaView).mediaContent = mediaContent
    // } else {
    //   if let iconImage = nativeAd.icon?.image {
    //     if iconViewReference?.superview == nil {
    //       nativeAdView.addSubview(iconViewReference!)
    //     }

    //     iconViewReference?.image = iconImage
    //   } else {
    //     nativeAdView.iconView?.removeFromSuperview()
    //     iconViewReference = nativeAdView.iconView as? UIImageView
    //   }
    // }

    nativeAdView.callToActionView?.isUserInteractionEnabled = false

    nativeAdView.nativeAd = nativeAd

    return nativeAdView
  }
}
