//
//  EYIronSourceInterstitialAdAdapter.h
//  Bolts
//
//  Created by caochao on 2019/3/19.
//
#ifdef IRON_ADS_ENABLED

#ifndef EYIronSourceInterstitialAdAdapter_h
#define EYIronSourceInterstitialAdAdapter_h

#import "EYInterstitialAdAdapter.h"

@interface EYIronSourceInterstitialAdAdapter : EYInterstitialAdAdapter

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;
@end

#endif
#endif /*IRON_ADS_ENABLED*/
