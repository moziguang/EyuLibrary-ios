//
//  AdPlayer-ios.m
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import <Foundation/Foundation.h>
#import "EYAdManager.h"
#import "SVProgressHUD.h"
#import "EYRemoteConfigHelper.h"
#import "EYAdKey.h"
#import "EYAdGroup.h"
#import "EYAdPlace.h"
#import "EYInterstitialAdGroup.h"
#import "EYNativeAdGroup.h"
#import "EYRewardAdGroup.h"
#import "EYNativeAdAdapter.h"
#import "EYNativeAdView.h"
#import <CoreTelephony/CTCellularData.h>
#import <BUAdSDK/BUAdSDKManager.h>


#ifndef BYTE_DANCE_ONLY
#import <AppLovinSDK/AppLovinSDK.h>
#import <MTGSDK/MTGSDK.h>
#import "IronSource/IronSource.h"
#import "GoogleMobileAds/GoogleMobileAds.h"
#endif


#ifndef BYTE_DANCE_ONLY
@interface EYAdManager()<UnityAdsDelegate, VungleSDKDelegate, ISDemandOnlyInterstitialDelegate, ISDemandOnlyRewardedVideoDelegate>
#else
@interface EYAdManager()
#endif
{

}

@property(nonatomic,assign) bool isInited;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYAdKey*>* adKeyDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYAdGroup*>* adGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYAdPlace*>* adPlaceDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYInterstitialAdGroup*>* interstitialAdGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYNativeAdGroup*>* nativeAdGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,EYRewardAdGroup*>* rewardAdGroupDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*,NSString*>*  nativeAdViewNibDict;
@property(nonatomic,strong) NSMutableDictionary<NSNumber*,NSMutableDictionary<NSString*,EYNativeAdView*>*>*  nativeAdViewDict;
@property(nonatomic,weak) UIViewController* nativeAdController;

#ifndef BYTE_DANCE_ONLY

@property(nonatomic,strong) NSMutableDictionary<NSString*, id<UnityAdsDelegate>>* unityAdsDelegateDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*, id<VungleSDKDelegate>>* vungleAdsDelegateDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*, id<ISDemandOnlyRewardedVideoDelegate>>* ironRewardDelegateDict;
@property(nonatomic,strong) NSMutableDictionary<NSString*, id<ISDemandOnlyInterstitialDelegate>>* ironInterDelegateDict;
#endif
@property(nonatomic,strong) CTCellularData* cellularData;

@end

static id s_sharedInstance;

@implementation EYAdManager

@synthesize adConfig = _adConfig;
@synthesize adKeyDict = _adKeyDict;
@synthesize adGroupDict = _adGroupDict;
@synthesize adPlaceDict = _adPlaceDict;

@synthesize interstitialAdGroupDict = _interstitialAdGroupDict;
@synthesize nativeAdGroupDict = _nativeAdGroupDict;
@synthesize rewardAdGroupDict = _rewardAdGroupDict;
@synthesize nativeAdViewDict = _nativeAdViewDict;
@synthesize nativeAdViewNibDict = _nativeAdViewNibDict;
@synthesize nativeAdController = _nativeAdController;
#ifndef BYTE_DANCE_ONLY

@synthesize unityAdsDelegateDict = _unityAdsDelegateDict;
@synthesize vungleAdsDelegateDict = _vungleAdsDelegateDict;
@synthesize ironRewardDelegateDict = _ironRewardDelegateDict;
@synthesize ironInterDelegateDict = _ironInterDelegateDict;
#endif
@synthesize isAdmobRewardAdLoaded = _isAdmobRewardAdLoaded;
@synthesize isAdmobRewardAdLoading = _isAdmobRewardAdLoading;
@synthesize cellularData = _cellularData;

+(EYAdManager*) sharedInstance
{
    if (s_sharedInstance == nil)
    {
        s_sharedInstance = [[EYAdManager alloc] init];
    }

    return s_sharedInstance;
}

