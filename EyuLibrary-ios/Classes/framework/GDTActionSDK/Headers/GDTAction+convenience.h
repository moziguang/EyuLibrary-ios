//
//  GDTAction+convenience.h
//  GDTActionSDK
//
//  Created by Nancy on 2019/9/3.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTAction.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDTAction (convenience)

/**
 用户注册流程完成时调用此接口
 
 @param method 表示注册方式，业务方可以传任意可标识注册方式的值，如注册方式为手机号：method = @"phone" 微信注册：method = @“WeChat” 邮箱：method = @"mail"等等。
 这个参数作用：方便业务方在数据平台以method为key查询数据
 @param isSuccess 是否注册成功
 */
+ (void)reportRegisterActionWithMethod:(NSString *)method isSuccess:(BOOL)isSuccess;

/**
 用户登录完成时调用此接口
 
 @param method 表示登录的方式，如游戏账号、手机号等
 @param isSuccess 是否登录成功
 */
+ (void)reportLoginActionWithMethod:(NSString *)method isSuccess:(BOOL)isSuccess;

/**
 绑定社交账户时调用此接口
 
 @param method 表示登录的方式，如游戏账号、手机号等
 @param isSuccess 是否注册成功
 */

/**
 绑定社交账户时调用此接口
 
 @param type 社交账号类型 如如微信、微博等
 @param isSuccess 是否绑定成功
 */
+ (void)reportBindSocialAccountActionWithType:(NSString *)type isSuccess:(BOOL)isSuccess;

/**
 完成节点（如教学/任务/副本）时调用此接口
 
 @param questID 教学/任务/副本等关卡标识符
 @param type 节点类型
 @param name 教学/任务/副本等关卡名称
 @param number 第几个任务节点
 @param desc 节点描述
 @param isSuccess 节点是否完成
 */
+ (void)reportFinishQuestActionWithQuestID:(NSString *)questID
                    questType:(NSString *)type
                    questName:(NSString *)name
                   questNumer:(NSUInteger)number
                  description:(NSString *)desc
                    isSuccess:(BOOL)isSuccess;

/**
 用户创建游戏角色后调用此接口
 
 @param role 游戏角色
 */

+ (void)reportCreateRoleActionWithRole:(NSString *)role;

/**
 用户升级后调用此接口
 
 @param level 当前用户等级
 */
+ (void)reportUpgradeLevelActionWithLevel:(NSUInteger)level;

/**
 查看内容/商品详情时调用此接口
 
 @param type 内容类型如“配备”、“皮肤”
 @param name 商品或内容名称
 @param contentID 商品或内容标识符
 */
+ (void)reportViewContentActionWithContentType:(NSString *)type
                            contentName:(NSString *)name
                              contentID:(NSString *)contentID;

/**
 加入购买/购物车时调用此接口
 
 @param type 内容类型如“配备”、“皮肤”
 @param name 商品或内容名称
 @param contentID 商品或内容标识符
 @param number 商品数量
 @param isSuccess 加入购买/购物车是否成功
 */
+ (void)reportAddingToCartActionWithContentType:(NSString *)type
                        contentName:(NSString *)name
                          contentID:(NSString *)contentID
                      contentNumber:(NSUInteger)number
                          isSuccess:(BOOL)isSuccess;

/**
 提交购买/下单时调用此接口
 
 @param type 内容类型如“配备”、“皮肤”
 @param name 商品或内容名称
 @param contentID 商品或内容标识符
 @param number 商品数量
 @param isVirtualCurrency 是否使用的是虚拟货币
 @param virtualCurrencyType 虚拟货币类型，如"元宝"、“金币”等
 @param realCurrencyType 真实货币类型，ISO 4217代码，如：“USD”
 @param isSuccess 提交购买/下单是否成功
 */
+ (void)reportCheckoutActionWithContentType:(NSString *)type
                         contentName:(NSString *)name
                           contentID:(NSString *)contentID
                       contentNumber:(NSUInteger)number
                   isVirtualCurrency:(BOOL)isVirtualCurrency
                     virtualCurrencyType:(NSString *)virtualCurrencyType
                            realCurrencyType:(NSString *)realCurrencyType
                           isSuccess:(BOOL)isSuccess;


/**
 支付时调用此接口
 
 @param type 内容类型如“配备”、“皮肤”
 @param name 商品或内容名称
 @param contentID 商品或内容标识符
 @param number 商品数量
 @param channel 支付渠道名，如支付宝、微信等
 @param realCurrency 真实货币类型，ISO 4217代码，如：“USD”
 @param amount 本次支付的真实货币的金额
 @param isSuccess 支付是否成功
 */
+ (void)reportPurchaseActionWithContentType:(NSString *)type
                         contentName:(NSString *)name
                           contentID:(NSString *)contentID
                       contentNumber:(NSUInteger)number
                      paymentChannel:(NSString *)channel
                            realCurrency:(NSString *)realCurrency
                     currencyAmount:(unsigned long long)amount
                           isSuccess:(BOOL)isSuccess;


/**
 添加支付渠道时调用此接口
 
 @param channel 支付渠道名，如支付宝、微信支付等
 @param isSuccess 添加支付渠道是否成功
 */
+ (void)reportAddPaymentChannelActionWithChannel:(NSString *)channel isSuccess:(BOOL)isSuccess;

/**
 对APP进行应用商店评分时调用此接口
 
 @param rate 评分
 */
+ (void)reportRateActionWithRate:(CGFloat)rate;

/**
 分享至社交媒体时调用此接口
 
 @param channel 社交媒体
 @param isSuccess 分享是否成功
 */
+ (void)reportShareActionWithChannel:(NSString *)channel isSuccess:(BOOL)isSuccess;


@end


NS_ASSUME_NONNULL_END
