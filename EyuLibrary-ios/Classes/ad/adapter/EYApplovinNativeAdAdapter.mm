//
//  EYApplovinNativeAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef APPLOVIN_ADS_ENABLED

#include "EYApplovinNativeAdAdapter.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "ALNativeAdVideoPlayer.h"
#import "ALNativeAdVideoView.h"

#define kVideoViewBackgroundColor             [UIColor clearColor]


@interface EYApplovinNativeAdAdapter() <ALNativeAdLoadDelegate, ALPostbackDelegate, ALNativeAdPrecacheDelegate>
@property (nonatomic, strong) ALNativeAd *nativeAd;
@property (nonatomic, strong) ALNativeAdVideoPlayer *nativeAdPlayer;
@property (nonatomic, strong) ALNativeAdVideoView *nativeAdVideoView;
@property (nonatomic, strong) UIImageView *nativeAdImgView;
@property (nonatomic, assign) bool isCached;
//@property (nonatomic, strong) UITapGestureRecognizer *mediaLayoutTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, weak) UIView *touchView;

@end


@implementation EYApplovinNativeAdAdapter

@synthesize nativeAd = _nativeAd;
@synthesize isCached = _isCached;
@synthesize nativeAdPlayer = _nativeAdPlayer;
@synthesize nativeAdVideoView = _nativeAdVideoView;
@synthesize nativeAdImgView = _nativeAdImgView;
@synthesize tapGesture = _tapGesture;
@synthesize touchView = _touchView;

-(void) loadAd
{
    NSLog(@" lwq, load applovin nativeAd ");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
    }else if (!self.isLoading){
        self.isLoading = true;
        if(self.nativeAd==NULL){
            [[ALSdk shared].nativeAdService loadNativeAdGroupOfCount: 1 andNotify: self];
        }else{
            [[ALSdk shared].nativeAdService precacheResourcesForNativeAd:self.nativeAd andNotify: self];
        }
        [self startTimeoutTask];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithAdLayout:(UIView*)nativeAdLayout iconView:(UIImageView*)nativeAdIcon titleView:(UILabel*)nativeAdTitle
                  descView:(UILabel*)nativeAdDesc mediaLayout:(UIView*)mediaLayout actBtn:(UIButton*)actBtn controller:(UIViewController*)controller
{
    NSLog(@" lwq, applovin nativeAd showAd");
    if (self.nativeAd == NULL) return false;
    CGRect mediaViewBounds = CGRectMake(0,0, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
    
    if(nativeAdLayout)
    {
        self.touchView = nativeAdLayout;
        nativeAdLayout.userInteractionEnabled = true;
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didTapNativeAd:)];
        [nativeAdLayout addGestureRecognizer:self.tapGesture];
    }

    if(mediaLayout!= NULL){
        if(self.nativeAd.videoURL && [self.nativeAd isVideoPrecached]){
            self.nativeAdPlayer = [[ALNativeAdVideoPlayer alloc] initWithMediaSource: self.nativeAd.videoURL];
            [self.nativeAdPlayer playVideo];
            self.nativeAdVideoView = self.nativeAdPlayer.videoView;
            [self.nativeAdVideoView.playerLayer setNeedsDisplay];
            self.nativeAdVideoView.backgroundColor = kVideoViewBackgroundColor;
            self.nativeAdVideoView.frame = mediaViewBounds;
            [mediaLayout addSubview:self.nativeAdVideoView];
        }else if(self.nativeAd.imageURL && [self.nativeAd isImagePrecached]){
            self.nativeAdImgView = [[UIImageView alloc] initWithFrame:mediaViewBounds];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:self.nativeAd.imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.nativeAdImgView.image = [UIImage imageWithData:imageData];
                });
            });
            [mediaLayout addSubview:self.nativeAdImgView];
        }
    }
    
    if(nativeAdIcon!=NULL){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:self.nativeAd.iconURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                nativeAdIcon.image = [UIImage imageWithData:imageData];
            });
        });
    }
    // Render native ads onto UIView
    if(nativeAdTitle!=NULL){
        nativeAdTitle.text = self.nativeAd.title;
    }
    if(nativeAdDesc != NULL){
        nativeAdDesc.text = self.nativeAd.descriptionText;
    }
    
    if(actBtn != NULL){
        actBtn.hidden = false;
        actBtn.userInteractionEnabled = false;
        [actBtn setTitle:self.nativeAd.ctaText forState:UIControlStateNormal];
    }
    
    [self trackImpression: self.nativeAd];
    return true;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, applovin nativeAd isAdLoaded, self.nativeAd = %@", self.nativeAd);
    return self.nativeAd!=NULL && self.isCached;
}

