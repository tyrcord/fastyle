#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
    s.name             = 'fastyle_ad'
    s.version          = '0.0.1'
    s.summary          = 'Native ads with templates'
    s.homepage         = 'https://github.com/tyrcord/fastyle/tree/master/packages/ad'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Tyrcord, Inc' => 'dev@tyrcord.com' }
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*.{swift,xib}'
    s.resource_bundles = {
        'FastAdFramework' => ['Classes/**/*.{storyboard,xib,xcassets,json,imageset,png}']
    }
    s.ios.deployment_target = '9.0'
    s.dependency 'Flutter'
    s.dependency 'google_mobile_ads'
    s.dependency 'Google-Mobile-Ads-SDK'
    s.static_framework = true
  end
