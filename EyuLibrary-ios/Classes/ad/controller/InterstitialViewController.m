#import "InterstitialViewController.h"

@interface InterstitialViewController()

@end

@implementation InterstitialViewController

@synthesize nativeAdTitle = _nativeAdTitle;
@synthesize nativeAdDesc = _nativeAdDesc;
@synthesize nativeAdIcon = _nativeAdIcon;
@synthesize mediaLayout = _mediaLayout;
@synthesize actBtn = _actBtn;
@synthesize closeBtn = _closeBtn;

#pragma mark - lifeCycle

- (void)loadView {
    // Set EAGLView as view of RootViewController
    self.view = [[UIView alloc] init];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view.frame = bounds;
    
    self.mediaLayout = [[UIView alloc] initWithFrame:bounds];
    [self.view addSubview:self.mediaLayout];
    
    self.nativeAdTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220, 35)];
    [self.view addSubview:self.nativeAdTitle];
    
    self.nativeAdIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
    [self.view addSubview:self.nativeAdIcon];
    
    self.nativeAdDesc = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 230, 20)];
    [self.view addSubview:self.nativeAdDesc];

    self.actBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 10, 80, 120)];
    self.actBtn.titleLabel.text = @"Install";
    [self.view addSubview:self.actBtn];

    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 110, 80, 120)];
    self.closeBtn.titleLabel.text = @"Close";
    [self.view addSubview:self.closeBtn];
}

@end
