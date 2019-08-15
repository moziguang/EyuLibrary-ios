//
//  EYGdtNativeInterstitialAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY
#ifdef GDT_AD_ENABLED

#include "EYGdtNativeInterstitialAdAdapter.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTUnifiedNativeAdView.h"
#import "EYAdManager.h"
#import "InterstitialViewController.h"

@interface EYGdtNativeInterstitialAdAdapter()<GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate>

@property(nonatomic,strong)GDTUnifiedNativeAd *nativeAd;
@property(nonatomic,strong)GDTUnifiedNativeAdDataObject *dataObject;
@property(nonatomic,strong)GDTUnifiedNativeAdView *unifiedNativeAdView;


@end


@implementation EYGdtNativeInterstitialAdAdapter

@synthesize nativeAd = _nativeAd;
@synthesize dataObject = _dataObject;
@synthesize unifiedNativeAdView = _unifiedNativeAdView;

-(void) loadAd
{
    NSLog(@" lwq, gdt interstitialAd loadAd ");
    if(self.nativeAd == NULL)
    {
        EYAdManager* manager = [EYAdManager sharedInstance];
        NSString* appId = manager.adConfig.gdtAppId;
        self.nativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:appId placementId:self.adKey.key];
        self.nativeAd.delegate = self;
        
        self.isLoading = true;
        [self.nativeAd loadAdWithAdCount:1];
        [self startTimeoutTask];
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" lwq, gdt interstitialAd showAd ");
    if([self isAdLoaded])
    {
//        [self.interstitialAd presentFromRootViewController:controller];
        InterstitialViewController *secondViewController = [[InterstitialViewController alloc] init];
        [controller presentViewController:secondViewController animated:YES completion:^{
            NSLog(@" lwq, gdt interstitialAd showAd, show next controller");
        }];
        [self showAd:self.dataObject withController:secondViewController];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, gdt interstitialAd isAdLoaded , dataObject = %@", self.dataObject);
    return self.dataObject != NULL;
}

/**
 拼装图文类型广告
 
 @param dataObject 数据对象
 */
- (void)showAd:(GDTUnifiedNativeAdDataObject *)dataObject withController:(InterstitialViewController *)controller
{
    
    /*自渲染2.0视图类*/
    GDTUnifiedNativeAdView *unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] initWithFrame:CGRectMake(10, 250, controller.view.frame.size.width - 2 * 10, 250)];
    unifiedNativeAdView.delegate = self;
    
    /*广告标题*/
    controller.nativeAdTitle.text = dataObject.title;
    
    
    /*广告Logo*/
    GDTLogoView *logoView = [[GDTLogoView alloc] init];
    [unifiedNativeAdView addSubview:logoView];
    logoView.frame = CGRectMake(CGRectGetWidth(unifiedNativeAdView.frame) - 54, CGRectGetHeight(unifiedNativeAdView.frame) - 23, 54, 18);
    
    /*广告Icon*/
    NSURL *iconURL = [NSURL URLWithString:dataObject.iconUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            controller.nativeAdIcon.image = [UIImage imageWithData:iconData];
        });
    });
    
    /*广告描述*/
    controller.nativeAdDesc.text = dataObject.desc;
    
    /*广告详情图*/
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(unifiedNativeAdView.frame), 176)];
    [unifiedNativeAdView addSubview:imgV];
    NSURL *imageURL = [NSURL URLWithString:dataObject.imageUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            imgV.image = [UIImage imageWithData:imageData];
        });
    });
    [unifiedNativeAdView registerDataObject:dataObject logoView:logoView viewController:controller clickableViews:@[imgV]];
    
    [controller.view addSubview:unifiedNativeAdView];
}

/**
 * 拉取广告的回调，包含成功和失败情况
 */
#pragma mark - GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error
{
    if (unifiedNativeAdDataObjects) {
        NSLog(@"lwq, gdt native 成功请求到广告数据");
        self.dataObject = unifiedNativeAdDataObjects[0];
        self.isLoading = false;
        [self cancelTimeoutTask];
        [self notifyOnAdLoaded];
    }else{
        if (error.code == 5004) {
            NSLog(@"lwq, gdt native 没匹配的广告，禁止重试，否则影响流量变现效果");
        } else if (error.code == 5005) {
            NSLog(@"lwq, gdt native 流量控制导致没有广告，超过日限额，请明天再尝试");
        } else if (error.code == 5009) {
            NSLog(@"lwq, gdt native 流量控制导致没有广告，超过小时限额");
        } else if (error.code == 5006) {
            NSLog(@"lwq, gdt native 包名错误");
        } else if (error.code == 5010) {
            NSLog(@"lwq, gdt native 广告样式校验失败");
        } else if (error.code == 3001) {
            NSLog(@"lwq, gdt native 网络错误");
        }
        NSLog(@"lwq, gdt Native ad failed to load with error: %@", error);
        self.isLoading = false;
        if(self.nativeAd != NULL)
        {
            self.nativeAd.delegate = NULL;
            self.nativeAd = NULL;
        }
        [self cancelTimeoutTask];
        [self notifyOnAdLoadFailedWithError:(int)error.code];
    }
}

#pragma mark - GDTUnifiedNativeAdViewDelegate
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"lwq, gdt native 广告被点击");
    [self notifyOnAdClicked];
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"lwq, gdt native 广告被曝光");
    [self notifyOnAdShowed];
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"lwq, gdt native 广告详情页已关闭");
}

- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"lwq, gdt native 广告进入后台");
}

- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"lwq, gdt native 广告详情页面即将打开");
}

- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo
{
    NSLog(@"lwq, gdt native 视频广告状态变更");
    switch (status) {
        case GDTMediaPlayerStatusInitial:
            NSLog(@"lwq, gdt native 视频初始化");
            break;
        case GDTMediaPlayerStatusLoading:
            NSLog(@"lwq, gdt native 视频加载中");
            break;
        case GDTMediaPlayerStatusStarted:
            NSLog(@"lwq, gdt native 视频开始播放");
            break;
        case GDTMediaPlayerStatusPaused:
            NSLog(@"lwq, gdt native 视频暂停");
            break;
        case GDTMediaPlayerStatusStoped:
            NSLog(@"lwq, gdt native 视频停止");
            break;
        case GDTMediaPlayerStatusError:
            NSLog(@"lwq, gdt native 视频播放出错");
        default:
            break;
    }
    if (userInfo) {
        long videoDuration = [userInfo[kGDTUnifiedNativeAdKeyVideoDuration] longValue];
        NSLog(@"lwq, gdt native 视频广告长度为 %ld s", videoDuration);
    }
}

- (void)dealloc
{
    if(self.nativeAd!= NULL)
    {
        self.nativeAd.delegate = NULL;
        self.nativeAd = NULL;
    }
    
    if(self.unifiedNativeAdView){
        self.unifiedNativeAdView.delegate = nil;
        self.unifiedNativeAdView = nil;
    }
}

@end
#endif /*GDT_AD_ENABLED*/

#endif /*BYTE_DANCE_ONLY*/
