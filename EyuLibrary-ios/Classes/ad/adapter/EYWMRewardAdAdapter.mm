//
//  EYWMRewardAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#include "EYWMRewardAdAdapter.h"
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>

@interface EYWMRewardAdAdapter()<BURewardedVideoAdDelegate>

@property(nonatomic,assign)bool isRewarded;
@property(nonatomic,strong)BURewardedVideoAd* rewardAd;

@end

@implementation EYWMRewardAdAdapter

@synthesize isRewarded = _isRewarded;
@synthesize rewardAd = _rewardAd;

-(void) loadAd
{
    NSLog(@" lwq, wm loadAd isAdLoaded = %d", [self isAdLoaded]);
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
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = @"123";
        model.isShowDownloadBar = YES;
        self.rewardAd = [[BURewardedVideoAd alloc] initWithSlotID:self.adKey.key rewardedVideoModel:model];
        self.rewardAd.delegate = self;
        [self startTimeoutTask];
        [self.rewardAd loadAdData];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" lwq, wm showAd ");
    if([self isAdLoaded])
    {
        return [self.rewardAd showAdFromRootViewController:controller];
    }
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = self.rewardAd != NULL && [self.rewardAd isAdValid];
    NSLog(@" lwq, wm Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

#pragma mark BURewardedVideoAdDelegate

- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"lwq, wm reawrded material load success");
    
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"lwq, wm reawrded video did load");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"lwq, wm rewarded video will visible");
    [self notifyOnAdShowed];
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"lwq, wm rewarded video did close");
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

- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"lwq, wm rewarded video did click");
    [self notifyOnAdClicked];
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"lwq, wm rewarded video material load fail");
    self.isLoading = false;
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (error) {
        NSLog(@"lwq, wm rewarded play error");
    } else {
        NSLog(@"lwq, wm rewarded play finish");
    }
    
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"lwq, wm rewarded verify failed");
    
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    NSLog(@"lwq, wm rewarded verify succeed");
    NSLog(@"lwq, wm verify result: %@", verify ? @"success" : @"fail");
    if(verify){
        self.isRewarded = true;
    }
}

@end
