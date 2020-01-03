//
//  EYIronSourceRewardAdAdapter.h
//  Bolts
//
//  Created by caochao on 2019/3/19.
//
#ifdef IRON_ADS_ENABLED

#ifndef EYIronSourceRewardAdAdapter_h
#define EYIronSourceRewardAdAdapter_h

#import "EYRewardAdAdapter.h"


@interface EYIronSourceRewardAdAdapter : EYRewardAdAdapter
-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;
@end

#endif
#endif /*IRON_ADS_ENABLED*/
