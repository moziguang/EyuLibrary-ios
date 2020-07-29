//
//  EYSdkUtils.m
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import <Foundation/Foundation.h>
#import "EYSdkUtils.h"
#import "EYEventUtils.h"

#ifdef FIREBASE_ENABLED
#import "Firebase.h"
#endif

#ifdef AF_ENABLED
#import <AppsFlyerLib/AppsFlyerTracker.h>
#endif

#ifdef GDT_ACTION_ENABLED
#import <GDTActionSDK/GDTAction.h>
#endif

#ifdef UM_ENABLED
#import <UMCommon/UMCommon.h>
#endif

#ifdef FACEBOOK_ENABLED
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#endif

#ifdef TRACKING_ENABLED
#import "Tracking.h"
#endif

#ifdef AF_ENABLED
@interface AppsFlyerDelegate : NSObject <AppsFlyerTrackerDelegate> {
}
@end

@implementation AppsFlyerDelegate
- (void)onConversionDataFail:(nonnull NSError *)error {
    NSLog(@"onConversionDataFail %@", error);
}

- (void)onConversionDataSuccess:(nonnull NSDictionary *)installData {
    NSLog(@"onConversionDataSuccess %@", installData);
    if(installData == nil) return;
    NSNumber *is_first_launch = installData[@"is_first_launch"];
    if (is_first_launch.integerValue == 0) {
        return;
    }
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
        mDic[@"pid"] = installData[@"media_source"];
        mDic[@"c"] = installData[@"campaign"];
        mDic[@"af_ad_id"] = installData[@"af_ad_id"];
        NSString *afId = installData[@"af_ad"];
        if (afId.length > 100) {
            mDic[@"af_ad"] = [afId substringToIndex:100];
            mDic[@"af_ad2"] = [afId substringWithRange: NSMakeRange(100, afId.length-100)];
        } else {
            mDic[@"af_ad"] = afId;
        }
        mDic[@"af_ad_type"] = installData[@"af_ad_type"];
        mDic[@"af_adset_id"] = installData[@"af_adset_id"];
        mDic[@"af_adset"] = installData[@"af_adset"];
        mDic[@"af_c_id"] = installData[@"af_c_id"];
        mDic[@"af_channel"] = installData[@"af_channel"];
        mDic[@"af_siteid"] = installData[@"af_siteid"];
        mDic[@"advertising_id"] = installData[@"advertising_id"];
        mDic[@"idfa"] = installData[@"idfa"];
        [EYEventUtils logEvent:EVENT_CONVERSION parameters:mDic];
        NSLog(@"This is a af none organic install: %@", mDic);
    } else if([status isEqualToString:@"Organic"]) {
        NSLog(@"This is an organic install.");
    }
}

@end
# endif

@implementation EYSdkUtils

static bool sIsUMInited = false;
static bool sIsGDTInited = false;
static bool sIsFBInited = false;

    
#ifdef FACEBOOK_ENABLED
/**
 *需要在info.plist里设置FacebookAppID
 **/
+(void) initFacebookSdkWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions
{
    
    [FBSDKSettings setAutoLogAppEventsEnabled:YES];
    [FBSDKSettings setAutoInitEnabled: YES ];
    [FBSDKSettings setAdvertiserIDCollectionEnabled:YES];
    [FBSDKApplicationDelegate initializeSDK:nil];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [self fetchDeferredAppLink:launchOptions];
    [FBSDKAppEvents activateApp];
    sIsFBInited = true;
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance]
        application:application openURL:url
        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
        annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                        ];
        
    return handled;
}

+(void) fetchDeferredAppLink:(NSDictionary *)launchOptions {
    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
      [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
        if (error) {
          NSLog(@"Received error while fetching deferred app link %@", error);
        }
        if (url) {
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
            mDic[@"eyu_channel"] = @"facebook";
            NSString *host = [url.absoluteString componentsSeparatedByString:@"?"].firstObject;
            NSString *ad_name = [host componentsSeparatedByString:@"://"].lastObject;
            if (ad_name.length > 100) {
                mDic[@"ad_name"] = [ad_name substringToIndex:100];
                mDic[@"ad_name2"] = [ad_name substringWithRange: NSMakeRange(100, ad_name.length-100)];
            } else {
                mDic[@"ad_name"] = ad_name;
            }
            NSLog(@"This is a fb none organic install: %@", mDic);
            [EYEventUtils logEvent:EVENT_FBCONVERSION parameters:mDic];
        }
      }];
    }
}
#endif

#ifdef FIREBASE_ENABLED
+(void) initFirebaseSdk
{
    NSLog(@"initFirebaseSdk");
    [FIRApp configure];
}
#endif

#ifdef AF_ENABLED
AppsFlyerDelegate *_appflyerDelegate = [AppsFlyerDelegate new];

+(void) initAppFlyer:(NSString*) devKey appId:(NSString*)appId
{
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = devKey;
    [AppsFlyerTracker sharedTracker].appleAppID = appId;
    [AppsFlyerTracker sharedTracker].delegate = _appflyerDelegate;
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}
#endif

#ifdef UM_ENABLED
+(void) initUMMobSdk:(NSString*) appKey channel:(NSString*) channel
{
    [UMConfigure initWithAppkey:appKey channel:channel];
    sIsUMInited = true;
}

+(bool) isUMInited
{
    return sIsUMInited;
}
#endif

#ifdef GDT_ACTION_ENABLED
+(void) initGDTActionSdk:(NSString*) setid secretkey:(NSString*)secretkey
{
    [GDTAction init:setid secretKey:secretkey];
    sIsGDTInited = true;
}

+(void) doGDTSDKActionStartApp
{
    [GDTAction logAction:GDTSDKActionNameStartApp actionParam:@{@"value":@(123)}];
}

+(bool) isGDTInited
{
    return sIsGDTInited;
}

#endif

#ifdef TRACKING_ENABLED

+ (void)initTrackingWithAppKey:(NSString *)appKey
{
    [EYSdkUtils initTrackingWithAppKey:appKey withChannelId:@"_default_"];
}

+ (void)initTrackingWithAppKey:(NSString *)appKey withChannelId:(NSString *)channelId
{
    [Tracking initWithAppKey:appKey withChannelId:channelId];
}
#endif

    
+(bool) isFBInited
{
    return sIsFBInited;
}

+ (NSData *)readFileWithName:(NSString *)name
{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return data;
}

// 读取本地JSON文件
+ (NSDictionary *)readJsonFileWithName:(NSString *)name
{
    NSData *data = [EYSdkUtils readFileWithName:name];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end

