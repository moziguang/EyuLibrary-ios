//
//  FbInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#ifndef BYTE_DANCE_ONLY

#include "EYFbInterstitialAdAdapter.h"


@implementation EYFbInterstitialAdAdapter

@synthesize interstitialAd = _interstitialAd;

-(void) loadAd
{
    NSLog(@" lwq, fb interstitialAd loadAd ");
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if(self.interstitialAd == NULL)
    {
        self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:self.adKey.key];
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
    NSLog(@" lwq, fb interstitialAd showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        return [self.interstitialAd showAdFromRootViewController:controller];
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, fb interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && [self.interstitialAd isAdValid];
}

- (void)interstitialAdWillLogImpression:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"lwq,The user sees the add");
    // Use this function as indication for a user's impression on the ad.
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"lwq,The user clicked on the ad and will be taken to its destination");
    // Use this function as indication for a user's click on the ad.
    [self notifyOnAdClicked];
}

- (void)interstitialAdWillClose:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"lwq,The user clicked on the close button, the ad is just about to close");
    // Consider to add code here to resume your app's flow
    
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"lwq,Interstitial had been closed, %@", [NSThread currentThread]);
    // Consider to add code here to resume your app's flow
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed];
}

/**
 Sent when an FBInterstitialAd successfully loads an ad.
 
 - Parameter interstitialAd: An FBInterstitialAd object sending the message.
 */
- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
    NSLog(@"lwq,Interstitial did loaded");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"lwq,fb interstitial Ad failed to load");
    self.isLoading = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
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
