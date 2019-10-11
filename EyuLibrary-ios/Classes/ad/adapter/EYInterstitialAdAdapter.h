//
//  IAd.h
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EYAdKey.h"
#import "EYAdGroup.h"
#include "EYAdConstants.h"


@protocol IInterstitialAdDelegate;

@interface EYInterstitialAdAdapter : NSObject{
    
}
@property(nonatomic,weak)id<IInterstitialAdDelegate> delegate;
@property(nonatomic,strong)EYAdKey *adKey;
@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,assign)bool isLoading;
@property(nonatomic,strong)NSTimer *loadingTimer;
@property(nonatomic,assign)bool isShowing;


-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(void) loadAd;
-(bool) showAdWithController:(UIViewController*) controller;
-(bool) isAdLoaded;
-(void) notifyOnAdLoaded;
-(void) notifyOnAdLoadFailedWithError:(int)errorCode;
-(void) notifyOnAdShowed;
-(void) notifyOnAdClicked;
-(void) notifyOnAdClosed;
-(void) notifyOnAdImpression;


-(void) startTimeoutTask;
-(void) cancelTimeoutTask;

@end

@protocol IInterstitialAdDelegate<NSObject>

@optional
-(void) onAdLoaded:(EYInterstitialAdAdapter *)adapter;
-(void) onAdLoadFailed:(EYInterstitialAdAdapter*)adapter withError:(int)errorCode;
-(void) onAdShowed:(EYInterstitialAdAdapter*)adapter;
-(void) onAdClicked:(EYInterstitialAdAdapter*)adapter;
-(void) onAdClosed:(EYInterstitialAdAdapter*)adapter;
-(void) onAdImpression:(EYInterstitialAdAdapter *)adapter;

@end
