//
//  AdConfig.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import <Foundation/Foundation.h>
#include "EYAdConfig.h"


@implementation EYAdConfig

@synthesize maxTryLoadInterstitialAd = _maxTryLoadInterstitialAd;
@synthesize maxTryLoadRewardAd = _maxTryLoadRewardAd;
@synthesize maxTryLoadNativeAd = _maxTryLoadNativeAd;
@synthesize adPlaceData = _adPlaceData;
@synthesize adKeyData = _adKeyData;
@synthesize adGroupData = _adGroupData;
@synthesize admobClientId = _admobClientId;
@synthesize unityClientId = _unityClientId;
@synthesize vungleClientId = _vungleClientId;
@synthesize reportEvent = _reportEvent;
@synthesize wmAppKey = _wmAppKey;
@synthesize isPaidApp = _isPaidApp;
@synthesize mtgAppId = _mtgAppId;
@synthesize mtgAppKey = _mtgAppKey;
//@synthesize enableIronSource = _enableIronSource;
@synthesize isWmOnly = _isWmOnly;
#ifdef GDT_AD_ENABLED
@synthesize gdtAppId = _gdtAppId;
#endif

-(instancetype) initWithPlace:(NSData*)adPlaceData  key: (NSData*) adKeyData group:(NSData*) adGroupData;
{
    self = [self init];
    if(self)
    {
        self.adPlaceData = adPlaceData;
        self.adKeyData = adKeyData;
        self.adGroupData = adGroupData;
        self.maxTryLoadNativeAd = 7;
        self.maxTryLoadRewardAd = 7;
        self.maxTryLoadInterstitialAd = 7;
        self.reportEvent = false;
        self.wmAppKey = nil;
        self.admobClientId = nil;
        self.unityClientId = nil;
        self.vungleClientId = nil;
        self.isPaidApp = false;
        self.ironSourceAppKey = nil;
#ifdef GDT_AD_ENABLED
        self.gdtAppId = nil;
#endif
        self.mtgAppId = nil;
        self.mtgAppKey = nil;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"lwq,EYAdConfig dealloc count");
}


@end
