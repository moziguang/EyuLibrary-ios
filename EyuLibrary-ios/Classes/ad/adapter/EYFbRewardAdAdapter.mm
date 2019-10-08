//
//  FbRewardAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#include "EYFbRewardAdAdapter.h"


@implementation EYFbRewardAdAdapter

@synthesize isRewarded = _isRewarded;
@synthesize rewardAd = _rewardAd;

-(void) loadAd
{
    NSLog(@" lwq, fb loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if(![self isLoading] )
    {
        if(self.rewardAd!=NULL)
        {
            self.rewardAd.delegate = nil;
        }
        self.isLoading = true;
        self.rewardAd = [[FBRewardedVideoAd alloc] initWithPlacementID:self.adKey.key];
        self.rewardAd.delegate = self;
        [self startTimeoutTask];
        [self.rewardAd loadAd];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" lwq, fb showAd ");
    if([self isAdLoaded])
    {
        bool result = [self.rewardAd showAdFromRootViewController:controller];
        if(result)
        {
            [self notifyOnAdShowed];
        }
        return result;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = self.rewardAd != NULL && [self.rewardAd isAdValid];
    NSLog(@" lwq, fb Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

/**
 Sent when an ad has been successfully loaded.
 
 - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdDidLoad:(FBRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@" lwq, fb Reward video ad is loaded.");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

/**
 Sent after an FBRewardedVideoAd object has been dismissed from the screen, returning control
 to your application.
 
 - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdDidClose:(FBRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@" lwq, fb Reward video ad is closed.");
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    
    if(self.isRewarded){
        [self notifyOnAdRewarded];
    }
    self.isRewarded = false;
    [self notifyOnAdClosed];
}

/**
 Sent after an FBRewardedVideoAd fails to load the ad.
 
 - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
 - Parameter error: An error object containing details of the error.
 */
- (void)rewardedVideoAd:(FBRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    NSLog(@" lwq, fb Reward video ad is failed to load. error = %d", (int)error.code);
    self.isLoading = false;
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

/**
 Sent after the FBRewardedVideoAd object has finished playing the video successfully.
 Reward the user on this callback.
 
 - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdVideoComplete:(FBRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@" lwq, fb Reward video ad is showed.");
    self.isRewarded = true;
}

/**
  Sent immediately before the impression of an FBRewardedVideoAd object will be logged.

 @param rewardedVideoAd An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdWillLogImpression:(FBRewardedVideoAd *)rewardedVideoAd
{
    [self notifyOnAdImpression];
}
@end
#endif /*BYTE_DANCE_ONLY*/
