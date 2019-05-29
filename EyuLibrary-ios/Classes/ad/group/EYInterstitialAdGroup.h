//
//  InterstitialAdGroup.h
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import <Foundation/Foundation.h>
#import "EYAdGroup.h"
#import "EYInterstitialAdAdapter.h"
#import <UIKit/UIKit.h>
#import "EYAdDelegate.h"
#import "EYAdConstants.h"
#import "EYAdConfig.h"

@interface EYInterstitialAdGroup :NSObject{
    
}

@property(nonatomic,weak) id<EYAdDelegate> delegate;
@property(nonatomic,strong)EYAdGroup *adGroup;

-(EYInterstitialAdGroup*) initWithGroup:(EYAdGroup*)adGroup adConfig:(EYAdConfig*) adConfig;
-(bool) isCacheAvailable;
-(bool) showAd:(NSString*)adPlaceId controller:(UIViewController*)controller;
-(void) loadAd:(NSString*)adPlaceId;

@end
