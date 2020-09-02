//
//  EYMaxInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef APPLOVIN_MAX_ENABLED

#include "EYMaxInterstitialAdAdapter.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface EYMaxInterstitialAdAdapter() <MAAdDelegate>
@property (nonatomic, strong) MAInterstitialAd *ad;
@end

@implementation EYMaxInterstitialAdAdapter

@synthesize ad = _ad;

-(void) loadAd
{
    NSLog(@"lwq, MAX loadAd ad = %@", self.ad);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else if(!self.isLoading){
        self.isLoading = true;
        if(_ad == nil){
            self.ad = [[MAInterstitialAd alloc] initWithAdUnitIdentifier:self.adKey.key];
            self.ad.delegate = self;
        }
        [self.ad loadAd];
        [self startTimeoutTask];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"lwq, MAX showAd [self isAdLoaded] = %d", [self isAdLoaded]);
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        [self.ad showAd];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    return self.ad != NULL && [self.ad isReady];
}

#pragma mark - MAAdDelegate

/**
 * This method is called when a new ad has been loaded.
 */
- (void)didLoadAd:(MAAd *)ad
{
    NSLog(@"lwq, MAX didLoadAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

/**
 * This method is called when an ad could not be retrieved.
 *
 * Common error codes:
 * 204 - no ad is available
 * 5xx - internal server error
 * negative number - internal errors
 *
 * @param adUnitIdentifier  Ad unit identifier for which the ad was requested.
 * @param errorCode         An error code representing the failure reason. Common error codes are defined in `MAErrorCode.h`.
 */
- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withErrorCode:(NSInteger)errorCode
{
    NSLog(@"lwq, MAX interstitial didFailToLoadAdWithError: %ld, adKey = %@", errorCode, self.adKey);
       self.isLoading = false;
       [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)errorCode];
}

/**
 * This method is invoked when an ad is displayed.
 *
 * This method is invoked on the main UI thread.
 */
- (void)didDisplayAd:(MAAd *)ad
{
    NSLog(@"lwq, MAX interstitial ad wasDisplayedIn");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

/**
 * This method is invoked when an ad is hidden.
 *
 * This method is invoked on the main UI thread.
 */
- (void)didHideAd:(MAAd *)ad
{
    NSLog(@"lwq, MAX interstitial ad wasHiddenIn");
    self.isShowing = NO;
    [self notifyOnAdClosed];
}

/**
 * This method is invoked when the ad is clicked.
 *
 * This method is invoked on the main UI thread.
 */
- (void)didClickAd:(MAAd *)ad
{
    NSLog(@"lwq, MAX interstitial ad wasClickedIn");
    [self notifyOnAdClicked];
}

/**
 * This method is invoked when the ad failed to displayed.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad        Ad that was just failed to display.
 * @param errorCode Error that indicates display failure. Common error codes are defined in `MAErrorCode.h`.
 */
- (void)didFailToDisplayAd:(MAAd *)ad withErrorCode:(NSInteger)errorCode
{
    NSLog(@"lwq, MAX didFailToDisplayAd adKey = %@， code = %ld", self.adKey, errorCode);
    self.isShowing = false;
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)errorCode];
}

#pragma mark dealloc
- (void)dealloc
{
    if(self.ad!= NULL)
    {
        self.ad = NULL;
    }
}

@end
#endif /*APPLOVIN_MAX_ENABLED*/
