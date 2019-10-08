//
//  EYMtgInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#include "EYMtgInterstitialAdAdapter.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKInterstitialVideo/MTGInterstitialVideoAdManager.h>



@interface EYMtgInterstitialAdAdapter()<MTGInterstitialVideoDelegate>

@property(nonatomic,strong)MTGInterstitialVideoAdManager *interstitialAd;
@property(nonatomic,assign)bool isLoaded;


@end


@implementation EYMtgInterstitialAdAdapter

@synthesize interstitialAd = _interstitialAd;
@synthesize isLoaded = _isLoaded;

-(void) loadAd
{
    NSLog(@" lwq, mtg interstitialAd loadAd ");
    if(self.interstitialAd == NULL)
    {
        self.interstitialAd = [[MTGInterstitialVideoAdManager alloc] initWithUnitID:self.adKey.key delegate:self];

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
    NSLog(@" lwq, mtg interstitialAd showAd ");
    if([self isAdLoaded])
    {
        self.isLoaded = false;
        [self.interstitialAd showFromViewController:controller];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, mtg interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && self.isLoaded;
}

#pragma mark - Interstitial Delegate Methods

- (void) onInterstitialAdLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@" lwq, mtg onInterstitialAdLoadSuccess");
}

- (void) onInterstitialVideoLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@"lwq, mtg interstitialAd fullscreenVideoAdDidVisible");
    self.isLoading = false;
    self.isLoaded = true;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void) onInterstitialVideoLoadFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@"lwq, mtg onInterstitialVideoLoadFail error = %@", error);
    self.isLoading = false;
    self.isLoaded = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void) onInterstitialVideoShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@"lwq, mtg onInterstitialVideoShowSuccess");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void) onInterstitialVideoShowFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@"lwq, mtg onInterstitialVideoShowFail error = %@", error);

}

- (void) onInterstitialVideoAdClick:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@"lwq, wm interstitialAd fullscreenVideoAdDidClick");
    [self notifyOnAdClicked];
}

- (void)onInterstitialVideoAdDismissedWithConverted:(BOOL)converted adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@"lwq, mtg ionInterstitialVideoAdDismissedWithConverted converted = %d", converted);
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
#endif /*BYTE_DANCE_ONLY*/
