//
//  EYSdkUtils.h
//  ballzcpp-mobile
//
//  Created by qianyuan on 2017/12/19.
//

#ifndef EYSdkUtils_h
#define EYSdkUtils_h


@interface EYSdkUtils : NSObject {
    
}

/**
 *需要再info.plist里设置FacebookAppID
 **/
+(void) initFacebookSdkWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions;

+(void) initFirebaseSdk;
//+(void) initGaSdk:(NSString*) trackId;
+(void) initAppFlyer:(NSString*) devKey appId:(NSString*)appId;
+(void) initUMMobSdk:(NSString*) appKey channel:(NSString*) channel;
+(void) initGDTActionSdk:(NSString*) setid secretkey:(NSString*)secretkey;
+(void) doGDTSDKActionStartApp;

+(bool) isUMInited;
+(bool) isGDTInited;

@end

#endif /* EYSdkUtils_h */



