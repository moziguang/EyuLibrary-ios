//
//  EYViewControllerB.m
//  EyuLibrary-ios
//
//  Created by WeiqiangLuo on 09/28/2018.
//  Copyright (c) 2018 WeiqiangLuo. All rights reserved.
//

#import "EYViewControllerB.h"
#import "EYAdManager.h"
#import "EYAdConfig.h"
#import "EYRemoteConfigHelper.h"

@interface EYViewControllerB ()

@end

@implementation EYViewControllerB

@synthesize nativeAdRootView1 = _nativeAdRootView1;
@synthesize nativeAdRootView2 = _nativeAdRootView2;
@synthesize rewardAdBtn = _rewardAdBtn;
@synthesize interstitialAdBtn = _interstitialAdBtn;
@synthesize backBtn = _backBtn;
@synthesize nativeAdBtn = _nativeAdBtn;
@synthesize nativeAdBtn2 = _nativeAdBtn2;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    UITapGestureRecognizer *backGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)];
//    [self.backBtn addGestureRecognizer:backGesture];
//    [backGesture setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *rewardAdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showRewardAd:)];
    [self.rewardAdBtn addGestureRecognizer:rewardAdGesture];
    [rewardAdGesture setNumberOfTapsRequired:1];

    
    UITapGestureRecognizer *interstitialAdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showInterstitialAd:)];
    [self.interstitialAdBtn addGestureRecognizer:interstitialAdGesture];
    [interstitialAdGesture setNumberOfTapsRequired:1];

    
    UITapGestureRecognizer *nativeAdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNativeAd:)];
    [self.nativeAdBtn addGestureRecognizer:nativeAdGesture];
    [nativeAdGesture setNumberOfTapsRequired:1];

    UITapGestureRecognizer *nativeAd2Gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNativeAd2:)];
    [self.nativeAdBtn2 addGestureRecognizer:nativeAd2Gesture];
    [nativeAd2Gesture setNumberOfTapsRequired:1];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(UITapGestureRecognizer *)gesture {
    NSLog(@"back");
    //[[EYAdManager sharedInstance] showRewardVideoAd:@"REWORD_AD_OPEN_TREASURE" withViewController:self];
}

- (void)showRewardAd:(UITapGestureRecognizer *)gesture {
    NSLog(@"showRewardAd");
    [[EYAdManager sharedInstance] showRewardVideoAd:@"REWORD_AD_OPEN_TREASURE" withViewController:self];
}

- (void)showInterstitialAd:(UITapGestureRecognizer *)gesture {
    NSLog(@"showInterstitialAd");
    [[EYAdManager sharedInstance] showInterstitialAd:@"INTER_AD_PLAY" withViewController:self];
}

- (void)showNativeAd:(UITapGestureRecognizer *)gesture {
    NSLog(@"showNativeAd");
    [[EYAdManager sharedInstance] showNativeAd:@"NATIVE_AD_1" withViewController:self viewGroup:self.nativeAdRootView1];
}

- (void)showNativeAd2:(UITapGestureRecognizer *)gesture {
    NSLog(@"showNativeAd2");
    [[EYAdManager sharedInstance] showNativeAd:@"NATIVE_AD_2" withViewController:self viewGroup:self.nativeAdRootView2];

}


@end
