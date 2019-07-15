# EyuLibrary-ios

[![CI Status](https://img.shields.io/travis/WeiqiangLuo/EyuLibrary-ios.svg?style=flat)](https://travis-ci.org/WeiqiangLuo/EyuLibrary-ios)
[![Version](https://img.shields.io/cocoapods/v/EyuLibrary-ios.svg?style=flat)](https://cocoapods.org/pods/EyuLibrary-ios)
[![License](https://img.shields.io/cocoapods/l/EyuLibrary-ios.svg?style=flat)](https://cocoapods.org/pods/EyuLibrary-ios)
[![Platform](https://img.shields.io/cocoapods/p/EyuLibrary-ios.svg?style=flat)](https://cocoapods.org/pods/EyuLibrary-ios)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

EyuLibrary-ios is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby

#国内国外一体版本
pod 'EyuLibrary-ios',:subspecs => ['3rd','Core','gdt','mtg','ironsource','others_ads_sdk','fb_sdk'], :git => 'https://github.com/moziguang/EyuLibrary-ios.git',:tag =>'1.2.5'

GCC_PREPROCESSOR_DEFINITIONS 加上 FACEBOOK_ENABLED


Facebook配置请参考https://developers.facebook.com/docs/app-events/getting-started-app-events-ios
[EYSdkUtils initFacebookSdkWithApplication:application options:launchOptions];
[EYSdkUtils application:app openURL:url options:options];

#国内只包含穿山甲sdk
pod 'EyuLibrary-ios',:subspecs => ['3rd','Core','gdt','BytedanceOnly'], :git => 'https://github.com/moziguang/EyuLibrary-ios.git',:tag =>'1.2.5'


目标target的
HEADER_SEARCH_PATHS 加上 $(inherited)
GCC_PREPROCESSOR_DEFINITIONS 加上BYTE_DANCE_ONLY=1

//初始化FB， Firebase， UMMobSdk， AppFlyer， GDTActionSdk，及firebase 远程配置

[EYSdkUtils initFirebaseSdk];
[EYSdkUtils initUMMobSdk:@"XXXXXXXXXXXXXXXXXX" channel:@"channel"];
[EYSdkUtils initAppFlyer:@"XXXXXXXXXXXXXXXXX" appId:@"XXXXXXXXXXXXX"];
[EYSdkUtils initGDTActionSdk:@"XXXXXX" secretkey:@"XXXXXXXXX"];


firebase 远程配置初始化
NSDictionary* dict = [NSDictionary alloc] init];
[[EYRemoteConfigHelper sharedInstance] setupWithDefault:dict];

//初始化广告sdk
EYAdConfig* adConfig = [[EYAdConfig alloc] init];
adConfig.adKeyData =  [EYRemoteConfigHelper readFileWithName:@"ios_ad_key_setting"];
adConfig.adGroupData = [EYRemoteConfigHelper readFileWithName:@"ios_ad_cache_setting"];
adConfig.adPlaceData = [EYRemoteConfigHelper readFileWithName:@"ios_ad_setting"];
adConfig.maxTryLoadNativeAd = 7;
adConfig.maxTryLoadRewardAd = 7;
adConfig.maxTryLoadInterstitialAd = 7;
adConfig.unityClientId = @"XXXXXX";
adConfig.vungleClientId = @"XXXXXXXXXXXXXXX";
adConfig.ironSourceAppKey = @"XXXXXXX";
adConfig.wmAppKey = @"XXXXXX";

[[EYAdManager sharedInstance] setupWithConfig:adConfig];
[[EYAdManager sharedInstance] setDelegate:self];

//展示激励视频 reward_ad为广告位id，对应ios_ad_setting.json配置
[[EYAdManager sharedInstance] showRewardVideoAd:@"reward_ad" withViewController:self];

//展示插屏 inter_ad为广告位id，对应ios_ad_setting.json配置
[[EYAdManager sharedInstance] showInterstitialAd:@"inter_ad" withViewController:self];

//展示原生广告 native_ad为广告位id，对应ios_ad_setting.json配置
[[EYAdManager sharedInstance] showNativeAd:@"native_ad" withViewController:self viewGroup:self.nativeRootView];

//广告回掉EYAdDelegate
-(void) onAdLoaded:(NSString*) adPlaceId type:(NSString*)type
{
NSLog(@"广告加载完成 onAdLoaded adPlaceId = %@, type = %@", adPlaceId, type);
}
-(void) onAdReward:(NSString*) adPlaceId  type:(NSString*)type
{
NSLog(@"激励视频观看完成 onAdReward adPlaceId = %@, type = %@", adPlaceId, type);

}
-(void) onAdShowed:(NSString*) adPlaceId  type:(NSString*)type
{
NSLog(@"广告展示 onAdShowed adPlaceId = %@, type = %@", adPlaceId, type);

}
-(void) onAdClosed:(NSString*) adPlaceId  type:(NSString*)type
{
NSLog(@"广告关闭 onAdClosed adPlaceId = %@, type = %@", adPlaceId, type);

}
-(void) onAdClicked:(NSString*) adPlaceId  type:(NSString*)type
{
NSLog(@"广告点击 onAdClicked adPlaceId = %@, type = %@", adPlaceId, type);

}

- (void)onDefaultNativeAdClicked {
NSLog(@"默认原生广告点击 onDefaultNativeAdClicked");
}

```

## Author

WeiqiangLuo, weiqiangluo@qianyuan.tv

## License

EyuLibrary-ios is available under the MIT license. See the LICENSE file for more info.
