//
//  EYGdtInterstitialAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#ifdef GDT_ADS_ENABLED
#include "EYGdtInterstitialAdAdapter.h"
//#import "GDTMobInterstitial.h"
#import "GDTUnifiedInterstitialAd.h"
#import "EYAdManager.h"

@interface EYGdtInterstitialAdAdapter()<GDTUnifiedInterstitialAdDelegate>

@property(nonatomic,strong)GDTUnifiedInterstitialAd *interstitialAd;

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
        self.interstitialAd = [[GDTUnifiedInterstitialAd alloc] initWithAppId:appId placementId:self.adKey.key];
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
        [self.interstitialAd presentFullScreenAdFromRootViewController:controller];
        self.isShowing = YES;
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, gdt interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && [self.interstitialAd isAdValid];
}

#pragma mark - GDTUnifiedInterstitialAdDelegate
// 广告预加载成功回调
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@"lwq, gdt interstitialAd interstitialSuccessToLoadAd");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

// 广告预加载失败回调
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error;
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
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@"lwq, gdt interstitialDidPresentScreen");
    [self notifyOnAdShowed];
}

// 插屏广告展示结束回调
// 详解: 插屏广告展示结束回调该函数
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@"lwq, gdt unifiedInterstitialDidDismissScreen");
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed];
}

/**
 *  插屏广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@"lwq, gdt interstitialClicked");
    [self notifyOnAdClicked];
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@"lwq, gdt interstitialDidPresentScreen");
    [self notifyOnAdImpression];
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@"lwq, gdt interstitialAdDidDismissFullScreenModal");
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
#endif /*GDT_ADS_ENABLED*/
