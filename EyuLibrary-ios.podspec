#
# Be sure to run `pod lib lint EyuLibrary-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
#    s.use_frameworks!
  s.name             = 'EyuLibrary-ios'
  s.version          = '1.3.22'
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
      b.dependency 'SVProgressHUD'
      b.dependency 'FFToast'
      # a.resource_bundles = {
      #   'BUAdSDK' => ['EyuLibrary-ios/Assets/BUAdSDK.bundle/*']
      #}

      #a.public_header_files = 'Pod/Classes/**/*.h'
      # a.frameworks = 'UIKit', 'MapKit'
      # a.dependency 'AFNetworking', '~> 2.3'
      b.frameworks = 'AdSupport','CoreData','SystemConfiguration','AVFoundation','CoreMedia'
#      a.ios.libraries = 'c++','resolv.9'
  end
 
 s.subspec 'gdt_action' do |gdt_action|
     gdt_action.vendored_frameworks = ['EyuLibrary-ios/3rd/GDTActionSDK.framework']
     gdt_action.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GDT_ACTION_ENABLED'}
 end
 
 s.subspec 'um_sdk' do |um|
     um.dependency 'UMCCommon'
     um.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) UM_ENABLED'}
 end
 
 s.subspec 'af_sdk' do |af|
     af.dependency 'AppsFlyerFramework','5.4.1'
     af.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) AF_ENABLED'}
 end
 
 s.subspec 'iron_ads_sdk' do |iron_ads_sdk|
     iron_ads_sdk.dependency 'IronSourceSDK','6.11.0.0'
     iron_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) IRON_ADS_ENABLED'}
 end
 
 s.subspec 'admob_sdk' do |admob|
     admob.dependency 'Google-Mobile-Ads-SDK'
     admob.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ADMOB_ADS_ENABLED'}
 end
 
 s.subspec 'fb_ads_sdk' do |fb_ads_sdk|
     fb_ads_sdk.dependency 'FBAudienceNetwork','5.9.0'
     fb_ads_sdk.dependency 'FBSDKCoreKit','6.5.1'
     fb_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FB_ADS_ENABLED FACEBOOK_ENABLED'}
 end
 
 #新版本的FB广告sdk与白鹭引擎符号表冲突，需要使用此版本
 s.subspec 'fb_ads_sdk_5_4_0' do |fb_ads_sdk_5_4_0|
     fb_ads_sdk_5_4_0.dependency 'FBAudienceNetwork','5.4.0'
     fb_ads_sdk_5_4_0.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FB_ADS_ENABLED FACEBOOK_ENABLED'}
 end
 
 s.subspec 'applovin_ads_sdk' do |applovin_ads_sdk|
     applovin_ads_sdk.dependency 'AppLovinSDK','6.11.4'
     applovin_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) APPLOVIN_ADS_ENABLED'}
 end
 
 s.subspec 'unity_ads_sdk' do |unity_ads_sdk|
     unity_ads_sdk.dependency 'UnityAds','3.4.2'
     unity_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) UNITY_ADS_ENABLED'}
 end

 s.subspec 'vungle_ads_sdk' do |vungle_ads_sdk|
     vungle_ads_sdk.dependency 'VungleSDK-iOS','6.5.2'
     vungle_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) VUNGLE_ADS_ENABLED'}
 end
 
 s.subspec 'byte_dance_ads_sdk' do |byte_dance_ads_sdk|
#     byte_dance_ads_sdk.source 'https://github.com/CocoaPods/Specs.git'
     byte_dance_ads_sdk.dependency 'Bytedance-UnionAD','3.1.0.5'
     byte_dance_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) BYTE_DANCE_ADS_ENABLED'}
 end
 
 s.subspec 'mtg_ads_sdk' do |mtg_ads_sdk|
#     mtg_ads_sdk.vendored_frameworks = ['EyuLibrary-ios/3rd/MTGSDK.framework','EyuLibrary-ios/3rd/MTGSDKReward.framework','EyuLibrary-ios/3rd/MTGSDKInterstitialVideo.framework']
    mtg_ads_sdk.dependency 'MintegralAdSDK/InterstitialVideoAd','6.1.3.0'
    mtg_ads_sdk.dependency 'MintegralAdSDK/RewardVideoAd','6.1.3.0'

     mtg_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MTG_ADS_ENABLED'}
 end
 
 s.subspec 'gdt_ads_sdk' do |gdt_ad|
     gdt_ad.dependency 'GDTMobSDK','4.11.8'
     gdt_ad.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GDT_ADS_ENABLED'}
 end
 
 s.subspec 'fb_login_sdk' do |fb|
     fb.dependency 'FBSDKCoreKit','6.5.1'
     fb.dependency 'FBSDKShareKit','6.5.1'
     fb.dependency 'FBSDKLoginKit','6.5.1'
     fb.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FACEBOOK_LOGIN_ENABLED FACEBOOK_ENABLED'}
 end
 
 s.subspec 'crashlytics_sdk' do |crash|
     crash.dependency 'Fabric'
     crash.dependency 'Crashlytics'
end
 
 s.subspec 'firebase_sdk' do |firebase|
     firebase.dependency 'Firebase/Analytics'
     firebase.dependency 'Firebase/Core'
     firebase.dependency 'Firebase/Messaging'
     firebase.dependency 'Firebase/RemoteConfig'
     firebase.dependency 'Firebase/Auth'
     firebase.dependency 'Firebase/Firestore'
     firebase.dependency 'Firebase/Storage'
     firebase.dependency 'Firebase/DynamicLinks'
     firebase.dependency 'Firebase/AdMob'#,'5.6.0'
     firebase.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FIREBASE_ENABLED ADMOB_ADS_ENABLED'}
 end
 
 s.subspec 'ReYunTracking' do |tracking|
     tracking.preserve_paths = 'EyuLibrary-ios/Classes/framework/ReYunTracking/Headers/*.h'
     tracking.vendored_libraries = 'EyuLibrary-ios/Classes/framework/ReYunTracking/libReYunTracking.a'
     tracking.libraries = 'ReYunTracking'
     tracking.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/ReYunTracking/Headers/**",'LIBRARY_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/ReYunTracking/**" }
     tracking.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) TRACKING_ENABLED'}
     tracking.frameworks = 'iAd'
 end
 
 
end
