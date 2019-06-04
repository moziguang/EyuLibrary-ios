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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GDTActionSDK/GDTAction.h>
#import <UMCommon/UMCommon.h>

//#include "GAI.h"
//#include "GAITracker.h"
//#include "GAIDictionaryBuilder.h"
//#include "GAIFields.h"



@implementation EYSdkUtils

/**
 *需要在info.plist里设置FacebookAppID
 **/
+(void) initFacebookSdkWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions
{
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FBSDKSettings setAutoLogAppEventsEnabled:@1];
    
    [FBSDKAppEvents activateApp];
}

+(void) initFirebaseSdk
{
    [FIRApp configure];
}

//+(void) initGaSdk:(NSString*) trackId
//{
//    // Optional: configure GAI options.
//    GAI *gai = [GAI sharedInstance];
//    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
//    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
//
//    // Initialize a tracker using a Google Analytics property ID.
//    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:trackId];
//    [tracker set:kGAIScreenName value:@"main"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//}

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
}

+(void) initGDTActionSdk:(NSString*) setid secretkey:(NSString*)secretkey
{
    [GDTAction init:setid secretKey:secretkey];
}

+(void) doGDTSDKActionStartApp
{
    [GDTAction logAction:GDTSDKActionNameStartApp actionParam:@{@"value":@(123)}];
}

@end

