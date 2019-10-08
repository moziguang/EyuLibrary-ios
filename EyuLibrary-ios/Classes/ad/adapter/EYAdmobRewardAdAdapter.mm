//
//  FbRewardAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#include "EYAdmobRewardAdAdapter.h"
#include "EYAdManager.h"

#ifndef BYTE_DANCE_ONLY

@implementation EYAdmobRewardAdAdapter

@synthesize isRewarded = _isRewarded;


-(void) loadAd
{
    NSLog(@"lwq, AdmobRewardAdAdapter loadAd #############. adId = #%@#", self.adKey.key);
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if([[EYAdManager sharedInstance] isAdmobRewardAdLoaded]){
        NSLog(@"lwq,one AdmobRewardAdAdapter was already loaded.");
        [self notifyOnAdLoadFailedWithError:ERROR_OTHER_ADMOB_REWARD_AD_LOADED];
    }else if([[EYAdManager sharedInstance] isAdmobRewardAdLoading]){
        NSLog(@"lwq,one AdmobRewardAdAdapter is loading.");
        if(self.isLoading){
            if(self.loadingTimer == nil){
                [self startTimeoutTask];
            }
        }else{
            [self notifyOnAdLoadFailedWithError:ERROR_OTHER_ADMOB_REWARD_AD_LOADING];
        }
    }else if(!self.isLoading)
    {
        self.isLoading = true;
        [GADRewardBasedVideoAd sharedInstance].delegate = self;
        GADRequest* request = [GADRequest request];
        //request.testDevices = @[ @"9b80927958fbfef89ca335966239ca9a",@"46fd4577df207ecb050bffa2948d5e52" ];
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:self.adKey.key];
        [self startTimeoutTask];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"lwq, AdmobRewardAdAdapter showAd #############.");
    if([self isAdLoaded])
    {
        self.isRewarded = false;
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:controller];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    return [[GADRewardBasedVideoAd sharedInstance] isReady];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward {
    //[[AdPlayerIOS sharedAdPlayerIOS] onRewardAdRewarded:self];
    NSLog(@"lwq, AdmobRewardAdAdapter Reward based video ad is rewarded.");
    self.isRewarded = true;
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"lwq, AdmobRewardAdAdapter Reward based video ad is received.");
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"lwq, AdmobRewardAdAdapter Opened reward based video ad.");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"lwq, AdmobRewardAdAdapter Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"lwq, AdmobRewardAdAdapter Reward based video ad is closed. self->isRewarded = %d", self.isRewarded);
    
    if(self.isRewarded){
        [self notifyOnAdRewarded];
    }
    self.isRewarded = false;
    [self notifyOnAdClosed];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"lwq, AdmobRewardAdAdapter Reward based video ad will leave application.");
    [self notifyOnAdClicked];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"lwq, AdmobRewardAdAdapter Reward based video ad failed to load. error = %@", error);
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

@end
#endif /*BYTE_DANCE_ONLY*/
