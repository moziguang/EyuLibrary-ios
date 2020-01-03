//
//  FbRewardAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef ADMOB_ADS_ENABLED

#ifndef AdmobRewardAdAdapter_h
#define AdmobRewardAdAdapter_h

#import "EYRewardAdAdapter.h"
#import "GoogleMobileAds/GoogleMobileAds.h"

@interface EYAdmobRewardAdAdapter : EYRewardAdAdapter <GADRewardBasedVideoAdDelegate> {

}
@property(nonatomic,assign)bool isRewarded;
@property(nonatomic,assign)bool isLoaded;

@end

#endif /* FbRewardAdAdapter_h */

#endif /*ADMOB_ADS_ENABLED*/
