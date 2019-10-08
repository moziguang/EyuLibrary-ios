//
//  EYMtgNativeAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#include "EYMtgNativeAdAdapter.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDK/MTGNativeAdManager.h>
#import <MTGSDK/MTGAdChoicesView.h>

@interface EYMtgNativeAdAdapter()<MTGNativeAdManagerDelegate,MTGMediaViewDelegate>

@property(nonatomic,strong)MTGNativeAdManager *nativeAd;
@property(nonatomic,strong)MTGCampaign *campaign;
@property(nonatomic,strong)UIView *nativeView;
@property(nonatomic,strong)MTGMediaView *mediaView;
@property(nonatomic,strong)MTGAdChoicesView *adChoicesView;

@end

@implementation EYMtgNativeAdAdapter

@synthesize nativeAd = _nativeAd;
@synthesize campaign = _campaign;
@synthesize nativeView = _nativeView;
@synthesize mediaView = _mediaView;
@synthesize adChoicesView = _adChoicesView;

-(void) loadAd
{
    NSLog(@" lwq, mtg nativeAd loadAd nativeAd = %@, key = %@.", self.campaign, self.adKey.key);
    if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else if(self.nativeAd == NULL)
    {
        self.nativeAd = [[MTGNativeAdManager alloc] initWithUnitID:self.adKey.key fbPlacementId:nil supportedTemplates:@[[MTGTemplate templateWithType:MTGAD_TEMPLATE_BIG_IMAGE adsNum:1]] autoCacheImage:NO adCategory:MTGAD_CATEGORY_ALL presentingViewController:nil];
        self.nativeAd.delegate = self;
        
        self.isLoading = true;
        [self.nativeAd loadAds];
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
    NSLog(@" lwq, mtg nativeAd showAd self.nativeAd = %@.", self.nativeAd);
    if ([self isAdLoaded]) {
        
        [self.nativeAd registerViewForInteraction:nativeAdLayout withCampaign:self.campaign];
        
        if(mediaLayout!= NULL){
            CGRect mediaViewBounds = CGRectMake(0,0, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
            self.mediaView = [[MTGMediaView alloc] initWithFrame:mediaViewBounds];
            self.mediaView.autoLoopPlay = YES;
            self.mediaView.videoRefresh = YES;
            self.mediaView.allowFullscreen = YES;
            self.mediaView.delegate = self;
            [self.mediaView setMediaSourceWithCampaign:self.campaign unitId:self.adKey.key];
            [mediaLayout addSubview:self.mediaView];
        }
        
        if (!CGSizeEqualToSize(self.campaign.adChoiceIconSize, CGSizeZero)) {
            CGRect frame = CGRectMake(0,0, self.campaign.adChoiceIconSize.width, self.campaign.adChoiceIconSize.height);
            self.adChoicesView = [[MTGAdChoicesView alloc] initWithFrame:frame];
            self.adChoicesView.hidden = NO;
            self.adChoicesView.campaign = self.campaign;
            [nativeAdLayout addSubview:self.adChoicesView];
        }
        
        if(nativeAdIcon!=NULL){
            nativeAdIcon.image = nil;
            [self.campaign loadIconUrlAsyncWithBlock:^(UIImage *image) {
                if (image) {
                    [nativeAdIcon setImage:image];
                }
            }];
        }
        
        // Render native ads onto UIView
        if(nativeAdTitle!=NULL){
            nativeAdTitle.text = self.campaign.appName;
        }
        
        if(nativeAdDesc != NULL){
            nativeAdDesc.text = self.campaign.appDesc;
        }
        
        if(actBtn != NULL){
            actBtn.hidden = false;
            [actBtn setTitle:self.campaign.adCall forState:UIControlStateNormal];
        }
        self.nativeView = nativeAdLayout;
    }
    
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@" lwq, mtg nativeAd campaign ? = %@", self.campaign);
    return self.campaign!=nil;
}


- (void)unregisterView {
    @try {
        if(self.nativeAd != NULL && self.mediaView){
            [self.mediaView removeFromSuperview];
            self.mediaView = nil;
        }
        
        if(self.adChoicesView){
            [self.adChoicesView removeFromSuperview];
            self.adChoicesView = nil;
        }
        
        if(self.nativeAd != NULL)
        {
            [self.nativeAd unregisterView:self.nativeView];
            self.nativeAd.delegate = NULL;
            self.nativeAd = NULL;
            self.nativeView = NULL;
        }
    } @catch (NSException *exception) {
        NSLog(@"EXCEPTION THROW: %@", exception);
    }
    
}

#pragma mark MediaView and AdManger Click delegate

- (void)nativeAdDidClick:(MTGCampaign *)nativeAd nativeManager:(nonnull MTGNativeAdManager *)nativeManager
{
    NSLog(@"lwq, mtg Registerview Ad is clicked");
    [self notifyOnAdClicked];
}

- (void)nativeAdDidClick:(MTGCampaign *)nativeAd mediaView:(nonnull MTGMediaView *)mediaView
{
    NSLog(@"lwq, mtg Registerview Ad is clicked");
    [self notifyOnAdClicked];
}

#pragma mark AdManger delegate
- (void)nativeAdsLoaded:(NSArray *)nativeAds nativeManager:(nonnull MTGNativeAdManager *)nativeManager
{
    NSLog(@"lwq, mtg nativeAdDidLoad");
    if(nativeAds.count > 0){
        self.isLoading = false;
        self.campaign = nativeAds[0];
        [self cancelTimeoutTask];
        [self notifyOnAdLoaded];
    }
}

- (void)nativeAdsFailedToLoadWithError:(NSError *)error nativeManager:(nonnull MTGNativeAdManager *)nativeManager
{
    NSLog(@"lwq,mtg Native ad failed to load with error: %@", error);
    self.isLoading = false;
    if(self.nativeAd != NULL)
    {
        self.nativeAd.delegate = NULL;
        self.nativeAd = NULL;
        self.campaign = NULL;
    }
    
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)nativeAdImpressionWithType:(MTGAdSourceType)type mediaView:(MTGMediaView *)mediaView;
{
    NSLog(@"lwq,mtg nativeAdImpressionWithType");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)dealloc
{
    NSLog(@"lwq, EYMtgNativeAdAdapter dealloc ");
    [self unregisterView];
}

@end

#endif /*BYTE_DANCE_ONLY*/
