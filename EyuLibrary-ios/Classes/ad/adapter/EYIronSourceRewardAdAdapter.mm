//
//  EYIronSourceRewardAdAdapter.m
//  Bolts
//
//  Created by caochao on 2019/3/19.
//
#ifndef BYTE_DANCE_ONLY

#import "EYIronSourceRewardAdAdapter.h"
#import "IronSource/IronSource.h"
#import "EYAdManager.h"

@interface EYIronSourceRewardAdAdapter()<ISRewardedVideoDelegate>

@property(nonatomic,assign) bool isRewarded;
@property(nonatomic,assign) bool isClosed;

@end

@implementation EYIronSourceRewardAdAdapter

-(void) loadAd
{
    NSLog(@"EYIronSourceRewardAdAdapter loadAd #############. adId = #%@#", self.adKey.key);
    [EYAdManager sharedInstance].ISRVAdapter = self;
    if([self isAdLoaded]) {
        [self notifyOnAdLoaded];
    }
    else {
        [self notifyOnAdLoadFailedWithError:ERROR_IRON_SOURCE_AD_NOT_LOADED];
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"EYIronSourceRewardAdAdapter showAd #############.");
    [EYAdManager sharedInstance].ISRVAdapter = self;
    if([self isAdLoaded])
    {
        self.isRewarded = false;
        self.isClosed = false;
        [IronSource showRewardedVideoWithViewController:controller placement:self.adKey.key];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    //广告次数达到上限
    bool isCapped = [IronSource isRewardedVideoCappedForPlacement:self.adKey.key];
    if(isCapped) {
        NSLog(@"EYIronSourceRewardAdAdapter key = %@ isCapped", self.adKey.key);
        return false;
    }
    return [IronSource hasRewardedVideo];
}

#pragma mark - IronSource Rewarded Video Delegate Functions
/**
 Called after a rewarded video has changed its availability.
 
 @param available The new rewarded video availability. YES if available and ready to be shown, NO otherwise.
 */
- (void)rewardedVideoHasChangedAvailability:(BOOL)available
{
    NSLog(@"EYIronSourceRewardAdAdapter rewardedVideoHasChangedAvailability");
    if(available == YES) {
        [self notifyOnAdLoaded];
    }
}

/**
 Called after a rewarded video has been viewed completely and the user is eligible for reward.
 
 @param placementInfo An object that contains the placement's reward name and amount.
 */
- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo
{
    NSLog(@"EYIronSourceRewardAdAdapter didReceiveRewardForPlacement, self->isClosed = %d", self.isClosed);
    self.isRewarded = true;
    if(self.isClosed) {
        [self notifyOnAdRewarded];
    }
}

/**
 Called after a rewarded video has attempted to show but failed.
 
 @param error The reason for the error
 */
- (void)rewardedVideoDidFailToShowWithError:(NSError *)error
{
    NSLog(@"EYIronSourceRewardAdAdapter rewardedVideoDidFailToShowWithError, error = %@", error);
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

/**
 Called after a rewarded video has been opened.
 */
- (void)rewardedVideoDidOpen
{
    NSLog(@"EYIronSourceRewardAdAdapter rewardedVideoDidOpen");
    [self notifyOnAdShowed];
}

/**
 Called after a rewarded video has been dismissed.
 */
- (void)rewardedVideoDidClose
{
    NSLog(@"EYIronSourceRewardAdAdapter rewardedVideoDidClose. self->isRewarded = %d", self.isRewarded);
    self.isClosed = true;
    if(self.isRewarded){
        [self notifyOnAdRewarded];
    }
    [self notifyOnAdClosed];
}

/**
 * Note: the events below are not available for all supported rewarded video ad networks.
 * Check which events are available per ad network you choose to include in your build.
 * We recommend only using events which register to ALL ad networks you include in your build.
 */

/**
 Called after a rewarded video has started playing.
 */
- (void)rewardedVideoDidStart
{
    NSLog(@"EYIronSourceRewardAdAdapter rewardedVideoDidStart");
}

/**
 Called after a rewarded video has finished playing.
 */
- (void)rewardedVideoDidEnd
{
    NSLog(@"EYIronSourceRewardAdAdapter rewardedVideoDidEnd");
}

/**
 Called after a video has been clicked.
 */
- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo
{
    NSLog(@"EYIronSourceRewardAdAdapter didClickRewardedVideo");
    [self notifyOnAdClicked];
}
    
@end
#endif /*BYTE_DANCE_ONLY*/
