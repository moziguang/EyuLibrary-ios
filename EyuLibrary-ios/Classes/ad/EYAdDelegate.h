//
//  EYAdDelegate.h
//  EyuLibrary-ios_Example
//
//  Created by qianyuan on 2018/10/17.
//  Copyright © 2018年 WeiqiangLuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EYAdDelegate <NSObject>

-(void) onAdLoaded:(NSString*) adPlaceId type:(NSString*)type;
-(void) onAdReward:(NSString*) adPlaceId  type:(NSString*)type;
-(void) onAdShowed:(NSString*) adPlaceId  type:(NSString*)type;
-(void) onAdClosed:(NSString*) adPlaceId  type:(NSString*)type;
-(void) onAdClicked:(NSString*) adPlaceId  type:(NSString*)type;
-(void) onAdLoadFailed:(NSString*) adPlaceId key:(NSString*)key code:(int)code;


-(void) onDefaultNativeAdClicked;
@end

NS_ASSUME_NONNULL_END
