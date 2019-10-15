//
//  RewardAdGroup.m
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import <Foundation/Foundation.h>
#import "EYRewardAdGroup.h"
#import "EYAdKey.h"
#import "EYEventUtils.h"
#import "SVProgressHUD.h"
#import <FFToast/FFToast.h>
#import "EyAdManager.h"

@interface EYRewardAdGroup()<IRewardAdDelegate>

@property(nonatomic,strong)NSMutableArray<EYRewardAdAdapter*> *adapterArray;
@property(nonatomic,strong)NSDictionary<NSString*, Class> *adapterClassDict;
@property(nonatomic,copy)NSString *adPlaceId;
@property(nonatomic,assign)int  maxTryLoadAd;
@property(nonatomic,assign)int tryLoadAdCounter;
@property(nonatomic,assign)int curLoadingIndex;
@property(nonatomic,assign)bool isLoadingDialogShowed;
@property(nonatomic,strong)NSTimer *loadingTimer;
@property(nonatomic,assign)bool reportEvent;

@end

@implementation EYRewardAdGroup

@synthesize adGroup = _adGroup;
@synthesize adapterArray = _adapterArray;
@synthesize adapterClassDict = _adapterClassDict;
@synthesize maxTryLoadAd = _maxTryLoadAd;
@synthesize curLoadingIndex = _curLoadingIndex;
@synthesize tryLoadAdCounter = _tryLoadAdCounter;
@synthesize isLoadingDialogShowed = _isLoadingDialogShowed;
@synthesize loadingTimer = _loadingTimer;
@synthesize delegate = _delegate;
@synthesize reportEvent = _reportEvent;


-(EYRewardAdGroup*) initWithGroup:(EYAdGroup*)group adConfig:(EYAdConfig*) adConfig
{
    self = [super init];
    if(self)
    {
        if(adConfig.isWmOnly){
            self.adapterClassDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     NSClassFromString(@"EYWMRewardAdAdapter"), ADNetworkWM,
                                     nil];
        }else if(!adConfig.enableIronSource) {
            self.adapterClassDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     NSClassFromString(@"EYFbRewardAdAdapter"), ADNetworkFacebook,
                                     NSClassFromString(@"EYAdmobRewardAdAdapter"), ADNetworkAdmob,
                                     NSClassFromString(@"EYUnityRewardAdAdapter"), ADNetworkUnity,
                                     NSClassFromString(@"EYVungleRewardAdAdapter"), ADNetworkVungle,
                                     NSClassFromString(@"EYApplovinRewardAdAdapter"), ADNetworkApplovin,
                                     NSClassFromString(@"EYWMRewardAdAdapter"), ADNetworkWM,
#ifdef GDT_AD_ENABLED
                                     NSClassFromString(@"EYGdtRewardAdAdapter"), ADNetworkGdt,
#endif /*GDT_AD_ENABLED*/
                                     NSClassFromString(@"EYMtgRewardAdAdapter"), ADNetworkMtg,
                                     nil];
        }
        else {
            self.adapterClassDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     NSClassFromString(@"EYWMRewardAdAdapter"), ADNetworkWM,
#ifdef GDT_AD_ENABLED

                                     NSClassFromString(@"EYGdtRewardAdAdapter"), ADNetworkGdt,
#endif /*GDT_AD_ENABLED*/

                                     NSClassFromString(@"EYMtgRewardAdAdapter"), ADNetworkMtg,
                                     NSClassFromString(@"EYIronSourceRewardAdAdapter"), ADNetworkIronSource,
                                     nil];
        }
        self.adGroup = group;
        self.adapterArray = [[NSMutableArray alloc] init];
        
        self.maxTryLoadAd = adConfig.maxTryLoadRewardAd > 0 ? adConfig.maxTryLoadRewardAd : 7;
        self.curLoadingIndex = -1;
        self.tryLoadAdCounter = 0;
        self.reportEvent = adConfig.reportEvent;
        
        NSArray<EYAdKey*>* keyList = group.keyArray;
        
        for(EYAdKey* adKey:keyList)
        {
            if(adKey){
                EYRewardAdAdapter *adapter = [self createAdAdapterWithKey:adKey adGroup:group];
                if(adapter){
                    [self.adapterArray addObject:adapter];
                }
            }
        }
    }
    return self;
}

-(void) loadAd:(NSString*) placeId
{
    NSLog(@"EYRewardAdGroup loadAd placeId = %@, self.curLoadingIndex = %d", placeId, self.curLoadingIndex);
    self.adPlaceId = placeId;
    if(self.adapterArray.count == 0) return;
    self.curLoadingIndex = 0;
    self.tryLoadAdCounter = 1;
    
    EYRewardAdAdapter* adapter = self.adapterArray[0];
    [adapter loadAd];
    
    if(self.adapterArray.count > 1)
    {
        EYRewardAdAdapter* adapter = self.adapterArray[1];
        [adapter loadAd];
        self.curLoadingIndex = 1;
        self.tryLoadAdCounter = 2;
    }
    
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
    }
}

-(bool) isCacheAvailable
{
    for(EYRewardAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            return true;
        }
    }
    return false;
}

