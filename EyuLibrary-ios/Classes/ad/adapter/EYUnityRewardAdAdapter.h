//
//  UnityRewardAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#ifndef UnityRewardAdAdapter_h
#define UnityRewardAdAdapter_h

#import "EYRewardAdAdapter.h"


@interface EYUnityRewardAdAdapter : EYRewardAdAdapter  {

}

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

@end

#endif /* UnityRewardAdAdapter_h */
#endif /*BYTE_DANCE_ONLY*/
