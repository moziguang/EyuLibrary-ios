//
//  EYNativeAdView.m
//  EyuLibrary-ios_Example
//
//  Created by qianyuan on 2018/9/30.
//  Copyright © 2018年 WeiqiangLuo. All rights reserved.
//

#import "EYNativeAdView.h"
#import "EYAdManager.h"
#import <Foundation/Foundation.h>


@interface EYNativeAdView()
@property(nonatomic,strong,nullable) EYNativeAdAdapter* adAdapter;
@property(nonatomic,strong) UIView* rootView;

@end

@implementation EYNativeAdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize rootView = _rootView;
@synthesize controller = _controller;
@synthesize nativeAdLayout = _nativeAdLayout;
@synthesize nativeAdTitle = _nativeAdTitle;
@synthesize nativeAdDesc = _nativeAdDesc;
@synthesize nativeAdIcon = _nativeAdIcon;
@synthesize mediaLayout = _mediaLayout;
@synthesize actBtn = _actBtn;
@synthesize closeBtn = _closeBtn;
@synthesize adAdapter = _adAdapter;
@synthesize isCanShow = _isCanShow;
@synthesize isNeedUpdate = _isNeedUpdate;

- (instancetype)initWithFrame:(CGRect)frame nibName:(NSString*)nibName
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.userInteractionEnabled = false;
        NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        UIView* rootView = [nibView firstObject];
        rootView.frame = frame;
        [self addSubview:rootView];
        self.rootView = rootView;
        
        if(self.actBtn){
            NSLog(@"lwq, EYNativeAdView initWithFrame self.actBtn = %@",self.actBtn);
            auto tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didTapNativeAd:)];
            [self.actBtn addGestureRecognizer:tapGesture];
        }
        
        if(self.closeBtn){
            NSLog(@"lwq, EYNativeAdView initWithFrame closeBtn = %@",self.closeBtn);
            auto closeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didTapCloseAd:)];
            [self.closeBtn addGestureRecognizer:closeTapGesture];
        }
    }
    return self;
}

-(EYNativeAdAdapter*) getAdapter{
    return self.adAdapter;
}

-(void) updateNativeAdAdapter:(EYNativeAdAdapter*)adapter
{
    [self unregisterView];
    self.adAdapter = adapter;
    if(self.adAdapter){
        if(self.mediaLayout){
            NSArray *subviews = self.mediaLayout.subviews;
            for(UIView* view:subviews){
                [view removeFromSuperview];
            }
        }
        [self.adAdapter showAdWithAdLayout:self.nativeAdLayout iconView:self.nativeAdIcon titleView:self.nativeAdTitle descView:self.nativeAdDesc mediaLayout:self.mediaLayout actBtn:self.actBtn controller:self.controller];
        self.isNeedUpdate = false;
        if(self.isCanShow && self.superview){
            [self.superview setHidden:NO];
        }
    }
}

-(void) unregisterView
{
    if(self.adAdapter)
    {
        [self.adAdapter unregisterView];
        self.adAdapter = nil;
    }
}

- (void)didTapNativeAd:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"lwq, default native ad Redirecting from app icon click");
    [[EYAdManager sharedInstance] onDefaultNativeAdClicked];
}

- (void)didTapCloseAd:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"lwq, close native ad ");
    self.isCanShow = NO;
    if(self.superview){
        [self.superview setHidden:YES];
    }
}

@end