-(void) loadAdConfig:(EYAdConfig*)config
{
    self.adConfig = config;
    NSData* adKeySettingData = config.adKeyData;
    //NSLog(@"lwq, loadAdConfig adKeySettingData = %@", adKeySettingData);
    NSString* keyStr = [[NSString alloc] initWithData:adKeySettingData encoding:NSASCIIStringEncoding];
    NSLog(@"lwq, loadAdConfig adKeySettingData = %@", keyStr);
    NSArray *adKeyArray = [NSJSONSerialization JSONObjectWithData:adKeySettingData options:kNilOptions error:nil];
    for(NSDictionary* adKeySetting:adKeyArray)
    {
        NSString *keyId = adKeySetting[@"id"];
        NSString *network = adKeySetting[@"network"];
        NSString *key = adKeySetting[@"key"];
        EYAdKey *adKey = [[EYAdKey alloc] initWithId:keyId network:network key:key];
        [self.adKeyDict setObject:adKey forKey:keyId];
    }
    
    NSData* adGroupData = config.adGroupData;
    NSString* str = [[NSString alloc] initWithData:adGroupData encoding:NSASCIIStringEncoding];
    NSLog(@"lwq, loadAdConfig adGroupData = %@", str);
    NSArray *adGroupArray = [NSJSONSerialization JSONObjectWithData:adGroupData options:kNilOptions error:nil];
    for(NSDictionary* adGroupDict:adGroupArray)
    {
        //NSLog(@"lwq, loadAdConfig adCacheDict = %@", adCacheDict);
        NSString *groupId = adGroupDict[@"id"];
        NSString *keys = adGroupDict[@"keys"];
        NSString *type = adGroupDict[@"type"];
        NSString *isAutoLoadStr = adGroupDict[@"isAutoLoad"];
        EYAdGroup *adGroup = [[EYAdGroup alloc] initWithId:groupId];
        if(keys != NULL){
            NSData* data = [keys dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *keyIdArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if(keyIdArray!=NULL){
                for (NSString* keyId in keyIdArray ) {
                    EYAdKey* key = self.adKeyDict[keyId];
                    [adGroup addAdKey:key];
                }
            }
        }
        adGroup.isAutoLoad = [@"true" isEqualToString:isAutoLoadStr];
        adGroup.type = type;
        [self.adGroupDict setObject:adGroup forKey:groupId];
    }
    
    NSData* adSettingData = config.adPlaceData;
    NSString* adSettingStr = [[NSString alloc] initWithData:adSettingData encoding:NSASCIIStringEncoding];
    NSLog(@"lwq, loadAdConfig adSettingStr = %@", adSettingStr);
    NSArray *adArray = [NSJSONSerialization JSONObjectWithData:adSettingData options:kNilOptions error:nil];
    for(NSDictionary* adSetting:adArray)
    {
        NSString *placeId = adSetting[@"id"];
        NSString *groupId = adSetting[@"cacheGroup"];
        NSString *nibName = adSetting[@"nativeAdLayout"];
        EYAdPlace *adPlace = [[EYAdPlace alloc] initWithId:placeId groupId:groupId];
        [self.adPlaceDict setObject:adPlace forKey:placeId];
        if(nibName){
            [self.nativeAdViewNibDict setObject:nibName forKey:placeId];
        }
    }
}

- (void) initAdGroup
{
    for(NSString* groupId in self.adGroupDict)
    {
        EYAdGroup* group = self.adGroupDict[groupId];
        if([ADTypeInterstitial isEqualToString:group.type])
        {
            EYInterstitialAdGroup* interstitialAdGroup = [[EYInterstitialAdGroup alloc] initWithGroup:group adConfig:self.adConfig];
            [interstitialAdGroup setDelegate:self];
            [self.interstitialAdGroupDict setObject:interstitialAdGroup forKey:group.groupId];
            if(group.isAutoLoad)
            {
                [interstitialAdGroup loadAd:@"auto"];
            }
        }else if([ADTypeNative isEqualToString:group.type])
        {
            EYNativeAdGroup* nativeAdGroup = [[EYNativeAdGroup alloc] initWithGroup:group adConfig:self.adConfig];
            [nativeAdGroup setDelegate:self];
            [self.nativeAdGroupDict setObject:nativeAdGroup forKey:group.groupId];
            if(group.isAutoLoad)
            {
                [nativeAdGroup loadAd:@"auto"];
            }
        }else if([ADTypeReward isEqualToString:group.type])
        {
            EYRewardAdGroup* rewardAdGroup = [[EYRewardAdGroup alloc] initWithGroup:group adConfig:self.adConfig];
            [rewardAdGroup setDelegate:self];
            [self.rewardAdGroupDict setObject:rewardAdGroup forKey:group.groupId];
            if(group.isAutoLoad)
            {
                [rewardAdGroup loadAd:@"auto"];
            }
        }
    }
}

-(void) initSdk:(EYAdConfig*) config
{
    NSString* wmAppKey = config.wmAppKey;
    if(wmAppKey == NULL || [wmAppKey isEqualToString:@""])
    {
        NSLog(@"lwq, setup wmAppKey ==  NULL");
    }else{
        NSLog(@"lwq, setup wmAppKey =  %@", wmAppKey);
        [BUAdSDKManager setAppID:wmAppKey];
        [BUAdSDKManager setIsPaidApp:config.isPaidApp];
    }
    
#ifdef BYTE_DANCE_ONLY
    config.isWmOnly = true;
#else
    if(config.isWmOnly){
        return;
    }
    
    NSString* mtgAppId = config.mtgAppId;
    NSString* mtgAppKey = config.mtgAppKey;
    if(mtgAppId == NULL || [mtgAppId isEqualToString:@""] ||
       mtgAppKey == NULL || [mtgAppKey isEqualToString:@""])
    {
        NSLog(@"lwq, setup mtgAppId ==  NULL");
    }else{
        NSLog(@"lwq, setup mtgAppId =  %@, mtgAppKey = %@", mtgAppId, mtgAppKey);
        [[MTGSDK sharedInstance] setAppID:mtgAppId ApiKey:mtgAppKey];
    }
    
    NSString* admobClientId = config.admobClientId;
    if(admobClientId == NULL || [admobClientId isEqualToString:@""])
    {
        NSLog(@"lwq, setup admobClientId ==  NULL");
    }else{
        NSLog(@"lwq, setup admobClientId =  %@", admobClientId);
        [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
            NSLog(@"lwq, setup admobClient status = %@", status);
        }];
    }
    
    //init Applovin SDK
    /**
     *需要在info.plist里设置AppLovinSdkKey
     **/
    [ALSdk initializeSdk];
    
        NSString* unityClientId = config.unityClientId;
        if(unityClientId == NULL || [unityClientId isEqualToString:@""])
        {
            NSLog(@"lwq, setup unityClientId ==  NULL");
        }else{
            NSLog(@"lwq, setup unityClientId =  %@", unityClientId);
            //[GADMobileAds configureWithApplicationID:unityClientId];
            [UnityAds initialize:unityClientId delegate:self];
        }
        
        NSString* vungleClientId = config.vungleClientId;
        if(vungleClientId == NULL || [vungleClientId isEqualToString:@""])
        {
            NSLog(@"lwq, setup vungleClientId ==  NULL");
        }else{
            NSLog(@"lwq, setup vungleClientId =  %@", vungleClientId);
            NSError* error;
            VungleSDK* sdk = [VungleSDK sharedSDK];
            sdk.delegate = self;
            [sdk startWithAppId:vungleClientId error:&error];
            if(error){
                NSLog(@"lwq, setup VungleSDK error =  %@", error);
            }
        }
        NSString *ironSourceAppKey = config.ironSourceAppKey;
        if(ironSourceAppKey == NULL || [ironSourceAppKey isEqualToString:@""]) {
            NSLog(@"lwq, setup ironSourceAppKey ==  NULL");
        }
        else {
            NSLog(@"lwq, setup ironSourceAppKey ==  %@", ironSourceAppKey);
//            [IronSource setInterstitialDelegate:self];
//            [IronSource setRewardedVideoDelegate:self];
            [IronSource initISDemandOnly:ironSourceAppKey adUnits:@[IS_INTERSTITIAL]];
            [IronSource initISDemandOnly:ironSourceAppKey adUnits:@[IS_REWARDED_VIDEO]];

            [IronSource setISDemandOnlyInterstitialDelegate:self];
            [IronSource setISDemandOnlyRewardedVideoDelegate:self];
            [IronSource shouldTrackReachability:YES];
//            [IronSource initWithAppKey:ironSourceAppKey];
            [IronSource setAdaptersDebug:NO];
            [ISIntegrationHelper validateIntegration];
        }
#endif
}