- (void)unregisterView {
    if(self.nativeAdPlayer){
        [self.nativeAdPlayer stopVideo];
        self.nativeAdPlayer = nil;
    }
    if(self.nativeAdVideoView)
    {
        [self.nativeAdVideoView removeFromSuperview];
        self.nativeAdVideoView = nil;
    }
    if(self.nativeAdImgView)
    {
        [self.nativeAdImgView removeFromSuperview];
        self.nativeAdImgView = nil;
    }
    if(self.nativeAd!=NULL)
    {
        self.nativeAd = NULL;
    }
    if(self.touchView)
    {
        [self.touchView removeGestureRecognizer:self.tapGesture];
        self.touchView = nil;
    }
    if(self.tapGesture){
        
        [self.tapGesture removeTarget:self action:@selector(didTapNativeAd:)];
        self.tapGesture = nil;
    }
}

- (void)didTapNativeAd:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"Redirecting from app icon click");
    if ( self.nativeAd )
    {
        [self.nativeAd launchClickTarget];
    }
}


#pragma mark - Native Ad Load Delegate

- (void)nativeAdService:(ALNativeAdService *)service didLoadAds:(NSArray *)ads
{

    // Callbacks may not happen on main queue
    dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Native ad loaded, assets not retrieved yet.");
        self.nativeAd = [ads firstObject];
        
        [[ALSdk shared].nativeAdService precacheResourcesForNativeAd:self.nativeAd andNotify: self];
    });
}

- (void)nativeAdService:(ALNativeAdService *)service didFailToLoadAdsWithError:(NSInteger)code
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Native ad failed to load with error code %d", (int)code);        self.isCached = false;
        self.isLoading = false;
        [self cancelTimeoutTask];
        [self notifyOnAdLoadFailedWithError:(int)code];
    });
}

#pragma mark - Native Ad Precache Delegate

- (void)nativeAdService:(ALNativeAdService *)service didPrecacheImagesForAd:(ALNativeAd *)ad
{
    NSLog( @"Native ad precached images");
    
}

- (void)nativeAdService:(ALNativeAdService *)service didPrecacheVideoForAd:(ALNativeAd *)ad
{
    // This delegate method will get called whether an ad actually has a video to precache or not
    // Callbacks may not happen on main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog( @"Native ad done precaching");
        self.isCached = true;
        [self cancelTimeoutTask];
        [self notifyOnAdLoaded];
    });
}

- (void)nativeAdService:(ALNativeAdService *)service didFailToPrecacheImagesForAd:(ALNativeAd *)ad withError:(NSInteger)errorCode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog( @"Native ad failed to precache images with error code %d", (int)errorCode);
    });
}

- (void)nativeAdService:(ALNativeAdService *)service didFailToPrecacheVideoForAd:(ALNativeAd *)ad withError:(NSInteger)errorCode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog( @"Native ad failed to precache video with error code %d", (int)errorCode);
        self.isCached = false;
        self.isLoading = false;
        [self cancelTimeoutTask];
        [self notifyOnAdLoadFailedWithError:(int)errorCode];
    });
}

- (void)trackImpression:(ALNativeAd *)ad
{
    // Callbacks may not happen on main queue
    [ad trackImpressionAndNotify: self];
    dispatch_async(dispatch_get_main_queue(), ^{
        // Impression tracked!
        [self notifyOnAdShowed];
    });
}

- (void)postbackService:(ALPostbackService *)postbackService didExecutePostback:(NSURL *)postbackURL
{
    // Callbacks may not happen on main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        // Impression tracked!
        [self notifyOnAdImpression];
    });
}

- (void)postbackService:(ALPostbackService *)postbackService didFailToExecutePostback:(nullable NSURL *)postbackURL errorCode:(NSInteger)errorCode
{
    // Callbacks may not happen on main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        // Impression could not be tracked. Retry the postback later.
        
    });
}

- (void)dealloc
{
    NSLog(@"lwq, EYApplovinNativeAdAdapter dealloc ");
    [self unregisterView];
}

@end
#endif /*APPLOVIN_ADS_ENABLED*/
