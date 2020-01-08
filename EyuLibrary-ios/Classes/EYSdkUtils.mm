//
//  EYSdkUtils.m
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import <Foundation/Foundation.h>
#import "EYSdkUtils.h"

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
#endif

#ifdef FIREBASE_ENABLED
+(void) initFirebaseSdk
{
    NSLog(@"initFirebaseSdk");
    [FIRApp configure];
}
#endif

#ifdef AF_ENABLED
+(void) initAppFlyer:(NSString*) devKey appId:(NSString*)appId
{
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = devKey;
    [AppsFlyerTracker sharedTracker].appleAppID = appId;
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

