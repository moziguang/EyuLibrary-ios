//
//  EYGdtInterstitialAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#ifdef GDT_AD_ENABLED
#include "EYGdtInterstitialAdAdapter.h"
#import "GDTMobInterstitial.h"
#import "EYAdManager.h"

@interface EYGdtInterstitialAdAdapter()<GDTMobInterstitialDelegate>

@property(nonatomic,strong)GDTMobInterstitial *interstitialAd;

@end


@implementation EYGdtInterstitialAdAdapter

@synthesize interstitialAd = _interstitialAd;

-(void) loadAd
{
    NSLog(@" lwq, gdt interstitialAd loadAd ");
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if(self.interstitialAd == NULL)
    {
        EYAdManager* manager = [EYAdManager sharedInstance];
        NSString* appId = manager.adConfig.gdtAppId;
        self.interstitialAd = [[GDTMobInterstitial alloc] initWithAppId:appId placementId:self.adKey.key];
        self.interstitialAd.delegate = self;
        self.isLoading = true;
        [self.interstitialAd loadAd];
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
    NSLog(@" lwq, gdt interstitialAd showAd ");
    if([self isAdLoaded])
    {
        [self.interstitialAd presentFromRootViewController:controller];
        self.isShowing = YES;
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, gdt interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && [self.interstitialAd isReady];
}

#pragma mark - GDTMobInterstitialDelegate
// 广告预加载成功回调
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    NSLog(@"lwq, gdt interstitialAd interstitialSuccessToLoadAd");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

// 广告预加载失败回调
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    NSLog(@"lwq, gdt interstitialFailToLoadAd, error = %@", error);
    self.isLoading = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

// 插屏广告视图展示成功回调
// 详解: 插屏广告展示成功回调该函数
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"lwq, gdt interstitialDidPresentScreen");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

// 插屏广告展示结束回调
// 详解: 插屏广告展示结束回调该函数
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"lwq, gdt interstitialDidDismissScreen");
//    self.isShowing = NO;
//    if(self.interstitialAd != NULL)
//    {
//        self.interstitialAd.delegate = NULL;
//        self.interstitialAd = NULL;
//    }
//    [self notifyOnAdClosed];
}

/**
 *  插屏广告点击回调
 */
- (void)interstitialClicked:(GDTMobInterstitial *)interstitial
{
    NSLog(@"lwq, gdt interstitialClicked");
    [self notifyOnAdClicked];
}

/**
 *  点击插屏广告以后弹出全屏广告页
 */
- (void)interstitialAdDidPresentFullScreenModal:(GDTMobInterstitial *)interstitial
{
    NSLog(@"lwq, gdt interstitialDidPresentScreen");
    [self notifyOnAdShowed];
}

/**
 *  全屏广告页被关闭
 */
- (void)interstitialAdDidDismissFullScreenModal:(GDTMobInterstitial *)interstitial
{
    NSLog(@"lwq, gdt interstitialAdDidDismissFullScreenModal");
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed];
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
#endif /*GDT_AD_ENABLED*/
#endif /*BYTE_DANCE_ONLY*/
