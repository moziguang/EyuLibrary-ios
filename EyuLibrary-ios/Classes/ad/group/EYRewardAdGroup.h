//
//  RewardAdGroup.h
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import <Foundation/Foundation.h>
#import "EYAdGroup.h"
#import "EYRewardAdAdapter.h"
#import <UIKit/UIKit.h>
#import "EYAdDelegate.h"
#import "EYAdConstants.h"
#import "EYAdConfig.h"


@interface EYRewardAdGroup :NSObject{
    
}

@property(nonatomic,weak) id<EYAdDelegate> delegate;
@property(nonatomic,strong)EYAdGroup *adGroup;

-(EYRewardAdGroup*) initWithGroup:(EYAdGroup*)group adConfig:(EYAdConfig*) adConfig;
-(void) loadAd:(NSString*) placeId;
-(bool) isCacheAvailable;
-(bool) showAd:(NSString*) placeId withController:(UIViewController*) controller;

@end
