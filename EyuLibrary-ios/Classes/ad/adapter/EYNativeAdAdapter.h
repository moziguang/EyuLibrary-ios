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


@protocol INativeAdDelegate;

@interface EYNativeAdAdapter : NSObject{
    
}
@property(nonatomic,weak)id<INativeAdDelegate> delegate;
@property(nonatomic,strong)EYAdKey *adKey;
@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,assign)bool isLoading;
@property(nonatomic,strong)NSTimer *loadingTimer;


-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(void) loadAd;
-(bool) showAdWithAdLayout:(UIView*)nativeAdLayout iconView:(UIImageView*)nativeAdIcon titleView:(UILabel*)nativeAdTitle
                  descView:(UILabel*)nativeAdDesc mediaLayout:(UIView*)mediaLayout actBtn:(UIButton*)actBtn controller:(UIViewController*)controller;
-(bool) isAdLoaded;
-(void) unregisterView;

-(void) notifyOnAdLoaded;
-(void) notifyOnAdLoadFailedWithError:(int)errorCode;
-(void) notifyOnAdShowed;
-(void) notifyOnAdClicked;

-(void) startTimeoutTask;
-(void) cancelTimeoutTask;

@end


@protocol INativeAdDelegate<NSObject>

@optional
-(void) onAdLoaded:(EYNativeAdAdapter *)adapter;
-(void) onAdLoadFailed:(EYNativeAdAdapter *)adapter withError:(int)errorCode;
-(void) onAdShowed:(EYNativeAdAdapter *)adapter;
-(void) onAdClicked:(EYNativeAdAdapter *)adapter;
@end
