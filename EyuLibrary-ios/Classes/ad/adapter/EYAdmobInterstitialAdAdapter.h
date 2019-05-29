//
//  AdmobInterstitialAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#ifndef AdmobInterstitialAdAdapter_h
#define AdmobInterstitialAdAdapter_h

#ifndef BYTE_DANCE_ONLY

#import "EYInterstitialAdAdapter.h"
#import "GoogleMobileAds/GoogleMobileAds.h"

@interface EYAdmobInterstitialAdAdapter : EYInterstitialAdAdapter <GADInterstitialDelegate> {
    
}
@property(nonatomic,strong)GADInterstitial *interstitialAd;
@end

#endif /*BYTE_DANCE_ONLY*/
#endif /* AdmobInterstitialAdAdapter_h */
