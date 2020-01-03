//
//  EYVungleInterstitialAdAdapter.hpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef VUNGLE_ADS_ENABLED

#ifndef EYVungleInterstitialAdAdapter_h
#define EYVungleInterstitialAdAdapter_h

#import "EYInterstitialAdAdapter.h"

@interface EYVungleInterstitialAdAdapter : EYInterstitialAdAdapter  {
    
}

-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group ;

@end

#endif /* EYVungleInterstitialAdAdapter_h */
#endif /*VUNGLE_ADS_ENABLED*/