-(void) setupWithConfig:(EYAdConfig*) config
{
    //NSLog(@"lwq, setup 111111111 %@", [NSThread currentThread]);
    //self.interstitialViewController = [[UIViewController alloc] init];
    if(self.isInited)
    {
        NSLog(@"lwq, setupWithViewController error,self.isInited = true");
        return;
    }
    if(config==nil)
    {
        NSLog(@"lwq, setupWithViewController error,config == nil");
        return;
    }
    
    [self initSdk:config];
    
    self.adKeyDict = [[NSMutableDictionary alloc] init];
    self.adGroupDict = [[NSMutableDictionary alloc] init];
    self.adPlaceDict = [[NSMutableDictionary alloc] init];
    
    self.interstitialAdGroupDict = [[NSMutableDictionary alloc] init];
    self.nativeAdGroupDict = [[NSMutableDictionary alloc] init];
    self.rewardAdGroupDict = [[NSMutableDictionary alloc] init];
    self.nativeAdViewDict = [[NSMutableDictionary alloc] init];
    self.nativeAdViewNibDict = [[NSMutableDictionary alloc] init];
    self.nativeAdController = nil;
#ifndef BYTE_DANCE_ONLY
    self.unityAdsDelegateDict = [[NSMutableDictionary alloc] init];
    self.vungleAdsDelegateDict = [[NSMutableDictionary alloc] init];
    self.ironInterDelegateDict = [[NSMutableDictionary alloc] init];
    self.ironRewardDelegateDict = [[NSMutableDictionary alloc] init];
#endif
    [self loadAdConfig:config];
    [self initAdGroup];
    self.isInited = true;
}

