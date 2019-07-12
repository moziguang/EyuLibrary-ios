//
//  EYSdkUtils.m
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import <Foundation/Foundation.h>
#import "EYSdkUtils.h"
#import "Firebase.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>
#import <GDTActionSDK/GDTAction.h>
#import <UMCommon/UMCommon.h>

#ifdef FACEBOOK_ENABLED
#import <FBSDKCoreKit/FBSDKCoreKit.h>
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
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FBSDKSettings setAutoLogAppEventsEnabled:YES];
    
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
    
+(void) initFirebaseSdk
{
    [FIRApp configure];
}

+(void) initAppFlyer:(NSString*) devKey appId:(NSString*)appId
{
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = devKey;
    [AppsFlyerTracker sharedTracker].appleAppID = appId;
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

+(void) initUMMobSdk:(NSString*) appKey channel:(NSString*) channel
{
//    UMConfigInstance.appKey =appKey;
//    //    UMConfigInstance.ChannelId = @"App Store";
//    UMConfigInstance.eSType = E_UM_GAME;
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
//    NSLog(@"lwq, initUMMobSdk version = %@", version);
//    [MobClick startWithConfigure:UMConfigInstance];
    [UMConfigure initWithAppkey:appKey channel:channel];
    sIsUMInited = true;
}

+(void) initGDTActionSdk:(NSString*) setid secretkey:(NSString*)secretkey
{
    [GDTAction init:setid secretKey:secretkey];
    sIsGDTInited = true;
}

+(void) doGDTSDKActionStartApp
{
    [GDTAction logAction:GDTSDKActionNameStartApp actionParam:@{@"value":@(123)}];
}

+(bool) isUMInited
{
    return sIsUMInited;
}

+(bool) isGDTInited
{
    return sIsGDTInited;
}
    
+(bool) isFBInited
{
    return sIsFBInited;
}

@end

