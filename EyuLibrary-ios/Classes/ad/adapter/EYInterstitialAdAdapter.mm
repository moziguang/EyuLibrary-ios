//
//  FbInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#include "EYInterstitialAdAdapter.h"


@implementation EYInterstitialAdAdapter

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
    }
    return self;
}

-(void) loadAd
{
    NSAssert(true, @"子类中实现");
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSAssert(true, @"子类中实现");
    return false;
}

-(bool) isAdLoaded
{
    NSAssert(true, @"子类中实现");
    return false;
}

-(void) notifyOnAdLoaded
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdLoaded:self];
    }
}

-(void) notifyOnAdLoadFailedWithError:(int)errorCode;
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

-(void) notifyOnAdClosed
{
    if(self.delegate!=NULL)
    {
        [self.delegate onAdClosed:self];
    }
}

-(void) startTimeoutTask
{
    [self cancelTimeoutTask];
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
    self.adGroup = NULL;
}

@end
