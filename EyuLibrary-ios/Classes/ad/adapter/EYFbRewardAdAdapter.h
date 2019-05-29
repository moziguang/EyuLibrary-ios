//
//  FbRewardAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#ifndef FbRewardAdAdapter_h
#define FbRewardAdAdapter_h

#import "EYRewardAdAdapter.h"
#import "FBAudienceNetwork/FBAudienceNetwork.h"


@interface EYFbRewardAdAdapter : EYRewardAdAdapter < FBRewardedVideoAdDelegate> {

}
@property(nonatomic,assign)bool isRewarded;
@property(nonatomic,strong)FBRewardedVideoAd* rewardAd;
@end

#endif /* FbRewardAdAdapter_h */
#endif /*BYTE_DANCE_ONLY*/
