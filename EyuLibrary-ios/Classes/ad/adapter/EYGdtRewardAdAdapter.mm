//
//  EYGdtRewardAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef GDT_ADS_ENABLED

#include "EYGdtRewardAdAdapter.h"
#import "GDTRewardVideoAd.h"
#import "EYAdManager.h"


@interface EYGdtRewardAdAdapter()<GDTRewardedVideoAdDelegate>

@property(nonatomic,assign)bool isRewarded;
@property(nonatomic,strong)GDTRewardVideoAd* rewardAd;

@end

@implementation EYGdtRewardAdAdapter

@synthesize isRewarded = _isRewarded;
@synthesize rewardAd = _rewardAd;

-(void) loadAd
{
    NSLog(@" lwq, gdt EYGdtRewardAdAdapter loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if(![self isLoading] )
    {
        if(self.rewardAd!=NULL)
        {
            self.rewardAd.delegate = nil;
        }
        EYAdManager* manager = [EYAdManager sharedInstance];
        NSString* appId = manager.adConfig.gdtAppId;
        self.isLoading = true;
        self.rewardAd =  [[GDTRewardVideoAd alloc] initWithAppId:appId placementId:self.adKey.key];
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
    NSLog(@" lwq, gdt show reward Ad ");
    if([self isAdLoaded])
    {
        self.isShowing = true;
        return [self.rewardAd showAdFromRootViewController:controller];
    }
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = self.rewardAd != NULL && [self.rewardAd isAdValid] && self.rewardAd.expiredTimestamp > [[NSDate date] timeIntervalSince1970];
    NSLog(@" lwq, gdt Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"lwq, gdt gdt_rewardVideoAdDidLoad");
}

- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"lwq, gdt gdt_rewardVideoAdVideoDidLoad");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"lwq, gdt 广告已曝光");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"lwq, gdt 广告已关闭");
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    
    if(self.isRewarded){
        [self notifyOnAdRewarded];
    }
    self.isRewarded = false;
    self.isShowing = false;
    [self notifyOnAdClosed];
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"lwq, gdt 广告已点击");
    [self notifyOnAdClicked];
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    if (error.code == 4014) {
        NSLog(@"lwq, gdt 请拉取到广告后再调用展示接口");
    } else if (error.code == 4016) {
        NSLog(@"lwq, gdt 应用方向与广告位支持方向不一致");
    } else if (error.code == 5012) {
        NSLog(@"lwq, gdt 广告已过期");
    } else if (error.code == 4015) {
        NSLog(@"lwq, gdt 广告已经播放过，请重新拉取");
    } else if (error.code == 5002) {
        NSLog(@"lwq, gdt 视频下载失败");
    } else if (error.code == 5003) {
        NSLog(@"lwq, gdt 视频播放失败");
    } else if (error.code == 5004) {
        NSLog(@"lwq, gdt 没有合适的广告");
    }
    NSLog(@"lwq, gdt rewarded video load fail, error:%@",error);
    self.isLoading = false;
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"lwq, gdt 播放达到激励条件");
    self.isRewarded = true;
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"lwq, gdt 视频播放结束");
    self.isRewarded = true;
}

@end
#endif /*GDT_ADS_ENABLED*/
