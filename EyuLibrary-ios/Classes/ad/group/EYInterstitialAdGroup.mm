//
//  InterstitialAdGroup.m
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import <Foundation/Foundation.h>
#import "EYInterstitialAdGroup.h"
#import "EYInterstitialAdAdapter.h"
#import "EYAdKey.h"
#import "EYEventUtils.h"
#import "EYAdManager.h"

@interface EYInterstitialAdGroup()<IInterstitialAdDelegate>

@property(nonatomic,strong)NSDictionary<NSString*, Class> *adapterClassDict;
@property(nonatomic,strong)NSMutableArray<EYInterstitialAdAdapter*> *adapterArray;
@property(nonatomic,copy)NSString *adPlaceId;
@property(nonatomic,assign)int  maxTryLoadAd;
@property(nonatomic,assign)int tryLoadAdCounter;
@property(nonatomic,assign)int curLoadingIndex;
@property(nonatomic,assign)bool reportEvent;

@end



@implementation EYInterstitialAdGroup

@synthesize adGroup = _adGroup;
@synthesize adapterArray = _adapterArray;
@synthesize adapterClassDict = _adapterClassDict;
@synthesize maxTryLoadAd = _maxTryLoadAd;
@synthesize curLoadingIndex = _curLoadingIndex;
@synthesize tryLoadAdCounter = _tryLoadAdCounter;
@synthesize adPlaceId = _adPlaceId;
@synthesize delegate = _delegate;
@synthesize reportEvent = _reportEvent;

-(EYInterstitialAdGroup*) initWithGroup:(EYAdGroup*)adGroup adConfig:(EYAdConfig*) adConfig
{
    self = [super init];
    if(self)
    {

        self.adapterClassDict = [[NSDictionary alloc] initWithObjectsAndKeys:
#ifdef FB_ADS_ENABLED
        NSClassFromString(@"EYFbInterstitialAdAdapter"), ADNetworkFacebook,
#endif
#ifdef ADMOB_ADS_ENABLED
        NSClassFromString(@"EYAdmobInterstitialAdAdapter"), ADNetworkAdmob,
#endif
#ifdef UNITY_ADS_ENABLED
        NSClassFromString(@"EYUnityInterstitialAdAdapter"), ADNetworkUnity,
#endif
#ifdef VUNGLE_ADS_ENABLED
        NSClassFromString(@"EYVungleInterstitialAdAdapter"), ADNetworkVungle,
#endif
#ifdef APPLOVIN_ADS_ENABLED
        NSClassFromString(@"EYApplovinInterstitialAdAdapter"), ADNetworkApplovin,
#endif
#ifdef BYTE_DANCE_ADS_ENABLED
        NSClassFromString(@"EYWMInterstitialAdAdapter"), ADNetworkWM,
#endif
#ifdef MTG_ADS_ENABLED
        NSClassFromString(@"EYMtgInterstitialAdAdapter"), ADNetworkMtg,
#endif
#ifdef IRON_ADS_ENABLED
        NSClassFromString(@"EYIronSourceInterstitialAdAdapter"), ADNetworkIronSource,
#endif
#ifdef GDT_ADS_ENABLED
        NSClassFromString(@"EYGdtInterstitialAdAdapter"), ADNetworkGdt,
#endif

        nil];

        self.adGroup = adGroup;
        self.adapterArray = [[NSMutableArray alloc] init];
//        self.maxTryLoadAd = adConfig.maxTryLoadInterstitialAd > 0 ? adConfig.maxTryLoadInterstitialAd : 7;
        self.curLoadingIndex = -1;
        self.tryLoadAdCounter = 0;
        self.reportEvent = adConfig.reportEvent;

        NSArray<EYAdKey*>* keyList = adGroup.keyArray;

        for(EYAdKey* adKey:keyList)
        {
            if(adKey){
                EYInterstitialAdAdapter *adapter = [self createAdAdapterWithKey:adKey adGroup:adGroup];
                if(adapter){
                    [self.adapterArray addObject:adapter];
                }
            }
        }
        
        self.maxTryLoadAd = ((int)self.adapterArray.count) * 2;
        
    }
    return self;
}

-(void) cacheAllAd
{
    for(EYInterstitialAdAdapter* adapter in self.adapterArray)
    {
        if(![adapter isAdLoaded])
        {
            [adapter loadAd];
        }
    }
}

-(bool) isCacheAvailable
{
    for(EYInterstitialAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            return true;
        }
    }
    return false;
}

