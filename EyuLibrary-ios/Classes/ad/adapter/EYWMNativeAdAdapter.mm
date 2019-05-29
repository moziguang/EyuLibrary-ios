//
//  EYWMNativeAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#include "EYWMNativeAdAdapter.h"
#import <BUAdSDK/BUNativeAd.h>
#import <BUAdSDK/BUNativeAdRelatedView.h>

@interface EYWMNativeAdAdapter()<BUNativeAdDelegate>

@property(nonatomic,strong)BUNativeAd *nativeAd;
@property(nonatomic,strong)BUNativeAdRelatedView *relatedView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,assign)bool isLoaded;

@end

@implementation EYWMNativeAdAdapter

@synthesize nativeAd = _nativeAd;
@synthesize relatedView = _relatedView;
@synthesize imageView = _imageView;
@synthesize isLoaded = _isLoaded;


-(void) loadAd
{
    NSLog(@" lwq, wm nativeAd loadAd nativeAd = %@, key = %@.", self.nativeAd, self.adKey.key);
    if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else if(self.nativeAd == NULL)
    {
        self.nativeAd = [[BUNativeAd alloc] init];;
        BUAdSlot *slot1 = [[BUAdSlot alloc] init];
        BUSize *imgSize1 = [[BUSize alloc] init];
        imgSize1.width = 750;
        imgSize1.height = 532;
        slot1.ID = self.adKey.key;
        slot1.AdType = BUAdSlotAdTypeFeed;
        slot1.position = BUAdSlotPositionFeed;
        slot1.imgSize = imgSize1;
        slot1.isSupportDeepLink = YES;
        self.nativeAd.adslot = slot1;
        self.nativeAd.delegate = self;
        
        self.relatedView =  [[BUNativeAdRelatedView alloc] init];
        
        self.isLoading = true;
        [self.nativeAd loadAdData];
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
    NSLog(@" lwq, wm nativeAd showAd self.nativeAd = %@.", self.nativeAd);
    if ([self isAdLoaded]) {
//        self.relatedView.logoImageView.frame = CGRectZero;
//        [nativeAdLayout addSubview:self.relatedView.logoImageView];
        NSMutableArray<UIView*>* clickViews = [[NSMutableArray alloc] init];
        
        [clickViews addObject:nativeAdLayout];
        if(mediaLayout!= NULL){
            CGRect mediaViewBounds = CGRectMake(0,0, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
            if(self.nativeAd.data.imageMode == BUFeedVideoAdModeImage){
                self.relatedView.videoAdView.hidden = NO;
                self.relatedView.videoAdView.userInteractionEnabled = false;
                self.relatedView.videoAdView.frame = mediaViewBounds;
                [mediaLayout addSubview:self.relatedView.videoAdView];
            }else{
                self.imageView = [[UIImageView alloc] init];
                self.imageView.hidden = false;
                self.imageView.userInteractionEnabled = YES;
                self.imageView.frame = mediaViewBounds;
                [mediaLayout addSubview:self.imageView];
                if (self.nativeAd.data.imageAry.count > 0) {
                    BUImage *image = self.nativeAd.data.imageAry.firstObject;
                    NSLog(@"lwq, showAdWithAdLayout image strUrl = %@", image.imageURL);
                    if (image.imageURL.length > 0) {
                        NSURL *url = [NSURL URLWithString:[image.imageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//                        NSLog(@"lwq, showAdWithAdLayout image url = %@", url);
//                        NSData* data = [NSData dataWithContentsOfURL: url];
//                        self.imageView.image = [UIImage imageWithData:data];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                            NSData *imageData = [NSData dataWithContentsOfURL:url];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.imageView.image = [UIImage imageWithData:imageData];
                            });
                        });
                    }
                }
            }
        }
        
        if(self.relatedView.logoImageView){
            CGRect iconViewBounds = CGRectMake(0,0, 15, 15);
            self.relatedView.logoImageView.frame = iconViewBounds;
            [nativeAdLayout addSubview:self.relatedView.logoImageView];
        }
        
        
        if(nativeAdIcon!=NULL){
//            nativeAdIcon.image = nil;
            [clickViews addObject:nativeAdIcon];
            
            NSURL *url = [NSURL URLWithString:[self.nativeAd.data.icon.imageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    nativeAdIcon.image = [UIImage imageWithData:imageData];
                });
            });
        }
        
        // Render native ads onto UIView
        if(nativeAdTitle!=NULL){
            nativeAdTitle.text = self.nativeAd.data.AdTitle;
            [clickViews addObject:nativeAdTitle];
        }
        
        if(nativeAdDesc != NULL){
            nativeAdDesc.text = self.nativeAd.data.AdDescription;
            [clickViews addObject:nativeAdDesc];
        }
        
        if(actBtn != NULL){
            actBtn.hidden = false;
            [actBtn setTitle:self.nativeAd.data.buttonText forState:UIControlStateNormal];
            [clickViews addObject:actBtn];
        }
        [self.relatedView refreshData:self.nativeAd];
        
        [self.nativeAd registerContainer:nativeAdLayout withClickableViews:clickViews];
    }
    
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, wm nativeAd isAdLoaded ? = %d", self.isLoaded);
    return self.isLoaded;
}


- (void)unregisterView {
    if(self.nativeAd != NULL)
    {
        [self.nativeAd unregisterView];
        self.nativeAd.delegate = NULL;
        self.nativeAd = NULL;
    }
    if(self.relatedView != NULL)
    {
        [self.relatedView.videoAdView removeFromSuperview];
        [self.relatedView.logoImageView removeFromSuperview];
        [self.relatedView.logoADImageView removeFromSuperview];

        self.relatedView = NULL;
    }
    if(self.imageView != NULL)
    {
        [self.imageView removeFromSuperview];
        self.imageView = NULL;
    }
    
}

#pragma mark - BUNativeAdDelegate
- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd {
    NSLog(@"lwq, wm nativeAdDidLoad");
    self.isLoading = false;
    self.isLoaded = true;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error
{
    NSLog(@"lwq,wm Native ad failed to load with error: %@", error);
    self.isLoading = false;
    self.isLoaded = false;
    if(self.nativeAd != NULL)
    {
        [self.nativeAd unregisterView];
        self.nativeAd.delegate = NULL;
        self.nativeAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view
{
    NSLog(@"lwq,wm nativeAdDidClick");
    [self notifyOnAdClicked];
}

- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd
{
    [self notifyOnAdShowed];
}

- (void)dealloc
{
    NSLog(@"lwq, EYWMNativeAdAdapter dealloc ");
    [self unregisterView];
}

@end
