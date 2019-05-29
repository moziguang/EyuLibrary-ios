//
//  EYGdtNativeAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#include "EYGdtNativeAdAdapter.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTUnifiedNativeAdView.h"
#import "EYAdManager.h"

@interface EYGdtNativeAdAdapter()<GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate>

@property(nonatomic,strong)GDTUnifiedNativeAd *nativeAd;
@property(nonatomic,strong)GDTUnifiedNativeAdView *unifiedNativeAdView;
@property(nonatomic,strong)GDTUnifiedNativeAdDataObject *dataObject;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)GDTMediaView *mediaView;
@property(nonatomic,strong)UIImageView *bigImageView;
@property(nonatomic,strong)UIView *imageContainer;

@end

@implementation EYGdtNativeAdAdapter

@synthesize nativeAd = _nativeAd;
@synthesize unifiedNativeAdView = _unifiedNativeAdView;
@synthesize dataObject = _dataObject;
@synthesize iconView = _iconView;
@synthesize mediaView = _mediaView;
@synthesize bigImageView = _bigImageView;
@synthesize imageContainer = _imageContainer;

-(void) loadAd
{
    NSLog(@" lwq, gdt nativeAd loadAd nativeAd = %@, key = %@.", self.nativeAd, self.adKey.key);
    if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else if(self.nativeAd == NULL)
    {
        EYAdManager* manager = [EYAdManager sharedInstance];
        NSString* appId = manager.adConfig.gdtAppId;
        self.nativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:appId placementId:self.adKey.key];
        self.nativeAd.delegate = self;
        
        self.isLoading = true;
        [self.nativeAd loadAdWithAdCount:1];
        [self startTimeoutTask];
    }else{
        if(self.loadingTimer==nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithAdLayout:(UIView*)nativeAdLayout iconView:(UIImageView*)nativeAdIcon titleView:(UILabel*)nativeAdTitle
                  descView:(UILabel*)nativeAdDesc mediaLayout:(UIView*)mediaLayout actBtn:(UIButton*)actBtn controller:(UIViewController*)controller
{
    NSLog(@" lwq, gdt nativeAd showAd self.nativeAd = %@.", self.nativeAd);
    if ([self isAdLoaded]) {
        /*自渲染2.0视图类*/
//        self.unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] initWithFrame:CGRectMake(0, 0, nativeAdLayout.frame.size.width, nativeAdLayout.frame.size.height)];
//        self.unifiedNativeAdView.delegate = self;
//        //self.unifiedNativeAdView.userInteractionEnabled = false;
////        [nativeAdLayout insertSubview:self.unifiedNativeAdView belowSubview:mediaLayout];
//        [nativeAdLayout.superview addSubview:self.unifiedNativeAdView];
//        nativeAdLayout.userInteractionEnabled = false;
//        [self.unifiedNativeAdView setBackgroundColor:[UIColor redColor]];
//
//        GDTLogoView* logoView = [[GDTLogoView alloc] initWithFrame:CGRectMake(0, 0, 54, 18)];
//        [self.unifiedNativeAdView addSubview:logoView];
//
//        NSMutableArray<UIView*>* clickViews = [[NSMutableArray alloc] init];
//        [clickViews addObject:nativeAdLayout];
//        [clickViews addObject:self.unifiedNativeAdView];
//
//        if(nativeAdIcon!=NULL){
//            CGRect iconFrame = nativeAdIcon.frame;
//            self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconFrame.size.width, iconFrame.size.height)];
//            [nativeAdIcon addSubview:self.iconView];
//            NSURL *iconURL = [NSURL URLWithString:self.dataObject.iconUrl];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.iconView.image = [UIImage imageWithData:iconData];
//                });
//            });
//            [clickViews addObject:nativeAdIcon];
//        }
//
//        // Render native ads onto UIView
//        if(nativeAdTitle!=NULL){
//            nativeAdTitle.text = self.dataObject.title;
//            [clickViews addObject:nativeAdTitle];
//        }
//
//        if(nativeAdDesc != NULL){
//            nativeAdDesc.text = self.dataObject.desc;
//            [clickViews addObject:nativeAdDesc];
//        }
//
//        if(actBtn != NULL){
//            actBtn.hidden = true;
//        }
//
//        if(mediaLayout!= NULL){
//            CGRect mediaViewBounds = CGRectMake(0,0, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
//            if(self.dataObject.isThreeImgsAd){
//                /*定义三小图视图*/
//                self.imageContainer = [[UIView alloc] initWithFrame:mediaViewBounds];
//                UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mediaViewBounds.size.width/3, mediaViewBounds.size.height)];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                    NSData *image1Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataObject.mediaUrlList[0]]];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imageView1.image = [UIImage imageWithData:image1Data];
//                    });
//                });
//                [self.imageContainer addSubview:imageView1];
//
//                UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(mediaViewBounds.size.width/3, 0, mediaViewBounds.size.width/3, mediaViewBounds.size.height)];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,
//                                                         0), ^{
//                    NSData *image2Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataObject.mediaUrlList[1]]];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imageView2.image = [UIImage imageWithData:image2Data];
//                    });
//                });
//                [self.imageContainer addSubview:imageView2];
//
//                UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(mediaViewBounds.size.width*2/3, 0, mediaViewBounds.size.width/3, mediaViewBounds.size.height)];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                    NSData *image3Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataObject.mediaUrlList[2]]];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imageView3.image = [UIImage imageWithData:image3Data];
//                    });
//                });
//
//                [self.imageContainer addSubview:imageView3];
//                self.imageContainer.userInteractionEnabled = true;
//                [self.unifiedNativeAdView addSubview:self.imageContainer];
//                [self.unifiedNativeAdView registerDataObject:self.dataObject logoView:logoView viewController:controller clickableViews:@[self.imageContainer]];
//            }else if(self.dataObject.isVideoAd){
//                self.mediaView = [[GDTMediaView alloc] initWithFrame:mediaViewBounds];
//                self.mediaView.videoMuted = true;
//                self.mediaView.videoAutoPlayOnWWAN = true;
//                [self.unifiedNativeAdView addSubview:self.mediaView];
//                [self.unifiedNativeAdView registerDataObject:self.dataObject mediaView:self.mediaView logoView:logoView viewController:controller clickableViews:@[self.unifiedNativeAdView]];
//            }else{
//                self.bigImageView = [[UIImageView alloc] initWithFrame:mediaViewBounds];
//                self.bigImageView.userInteractionEnabled = true;
//                NSURL *imageURL = [NSURL URLWithString:self.dataObject.imageUrl];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.bigImageView.image = [UIImage imageWithData:imageData];
//                    });
//                });
//                [self.unifiedNativeAdView addSubview:self.bigImageView];
//                [self.unifiedNativeAdView registerDataObject:self.dataObject logoView:logoView viewController:controller clickableViews:@[self.bigImageView]];
//            }
//        }
    
//        /*自渲染2.0视图类*/
        self.unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] initWithFrame:CGRectMake(0, 100, nativeAdLayout.frame.size.width, nativeAdLayout.frame.size.height)];
        self.unifiedNativeAdView.delegate = self;
        self.unifiedNativeAdView.backgroundColor = UIColor.redColor;

        /*广告标题*/
        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220, 35)];
        txt.text = self.dataObject.title;
        [self.unifiedNativeAdView addSubview:txt];

        /*广告Logo*/
        GDTLogoView *logoView = [[GDTLogoView alloc] init];
        [self.unifiedNativeAdView addSubview:logoView];

        /*广告Icon*/
        logoView.frame = CGRectMake(CGRectGetWidth(self.unifiedNativeAdView.frame) - 54, CGRectGetHeight(self.unifiedNativeAdView.frame) - 23, 54, 18);
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        NSURL *iconURL = [NSURL URLWithString:self.dataObject.iconUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                iconV.image = [UIImage imageWithData:iconData];
            });
        });
        [self.unifiedNativeAdView addSubview:iconV];

        /*广告描述*/
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 230, 20)];
        desc.text = self.dataObject.desc;
        [self.unifiedNativeAdView addSubview:desc];

        /*广告详情图*/
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.unifiedNativeAdView.frame), 176)];
        [self.unifiedNativeAdView addSubview:imgV];
        NSURL *imageURL = [NSURL URLWithString:self.dataObject.imageUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                imgV.image = [UIImage imageWithData:imageData];
            });
        });
        [self.unifiedNativeAdView registerDataObject:self.dataObject logoView:logoView viewController:controller clickableViews:@[imgV]];

        self.unifiedNativeAdView.tag = 1001;
        [nativeAdLayout.superview.superview.superview.superview addSubview:self.unifiedNativeAdView];
        return true;
    }
    
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, gdt nativeAd dataObject ? = %@", self.dataObject);
    return self.dataObject!=nil;
}


- (void)unregisterView {
    if(self.nativeAd != NULL)
    {
        self.nativeAd.delegate = NULL;
        self.nativeAd = NULL;
    }
    if(self.unifiedNativeAdView!=NULL){
        self.unifiedNativeAdView.delegate = NULL;
        [self.unifiedNativeAdView removeFromSuperview];
        self.unifiedNativeAdView = NULL;
    }
    if(self.imageContainer != NULL)
    {
        [self.imageContainer removeFromSuperview];
        self.imageContainer = NULL;
    }
    if(self.bigImageView != NULL)
    {
        [self.bigImageView removeFromSuperview];
        self.bigImageView = NULL;
    }
    if(self.iconView != NULL)
    {
        [self.iconView removeFromSuperview];
        self.iconView = NULL;
    }
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
    NSLog(@"lwq, EYGdtNativeAdAdapter dealloc ");
    [self unregisterView];
}

@end
#endif /*BYTE_DANCE_ONLY*/
