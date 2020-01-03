//
//  EventUtils.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/8/2.
//

#import <Foundation/Foundation.h>
#import "EYEventUtils.h"

#ifdef AF_ENABLED
#import <AppsFlyerLib/AppsFlyerTracker.h>
#endif

#ifdef UM_ENABLED
#import <UMAnalytics/MobClick.h>
#endif

#ifdef GDT_ACTION_ENABLED
#import <GDTActionSDK/GDTAction.h>
#endif

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
    
#ifdef UM_ENABLED
    if([EYSdkUtils isUMInited]){
        [MobClick event:event attributes:strDict];
    }
#endif
    
#ifdef AF_ENABLED
    [[AppsFlyerTracker sharedTracker] trackEvent:event withValues:strDict];
#endif
    
#ifdef GDT_ACTION_ENABLED
    if([EYSdkUtils isGDTInited]){
        [GDTAction logAction:event actionParam:strDict];
    }
#endif
    
#ifdef FACEBOOK_ENABLED
    if([EYSdkUtils isFBInited]){
        [FBSDKAppEvents logEvent:event parameters:strDict];
    }
#endif
}

@end
