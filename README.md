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

#国内只包含穿山甲sdk
pod 'EyuLibrary-ios',:subspecs => ['3rd','Core','gdt','BytedanceOnly'], :git => 'https://github.com/moziguang/EyuLibrary-ios.git',:tag =>'1.1.9'


#国内国外一体版本
pod 'EyuLibrary-ios',:subspecs => ['3rd','Core','gdt','mtg','ironsource','others_ads_sdk'], :git => 'https://github.com/moziguang/EyuLibrary-ios.git',:tag =>'1.1.9'

//初始化FB， Firebase， UMMobSdk， AppFlyer， GDTActionSdk，及firebase 远程配置
[EYSdkUtils initFacebookSdkWithApplication:application options:launchOptions];
[EYSdkUtils initFirebaseSdk];
[EYSdkUtils initUMMobSdk:@"XXXXXXXXXXXXXXXXXX"];
[EYSdkUtils initAppFlyer:@"XXXXXXXXXXXXXXXXX" appId:@"XXXXXXXXXXXXX"];
[EYSdkUtils initGDTActionSdk:@"XXXXXX" secretkey:@"XXXXXXXXX"];


[[RemoteConfigHelperIOS sharedInstance] setup];

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


```

## Author

WeiqiangLuo, weiqiangluo@qianyuan.tv

## License

EyuLibrary-ios is available under the MIT license. See the LICENSE file for more info.
