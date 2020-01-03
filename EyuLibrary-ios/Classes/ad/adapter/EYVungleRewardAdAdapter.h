//
//  EYVungleRewardAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef VUNGLE_ADS_ENABLED

#ifndef EYVungleRewardAdAdapter_h
#define EYVungleRewardAdAdapter_h

#import "EYRewardAdAdapter.h"

@interface EYVungleRewardAdAdapter : EYRewardAdAdapter{

}
-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group ;
@end

#endif /* EYVungleRewardAdAdapter_h */
#endif /*VUNGLE_ADS_ENABLED*/
