//
//  EventUtils.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/8/2.
//

#import <Foundation/Foundation.h>
#import "EYEventUtils.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>
#import <UMAnalytics/MobClick.h>
#import <GDTActionSDK/GDTAction.h>
#import "EYSdkUtils.h"

#ifdef FIREBASE_ENABLED
#import "Firebase.h"
#endif

#ifdef FACEBOOK_ENABLED
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#endif


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
#ifdef FIREBASE_ENABLED
    [FIRAnalytics logEventWithName:event parameters:strDict];
#endif
    if([EYSdkUtils isUMInited]){
        [MobClick event:event attributes:strDict];
    }
    [[AppsFlyerTracker sharedTracker] trackEvent:event withValues:strDict];
    if([EYSdkUtils isGDTInited]){
        [GDTAction logAction:event actionParam:strDict];
    }
    
#ifdef FACEBOOK_ENABLED
    if([EYSdkUtils isFBInited]){
        [FBSDKAppEvents logEvent:event parameters:strDict];
    }
#endif
}

@end
