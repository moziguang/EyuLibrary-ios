//
//  FbRewardAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef UNITY_ADS_ENABLED

#ifndef UnityInterstitialAdAdapter_h
#define UnityInterstitialAdAdapter_h

#import "EYInterstitialAdAdapter.h"

@interface EYUnityInterstitialAdAdapter : EYInterstitialAdAdapter {

}

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group ;
@end

#endif /* UnityInterstitialAdAdapter_h */
#endif /*UNITY_ADS_ENABLED*/
