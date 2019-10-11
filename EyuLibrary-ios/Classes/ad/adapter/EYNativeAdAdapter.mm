//
//  FbInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#include "EYNativeAdAdapter.h"


@implementation EYNativeAdAdapter

@synthesize delegate = _delegate;
@synthesize adKey = _adKey;
@synthesize adGroup = _adGroup;
@synthesize isLoading = _isLoading;
@synthesize loadingTimer = _loadingTimer;


-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group
{
    self = [super init];
    if(self)
    {
        self.adKey = adKey;
        self.adGroup = group;
        self.isLoading = false;
    }
    return self;
}

-(void) loadAd
{
    NSAssert(true, @"子类中实现");
}

-(bool) showAdWithAdLayout:(UIView*)nativeAdLayout iconView:(UIImageView*)nativeAdIcon titleView:(UILabel*)nativeAdTitle
                  descView:(UILabel*)nativeAdDesc mediaLayout:(UIView*)mediaLayout actBtn:(UIButton*)actBtn controller:(UIViewController*)controller
{
    NSAssert(true, @"子类中实现");
    return false;
}

-(bool) isAdLoaded
{
    NSAssert(true, @"子类中实现");
    return false;
}

-(void) unregisterView
{
    NSAssert(true, @"子类中实现");
}

-(void) notifyOnAdLoaded
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdLoaded:self];
    }
}

-(void) notifyOnAdLoadFailedWithError:(int)errorCode
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdLoadFailed:self withError:errorCode];
    }
}

-(void) notifyOnAdShowed
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdShowed:self];
    }
}

-(void) notifyOnAdClicked
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdClicked:self];
    }
}

-(void) notifyOnAdImpression
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdImpression:self];
    }
}

-(void) startTimeoutTask
{
    [self cancelTimeoutTask];
//    self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_TIME repeats:false block:^(NSTimer * _Nonnull timer) {
//        [self cancelTimeoutTask];
//        [self notifyOnAdLoadFailedWithError:ERROR_TIMEOUT];
//    }];
    self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_TIME target:self selector:@selector(timeout) userInfo:nil repeats:false];

}

- (void) timeout{
    NSLog(@"lwq, timeout");
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:ERROR_TIMEOUT];
}

-(void) cancelTimeoutTask
{
    if (self.loadingTimer) {
        [self.loadingTimer invalidate];
        self.loadingTimer = nil;
    }
}

- (void)dealloc
{
    [self cancelTimeoutTask];
    self.delegate = NULL;
    self.adKey = NULL;
}

@end
