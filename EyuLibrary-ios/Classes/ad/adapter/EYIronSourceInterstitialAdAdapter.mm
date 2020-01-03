//
//  EYIronSourceInterstitialAdAdapter.m
//  Bolts
//
//  Created by caochao on 2019/3/19.
//
#ifdef IRON_ADS_ENABLED

#import "EYIronSourceInterstitialAdAdapter.h"
#import "IronSource/IronSource.h"
#import "EYAdManager.h"

@interface EYIronSourceInterstitialAdAdapter()<ISDemandOnlyInterstitialDelegate>

@end

@implementation EYIronSourceInterstitialAdAdapter

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super initWithAdKey:adKey adGroup:group];
    if(self)
    {
        [[EYAdManager sharedInstance] addIronInterDelegate:self withKey:adKey.key];
    }
    return self;
}

-(void) loadAd
{
    NSLog(@"lwq, EYIronSourceInterstitialAdAdapter loadAd key = %@", self.adKey.key);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded]) {
        [self notifyOnAdLoaded];
    }
    else if(!self.isLoading) {
        self.isLoading = true;
//        [IronSource loadInterstitial];
        [IronSource loadISDemandOnlyInterstitial:self.adKey.key];
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"lwq, EYIronSourceInterstitialAdAdapter showAd");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        [IronSource showISDemandOnlyInterstitial:controller instanceId:self.adKey.key];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool result = [IronSource hasISDemandOnlyInterstitial:self.adKey.key];
    NSLog(@"lwq, EYIronSourceInterstitialAdAdapter hasISDemandOnlyInterstitial result = %d, key = %@",result, self.adKey.key);
    return result;
}

#pragma mark - IronSource Interstitial Delegate Functions

/**
 Called after an interstitial has been loaded
 */
- (void)interstitialDidLoad:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceInterstitialAdAdapter interstitialDidLoad, instance id = %@", instanceId);
    self.isLoading = false;
    [self notifyOnAdLoaded];
}

/**
 Called after an interstitial has attempted to load but failed.

 @param error The reason for the error
 */
- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceInterstitialAdAdapter interstitialDidFailToLoadWithError, error = %@", error);
    self.isLoading = false;
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

/**
 Called after an interstitial has been opened.
 */
- (void)interstitialDidOpen:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceInterstitialAdAdapter interstitialDidOpen");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

/**
  Called after an interstitial has been dismissed.
 */
- (void)interstitialDidClose:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceInterstitialAdAdapter interstitialDidClose");
    self.isShowing = NO;
    [self notifyOnAdClosed];
}

/**
 Called after an interstitial has attempted to show but failed.
 @param error The reason for the error
 */
- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceInterstitialAdAdapter interstitialDidFailToShowWithError, error = %@", error);
}

/**
 Called after an interstitial has been clicked.
 */
- (void)didClickInterstitial:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceInterstitialAdAdapter didClickInterstitial");
    [self notifyOnAdClicked];
}

@end
#endif /*IRON_ADS_ENABLED*/
