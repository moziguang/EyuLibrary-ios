//
//  BillingHelper-ios.h
//  ballzcpp-mobile
//
//  Created by apple on 2018/2/24.
//

#ifndef RemoteConfigHelper_ios_h
#define RemoteConfigHelper_ios_h
#import<StoreKit/StoreKit.h>
#import "Firebase.h"

#define     RCKeyUnityClientId              @"ios_unity_game_id"
#define     RCKeyAdmobClientId              @"ios_admob_game_id"
#define     RCKeyIronSourceAppKey           @"ios_ironsource_app_key"
#define     RCKeyAdSetting                  @"ios_ad_setting"
#define     RCKeyAdKeySetting              @"ios_ad_key_setting"
#define     RCKeyAdCacheSetting            @"ios_ad_cache_setting"
#define     RCKeyAdCacheSettingChina           @"ios_ad_cache_setting_china"

@interface EYRemoteConfigHelper : NSObject

- (void) setupWithDefault:(NSDictionary *)defDict;
- (NSData*)getData:(NSString*) key;
- (NSString*)getString:(NSString*) key;
- (bool)getBoolean:(NSString*) key;
- (long)getLong:(NSString*) key;
- (double)getDouble:(NSString*) key;
+ (id) sharedInstance;
+ (NSData *)readFileWithName:(NSString *)name;
+ (NSDictionary *)readJsonFileWithName:(NSString *)name;
+ (bool)getBoolean:(NSDictionary*) dict;
+ (NSString*)getString:(NSDictionary*) dict;
+ (long)getLong:(NSDictionary*) dict;
+ (double)getDouble:(NSDictionary*) dict;
@end
#endif /* RemoteConfigHelper_ios_h */