-(void) loadRewardVideoAd:(NSString*) placeId
{
    if(!self.isInited)
    {
        return;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYRewardAdGroup *group = self.rewardAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            [group loadAd:placeId];
        }else{
            NSLog(@"loadRewardVideoAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"loadRewardVideoAd error, adPlace==nil, placeId = %@", placeId);
    }
}

-(void) showRewardVideoAd:(NSString*) placeId withViewController:(UIViewController*)controller
{
    if(!self.isInited)
    {
        return;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYRewardAdGroup *group = self.rewardAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            if(![group showAd:placeId withController:controller]){
                [self checkNetworkStatus];
            }
        }else{
            NSLog(@"showRewardVideoAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"showRewardVideoAd error, adPlace==nil, placeId = %@", placeId);
    }
}

-(void) loadInterstitialAd:(NSString*) placeId
{
    if(!self.isInited)
    {
        return;
    }
    NSLog(@"lwq, loadInterstitialAd placeId = %@", placeId);
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYInterstitialAdGroup *group = self.interstitialAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            [group loadAd:placeId];
        }else{
            NSLog(@"loadInterstitialAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"loadInterstitialAd error, adPlace==nil, placeId = %@", placeId);
    }
}

-(void) showInterstitialAd:(NSString*) placeId withViewController:(UIViewController*)controller
{
    if(!self.isInited)
    {
        return;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYInterstitialAdGroup *group = self.interstitialAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            if(![group showAd:placeId controller:controller])
            {
                [self checkNetworkStatus];
            }
        }else{
            NSLog(@"showInterstitialAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"showInterstitialAd error, adPlace==nil, placeId = %@", placeId);
        
    }
}

-(bool) isNativeAdLoaded:(NSString*) placeId
{
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYNativeAdGroup *group = self.nativeAdGroupDict[adPlace.groupId];
        return group!= nil && [group isCacheAvailable];
    }
    return false;
}

-(bool) isInterstitialAdLoaded:(NSString*) placeId
{
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYInterstitialAdGroup *group = self.interstitialAdGroupDict[adPlace.groupId];
        return group!= nil && [group isCacheAvailable];
    }
    return false;
}

-(bool) isRewardAdLoaded:(NSString*) placeId
{
    if(!self.isInited)
    {
        return false;
    }
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYRewardAdGroup *group = self.rewardAdGroupDict[adPlace.groupId];
        return group!= nil && [group isCacheAvailable];
    }
    return false;
}

-(void)loadNativeAd:(NSString*) placeId
{
    if(!self.isInited)
    {
        return;
    }
    NSLog(@"lwq, loadNativeAd start placeId = %@", placeId);
    EYAdPlace* adPlace = self.adPlaceDict[placeId];
    if(adPlace != nil)
    {
        EYNativeAdGroup *group = self.nativeAdGroupDict[adPlace.groupId];
        if(group!=nil)
        {
            [group loadAd:placeId];
        }else{
            NSLog(@"loadNativeAd error, group==nil, placeId = %@", placeId);
        }
    }else{
        NSLog(@"loadNativeAd error, adPlace==nil, placeId = %@", placeId);
    }
}

-(EYNativeAdView*) getNativeAdViewFromCache:(NSString* )placeId withViewController:(UIViewController*)controller
{
    EYNativeAdView* view = nil;
    auto viewDict = self.nativeAdViewDict[@((long)controller)];
    if(viewDict && viewDict[placeId]){
        view = viewDict[placeId];
    }
    return view;
}

