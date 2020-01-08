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
本SDK所有第三方sdk均可以模块形式集成
模块：易娱 sdk          :'Core'
    穿山甲SDK          :'byte_dance_ads_sdk'    BYTE_DANCE_ADS_ENABLED
    广点通广告          :'gdt_ads_sdk'           GDT_ADS_ENABLED
    mtg广告            :'mtg_ads_sdk'           MTG_ADS_ENABLED
    FB广告             :'fb_ads_sdk'            FB_ADS_ENABLED
    unity广告          :'unity_ads_sdk'         UNITY_ADS_ENABLED
    Vungle广告         :'vungle_ads_sdk'        VUNGLE_ADS_ENABLED
    applovin广告       :'applovin_ads_sdk'      APPLOVIN_ADS_ENABLED
    ironsource广告     :'iron_ads_sdk'          IRON_ADS_ENABLED
    firebase          :'firebase_sdk'          FIREBASE_ENABLED
    crashlytics       :'crashlytics_sdk'
    友盟               :'um_sdk'                UM_ENABLED
    AppsFlyer         :'af_sdk'                 AF_ENABLED
    广点通买量          :'gdt_action'             GDT_ACTION_ENABLED
    FB登录             :'fb_login_sdk'          FACEBOOK_LOGIN_ENABLED 
    热云               :'ReYunTracking'         TRACKING_ENABLED

1、修改项目的Podfile文件，例如
pod 'EyuLibrary-ios',:subspecs => ['Core','byte_dance_ads_sdk','um_sdk', 'af_sdk', 'gdt_action','gdt_ads_sdk', 'mtg_ads_sdk', 'fb_ads_sdk', 'unity_ads_sdk', 'vungle_ads_sdk', 'applovin_ads_sdk', 'iron_ads_sdk', 'firebase_sdk', 'crashlytics_sdk','fb_login_sdk'], :git => 'https://github.com/moziguang/EyuLibrary-ios.git',:tag =>'1.3.0'
    （以上模块可以根据项目需要进行删减）

2、在终端里运行 pod install或者pod update，并留意执行是否有警告或者报错

3、执行成功后，用xcode打开当前项目目录下的$YOUR_PROJECT_NAME.xcworkspace文件

4、根据项目需要修改编译配置，及编写初始化代码
HEADER_SEARCH_PATHS 加上 $(inherited)
LIBRARY_SEARCH_PATHS 加上 $(inherited)
OTHER_LDFLAGS 加上 $(inherited)

穿山甲SDK 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 BYTE_DANCE_ADS_ENABLED
adConfig.wmAppKey = @"XXXXXX";//代码里设置穿山甲sdk app key

广点通广告 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 GDT_ADS_ENABLED
adConfig.gdtAppId = @"xxxxxxxxxx";//代码里设置广点通广告sdk app id

mtg广告 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 MTG_ADS_ENABLED
adConfig.mtgAppId = @"xxxxxx";//代码里设置mtg广告sdk app id 及app key
adConfig.mtgAppKey = @"xxxxxxxxxxxxxxxxx";

FB广告 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 FB_ADS_ENABLED
请参考https://developers.facebook.com/docs/app-events/getting-started-app-events-ios
在app 对应的生命周期函数里加上
[EYSdkUtils initFacebookSdkWithApplication:application options:launchOptions];
[EYSdkUtils application:app openURL:url options:options];

unity广告 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 UNITY_ADS_ENABLED
adConfig.unityClientId = @"xxxxxxx";

Vungle广告 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 VUNGLE_ADS_ENABLED
adConfig.vungleClientId = @"xxxxxxxxxxx";

applovin广告 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 APPLOVIN_ADS_ENABLED
AppLovin需要在info.plist里设置AppLovinSdkKey

ironsource广告 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 IRON_ADS_ENABLED
adConfig.ironSourceAppKey = @"xxxxxxxx";

firebase 及 crashlytics 以及ADMOB
https://firebase.google.com/docs/ios/setup?authuser=0
下载 GoogleService-Info.plist 并放到xcode的根目录
需要在GCC_PREPROCESSOR_DEFINITIONS 加上 FIREBASE_ENABLED ADMOB_ADS_ENABLED
[EYSdkUtils initFirebaseSdk];
Info.plist 加上以下内容
<key>GADIsAdManagerApp</key>
<true/>

友盟 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 UM_ENABLED
[EYSdkUtils initUMMobSdk:@"XXXXXXXXXXXXXXXXXX" channel:@"channel"];

AppsFlyer 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 AF_ENABLED
[EYSdkUtils initAppFlyer:@"XXXXXXXXXXXXXXXXX" appId:@"XXXXXXXXXXXXX"];

广点通买量  需要在GCC_PREPROCESSOR_DEFINITIONS 加上 GDT_ACTION_ENABLED
[EYSdkUtils initGDTActionSdk:@"XXXXXX" secretkey:@"XXXXXXXXX"];
并在- (void)applicationDidBecomeActive:(UIApplication *)application中调用[EYSdkUtils doGDTSDKActionStartApp];

FB登录 需要在GCC_PREPROCESSOR_DEFINITIONS 加上 FACEBOOK_LOGIN_ENABLED

热云  需要在GCC_PREPROCESSOR_DEFINITIONS 加上 TRACKING_ENABLED


//初始化FB， Firebase， UMMobSdk， AppFlyer， GDTActionSdk，及firebase 远程配置

[EYSdkUtils initFirebaseSdk];
[EYSdkUtils initUMMobSdk:@"XXXXXXXXXXXXXXXXXX" channel:@"channel"];
[EYSdkUtils initAppFlyer:@"XXXXXXXXXXXXXXXXX" appId:@"XXXXXXXXXXXXX"];
[EYSdkUtils initGDTActionSdk:@"XXXXXX" secretkey:@"XXXXXXXXX"];

firebase 配置和初始化
https://firebase.google.com/docs/ios/setup?authuser=0
下载 GoogleService-Info.plist 并放到xcode的根目录

firebase 远程配置初始化
NSDictionary* dict = [[NSDictionary alloc] init];
[[EYRemoteConfigHelper sharedInstance] setupWithDefault:dict];

//初始化广告sdk
EYAdConfig* adConfig = [[EYAdConfig alloc] init];
adConfig.adKeyData =  [EYSdkUtils readFileWithName:@"ios_ad_key_setting"];
adConfig.adGroupData = [EYSdkUtils readFileWithName:@"ios_ad_cache_setting"];
adConfig.adPlaceData = [EYSdkUtils readFileWithName:@"ios_ad_setting"];
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

- (void)onAdLoadFailed:(nonnull NSString *)adPlaceId key:(nonnull NSString *)key code:(int)code 
{
    NSLog(@"广告加载失败 onAdLoadFailed adPlaceId = %@, key = %@, code = %d", adPlaceId, key, code);
}


- (void)onDefaultNativeAdClicked {
NSLog(@"默认原生广告点击 onDefaultNativeAdClicked");
}

-(void) onAdImpression:(NSString*) adPlaceId  type:(NSString*)type
{
NSLog(@"lwq, onAdImpression adPlaceId = %@, type = %@", adPlaceId, type);
}

事件上报
#import "EYEventUtils.h"
NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
[dic setObject:@"testValue" forKey:@"testKey"];
[EYEventUtils logEvent:@"EVENT_NAME"  parameters:dic];
```

## Author

WeiqiangLuo, weiqiangluo@qianyuan.tv

## License

EyuLibrary-ios is available under the MIT license. See the LICENSE file for more info.
