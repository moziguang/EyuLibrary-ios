//
//  EYViewController.m
//  EyuLibrary-ios
//
//  Created by WeiqiangLuo on 09/28/2018.
//  Copyright (c) 2018 WeiqiangLuo. All rights reserved.
//

#import "EYViewController.h"
#import "EYAdManager.h"
#import "EYAdConfig.h"
#import "EYRemoteConfigHelper.h"

@interface EYViewController ()

@end

@implementation EYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    EYAdConfig* adConfig = [[EYAdConfig alloc] init];
//    adConfig.adKeyData =  [RemoteConfigHelperIOS readFileWithName:@"ios_ad_key_setting"];
//    adConfig.adGroupData = [RemoteConfigHelperIOS readFileWithName:@"ios_ad_cache_setting"];
//    adConfig.adPlaceData = [RemoteConfigHelperIOS readFileWithName:@"ios_ad_setting"];
//    adConfig.maxTryLoadNativeAd = 7;
//    adConfig.maxTryLoadRewardAd = 7;
//    adConfig.maxTryLoadInterstitialAd = 7;
//
//    [[EYAdManager sharedInstance] setupWithConfig:adConfig];
//    UITapGestureRecognizer *gotoGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoNext:)];
//    [self.gotoBtn addGestureRecognizer:gotoGesture];
//    [gotoGesture setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *rewardAdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showRewardAd:)];
    [self.rewardAdBtn addGestureRecognizer:rewardAdGesture];
    [rewardAdGesture setNumberOfTapsRequired:1];

    
    UITapGestureRecognizer *interstitialAdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showInterstitialAd:)];
    [self.interstitialAdBtn addGestureRecognizer:interstitialAdGesture];
    [interstitialAdGesture setNumberOfTapsRequired:1];

    
    UITapGestureRecognizer *nativeAdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNativeAd:)];
    [self.nativeAdBtn addGestureRecognizer:nativeAdGesture];
    [nativeAdGesture setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *bannerGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBanner:)];
    [self.bannerBtn addGestureRecognizer:bannerGesture];
    [bannerGesture setNumberOfTapsRequired:1];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)gotoNext:(UITapGestureRecognizer *)gesture {
//    NSLog(@"showRewardAd");
//    //[[EYAdManager sharedInstance] showRewardVideoAd:@"REWORD_AD_OPEN_TREASURE" withViewController:self];
//}

- (void)showRewardAd:(UITapGestureRecognizer *)gesture {
    NSLog(@"showRewardAd");
    [[EYAdManager sharedInstance] showRewardVideoAd:@"reward_ad" withViewController:self];
}

- (void)showInterstitialAd:(UITapGestureRecognizer *)gesture {
    NSLog(@"showInterstitialAd");
    [[EYAdManager sharedInstance] showInterstitialAd:@"inter_ad" withViewController:self];
}

- (void)showNativeAd:(UITapGestureRecognizer *)gesture {
    NSLog(@"A showNativeAd");
    [[EYAdManager sharedInstance] showNativeAd:@"native_ad" withViewController:self viewGroup:self.nativeRootView];
}

- (void)showBanner:(UITapGestureRecognizer *)gesture {
    NSLog(@"A showBanner");
//    [[EYAdManager sharedInstance] showNativeAd:@"banner_ad" withViewController:self viewGroup:self.nativeRootView];
}

@end