-(void) putNativeAdViewToCache:(EYNativeAdView*) adView placeId:(NSString* )placeId withViewController:(UIViewController*)controller
{
    auto viewDict = self.nativeAdViewDict[@((long)controller)];
    if(viewDict==nil){
        viewDict = [[NSMutableDictionary alloc] init];
        [self.nativeAdViewDict setObject:viewDict forKey:@((long)controller)];
    }
    viewDict[placeId] = adView;
}

-(void) removeNativeAdViewCache:(UIViewController*) controller
{
    auto viewDict = self.nativeAdViewDict[@((long)controller)];
    if(viewDict){
        for(EYNativeAdView* view:[viewDict allValues])
        {
            [view removeFromSuperview];
            [view unregisterView];
        }
        [self.nativeAdViewDict removeObjectForKey:@((long)controller)];
    }
}

-(EYNativeAdView*) getNativeAdView:(NSString* )placeId withViewController:(UIViewController*)controller viewGroup:(UIView*)viewGroup
{
    EYNativeAdView* view = [self getNativeAdViewFromCache:placeId withViewController:controller];
    if(view == nil){
        auto nativeAdViewNib = self.nativeAdViewNibDict[placeId];
        /*NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:nativeAdViewNib owner:controller options:nil];
        view = [nibView firstObject];
        CGRect viewRect = viewGroup.frame;
        view.frame = viewRect;*/
        CGRect rect = viewGroup.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        view = [[EYNativeAdView alloc] initWithFrame:rect nibName:nativeAdViewNib];
        [viewGroup addSubview:view];
        [self putNativeAdViewToCache:view placeId:placeId withViewController:controller];
    }
    return view;
}

-(void) showNativeAd:(NSString*) placeId withViewController:(UIViewController*)controller viewGroup:(UIView*)viewGroup
{
    if(!self.isInited)
    {
        return;
    }
    EYNativeAdView* view = [self getNativeAdView:placeId withViewController:controller viewGroup:viewGroup];
    if(view){
        self.nativeAdController = controller;
        EYNativeAdAdapter* adapter = [view getAdapter];
//        if(adapter){
//            [view setHidden:false];
//        }
        view.isNeedUpdate = true;
        view.isCanShow = true;
        adapter = [self getNativeAdAdapter:placeId];
        if(adapter){
            [view updateNativeAdAdapter:adapter];
        }else{
            [self loadNativeAd:placeId];
        }
    }
}

-(void) hideNativeAd:(NSString*) placeId forController:(UIViewController*)controller
{
    EYNativeAdView* view = [self getNativeAdViewFromCache:placeId withViewController:controller];
    if(view){
//        [view setHidden:true];
        view.isCanShow = false;
    }
}

-(EYNativeAdAdapter*) getNativeAdAdapter:(NSString*) adPlaceId
{
    EYNativeAdAdapter* adapter = nil;
    EYAdPlace* adPlace = self.adPlaceDict[adPlaceId];
    if(adPlace != nil)
    {
        EYNativeAdGroup *group = self.nativeAdGroupDict[adPlace.groupId];
        if(group!=nil && [group isCacheAvailable])
        {
            adapter = [group getAvailableAdapter];
        }
    }
    return adapter;
}

-(void) onNativeAdLoaded:(NSString*) adPlaceId
{
    NSLog(@"lwq, AdPlayer onNativeAdLoaded , adPlaceId = %@", adPlaceId);
    EYNativeAdView* view = [self getNativeAdViewFromCache:adPlaceId withViewController:self.nativeAdController];
    if(view && view.isCanShow && view.isNeedUpdate)
    {
        EYNativeAdAdapter* adapter = [self getNativeAdAdapter:adPlaceId];
        if(adapter)
        {
            [view updateNativeAdAdapter:adapter];
        }
    }
}

-(void) onAdLoaded:(NSString*) adPlaceId type:(NSString*)type
{
    NSLog(@"lwq, AdPlayer onAdLoaded , adPlaceId = %@, type = %@", adPlaceId, type);
    if(self.delegate)
    {
        [self.delegate onAdLoaded:adPlaceId type:type];
    }
    
    if([ADTypeNative isEqualToString:type])
    {
        [self onNativeAdLoaded:adPlaceId];
    }
}

