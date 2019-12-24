//
//  AdManager.h
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#ifndef AdManager_h
#define AdManager_h

#import "EYNativeAdAdapter.h"
#import "EYRewardAdAdapter.h"
#import "EYInterstitialAdAdapter.h"
#import "EYAdKey.h"
#import "EYAdConfig.h"
#import "EYAdDelegate.h"
#import "EYAdConstants.h"

#if BYTE_DANCE_ONLY != 1
#import "IronSource/IronSource.h"
#import "UnityAds/UnityAds.h"
#import "VungleSDK/VungleSDK.h"
#endif /*BYTE_DANCE_ONLY*/



@interface EYAdManager : NSObject <EYAdDelegate>{
    
}

+(EYAdManager*) sharedInstance;

@property(nonatomic,weak) id<EYAdDelegate> delegate;
@property(nonatomic,strong) EYAdConfig* adConfig;
@property(nonatomic,assign) bool isAdmobRewardAdLoaded;
@property(nonatomic,assign) bool isAdmobRewardAdLoading;

-(void) loadRewardVideoAd:(NSString*) placeId;
-(void) showRewardVideoAd:(NSString*) placeId withViewController:(UIViewController*)controller;

-(void) loadInterstitialAd:(NSString*) placeId;
-(void) showInterstitialAd:(NSString*) placeId withViewController:(UIViewController*)controller;

-(void) loadNativeAd:(NSString*) placeId;
-(EYNativeAdAdapter*) getNativeAdAdapter:(NSString*) adPlaceId;
-(void) showNativeAd:(NSString*) placeId withViewController:(UIViewController*)controller viewGroup:(UIView*)viewGroup;
-(void) hideNativeAd:(NSString*) placeId forController:(UIViewController*)controller;
-(void) removeNativeAdViewCache:(UIViewController*)controller;

-(bool) isNativeAdLoaded:(NSString*) placeId;
-(bool) isInterstitialAdLoaded:(NSString*) placeId;
-(bool) isRewardAdLoaded:(NSString*) placeId;

-(void) setupWithConfig:(EYAdConfig*) config;
-(EYAdKey*) getAdKeyWithId:(NSString*) keyId;

#ifndef BYTE_DANCE_ONLY

-(void) addUnityAdsDelegate:(id<UnityAdsDelegate>) delegate withKey:(NSString*) adKey;
-(void) removeUnityAdsDelegate:(id<UnityAdsDelegate>) delegate forKey:(NSString *)adKey;
-(void) addVungleAdsDelegate:(id<VungleSDKDelegate>) delegate withKey:(NSString*) adKey;
-(void) removeVungleAdsDelegate:(id<VungleSDKDelegate>) delegate  forKey:(NSString *)adKey;
-(void) addIronInterDelegate:(id<ISDemandOnlyInterstitialDelegate>) delegate withKey:(NSString*) adKey;
-(void) removeIronInterDelegate:(id<ISDemandOnlyInterstitialDelegate>) delegate  forKey:(NSString *)adKey;

-(void) addIronRewardDelegate:(id<ISDemandOnlyRewardedVideoDelegate>) delegate withKey:(NSString*) adKey;
-(void) removeIronRewardDelegate:(id<ISDemandOnlyRewardedVideoDelegate>) delegate  forKey:(NSString *)adKey;
#endif
-(void) onDefaultNativeAdClicked;

-(void) reset;

@end

#endif /* AdManager_h */


