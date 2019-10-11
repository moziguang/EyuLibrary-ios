//
//  EYIronSourceInterstitialAdAdapter.m
//  Bolts
//
//  Created by caochao on 2019/3/19.
//
#ifndef BYTE_DANCE_ONLY

#import "EYIronSourceInterstitialAdAdapter.h"
#import "IronSource/IronSource.h"
#import "EYAdManager.h"

@interface EYIronSourceInterstitialAdAdapter()<ISInterstitialDelegate>

@end

@implementation EYIronSourceInterstitialAdAdapter

-(void) loadAd
{
    NSLog(@"EYIronSourceInterstitialAdAdapter loadAd");
    [EYAdManager sharedInstance].ISInterstitialAdapter = self;
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded]) {
        [self notifyOnAdLoaded];
    }
    else if(!self.isLoading) {
        self.isLoading = true;
        [IronSource loadInterstitial];
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"EYIronSourceInterstitialAdAdapter showAd");
    [EYAdManager sharedInstance].ISInterstitialAdapter = self;
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        [IronSource showInterstitialWithViewController:controller placement:self.adKey.key];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    //广告次数达到上限
    bool isCapped = [IronSource isInterstitialCappedForPlacement:self.adKey.key];
    if(isCapped) {
        NSLog(@"EYIronSourceInterstitialAdAdapter key = %@ isCapped", self.adKey.key);
        return false;
    }
    return [IronSource hasInterstitial];
}

#pragma mark - IronSource Interstitial Delegate Functions
/**
 Called after an interstitial has been loaded
 */
- (void)interstitialDidLoad
{
    NSLog(@"EYIronSourceInterstitialAdAdapter interstitialDidLoad");
    self.isLoading = false;
    [self notifyOnAdLoaded];
}

/**
 Called after an interstitial has attempted to load but failed.
 
 @param error The reason for the error
 */
- (void)interstitialDidFailToLoadWithError:(NSError *)error
{
    NSLog(@"EYIronSourceInterstitialAdAdapter interstitialDidFailToLoadWithError, error = %@", error);
    self.isLoading = false;
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

/**
 Called after an interstitial has been opened.
 */
- (void)interstitialDidOpen
{
    NSLog(@"EYIronSourceInterstitialAdAdapter interstitialDidOpen");
}

/**
 Called after an interstitial has been dismissed.
 */
- (void)interstitialDidClose
{
    NSLog(@"EYIronSourceInterstitialAdAdapter interstitialDidClose");
    self.isShowing = NO;
    [self notifyOnAdClosed];
}

/**
 Called after an interstitial has been displayed on the screen.
 */
- (void)interstitialDidShow
{
    NSLog(@"EYIronSourceInterstitialAdAdapter interstitialDidShow");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

/**
 Called after an interstitial has attempted to show but failed.
 
 @param error The reason for the error
 */
- (void)interstitialDidFailToShowWithError:(NSError *)error
{
    NSLog(@"EYIronSourceInterstitialAdAdapter interstitialDidFailToShowWithError, error = %@", error);
}

/**
 Called after an interstitial has been clicked.
 */
- (void)didClickInterstitial
{
    NSLog(@"EYIronSourceInterstitialAdAdapter didClickInterstitial");
    [self notifyOnAdClicked];
}

@end
#endif /*BYTE_DANCE_ONLY*/