-(void) onAdReward:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, AdPlayer onAdReward , adPlaceId = %@, type = %@", adPlaceId, type);
    if(self.delegate)
    {
        [self.delegate onAdReward:adPlaceId type:type];
    }
}

-(void) onAdShowed:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, AdPlayer onAdShowed , adPlaceId = %@, type = %@", adPlaceId, type);
    if(self.delegate)
    {
        [self.delegate onAdShowed:adPlaceId type:type];
    }
}

-(void) onAdClosed:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, AdPlayer onAdClosed , adPlaceId = %@, type = %@", adPlaceId, type);
    if(self.delegate)
    {
        [self.delegate onAdClosed:adPlaceId type:type];
    }
}

-(void) onAdClicked:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, AdPlayer onAdClicked , adPlaceId = %@, type = %@", adPlaceId, type);
    if(self.delegate)
    {
        [self.delegate onAdClicked:adPlaceId type:type];
    }
}

-(void) onAdLoadFailed:(NSString*) adPlaceId  key:(NSString*)key code:(int)code
{
    NSLog(@"lwq, AdPlayer onAdLoadFailed , adPlaceId = %@, key = %@, code = %d", adPlaceId, key, code);
    if(self.delegate)
    {
        [self.delegate onAdLoadFailed:adPlaceId key:key code:code];
    }
}

-(void) onAdImpression:(NSString*) adPlaceId  type:(NSString*)type
{
    NSLog(@"lwq, AdPlayer onAdImpression , adPlaceId = %@, type = %@", adPlaceId, type);
    if(self.delegate)
    {
        [self.delegate onAdImpression:adPlaceId type:type];
    }
}

-(EYAdKey*) getAdKeyWithId:(NSString*) keyId
{
     return self.adKeyDict[keyId];
}

#ifndef BYTE_DANCE_ONLY

-(void) addUnityAdsDelegate:(id<UnityAdsDelegate>) delegate withKey:(NSString*) adKey
{
    [self.unityAdsDelegateDict setObject:delegate forKey:adKey];
}

-(void) removeUnityAdsDelegate:(id<UnityAdsDelegate>) delegate forKey:(NSString *)adKey
{
    if(self.unityAdsDelegateDict[adKey] == delegate){
        self.unityAdsDelegateDict[adKey] = nil;
    }
}

- (void)unityAdsReady:(NSString *)placementId{
    NSLog(@"unityAdsReady , placementId = %@", placementId);
    id<UnityAdsDelegate> delegate = self.unityAdsDelegateDict[placementId];
    if(delegate){
        [delegate unityAdsReady:placementId];
    }
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    NSLog(@"unityAdsDidError , message = %@, error = %d", message, (int)error);
//    id<UnityAdsDelegate> delegate = self.unityAdsDelegateDict[placementId];
//    if(delegate){
//        [delegate unityAdsDidError:error :placementId];
//    }
}

