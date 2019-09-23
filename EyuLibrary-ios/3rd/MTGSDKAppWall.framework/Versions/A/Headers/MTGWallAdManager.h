//
//  MTGWallAdManager.h
//  MTGSDK
//
//  Created by Jomy on 15/10/14.
//

#define MTGAppWallSDKVersion @"5.7.1"


#import <Foundation/Foundation.h>


@interface MTGWallAdManager : NSObject

/*!
 @method
 
 @abstract Initialize the native ads manager.
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param viewController The UIViewController that will be used to present App Wall Controller. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our AppWall view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 */
- (nonnull instancetype)initWithUnitID:(nonnull NSString *)unitId
              presentingViewController:(nullable UIViewController *)viewController;


/*!
 @method
 
 @abstract Initialize the native ads manager.
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param navController The UINavigationController that will be used to push App Wall Controller. If not set, it will be the root viewController of your current UIWindow. But it may failed to push our AppWall view controller if your rootViewController is not a navigation controller. So set this property is necessary.
 */
- (nonnull instancetype)initWithUnitID:(nonnull NSString *)unitId
              withNavigationController:(nullable UINavigationController *)navController;

/**
 *
 @method
 
 @abstract present app wall modally or push app wall in your navigation controller. It depends on how you init the manager.
 */
- (void)showAppWall;


#define TAG_IMAGEVIEW 1111
#define TAG_REDVIEW 2222
/**
 *
 @method
 
 @abstract We will add a wall icon to the view you passed. Then the user can tap the icon to open the app wall. If you has your own imageView and redPointView, please use TAG_IMAGEVIEW and TAG_REDVIEW to tag them so we can handle the image in it and control the redpoint.
 
 @param view The view to put the wall icon in.
 @param image The default image of the wall icon. But the icon you set in our portal will replace the icon you set here.
 
 @discussion The Wall Icon will be exact same size with the view you passed by.
 */
- (void)loadWallIconToView:(nonnull UIView *)view withDefaultIconImage:(nonnull UIImage *)image;

/*!
 @method
 
 @abstract Set the app wall's navigation bar's tint color.
 
 @param color The tint color of the navigation bar of app wall.
 
 @discussion It will override the result of method - (void)setAppWallNavBarBackgroundImage:(nonnull UIImage *)image.
 */
- (void)setAppWallNavBarTintColor:(nonnull UIColor *)color;

/*!
 @method
 
 @abstract Set the app wall's navigation bar's background image.
 
 @param image The background image of the navigation bar of app wall.
 
 @discussion It will override the result of method - (void)setAppWallNavBarTintColor:(nonnull UIColor *)color.
 */
- (void)setAppWallNavBarBackgroundImage:(nonnull UIImage *)image;

/*!
 @method
 
 @abstract Set the app wall's navigation bar's title.
 
 @param title The title of the navigation bar of app wall.
 @param color The title color of the navigation bar of app wall.

 @discussion It will override the result of method - (void)setAppWallTitleImage:(nonnull UIImage *)image.
 */
- (void)setAppWallTitle:(nonnull NSString *)title
             titleColor:(nonnull UIColor *)color;

/*!
 @method
 
 @abstract A custom image displayed in the center of the app wall's navigation bar.
 
 @param image The title image of the navigation bar of app wall.
 
 @discussion It will override the result of method - (void)setAppWallTitle:(nonnull NSString *)title titleColor:(nonnull UIColor *)color.
 */
- (void)setAppWallTitleImage:(nonnull UIImage *)image;

/*!
 @method
 
 @abstract Custom the image of the close button displayed on the right of the app wall's navigation bar.
 
 @param image The image of the close button on state UIControlStateNormal.
 @param highlightedImage The image of the close button on state UIControlStateHighlighted.

 */
- (void)setAppWallCloseButtonImage:(nonnull UIImage *)image
                  highlightedImage:(nullable UIImage *)highlightedImage;



@end
