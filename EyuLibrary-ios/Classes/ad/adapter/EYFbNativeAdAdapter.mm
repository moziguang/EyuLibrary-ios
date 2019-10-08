//
//  FbInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifndef BYTE_DANCE_ONLY

#include "EYFbNativeAdAdapter.h"


@implementation EYFbNativeAdAdapter

@synthesize adChoicesView = _adChoicesView;
@synthesize fbMediaView = _fbMediaView;
@synthesize nativeAd = _nativeAd;
@synthesize fbIconView = _fbIconView;



-(void) loadAd
{
    NSLog(@" lwq, fb nativeAd loadAd nativeAd = %@, key = %@.", self.nativeAd, self.adKey.key);
    if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else if(self.nativeAd == NULL)
    {
        self.nativeAd = [[FBNativeAd alloc] initWithPlacementID:self.adKey.key];
        self.nativeAd.delegate = self;

        self.fbMediaView = [[FBMediaView alloc]init];
        [self.fbMediaView setBackgroundColor:[UIColor blackColor]];
        
        self.fbIconView = [[FBAdIconView alloc] init];
        
        self.adChoicesView = [[FBAdChoicesView alloc] init];
        self.isLoading = true;
        [self.nativeAd loadAd];
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
    NSLog(@" lwq, fb nativeAd showAd self.nativeAd = %@.", self.nativeAd);
    if ([self.nativeAd isAdValid]) {
        [self.nativeAd unregisterView];
        
        self.adChoicesView.nativeAd = self.nativeAd;
        [nativeAdLayout addSubview:self.adChoicesView];
        self.adChoicesView.corner = UIRectCornerTopLeft;
        NSMutableArray<UIView*>* clickViews = [[NSMutableArray alloc] init];
        
        if(mediaLayout!= NULL){
            CGRect mediaViewBounds = CGRectMake(0,0, mediaLayout.frame.size.width, mediaLayout.frame.size.height);
            self.fbMediaView.frame = mediaViewBounds;
            [mediaLayout addSubview:self.fbMediaView];
//            [self.fbMediaView setNativeAd:self.nativeAd];
        }
        
        if(nativeAdIcon!=NULL){
            CGRect iconViewBounds = CGRectMake(0,0, nativeAdIcon.frame.size.width, nativeAdIcon.frame.size.height);
            self.fbIconView.frame = iconViewBounds;
            [nativeAdIcon addSubview:self.fbIconView];
            [clickViews addObject:self.fbIconView];
        }
        // Render native ads onto UIView
        if(nativeAdTitle!=NULL){
            //nativeAdTitle.text = self->nativeAd.headline;
            nativeAdTitle.text = self.nativeAd.advertiserName;
            [clickViews addObject:nativeAdTitle];
        }
        if(nativeAdDesc != NULL){
            nativeAdDesc.text = self.nativeAd.socialContext;
            [clickViews addObject:nativeAdDesc];
        }
        
        if(actBtn != NULL){
            actBtn.hidden = false;
            [actBtn setTitle:self.nativeAd.callToAction forState:UIControlStateNormal];
            [clickViews addObject:actBtn];
        }
        
        [self.nativeAd registerViewForInteraction:nativeAdLayout mediaView:self.fbMediaView iconView:self.fbIconView viewController:controller clickableViews:clickViews];
    }
    
    return false;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = self.nativeAd!=NULL &&[self.nativeAd isAdValid];
    NSLog(@" lwq, fb nativeAd isAdLoaded ? = %d", isAdLoaded);
    return isAdLoaded;
}


- (void)unregisterView {
    if(self.nativeAd != NULL)
    {
        [self.nativeAd unregisterView];
        self.nativeAd.delegate = NULL;
        self.nativeAd = NULL;
    }
    if(self.adChoicesView != NULL)
    {
        [self.adChoicesView removeFromSuperview];
        self.adChoicesView = NULL;
    }
    if(self.fbMediaView != NULL)
    {
        [self.fbMediaView removeFromSuperview];
        self.fbMediaView = NULL;
    }
    if(self.fbIconView != NULL)
    {
        [self.fbIconView removeFromSuperview];
        self.fbIconView = NULL;
    }
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    NSLog(@"lwq,fb Native ad failed to load with error: %@", error);
    self.isLoading = false;
    if(self.nativeAd != NULL)
    {
        [self.nativeAd unregisterView];
        self.nativeAd.delegate = NULL;
        self.nativeAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    NSLog(@"lwq, nativeAdDidLoad");
//    self.isLoading = false;
//    [self cancelTimeoutTask];
//    [self notifyOnAdLoaded];
}

/**
 Sent when an FBNativeAd has succesfully downloaded all media
 */
- (void)nativeAdDidDownloadMedia:(FBNativeAd *)nativeAd
{
    NSLog(@"lwq, nativeAdDidDownloadMedia");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

/**
  Sent immediately before the impression of an FBNativeAd object will be logged.

 @param nativeAd An FBNativeAd object sending the message.
 */
- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd
{
    NSLog(@"lwq, fb nativeAdWillLogImpression");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

- (void)mediaViewDidLoad:(FBMediaView *)mediaView
{
    CGFloat currentAspect = mediaView.frame.size.width / mediaView.frame.size.height;
    NSLog(@"lwq, current aspect of media view: %f", currentAspect);
    
    CGFloat actualAspect = mediaView.aspectRatio;
    NSLog(@"lwq, actual aspect of media view: %f", actualAspect);
    [mediaView applyNaturalWidth];
}

- (void)dealloc
{
    NSLog(@"lwq, FbNativeAdAdapter dealloc ");
    
    [self unregisterView];
}

@end
#endif /*BYTE_DANCE_ONLY*/
