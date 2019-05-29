//
//  NativeAdGroup.h
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import <Foundation/Foundation.h>
#import "EYAdGroup.h"
#import "EYNativeAdAdapter.h"
#import <UIKit/UIKit.h>
#import "EYAdDelegate.h"
#import "EYAdConstants.h"
#import "EYAdConfig.h"


@interface EYNativeAdGroup :NSObject{
    
}

@property(nonatomic,weak) id<EYAdDelegate> delegate;
@property(nonatomic,strong)EYAdGroup *adGroup;

-(EYNativeAdGroup*) initWithGroup:(EYAdGroup*)group adConfig:(EYAdConfig*) adConfig;
-(bool) isCacheAvailable;
-(EYNativeAdAdapter*) getAvailableAdapter;
- (void) loadAd:(NSString*)placeId;

@end