-(bool) showAd:(NSString*)adPlaceId controller:(UIViewController*)controller
{
    NSLog(@"showAd adPlaceId = %@, self = %@", adPlaceId, self);
    self.adPlaceId = adPlaceId;
    EYInterstitialAdAdapter* loadedAdapter = NULL;
    for(EYInterstitialAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            loadedAdapter = adapter;
            break;
        }
    }
    if(loadedAdapter != nil)
    {
        [loadedAdapter showAdWithController:controller];
        return true;
    }else{
        return false;
    }
}

-(void) loadAd:(NSString*)adPlaceId
{
    NSLog(@"loadAd adPlaceId = %@, self = %@", adPlaceId, self);
    self.adPlaceId = adPlaceId;
    if(self.adapterArray.count == 0) return;
    self.curLoadingIndex = 0;
    self.tryLoadAdCounter = 1;
    
    EYInterstitialAdAdapter* adapter = self.adapterArray[0];
    [adapter loadAd];
    
    if(self.adapterArray.count > 1)
    {
        EYInterstitialAdAdapter* adapter = self.adapterArray[1];
        [adapter loadAd];
        self.curLoadingIndex = 1;
        self.tryLoadAdCounter = 2;
    }
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:adapter.adKey.keyId forKey:@"type"];
//    if(self.reportEvent){
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
//    }
}

-(EYInterstitialAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group
{
    EYInterstitialAdAdapter* adapter = NULL;
    NSString* network = adKey.network;
    Class adapterClass = self.adapterClassDict[network];
    if(adapterClass!= NULL){
        adapter = [[adapterClass alloc] initWithAdKey:adKey adGroup:group];
    }
    if(adapter != NULL)
    {
        adapter.delegate = self;
    }
    return adapter;
}

-(void) onAdLoaded:(EYInterstitialAdAdapter *)adapter
{
    NSLog(@"onAdLoaded adPlaceId = %@, self = %@", self.adPlaceId, self);
    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
    {
        self.curLoadingIndex = -1;
    }
    if(self.delegate)
    {
        [self.delegate onAdLoaded:self.adPlaceId type:ADTypeInterstitial];
    }
    
//    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:adapter.adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_SUCCESS]  parameters:dic];
//    }
}

-(void) onAdLoadFailed:(EYInterstitialAdAdapter*)adapter withError:(int)errorCode
{
    EYAdKey* adKey = adapter.adKey;
    NSLog(@"onAdLoadFailed adKey = %@, errorCode = %d", adKey.keyId, errorCode);
    
//    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:[[NSString alloc] initWithFormat:@"%d",errorCode] forKey:@"code"];
//        [dic setObject:adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_FAILED]  parameters:dic];
//    }
    
    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
    {
        if(self.tryLoadAdCounter >= self.maxTryLoadAd){
            self.curLoadingIndex = -1;
        }else{
            self.tryLoadAdCounter++;
            self.curLoadingIndex = (self.curLoadingIndex+1)%self.adapterArray.count;
            EYInterstitialAdAdapter* adapter = self.adapterArray[self.curLoadingIndex];
            [adapter loadAd];
//            if(self.reportEvent){
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                [dic setObject:adapter.adKey.keyId forKey:@"type"];
//                [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
//            }
        }
    }
    
    if(self.delegate)
    {
        [self.delegate onAdLoadFailed:self.adPlaceId key:adKey.keyId code:errorCode];
    }
}

-(void) onAdShowed:(EYInterstitialAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdShowed:self.adPlaceId type:ADTypeInterstitial];
    }
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_SHOW]  parameters:dic];
    }
}

-(void) onAdClicked:(EYInterstitialAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdClicked:self.adPlaceId type:ADTypeInterstitial];
    }
//    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:adapter.adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_CLICKED]  parameters:dic];
//    }
}
-(void) onAdClosed:(EYInterstitialAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdClosed:self.adPlaceId type:ADTypeInterstitial];
    }
    
    if (self.adGroup.isAutoLoad) {
        [self loadAd:@"auto"];
    }
}

-(void) onAdImpression:(EYInterstitialAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdImpression:self.adPlaceId type:ADTypeInterstitial];
    }
    EYAdKey *adKey = adapter.adKey;
    if(adKey){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adKey.network forKey:@"network"];
        [dic setObject:adKey.key forKey:@"unit"];
        [dic setObject:ADTypeInterstitial forKey:@"type"];
        [dic setObject:adKey.keyId forKey:@"keyId"];
        [EYEventUtils logEvent:EVENT_AD_IMPRESSION  parameters:dic];
    }
}

@end
