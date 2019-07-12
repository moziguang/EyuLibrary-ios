//
//  EYViewController.h
//  EyuLibrary-ios
//
//  Created by WeiqiangLuo on 09/28/2018.
//  Copyright (c) 2018 WeiqiangLuo. All rights reserved.
//

@import UIKit;

@interface EYViewController : UIViewController

@property(nonatomic,strong) IBOutlet UIButton* gotoBtn;
@property(nonatomic,strong) IBOutlet UIButton* rewardAdBtn;
@property(nonatomic,strong) IBOutlet UIButton* interstitialAdBtn;
@property(nonatomic,strong) IBOutlet UIButton* nativeAdBtn;
@property(nonatomic,strong) IBOutlet UIButton* bannerBtn;

@property(nonatomic,strong) IBOutlet UIView* nativeRootView;
@property(nonatomic,strong) IBOutlet UIView* bannerView;


@end
