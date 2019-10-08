//
//  EYVungleInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#include "EYVungleInterstitialAdAdapter.h"
//#import <VungleSDK/VungleSDK.h>
#include "EYAdConstants.h"
#include "EYAdManager.h"

@interface EYVungleInterstitialAdAdapter()<VungleSDKDelegate>


@end


@implementation EYVungleInterstitialAdAdapter

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super initWithAdKey:adKey adGroup:group];
    if(self)
    {
        [[EYAdManager sharedInstance] addVungleAdsDelegate:self withKey:adKey.key];
    }
    return self;
}

-(void) loadAd
{
    NSLog(@"lwq, vungle loadAd key = %@", self.adKey);
    VungleSDK* sdk = [VungleSDK sharedSDK];

    if(![sdk isInitialized])
    {
        [self notifyOnAdLoadFailedWithError:ERROR_SDK_UNINITED];
        return;
    }
    if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else if(!self.isLoading){
        self.isLoading = true;
        NSError* error;
        [sdk loadPlacementWithID:self.adKey.key error:&error];
        if(error)
        {
            NSLog(@"lwq, vungle load interstitial Ad error %@", error);
            self.isLoading = false;
            [self notifyOnAdLoadFailedWithError:(int)(error.code)];
        }else{
            [self startTimeoutTask];
        }
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    bool isAdLoaded = [self isAdLoaded];
    NSLog(@"lwq, vungle showAd [self isAdLoaded] = %d", isAdLoaded);
    if(isAdLoaded)
    {
        VungleSDK* sdk = [VungleSDK sharedSDK];
        NSError *error;
        [sdk playAd:controller options:nil placementID:self.adKey.key error:&error];
        if (error) {
            NSLog(@"lwq,vungle Error encountered playing ad: %@", error);
            return false;
        }else{
            return true;
        }
    }
    return false;
}

-(bool) isAdLoaded
{
    VungleSDK* sdk = [VungleSDK sharedSDK];
    return [sdk isInitialized] && [sdk isAdCachedForPlacementID:self.adKey.key];
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
    if([self.adKey.key isEqualToString:placementID] )
    {
        [self cancelTimeoutTask];
        if(error)
        {
            [self notifyOnAdLoadFailedWithError:(int)(error.code)];
        }else if(isAdPlayable){
            [self notifyOnAdLoaded];
        }
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
    if([self.adKey.key isEqualToString:placementID] )
    {
        [self notifyOnAdShowed];
        [self notifyOnAdImpression];
    }
}

/**
 * If implemented, this method gets called when a Vungle Ad Unit has been completely dismissed.
 * At this point, you can load another ad for non-auto-cahced placement if necessary.
 */
- (void)vungleDidCloseAdWithViewInfo:(nonnull VungleViewInfo *)info placementID:(nonnull NSString *)placementID
{
    NSLog(@"vungleDidCloseAdWithViewInfo , placementId = %@", placementID);
    if([self.adKey.key isEqualToString:placementID] )
    {
        if(info && info.didDownload)
        {
            [self notifyOnAdClicked];
        }
        [self notifyOnAdClosed];
    }
}

- (void)dealloc
{
    [[EYAdManager sharedInstance] removeVungleAdsDelegate:self forKey:self.adKey.key];
}

@end
#endif /*BYTE_DANCE_ONLY*/
