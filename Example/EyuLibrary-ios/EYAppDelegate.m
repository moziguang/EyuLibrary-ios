//
//  EYAppDelegate.m
//  EyuLibrary-ios
//
//  Created by WeiqiangLuo on 09/28/2018.
//  Copyright (c) 2018 WeiqiangLuo. All rights reserved.
//

#import "EYAppDelegate.h"
#import "EYAdManager.h"
#import "EYAdConfig.h"
#import "EYRemoteConfigHelper.h"
#import "EYSdkUtils.h"
//#import <FBSDKLoginKit/FBSDKLoginKit.h>


@implementation EYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [EYSdkUtils initFirebaseSdk];
    // Override point for customization after application launch.
//    EYAdConfig* adConfig2 = [[EYAdConfig alloc] init];
    EYAdConfig* adConfig = [[EYAdConfig alloc] init];
    //[[EYRemoteConfigHelper sharedInstance] setDefaults:dict];
//    [[EYRemoteConfigHelper sharedInstance] getString:@"ios_ad_key_setting"];
    adConfig.adKeyData =  [EYSdkUtils readFileWithName:@"ios_ad_key_setting"];
    adConfig.adGroupData = [EYSdkUtils readFileWithName:@"ios_ad_cache_setting"];
    adConfig.adPlaceData = [EYSdkUtils readFileWithName:@"ios_ad_setting"];
    adConfig.maxTryLoadNativeAd = 7;
    adConfig.maxTryLoadRewardAd = 7;
    adConfig.maxTryLoadInterstitialAd = 7;
    adConfig.mtgAppId = @"111418";
    adConfig.mtgAppKey = @"a339a16bbaca844012276afad6f59eaa";
    adConfig.admobClientId = @"ca-app-pub-9624926763614741~7511510626";
    adConfig.wmAppKey = @"5010261";
//    adConfig.gdtAppId = @"1108127036";
//    [EYAdManager sharedInstance].useIronSource = true;
    [[EYAdManager sharedInstance] setupWithConfig:adConfig];
    [[EYAdManager sharedInstance] setDelegate:self];
    
    
    
//    [EYSdkUtils initFacebookSdkWithApplication:application options:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) onAdLoaded:(NSString*) adPlaceId type:(NSString*)type
{
    NSLog(@"lwq, onAdLoaded adPlaceId = %@, type = %@", adPlaceId, type);
}
-(void) onAdReward:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, onAdReward adPlaceId = %@, type = %@", adPlaceId, type);

}
-(void) onAdShowed:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, onAdShowed adPlaceId = %@, type = %@", adPlaceId, type);
    [[EYAdManager sharedInstance] loadRewardVideoAd:@"reward_ad"];
}
-(void) onAdClosed:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, onAdClosed adPlaceId = %@, type = %@", adPlaceId, type);

}
-(void) onAdClicked:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, onAdClicked adPlaceId = %@, type = %@", adPlaceId, type);

}

- (void)onDefaultNativeAdClicked {

}

- (void)onAdLoadFailed:(nonnull NSString *)adPlaceId key:(nonnull NSString *)key code:(int)code {
    NSLog(@"lwq, onAdLoadFailed adPlaceId = %@, key = %@, code = %d", adPlaceId, key, code);
}

-(void) onAdImpression:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, onAdImpression adPlaceId = %@, type = %@", adPlaceId, type);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
//    return [EYSdkUtils application:app openURL:url options:options];
    return false;
}

@end
