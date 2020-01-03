//
//  UnityRewardAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef UNITY_ADS_ENABLED

#ifndef UnityRewardAdAdapter_h
#define UnityRewardAdAdapter_h

#import "EYRewardAdAdapter.h"


@interface EYUnityRewardAdAdapter : EYRewardAdAdapter  {

}

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

@end

#endif /* UnityRewardAdAdapter_h */
#endif /*UNITY_ADS_ENABLED*/
