//
//  BaseViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"
#import "ParentConstant.h"

@class CustomIOS7AlertView;

@interface BaseViewController : UIViewController

NS_ASSUME_NONNULL_BEGIN
+(void)setBackGroud:(UIViewController *_Nonnull)viewController;
+(void)setTeacherBackGroud:(UIViewController *)viewController;
+(UIView *)setNavigationTitle:(NSString *)strTitle;
+(UIView *)setNavigationTitle:(NSString *)strTitle titleColor:(UIColor*)titleColor;
+(void)setNavigation:(UIViewController *)navigation title:(NSString *)strTitle;

+(void)formateButton:(UIButton *)btn withColor:(UIColor *)color  title:(NSString *)title;
+(void)formateButtonCyne:(UIButton *)btn title:(NSString *)title;
+(void)formateButtonCyne:(UIButton *)btn title:(NSString *)title withIcon:(NSString *)imgName withBgColor:(UIColor *)bgColor;
+(void)formateButtonCyne:(UIButton *)btn title:(NSString *)title withIcon:(NSString *)imgName titleColor:(UIColor *)textColor;
+(void)formateButtonYellow:(UIButton *)btn withColor:(UIColor *)color  title:(NSString *)title;
+(void)formateButton:(UIButton *)btn withBackgourdColor:(UIColor *)bcolor  withTextColor:(UIColor *)tcolor title:(NSString *)title;

+(void)formatButton:(UIButton *)btn withColor:(UIColor *)color  title:(NSString *)title withIcon:(NSString *)imgName;
+(void)formatButton:(UIButton *)btn withBgColor:(UIColor *)bgColor  title:(NSString *)title withIcon:(NSString *)imgName;

+(CGFloat)getHeightForText:(NSString *)text withFont:(UIFont *)font andWidth:(int)width;
+(void)getDropDownBtn:(UIButton *)btn withString:(NSString *)title;
+(void)getDropDownBtn:(UIButton *)btn withString:(NSString *)title width:(CGFloat)width;

+(void)setCynaColorDefultFontLbl:(UILabel *)lable;
+(void)setCynaColorDefultFontBtn:(UIButton *)btn;

+(void)getRoundRectTextField:(UITextField *)textField;
+(void)getRoundRectTextField:(UITextField *)textField withIcon:(NSString *)iconName andLable:(NSString *)lableText;
+(void)getRoundRectTextField:(UITextField *)textField withIcon:(NSString *)iconName;

+(UILabel *)getRowTitleLable:(int)width text:(NSString *)text;
+(UILabel *)getRowDetailLable:(int)width text:(NSString *)text;

+(void)setRoudRectImage:(UIImageView *)img;
+(void)setRoudRectImage:(UIImageView *)img radius:(CGFloat)radius borderColor:(UIColor*)borderColor;

+(void)setNavigationBack:(UIViewController *)navigation title:(NSString *)strTitle WithSel:(SEL)action;
+(void)setNavigationBack:(UIViewController *)navigation title:(NSString *)strTitle titleColor:(UIColor*)titleColor WithSel:(SEL)action;

+(void)setNavigationMenu:(UIViewController *)navigation title:(NSString *)strTitle WithSel:(SEL)action;
+(UIBarButtonItem *)getMenuButtonWithSel:(SEL)action addTarget:(nullable id)target;
+(UIBarButtonItem *)getBackButtonWithSel:(SEL _Nullable )action addTarget:(nullable id)target;
+(UIBarButtonItem *)getRightButtonWithSel:(SEL)action addTarget:(nullable id)target icon:(NSString *_Nullable)imgName;
+(UIBarButtonItem *)getBadgeRightButtonWithSel:(SEL _Nonnull )action addTarget:(nullable id)target icon:(NSString *)imgName;

+(CustomIOS7AlertView *_Nonnull)customAlertDisplay: (NSString *)msgClassObj;
+(CustomIOS7AlertView *)customAlertDisplay:(NSString *)msgClassObj Btns:(NSMutableArray *)btnArr;

NS_ASSUME_NONNULL_END
@end