-(bool) showAd:(NSString*) placeId withController:(UIViewController*) controller
{
    NSLog(@"showAd placeId = %@, self.curLoadingIndex = %d", placeId, self.curLoadingIndex);
    self.adPlaceId = placeId;
    EYRewardAdAdapter* loadAdapter = NULL;
    for(EYRewardAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            loadAdapter = adapter;
            break;
        }
    }
    if(loadAdapter!=NULL)
    {
        [loadAdapter showAdWithController:controller];
        return true;
    }else{
        [self showLoadingDialog];
        [self loadAd:self.adPlaceId];
        return false;
    }
}

-(EYRewardAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group
{
    EYRewardAdAdapter* adapter = NULL;
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

-(void) showLoadingDialog;
{
    self.isLoadingDialogShowed = true;
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    if (self.loadingTimer == nil) {
        self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timeout) userInfo:nil repeats:false];
    }
}

-(void) hideLoadingDialog
{
    if (self.loadingTimer != nil) {
        [self.loadingTimer invalidate];
        self.loadingTimer = nil;
    }
    self.isLoadingDialogShowed = false;
    [SVProgressHUD dismiss];
}

- (void) timeout{
    NSLog(@"lwq, timeout");
    [self showLoadAdFailedToast];
    [self hideLoadingDialog];
}

-(void) showLoadAdFailedToast
{
    [FFToast showToastWithTitle:NSLocalizedString(@"sorry", @"Sorry") message:NSLocalizedString(@"ad_load_failed", @"Ads is not available，try again later") iconImage:nil duration:3 toastType:FFToastTypeDefault];
    
//    FFToast *toast = [[FFToast alloc] initToastWithTitle:@"Sorry!" message:@"Ads is not available，try again later" iconImage:nil];
//    toast.toastCornerRadius = 5.0f;
//    toast.toastPosition = FFToastPositionCentreWithFillet;
//    toast.toastType = FFToastTypeDefault;
//    [toast show];
}

-(void) onAdLoaded:(EYRewardAdAdapter *)adapter
{
    NSLog(@"onAdLoaded adapter = %@, self.isLoadingDialogShowed = %d", adapter, self.isLoadingDialogShowed);
    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
    {
        self.curLoadingIndex = -1;
    }
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_SUCCESS]  parameters:dic];
    }
    
    if(self.delegate)
    {
        [self.delegate onAdLoaded:self.adPlaceId type:ADTypeReward];
    }
    
    if(self.isLoadingDialogShowed)
    {
        [self hideLoadingDialog];
        UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        [self showAd:self.adPlaceId withController:controller];
    }
}

-(void) onAdLoadFailed:(EYRewardAdAdapter*)adapter withError:(int)errorCode
{
    EYAdKey* adKey = adapter.adKey;
    NSLog(@"onAdLoadFailed adKey = %@, errorCode = %d", adKey.keyId, errorCode);
    
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[NSString alloc] initWithFormat:@"%d",errorCode] forKey:@"code"];
        [dic setObject:adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOAD_FAILED]  parameters:dic];
    }
    
    if(self.curLoadingIndex>=0 && self.adapterArray[self.curLoadingIndex] == adapter)
    {
        if(self.tryLoadAdCounter >= self.maxTryLoadAd){
            self.curLoadingIndex = -1;
            if(self.isLoadingDialogShowed)
            {
                [self showLoadAdFailedToast];
                [self hideLoadingDialog];
            }
        }else{
            self.tryLoadAdCounter++;
            self.curLoadingIndex = (self.curLoadingIndex+1)%self.adapterArray.count;
            EYRewardAdAdapter* adapter = self.adapterArray[self.curLoadingIndex];
            [adapter loadAd];
            if(self.reportEvent){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:adapter.adKey.keyId forKey:@"type"];
                [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
            }
        }
    }
    if(self.delegate)
    {
        [self.delegate onAdLoadFailed:self.adPlaceId key:adKey.keyId code:errorCode];
    }
}

-(void) onAdShowed:(EYRewardAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdShowed:self.adPlaceId type:ADTypeReward];
    }
//    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_SHOW]  parameters:dic];
//    }
}

-(void) onAdClicked:(EYRewardAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdClicked:self.adPlaceId type:ADTypeReward];
    }
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_CLICKED]  parameters:dic];
    }
}

-(void) onAdClosed:(EYRewardAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdClosed:self.adPlaceId type:ADTypeReward];
    }
    if (self.adGroup.isAutoLoad) {
        [self loadAd:self.adPlaceId];
    }
}

-(void) onAdRewarded:(EYRewardAdAdapter *)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdReward:self.adPlaceId type:ADTypeReward];
    }

//    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_REWARDED]  parameters:dic];
//    }
}

-(void) onAdImpression:(EYRewardAdAdapter*)adapter
{
    if(self.delegate)
    {
        [self.delegate onAdImpression:self.adPlaceId type:ADTypeReward];
    }
    EYAdKey *adKey = adapter.adKey;
    if(adKey){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adKey.network forKey:@"network"];
        [dic setObject:adKey.key forKey:@"unit"];
        [dic setObject:ADTypeReward forKey:@"type"];
        [dic setObject:adKey.keyId forKey:@"keyId"];
        [EYEventUtils logEvent:EVENT_AD_IMPRESSION  parameters:dic];
    }
}
@end
