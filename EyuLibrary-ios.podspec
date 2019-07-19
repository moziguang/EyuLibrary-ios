#
# Be sure to run `pod lib lint EyuLibrary-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EyuLibrary-ios'
  s.version          = '1.2.8'
  s.summary          = 'A short description of EyuLibrary-ios.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'EyuLibrary'

  s.homepage         = 'https://github.com/moziguang/EyuLibrary-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WeiqiangLuo' => 'weiqiangluo@qianyuan.tv' }
  s.source           = { :git => 'https://github.com/moziguang/EyuLibrary-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.subspec 'Core' do |b|
      b.source_files = 'EyuLibrary-ios/Classes/**/*'
      
      # a.resource_bundles = {
      #   'BUAdSDK' => ['EyuLibrary-ios/Assets/BUAdSDK.bundle/*']
      #}

      #a.public_header_files = 'Pod/Classes/**/*.h'
      # a.frameworks = 'UIKit', 'MapKit'
      # a.dependency 'AFNetworking', '~> 2.3'
      
  end
  #s.subspec 'GoogleAnalytics' do |sga|
  #    sga.preserve_paths = 'EyuLibrary-ios/Classes/framework/GoogleAnalytics/Headers/*.h'
  #    sga.vendored_libraries = 'EyuLibrary-ios/Classes/framework/GoogleAnalytics/libAdIdAccess.a', 'EyuLibrary-ios/Classes/framework/GoogleAnalytics/libGoogleAnalyticsServices.a'
  #    sga.libraries = 'AdIdAccess', 'GoogleAnalyticsServices'
  #    sga.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/GoogleAnalytics/Headers/**",'LIBRARY_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/GoogleAnalytics/**" }
  #end
 
 #s.subspec 'UnityAds' do |c|
 #     c.vendored_frameworks = ['EyuLibrary-ios/Classes/framework/UnityAds.framework']
 #end
 
 s.subspec '3rd' do |a|
     a.dependency 'Firebase/Analytics'
     a.dependency 'Firebase/Core'
     a.dependency 'Firebase/Messaging'
     a.dependency 'Firebase/RemoteConfig'
     a.dependency 'Firebase/Auth'
     a.dependency 'Firebase/Firestore'
     a.dependency 'Firebase/Storage'
     a.dependency 'Firebase/DynamicLinks'
     a.dependency 'SVProgressHUD'
     a.dependency 'AppsFlyerFramework','4.8.8'
     
     a.dependency 'GDTMobSDK','4.8.4'
     a.dependency 'FFToast'
     a.dependency 'UMCAnalytics'
     #a.vendored_frameworks = ['EyuLibrary-ios/Classes/framework/UnityAds.framework','EyuLibrary-ios/Classes/framework/BUAdSDK.framework']
     a.frameworks = 'AdSupport','CoreData','SystemConfiguration','AVFoundation','CoreMedia'
     a.ios.libraries = 'c++','resolv.9'
 end
 
 s.subspec 'BytedanceOnly' do |bo|
     bo.dependency 'Bytedance-UnionAD','2.1.0.2'
     bo.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) BYTE_DANCE_ONLY=1'}
 end
 
 s.subspec 'mtg' do |b|
     b.vendored_frameworks = ['EyuLibrary-ios/3rd/MTGSDK.framework','EyuLibrary-ios/3rd/MTGSDKReward.framework','EyuLibrary-ios/3rd/MTGSDKInterstitialVideo.framework']
 end
 
 s.subspec 'gdt' do |c|
     c.vendored_frameworks = ['EyuLibrary-ios/3rd/GDTActionSDK.framework']
 end
 
 s.subspec 'ironsource' do |d|
     d.dependency 'IronSourceSDK','6.8.1.0'
     d.vendored_frameworks = ['EyuLibrary-ios/3rd/ISAdMobAdapter.framework','EyuLibrary-ios/3rd/ISAppLovinAdapter.framework',
     'EyuLibrary-ios/3rd/ISFacebookAdapter.framework','EyuLibrary-ios/3rd/ISUnityAdsAdapter.framework','EyuLibrary-ios/3rd/ISVungleAdapter.framework']
     d.frameworks = 'CoreGraphics','UIKit'
 end
 
 s.subspec 'others_ads_sdk' do |e|
     e.dependency 'Firebase/AdMob'#,'5.6.0'
     e.dependency 'AppLovinSDK','6.6.1'
     e.dependency 'FBAudienceNetwork','5.3.1'
     e.dependency 'UnityAds','3.0.0'
     e.dependency 'VungleSDK-iOS','6.2.0'
     e.dependency 'Bytedance-UnionAD','2.1.0.2'
 end
 
 s.subspec 'fb_sdk' do |fb|
     fb.dependency 'FBSDKCoreKit','5.2.1'
     fb.dependency 'FBSDKShareKit','5.2.1'
     fb.dependency 'FBSDKLoginKit','5.2.1'
     fb.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FACEBOOK_ENABLED'}
 end
 
 s.subspec 'Crashlytics_sdk' do |crash|
     crash.dependency 'Fabric'
     crash.dependency 'Crashlytics'
end
 
 # s.subspec 'ironsource_config' do |f|
 #    f.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ENABLE_IRON_SOURCE=1'}
 #end

end
