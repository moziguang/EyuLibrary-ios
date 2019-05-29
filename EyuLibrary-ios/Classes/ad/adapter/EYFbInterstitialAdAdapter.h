//
//  FbRewardAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#ifndef FbInterstitialAdAdapter_h
#define FbInterstitialAdAdapter_h

#ifndef BYTE_DANCE_ONLY

#import "EYInterstitialAdAdapter.h"
#import "FBAudienceNetwork/FBAudienceNetwork.h"

@interface EYFbInterstitialAdAdapter : EYInterstitialAdAdapter <FBInterstitialAdDelegate> {

}

@property(nonatomic,strong)FBInterstitialAd *interstitialAd;

@end

#endif /*BYTE_DANCE_ONLY*/

#endif /* FbInterstitialAdAdapter_h */
