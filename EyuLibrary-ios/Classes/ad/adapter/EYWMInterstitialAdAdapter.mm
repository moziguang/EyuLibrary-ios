//
//  EYWMInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#include "EYWMInterstitialAdAdapter.h"
#import <BUAdSDK/BUFullscreenVideoAd.h>


@interface EYWMInterstitialAdAdapter()<BUFullscreenVideoAdDelegate>

@property(nonatomic,strong)BUFullscreenVideoAd *interstitialAd;

@end


@implementation EYWMInterstitialAdAdapter

@synthesize interstitialAd = _interstitialAd;

-(void) loadAd
{
    NSLog(@" lwq, wm interstitialAd loadAd ");
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if(self.interstitialAd == NULL)
    {
        self.interstitialAd = [[BUFullscreenVideoAd alloc] initWithSlotID:self.adKey.key];
        self.interstitialAd.delegate = self;
        self.isLoading = true;
        [self.interstitialAd loadAdData];
        [self startTimeoutTask];
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" lwq, wm interstitialAd showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        return [self.interstitialAd showAdFromRootViewController:controller];
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, wm interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && [self.interstitialAd isAdValid];
}

#pragma mark BURewardedVideoAdDelegate

- (void)fullscreenVideoMaterialMetaAdDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    NSLog(@"lwq, wm interstitialAd fullscreenVideoMaterialMetaAdDidLoad");
}

- (void)fullscreenVideoAd:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error {
    NSLog(@"lwq, wm interstitialAd didFailWithError");
    self.isLoading = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)fullscreenVideoAdVideoDataDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    NSLog(@"lwq, wm interstitialAd fullscreenVideoAdDidVisible");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

/**
 广告位已经展示
 */
- (void)fullscreenVideoAdDidVisible:(BUFullscreenVideoAd *)fullscreenVideoAd
{
    NSLog(@"lwq, wm interstitialAd fullscreenVideoAdDidVisible");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

/**
 视频广告关闭
 */
- (void)fullscreenVideoAdDidClose:(BUFullscreenVideoAd *)fullscreenVideoAd
{
    NSLog(@"lwq, wm interstitialAd fullscreenVideoAdDidClose");
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed];
}

/**
 视频广告点击
 */
- (void)fullscreenVideoAdDidClick:(BUFullscreenVideoAd *)fullscreenVideoAd
{
    NSLog(@"lwq, wm interstitialAd fullscreenVideoAdDidClick");
    [self notifyOnAdClicked];
}

- (void)dealloc
{
    if(self.interstitialAd!= NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
}

@end
