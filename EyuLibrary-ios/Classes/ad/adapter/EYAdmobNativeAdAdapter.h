//
//  FbNativeAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#ifndef AdmobNativeAdAdapter_h
#define AdmobNativeAdAdapter_h
#ifndef BYTE_DANCE_ONLY


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
#endif /*BYTE_DANCE_ONLY*/

#endif /* AdmobNativeAdAdapter_h */