- (void)unityAdsDidStart:(NSString *)placementId{
    NSLog(@"unityAdsDidStart , placementId = %@", placementId);
    id<UnityAdsDelegate> delegate = self.unityAdsDelegateDict[placementId];
    if(delegate){
        [delegate unityAdsDidStart:placementId];
    }
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{
    NSLog(@"unityAdsDidFinish , placementId = %@, withFinishState = %d", placementId, (int)state);
    id<UnityAdsDelegate> delegate = self.unityAdsDelegateDict[placementId];
    if(delegate){
        [delegate unityAdsDidFinish:placementId withFinishState:state];
    }
}

-(void) addVungleAdsDelegate:(id<VungleSDKDelegate>) delegate withKey:(NSString*) adKey
{
    [self.vungleAdsDelegateDict setObject:delegate forKey:adKey];
}
    
-(void) removeVungleAdsDelegate:(id<VungleSDKDelegate>) delegate forKey:(NSString *)adKey
{
    if(self.vungleAdsDelegateDict[adKey] == delegate){
        self.vungleAdsDelegateDict[adKey] = nil;
    }
}

/**
 * If implemented, this will get called when the SDK has an ad ready to be displayed. Also it will
 * get called with an argument `NO` for `isAdPlayable` when for some reason, there is
 * no ad available, for instance there is a corrupt ad or the OS wiped the cache.
 * Please note that receiving a `NO` here does not mean that you can't play an Ad: if you haven't
 * opted-out of our Exchange, you might be able to get a streaming ad if you call `play`.
 * @param isAdPlayable A boolean indicating if an ad is currently in a playable state
 * @param placementID The ID of a placement which is ready to be played
 * @param error The error that was encountered.  This is only sent when the placementID is nil.
 */
- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(nullable NSString *)placementID error:(nullable NSError *)error
{
    NSLog(@"vungleAdPlayabilityUpdate , placementId = %@, isAdPlayable = %d, error = %@", placementID, isAdPlayable, error);
    id<VungleSDKDelegate> delegate = self.vungleAdsDelegateDict[placementID];
    if(delegate){
        [delegate vungleAdPlayabilityUpdate:isAdPlayable placementID:placementID error:error];
    }
}

/**
 * If implemented, this will get called when the SDK is about to show an ad. This point
 * might be a good time to pause your game, and turn off any sound you might be playing.
 * @param placementID The placement which is about to be shown.
 */
- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID
{
    NSLog(@"vungleWillShowAdForPlacementID , placementId = %@", placementID);
    id<VungleSDKDelegate> delegate = self.vungleAdsDelegateDict[placementID];
    if(delegate){
        [delegate vungleWillShowAdForPlacementID:placementID];
    }
}

/**
 * If implemented, this method gets called when a Vungle Ad Unit has been completely dismissed.
 * At this point, you can load another ad for non-auto-cahced placement if necessary.
 */
- (void)vungleDidCloseAdWithViewInfo:(nonnull VungleViewInfo *)info placementID:(nonnull NSString *)placementID
{
    NSLog(@"vungleDidCloseAdWithViewInfo , placementId = %@, info = %@", placementID, info);
    id<VungleSDKDelegate> delegate = self.vungleAdsDelegateDict[placementID];
    if(delegate){
        [delegate vungleDidCloseAdWithViewInfo:info placementID:placementID];
    }
}

/**
 * If implemented, this will get called when VungleSDK has finished initialization.
 * It's only at this point that one can call `playAd:options:placementID:error`
 * and `loadPlacementWithID:` without getting initialization errors
 */
- (void)vungleSDKDidInitialize
{
    NSLog(@"vungleSDKDidInitialize");
}

/**
 * If implemented, this will get called if the VungleSDK fails to initialize.
 * The included NSError object should give some information as to the failure reason.
 * @note If initialization fails, you will need to restart the VungleSDK.
 */
- (void)vungleSDKFailedToInitializeWithError:(NSError *)error
{
    NSLog(@"vungleSDKFailedToInitializeWithError , error = %@", error);
}

#pragma mark - ISDemandOnlyInterstitialDelegate
//Invoked when Interstitial Ad is ready to be shown after the load function was called.
- (void)interstitialDidLoad:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidLoad:instanceId];
    }
}
//Called if showing the Interstitial for the user has failed.
//You can learn about the reason by examining the ‘error’ value
- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidFailToShowWithError:error instanceId:instanceId];
    }
}
//Called each time the end user has clicked on the Interstitial ad.
- (void)didClickInterstitial:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] didClickInterstitial:instanceId];
    }
}
//Called each time the Interstitial window is about to close
- (void)interstitialDidClose:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidClose:instanceId];
    }
}
//Called each time the Interstitial window is about to open
- (void)interstitialDidOpen:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidOpen:instanceId];
    }
}
//Invoked when there is no Interstitial Ad available after calling the load function.
//@param error - will contain the failure code and description.
- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId {
    if(self.ironInterDelegateDict[instanceId])
    {
        [self.ironInterDelegateDict[instanceId] interstitialDidFailToLoadWithError:error instanceId:instanceId];
    }
}

#pragma mark - ISDemandOnlyRewardedVideoDelegate
//Called after a rewarded video has been requested and load succeed.
- (void)rewardedVideoDidLoad:(NSString *)instanceId{
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidLoad:instanceId];
    }
}
//Called after a rewarded video has attempted to load but failed.
//@param error The reason for the error
- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error instanceId:(NSString* )instanceId{
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidFailToLoadWithError:error instanceId:instanceId];
    }
}
//Called after a rewarded video has been viewed completely and the user is //eligible for reward.
- (void)rewardedVideoAdRewarded:(NSString *)instanceId{
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoAdRewarded:instanceId];
    }
}
//Called after a rewarded video has attempted to show but failed.
//@param error The reason for the error
- (void)rewardedVideoDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId {
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidFailToShowWithError:error instanceId:instanceId];
    }
}
//Called after a rewarded video has been opened.
- (void)rewardedVideoDidOpen:(NSString *)instanceId {
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidOpen:instanceId];
    }
}
//Called after a rewarded video has been dismissed.
- (void)rewardedVideoDidClose:(NSString *)instanceId {
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidClose:instanceId];
    }
}
//Invoked when the end user clicked on the RewardedVideo ad
- (void)rewardedVideoDidClick:(NSString *)instanceId
{
    if(self.ironRewardDelegateDict[instanceId]){
        [self.ironRewardDelegateDict[instanceId] rewardedVideoDidClick:instanceId];
    }
}

