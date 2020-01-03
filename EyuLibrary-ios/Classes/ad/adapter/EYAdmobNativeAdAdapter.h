//
//  FbNativeAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef ADMOB_ADS_ENABLED

#ifndef AdmobNativeAdAdapter_h
#define AdmobNativeAdAdapter_h


#import "EYNativeAdAdapter.h"
#import "GoogleMobileAds/GoogleMobileAds.h"

@interface EYAdmobNativeAdAdapter : EYNativeAdAdapter <GADUnifiedNativeAdLoaderDelegate, GADVideoControllerDelegate,
GADUnifiedNativeAdDelegate> {

}

@property(nonatomic,strong)GADAdLoader *nativeAdLoader;
@property(nonatomic,strong)GADUnifiedNativeAdView *nativeAdView;
@property(nonatomic,strong)GADUnifiedNativeAd *nativeAd;
@property(nonatomic,strong)GADMediaView* mediaView;
@property(nonatomic,strong)UIImageView * imageView;


@end

#endif /* AdmobNativeAdAdapter_h */

#endif /*ADMOB_ADS_ENABLED*/
