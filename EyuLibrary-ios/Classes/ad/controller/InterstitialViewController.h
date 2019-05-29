#import <UIKit/UIKit.h>

@interface InterstitialViewController : UIViewController

@property(nonatomic,strong) IBOutlet UIImageView* nativeAdIcon;
@property(nonatomic,strong) IBOutlet UILabel* nativeAdTitle;
@property(nonatomic,strong) IBOutlet UILabel* nativeAdDesc;
@property(nonatomic,strong) IBOutlet UIView* mediaLayout;
@property(nonatomic,strong) IBOutlet UIButton* actBtn;
@property(nonatomic,strong) IBOutlet UIButton* closeBtn;

@end
