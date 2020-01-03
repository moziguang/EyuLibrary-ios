//
//  UnityRewardAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef UNITY_ADS_ENABLED

#include "EYUnityRewardAdAdapter.h"
//#import "UnityAds/UnityAds.h"
#import "EYAdManager.h"

@interface EYUnityRewardAdAdapter()<UnityAdsDelegate>

//@property(nonatomic,copy)NSString *adId;

@end

@implementation EYUnityRewardAdAdapter

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super initWithAdKey:adKey adGroup:group];
    if(self)
    {
        [[EYAdManager sharedInstance] addUnityAdsDelegate:self withKey:adKey.key];
    }
    return self;
}

-(void) loadAd
{
    NSLog(@" lwq, unity loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([UnityAds isReady:self.adKey.key])
    {
        [self notifyOnAdLoaded];
    }else{
        [self notifyOnAdLoadFailedWithError:ERROR_UNITY_AD_NOT_LOADED];
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" lwq, unity showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        [UnityAds show:controller placementId:self.adKey.key];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = [UnityAds isInitialized] && [UnityAds isReady:self.adKey.key];
    NSLog(@" lwq, unity Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

- (void)unityAdsReady:(NSString *)placementId{
    [self notifyOnAdLoaded];
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    [self notifyOnAdLoadFailedWithError:error];
}

- (void)unityAdsDidStart:(NSString *)placementId{
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{
    if(state == UnityAdsFinishState::kUnityAdsFinishStateCompleted){
        [self notifyOnAdRewarded];
    }
    self.isShowing = NO;
    [self notifyOnAdClosed];
}

- (void)dealloc
{
    [[EYAdManager sharedInstance] removeUnityAdsDelegate:self forKey:self.adKey.key];
}

@end
#endif /*UNITY_ADS_ENABLED*/
