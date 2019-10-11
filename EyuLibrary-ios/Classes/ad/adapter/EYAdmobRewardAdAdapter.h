//
//  FbRewardAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#ifndef AdmobRewardAdAdapter_h
#define AdmobRewardAdAdapter_h
#ifndef BYTE_DANCE_ONLY

#import "EYRewardAdAdapter.h"
#import "GoogleMobileAds/GoogleMobileAds.h"

@interface EYAdmobRewardAdAdapter : EYRewardAdAdapter <GADRewardBasedVideoAdDelegate> {

}
@property(nonatomic,assign)bool isRewarded;
@property(nonatomic,assign)bool isLoaded;

@end
#endif /*BYTE_DANCE_ONLY*/

#endif /* FbRewardAdAdapter_h */
