//
//  AdConfig.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import <Foundation/Foundation.h>
#include "EYAdConfig.h"


@implementation EYAdConfig


@synthesize adPlaceData = _adPlaceData;
@synthesize adKeyData = _adKeyData;
@synthesize adGroupData = _adGroupData;
#ifdef ADMOB_ADS_ENABLED
@synthesize admobClientId = _admobClientId;
#endif

#ifdef UNITY_ADS_ENABLED
@synthesize unityClientId = _unityClientId;
#endif

#ifdef VUNGLE_ADS_ENABLED
@synthesize vungleClientId = _vungleClientId;
#endif

@synthesize reportEvent = _reportEvent;

#ifdef BYTE_DANCE_ADS_ENABLED
@synthesize wmAppKey = _wmAppKey;
#endif
@synthesize isPaidApp = _isPaidApp;

#ifdef MTG_ADS_ENABLED
@synthesize mtgAppId = _mtgAppId;
@synthesize mtgAppKey = _mtgAppKey;
#endif

#ifdef GDT_ADS_ENABLED
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
        self.reportEvent = false;
#ifdef BYTE_DANCE_ADS_ENABLED
        self.wmAppKey = nil;
#endif
#ifdef ADMOB_ADS_ENABLED
        self.admobClientId = nil;
#endif
#ifdef UNITY_ADS_ENABLED
        self.unityClientId = nil;
#endif
#ifdef VUNGLE_ADS_ENABLED
        self.vungleClientId = nil;
#endif
        self.isPaidApp = false;
#ifdef IRON_ADS_ENABLED
        self.ironSourceAppKey = nil;
#endif
#ifdef GDT_ADS_ENABLED
        self.gdtAppId = nil;
#endif
#ifdef MTG_ADS_ESNABLED
        self.mtgAppId = nil;
        self.mtgAppKey = nil;
#endif
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"lwq,EYAdConfig dealloc count");
}


@end
