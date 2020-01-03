//
//  FbRewardAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef FB_ADS_ENABLED

#ifndef FbInterstitialAdAdapter_h
#define FbInterstitialAdAdapter_h


#import "EYInterstitialAdAdapter.h"
#import "FBAudienceNetwork/FBAudienceNetwork.h"

@interface EYFbInterstitialAdAdapter : EYInterstitialAdAdapter <FBInterstitialAdDelegate> {

}

@property(nonatomic,strong)FBInterstitialAd *interstitialAd;

@end


#endif /* FbInterstitialAdAdapter_h */

#endif /**FB_ADS_ENABLED*/
