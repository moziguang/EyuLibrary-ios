//
//  EYMtgRewardAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#include "EYMtgRewardAdAdapter.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKReward/MTGRewardAdManager.h>

@interface EYMtgRewardAdAdapter()<MTGRewardAdLoadDelegate,MTGRewardAdShowDelegate>

@end

@implementation EYMtgRewardAdAdapter

-(void) loadAd
{
    NSLog(@" lwq, mtg loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if(![self isLoading] )
    {
        self.isLoading = true;
        
        [self startTimeoutTask];
        [[MTGRewardAdManager sharedInstance] loadVideo:self.adKey.key delegate:self];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" lwq, mtg showAd ");
    if([self isAdLoaded])
    {
        [[MTGRewardAdManager sharedInstance] showVideo:self.adKey.key withRewardId:@"1" userId:@"1" delegate:self viewController:controller];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = [[MTGRewardAdManager sharedInstance] isVideoReadyToPlay:self.adKey.key];
    NSLog(@" lwq, mtg Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

#pragma mark MTGRewardAdLoadDelegate

/**
 *  Called when the ad is loaded , and is ready to be displayed
 completely
 *  @param unitId - the unitId string of the Ad that was loaded.
 */
- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId
{
    NSLog(@"lwq, mtg reawrded video did load");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}


/**
 *  Called when the ad is loaded , but not ready to be displayed,need to wait download video
 completely
 *  @param unitId - the unitId string of the Ad that was loaded.
 */
- (void)onAdLoadSuccess:(nullable NSString *)unitId
{
    NSLog(@"lwq, mtg reawrded material load success");

}

/**
 *  Called when the ad is loaded failure
 completely
 */
- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error
{
    NSLog(@"lwq, mtg rewarded video material load fail unitId = %@, error = %@", unitId, error);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

#pragma mark MTGRewardAdShowDelegate

/**
 *  Called when the ad display success
 *
 *  @param unitId - the unitId string of the Ad that display success.
 */
- (void)onVideoAdShowSuccess:(nullable NSString *)unitId
{
    NSLog(@"lwq, mtg rewarded video will visible, unitId = %@", unitId);
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

/**
 *  Called when the ad display success
 *
 *  @param unitId - the unitId string of the Ad that display success.
 */

- (void)onVideoAdShowFailed:(nullable NSString *)unitId withError:(nonnull NSError *)error
{
    NSLog(@"lwq, mtg onVideoAdShowFailed unitId = %@, error = %@", unitId, error);
}

/**
 *  Called when the ad is clicked
 *
 *  @param unitId - the unitId string of the Ad clicked.
 */
- (void)onVideoAdClicked:(nullable NSString *)unitId
{
    NSLog(@"lwq, mtg rewarded video did click, unitId = %@", unitId);
    [self notifyOnAdClicked];
}

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *
 *  @param unitId      - the unitId string of the Ad that has been dismissed
 *  @param converted   - BOOL describing whether the ad has converted
 *  @param rewardInfo  - the rewardInfo object containing the info that should be given to your user.
 */
- (void)onVideoAdDismissed:(nullable NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(nullable MTGRewardAdInfo *)rewardInfo
{
    NSLog(@"lwq, mtg rewarded video did close, unitId = %@", unitId);
    if(rewardInfo){
        [self notifyOnAdRewarded];
    }
    [self notifyOnAdClosed];
}

@end
#endif /*BYTE_DANCE_ONLY*/
