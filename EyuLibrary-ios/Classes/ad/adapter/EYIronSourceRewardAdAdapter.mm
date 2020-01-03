//
//  EYIronSourceRewardAdAdapter.m
//  Bolts
//
//  Created by caochao on 2019/3/19.
//
#ifdef IRON_ADS_ENABLED

#import "EYIronSourceRewardAdAdapter.h"
#import "IronSource/IronSource.h"
#import "EYAdManager.h"

@interface EYIronSourceRewardAdAdapter()<ISDemandOnlyRewardedVideoDelegate>

@property(nonatomic,assign) bool isRewarded;
@property(nonatomic,assign) bool isClosed;

@end

@implementation EYIronSourceRewardAdAdapter

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super initWithAdKey:adKey adGroup:group];
    if(self)
    {
        [[EYAdManager sharedInstance] addIronRewardDelegate:self withKey:adKey.key];
    }
    return self;
}

-(void) loadAd
{
    NSLog(@"lwq, EYIronSourceRewardAdAdapter loadAd #############. adId = #%@#", self.adKey.key);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if([self isAdLoaded]) {
        [self notifyOnAdLoaded];
    }
    else {
        [IronSource loadISDemandOnlyRewardedVideo:self.adKey.key];
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"lwq, EYIronSourceRewardAdAdapter showAd #############.");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        self.isRewarded = false;
        self.isClosed = false;
        [IronSource showISDemandOnlyRewardedVideo:controller instanceId:self.adKey.key];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    bool result = [IronSource hasISDemandOnlyRewardedVideo:self.adKey.key];
    NSLog(@"lwq, EYIronSourceRewardAdAdapter hasISDemandOnlyRewardedVideo result = %d",result);
    return result;
}

#pragma mark - IronSource Rewarded Video Delegate Functions
- (void)rewardedVideoDidLoad:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceRewardAdAdapter rewardedVideoDidLoad key = %@", self.adKey.key);

    self.isLoading = false;
    [self notifyOnAdLoaded];
}

- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceRewardAdAdapter rewardedVideoDidFailToLoadWithError %@", error);
    self.isLoading = false;
    [self notifyOnAdLoadFailedWithError:error.code];
}

- (void)rewardedVideoDidOpen:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceRewardAdAdapter rewardedVideoDidOpen");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)rewardedVideoDidClose:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceRewardAdAdapter rewardedVideoDidClose. self->isRewarded = %d", self.isRewarded);
    self.isClosed = true;
    self.isShowing = NO;
    if(self.isRewarded){
        [self notifyOnAdRewarded];
    }
    [self notifyOnAdClosed];
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceRewardAdAdapter rewardedVideoDidFailToShowWithError, error = %@", error);
    self.isShowing = NO;
}

- (void)rewardedVideoDidClick:(NSString *)instanceId
{
    NSLog(@"lwq, EYIronSourceRewardAdAdapter didClickRewardedVideo");
    [self notifyOnAdClicked];
}

- (void)rewardedVideoAdRewarded:(NSString *)instanceId
{
    self.isRewarded = true;
    if(self.isClosed) {
        [self notifyOnAdRewarded];
    }
}
    
@end
#endif /*IRON_ADS_ENABLED*/