#endif
-(void) onDefaultNativeAdClicked
{
    if(self.delegate!= nil && [self.delegate respondsToSelector:@selector(onDefaultNativeAdClicked)])
    {
        [self.delegate onDefaultNativeAdClicked];
    }
}

-(void) reset
{
#ifndef BYTE_DANCE_ONLY
    [self.vungleAdsDelegateDict removeAllObjects];
    [self.unityAdsDelegateDict removeAllObjects];
#endif
    [self.rewardAdGroupDict removeAllObjects];
    [self.interstitialAdGroupDict removeAllObjects];
    [self.nativeAdGroupDict removeAllObjects];
    [self.nativeAdViewDict removeAllObjects];
    [self.nativeAdViewNibDict removeAllObjects];
    [self.adKeyDict removeAllObjects];
    [self.adGroupDict removeAllObjects];
    [self.adPlaceDict removeAllObjects];
    self.isAdmobRewardAdLoaded = NO;
    self.isAdmobRewardAdLoading = NO;
    self.isInited = NO;
}

-(void) checkNetworkStatus
{
    bool showNetworkAlert = [[NSUserDefaults standardUserDefaults] boolForKey:@"SHOW_NETWORK_ALERT"];
    if(!showNetworkAlert){
        if(self->_cellularData == nil){
            self->_cellularData = [[CTCellularData alloc] init];
            __block EYAdManager *blockSelf = self;

            self->_cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state)
            {
                switch (state)
                {
                case kCTCellularDataRestricted: NSLog(@"Restricrted");
                        [blockSelf showNetworkAlert];
                        break;
                case kCTCellularDataNotRestricted: NSLog(@"Not Restricted"); break;
                    //未知，第一次请求
                case kCTCellularDataRestrictedStateUnknown: NSLog(@"Unknown"); break;
                default: break;
                };
            };
        }else{
            CTCellularDataRestrictedState state = self.cellularData.restrictedState;
            if(state == kCTCellularDataRestricted)
            {
                [self showNetworkAlert];
            }
        }
    }
}

-(void) showNetworkAlert
{
    bool showNetworkAlert = [[NSUserDefaults standardUserDefaults] boolForKey:@"SHOW_NETWORK_ALERT"];
    if(!showNetworkAlert){
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"SHOW_NETWORK_ALERT"];
        UIAlertController* networkAlertController = [UIAlertController alertControllerWithTitle:@"Network connection failed" message:@"Your device is not connected. Please check your cellular data setting." preferredStyle:UIAlertControllerStyleAlert];
//        __block UIAlertController *blockAlertController = networkAlertController;
        [networkAlertController addAction:[UIAlertAction actionWithTitle:@"Cannel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            if(blockAlertController){
//                [blockAlertController dismissViewControllerAnimated:YES completion:nil];
//            }
        }]];
        
        [networkAlertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                    [[UIApplication sharedApplication] openURL:settingsURL];
                }
        }]];
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:networkAlertController animated:YES completion:nil];

    }
    
}

-(void) addIronInterDelegate:(id<ISDemandOnlyInterstitialDelegate>) delegate withKey:(NSString*) adKey
{
    self.ironInterDelegateDict[adKey] = delegate;
}

-(void) removeIronInterDelegate:(id<ISDemandOnlyInterstitialDelegate>) delegate  forKey:(NSString *)adKey
{
    if(self.ironInterDelegateDict[adKey] == delegate){
        self.ironInterDelegateDict[adKey] = nil;
    }
}

-(void) addIronRewardDelegate:(id<ISDemandOnlyRewardedVideoDelegate>) delegate withKey:(NSString*) adKey
{
    self.ironRewardDelegateDict[adKey] = delegate;
}

-(void) removeIronRewardDelegate:(id<ISDemandOnlyRewardedVideoDelegate>) delegate  forKey:(NSString *)adKey
{
    if(self.ironRewardDelegateDict[adKey] == delegate){
        self.ironRewardDelegateDict[adKey] = nil;
    }
}
@end
