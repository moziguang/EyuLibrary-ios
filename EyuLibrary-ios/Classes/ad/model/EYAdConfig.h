//
//  AdConfig.h
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#ifndef AdConfig_h
#define AdConfig_h

@interface EYAdConfig : NSObject{

}

@property(nonatomic,strong)NSData *adPlaceData;
@property(nonatomic,strong)NSData *adKeyData;
@property(nonatomic,strong)NSData *adGroupData;
@property(nonatomic,copy)NSString *admobClientId;
@property(nonatomic,copy)NSString *unityClientId;
@property(nonatomic,copy)NSString *vungleClientId;
@property(nonatomic,assign)int maxTryLoadInterstitialAd;
@property(nonatomic,assign)int maxTryLoadRewardAd;
@property(nonatomic,assign)int maxTryLoadNativeAd;
@property(nonatomic,assign)int reportEvent;
@property(nonatomic,copy)NSString *wmAppKey;
@property(nonatomic,assign)bool isWmOnly;
@property(nonatomic,assign)bool isPaidApp;
@property(nonatomic,copy)NSString *gdtAppId;
@property(nonatomic,copy)NSString *mtgAppId;
@property(nonatomic,copy)NSString *mtgAppKey;
@property(nonatomic,copy)NSString *ironSourceAppKey;
@property(nonatomic,assign) bool enableIronSource;






-(instancetype) initWithPlace:(NSData*)adPlaceData  key:(NSData*) adKeyData group:(NSData*) adGroupData;

@end

#endif /* AdConfig_h */
