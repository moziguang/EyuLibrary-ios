//
//  EventUtils.h
//  ballzcpp-mobile
//
//  Created by apple on 2018/2/24.
//

#ifndef EventUtils_ios_h
#define EventUtils_ios_h
#import<StoreKit/StoreKit.h>

@interface EYEventUtils : NSObject {
    
}

+ (void)logEvent:(NSString *)event parameters:(NSDictionary *)dict;

@end
#endif /* EventUtils_ios_h */
