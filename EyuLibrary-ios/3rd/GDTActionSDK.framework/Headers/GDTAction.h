//
//  GDTAction.h
//  GDTActionSDK
//
//  Created by Chao Gao on 2017/11/29.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const GDTSDKActionNameStartApp;        /**<  App启动  */
extern NSString *const GDTSDKActionNamePageView;        /**<  页面访问  */
extern NSString *const GDTSDKActionNameRegister;        /**<  注册  */
extern NSString *const GDTSDKActionNameViewContent;     /**<  内容浏览  */
extern NSString *const GDTSDKActionNameConsult;         /**<  咨询  */
extern NSString *const GDTSDKActionNameAddToCart;       /**<  加入购物车 */
extern NSString *const GDTSDKActionNamePurchase;        /**<  购买 */
extern NSString *const GDTSDKActionNameSearch;          /**<  搜索 */
extern NSString *const GDTSDKActionNameAddToWishList;   /**<  收藏 */
extern NSString *const GDTSDKActionNameInitiateCheckOut;/**<  开始结算 */
extern NSString *const GDTSDKActionNameCompleteOrder;   /**<  下单 */
extern NSString *const GDTSDKActionNameDownloadApp;     /**<  下载应用 */
extern NSString *const GDTSDKActionNameRate;            /**<  评分 */
extern NSString *const GDTSDKActionNameReservation;     /**<  预约 */
extern NSString *const GDTSDKActionNameShare;           /**<  分享 */
extern NSString *const GDTSDKActionNameApply;           /**<  申请 */
extern NSString *const GDTSDKActionNameClaimOffer;      /**<  领取卡券 */
extern NSString *const GDTSDKActionNameNavigate;        /**<  导航 */
extern NSString *const GDTSDKActionNameProductRecommend;/**<  商品推荐 */

@interface GDTAction : NSObject

extern NSString *const GDTSDKActionParamKeyOuterActionId; /**< 自定义去重Id */
extern NSString *const GDTSDKActionParamKeyAudienceType; /**<  标示客户类型 */

typedef enum GDTActionParamAudienceType{
    
    GDTActionParamAudienceType_NewAudience = 0,     // 新客户
    GDTActionParamAudienceType_UsedAudience = 1,    // 老客户
    
} GDTActionParamAudienceType;


/**
 在接入广点通行为数据SDK时，请在App启动的时候调用初始化方法。初始化方法调用时请传入数据源UserActionSetId和在后台看到的secretKey密钥串。

 @param actionSetId 数据源id，在DMP系统后台可以看见创建的数据源id
 @param secretKey 密钥串，在DMP系统后台可以看见分配的密钥串
 */
+(void)init:(NSString *)actionSetId secretKey:(NSString *)secretKey;

/**
 在上报广点通行为数据时，系统提供若干标准的行为类型actionName，若需要上报自定义actionName，请与广点通联系，并在参数名中传入自定义的字符串。

 @param actionName 行为类型名，参见GDTSDKActionName
 @param actionParam 行为参数，只支持单层结构，暂不支持嵌套的行为参数数据。
 */
+(void)logAction:(NSString *)actionName actionParam:(NSDictionary *)actionParam;

@end
