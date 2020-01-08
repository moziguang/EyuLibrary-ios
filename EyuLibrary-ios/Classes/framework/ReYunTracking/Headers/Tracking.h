//
//  Tracking.h
//  ReYun_Tracking
//
//  Created by jesse on 2018/1/19.
//  Copyright © 2018年 yun. All rights reserved.
//
#define REYUN_TRACKING_VERSION @"1.4.7"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface Tracking : NSObject
//开启打印日志   正式上线包请关掉
+(void) setPrintLog :(BOOL)print;
// 开启数据统计
+ (void)initWithAppKey:(NSString *)appKey withChannelId:(NSString *)channelId;
//注册成功后调用
+ (void)setRegisterWithAccountID:(NSString *)account;
//登陆成功后调用
+ (void)setLoginWithAccountID:(NSString *)account;
//生成订单
+(void)setDD:(NSString *)ryTID hbType:(NSString*)hbType hbAmount:(float)hbAmount;
// 支付完成，付费分析,记录玩家充值的金额（人民币单位是元）
+(void)setRyzf:(NSString *)ryTID ryzfType:(NSString*)ryzfType hbType:(NSString*)hbType hbAmount:(float)hbAmount;
//自定义事件
+(void)setEvent:(NSString *)eventName;
//获取设备信息
+(NSString*)getDeviceId;
@end
NS_ASSUME_NONNULL_END
