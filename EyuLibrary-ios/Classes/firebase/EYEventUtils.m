//
//  EventUtils.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/8/2.
//

#import <Foundation/Foundation.h>
#import "EYEventUtils.h"
#import "Firebase.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>
#import <UMAnalytics/MobClick.h>
#import <GDTActionSDK/GDTAction.h>


@implementation EYEventUtils

+ (void)logEvent:(NSString *)event parameters:(NSDictionary *)dict
{
    NSMutableDictionary* strDict = nil;
    if(dict){
        strDict = [[NSMutableDictionary alloc] initWithCapacity:dict.count];
        for(NSString* key in dict)
        {
            NSString *value = [NSString stringWithFormat:@"%@",dict[key]];
            [strDict setObject:value forKey:key];
        }
    }
    [FIRAnalytics logEventWithName:event parameters:strDict];
    [MobClick event:event attributes:strDict];
    [[AppsFlyerTracker sharedTracker] trackEvent:event withValues:strDict];
    [GDTAction logAction:event actionParam:strDict];
}

@end
