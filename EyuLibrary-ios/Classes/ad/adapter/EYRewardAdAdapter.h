//
//  IAd.h
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EYAdKey.h"
#import "EYAdGroup.h"
#include "EYAdConstants.h"


@protocol IRewardAdDelegate;

@interface EYRewardAdAdapter : NSObject{
    
}
@property(nonatomic,weak)id<IRewardAdDelegate> delegate;
@property(nonatomic,strong)EYAdKey *adKey;
@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,assign)bool isLoading;
@property(nonatomic,strong)NSTimer *loadingTimer;



-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(void) loadAd;
-(bool) showAdWithController:(UIViewController*) controller;
-(bool) isAdLoaded;

-(void) notifyOnAdLoaded;
-(void) notifyOnAdLoadFailedWithError:(int)errorCode;
-(void) notifyOnAdShowed;
-(void) notifyOnAdClicked;
-(void) notifyOnAdRewarded;
-(void) notifyOnAdClosed;
-(void) notifyOnAdImpression;

-(void) startTimeoutTask;
-(void) cancelTimeoutTask;

@end

@protocol IRewardAdDelegate<NSObject>

@optional
-(void) onAdLoaded:(EYRewardAdAdapter *)adapter;
-(void) onAdLoadFailed:(EYRewardAdAdapter *)adapter withError:(int)errorCode;
-(void) onAdShowed:(EYRewardAdAdapter *)adapter;
-(void) onAdClicked:(EYRewardAdAdapter *)adapter;
-(void) onAdClosed:(EYRewardAdAdapter *)adapter;
-(void) onAdRewarded:(EYRewardAdAdapter *)adapter;
-(void) onAdImpression:(EYRewardAdAdapter *)adapter;

@end
