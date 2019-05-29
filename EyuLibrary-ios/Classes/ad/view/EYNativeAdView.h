//
//  EYNativeAdView.h
//  EyuLibrary-ios_Example
//
//  Created by qianyuan on 2018/9/30.
//  Copyright © 2018年 WeiqiangLuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYNativeAdAdapter.h"
#import "EYAdManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface EYNativeAdView : UIView

@property(nonatomic,weak) IBOutlet UIViewController* controller;
@property(nonatomic,strong) IBOutlet UIView* nativeAdLayout;
@property(nonatomic,strong) IBOutlet UIImageView* nativeAdIcon;
@property(nonatomic,strong) IBOutlet UILabel* nativeAdTitle;
@property(nonatomic,strong) IBOutlet UILabel* nativeAdDesc;
@property(nonatomic,strong) IBOutlet UIView* mediaLayout;
@property(nonatomic,strong) IBOutlet UIButton* actBtn;
@property(nonatomic,strong) IBOutlet UIView* closeBtn;
@property(nonatomic,assign) bool isCanShow;
@property(nonatomic,assign) bool isNeedUpdate;

- (instancetype)initWithFrame:(CGRect)frame nibName:(NSString*)nibName;

-(EYNativeAdAdapter*) getAdapter;
-(void) updateNativeAdAdapter:(EYNativeAdAdapter*)adapter;
-(void) unregisterView;


@end

NS_ASSUME_NONNULL_END
