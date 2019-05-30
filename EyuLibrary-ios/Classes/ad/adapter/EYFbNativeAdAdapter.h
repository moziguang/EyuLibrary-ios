//
//  FbNativeAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#ifndef FbNativeAdAdapter_h
#define FbNativeAdAdapter_h

#import "EYNativeAdAdapter.h"
#import "FBAudienceNetwork/FBAudienceNetwork.h"

@interface EYFbNativeAdAdapter : EYNativeAdAdapter <FBNativeAdDelegate, FBMediaViewDelegate> {

}

@property(nonatomic,strong)FBNativeAd *nativeAd;
@property(nonatomic,strong)FBAdChoicesView *adChoicesView;
@property(nonatomic,strong)FBMediaView *fbMediaView;
@property(nonatomic,strong)FBAdIconView *fbIconView;


@end

#endif /* FbNativeAdAdapter_h */
#endif /*BYTE_DANCE_ONLY*/
