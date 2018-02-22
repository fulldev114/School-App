//
//  BaseViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "BaseViewController.h"
#import "UIBarButtonItem+Badge.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
}
+(void)setBackGroud:(UIViewController *)viewController {
	
	UIImage *backgroudImage = [UIImage imageNamed:@"background"];
	
	if (IS_IPHONE_5) {
		backgroudImage = [UIImage imageNamed:@"background-iphone5"];
	}
	
	viewController.view.backgroundColor = [UIColor colorWithPatternImage:backgroudImage];
	
	//viewController.view.backgroundColor = APP_BACKGROUD_COLOR;
}

+(void)setTeacherBackGroud:(UIViewController *)viewController {
	
	UIImage *backgroudImage = [UIImage imageNamed:@"teacher-background"];
	
	if (IS_IPHONE_5) {
		backgroudImage = [UIImage imageNamed:@"teacher-background-iphone5"];
	}
	
	viewController.view.backgroundColor = [UIColor colorWithPatternImage:backgroudImage];
	
	//viewController.view.backgroundColor = APP_BACKGROUD_COLOR;
}

+(UIView *)setNavigationTitle:(NSString *)strTitle {
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 180, 40)];
	
	UILabel *lblNavigation = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 35)];
	[lblNavigation setText:strTitle];
	[lblNavigation setBackgroundColor:[UIColor clearColor]];
	[lblNavigation setFont:FONT_NAVIGATION_TITLE];
	lblNavigation.textColor = COLOR_NAVIGATION_BAR_TEXT;
	[lblNavigation setTextAlignment:NSTextAlignmentCenter];
	lblNavigation.font = FONT_BTN_TITLE_18;
	[view addSubview:lblNavigation];
	return view;
}

+(UIView *)setNavigationTitle:(NSString *)strTitle titleColor:(UIColor*)titleColor {
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 180, 40)];
	
	UILabel *lblNavigation = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 35)];
	[lblNavigation setText:strTitle];
	[lblNavigation setBackgroundColor:[UIColor clearColor]];
	[lblNavigation setFont:FONT_NAVIGATION_TITLE];
	lblNavigation.textColor = titleColor;
	[lblNavigation setTextAlignment:NSTextAlignmentCenter];
	lblNavigation.font = FONT_BTN_TITLE_18;
	[view addSubview:lblNavigation];
	return view;
}

+(void)setNavigation:(UIViewController *)navigation title:(NSString *)strTitle{
	
	//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 180, 40)];
	//
	//    UILabel *lblNavigation = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 35)];
	//    [lblNavigation setText:strTitle];
	//    [lblNavigation setBackgroundColor:[UIColor clearColor]];
	//    [lblNavigation setFont:FONT_NAVIGATION_TITLE];
	//    lblNavigation.textColor = COLOR_NAVIGATION_BAR_TEXT;
	//    [lblNavigation setTextAlignment:NSTextAlignmentCenter];
	//
	//    [view addSubview:lblNavigation];
	[navigation.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"]
														forBarMetrics:UIBarMetricsDefault];
	navigation.navigationController.navigationBar.shadowImage = [UIImage new];
	navigation.navigationController.navigationBar.translucent = YES;
	
	
	[navigation.navigationItem setTitleView:[BaseViewController setNavigationTitle:strTitle]];
}

+(void)setNavigationBack:(UIViewController *)navigation title:(NSString *)strTitle WithSel:(SEL)action {
	
	[navigation.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"]
														forBarMetrics:UIBarMetricsDefault];
	navigation.navigationController.navigationBar.shadowImage = [UIImage new];
	navigation.navigationController.navigationBar.translucent = YES;
	
	[navigation.navigationItem setTitleView:[BaseViewController setNavigationTitle:strTitle]];
	
	navigation.navigationItem.leftBarButtonItem = [self getBackButtonWithSel:action addTarget:navigation];
}

+(void)setNavigationBack:(UIViewController *)navigation title:(NSString *)strTitle titleColor:(UIColor*)titleColor WithSel:(SEL)action {
	
	[navigation.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"]
														forBarMetrics:UIBarMetricsDefault];
	navigation.navigationController.navigationBar.shadowImage = [UIImage new];
	navigation.navigationController.navigationBar.translucent = YES;
	
	[navigation.navigationItem setTitleView:[BaseViewController setNavigationTitle:strTitle titleColor:titleColor]];
	
	navigation.navigationItem.leftBarButtonItem = [self getBackButtonWithSel:action addTarget:navigation];
}

+(void)setNavigationMenu:(UIViewController *)navigation title:(NSString *)strTitle WithSel:(SEL)action {
	
	[navigation.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"]
														forBarMetrics:UIBarMetricsDefault];
	navigation.navigationController.navigationBar.shadowImage = [UIImage new];
	navigation.navigationController.navigationBar.translucent = YES;
	
	[navigation.navigationItem setTitleView:[BaseViewController setNavigationTitle:strTitle]];
	
	navigation.navigationItem.leftBarButtonItem = [self getMenuButtonWithSel:action addTarget:navigation];
}

+(UIBarButtonItem *)getMenuButtonWithSel:(SEL)action addTarget:(nullable id)target {
	
	UIButton *btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnMenu setFrame:CGRectMake(15, 32, 25 , 25)];
	[btnMenu addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIImage *image = [UIImage imageNamed:@"menu-icon.png"];
	
	[btnMenu setBackgroundImage:image forState:UIControlStateNormal];
	[btnMenu setBackgroundImage:image forState:UIControlStateHighlighted];
	
	btnMenu.contentMode = UIViewContentModeCenter;
	
	UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
	
	return menuButton;
}

+(UIBarButtonItem *)getRightButtonWithSel:(SEL)action addTarget:(nullable id)target icon:(NSString *)imgName{
	
	UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[btnRight setFrame:CGRectMake(0, 0, 25, 25)];
	[btnRight addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIImage *image = [UIImage imageNamed:imgName];
	
	[btnRight setBackgroundImage:image forState:UIControlStateNormal];
	[btnRight setBackgroundImage:image forState:UIControlStateHighlighted];
	
	btnRight.contentMode = UIViewContentModeCenter;
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
	
	return rightButton;
}

+(UIBarButtonItem *)getBadgeRightButtonWithSel:(SEL)action addTarget:(nullable id)target icon:(NSString *)imgName{
	
	UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[btnRight setFrame:CGRectMake(0, 0, 25, 25)];
	[btnRight addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIImage *image = [UIImage imageNamed:imgName];
	
	[btnRight setBackgroundImage:image forState:UIControlStateNormal];
	[btnRight setBackgroundImage:image forState:UIControlStateHighlighted];
	
	btnRight.contentMode = UIViewContentModeCenter;
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
	rightButton.badgeBGColor = [UIColor colorWithRed:255/255.0f green:0.0f blue:59/255.0f alpha:0.0f];
	return rightButton;
}

+(UIBarButtonItem *)getBackButtonWithSel:(SEL)action addTarget:(nullable id)target {
	
	UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[btnBack setFrame:CGRectMake(0, 0, 25, 25)];
	[btnBack addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	UIImage *image = [UIImage imageNamed:@"back.png"];
	btnBack.contentMode = UIViewContentModeCenter;
	[btnBack setBackgroundImage:image forState:UIControlStateNormal];
	[btnBack setBackgroundImage:image forState:UIControlStateHighlighted];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
	return backButton;
}

+(void)formateButtonCyne:(UIButton *)btn title:(NSString *)title withIcon:(NSString *)imgName withBgColor:(UIColor *)bgColor {
	
	btn.titleLabel.font = FONT_BTN_TITLE_15;
	
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	// the space between the image and text
	CGFloat spacing;
	
	if (btn.tag == 1) {
		if (IS_IPAD) {
			spacing = 60.0;
		}
		else {
			spacing = 45.0;
		}
	}
	else if(btn.tag == 2){
		
		if (IS_IPAD) {
			spacing = 150.0;
		}
		else {
			spacing = 110.0;
		}
	}
	else if(btn.tag == 3){
		spacing = 30.0;
	}
	else if(btn.tag == 4){
		spacing = 120.0;
	}
	else if(btn.tag == 15){
		if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
			spacing = 100.0;
		}
		else {
			spacing = 70.0;
		}
	}
	else {
		spacing = 10.0;
	}
	// lower the text and push it left so it appears centered
	//  below the image
	//    CGSize imageSize = btn.imageView.image.size;
	//    btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
	//
	//    // raise the image and push it right so it appears centered
	//    //  above the text
	//    CGSize titleSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: btn.titleLabel.font}];
	//    btn.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
	
	//    CGSize imageSize = btn.imageView.frame.size;
	//    CGSize titleSize = btn.titleLabel.frame.size;
	
	//    CGFloat totalWidth = (imageSize.width + titleSize.width + spacing);
	//
	//    btn.imageEdgeInsets = UIEdgeInsetsMake(0.0f,titleSize.width,0.0f,(totalWidth - imageSize.width));
	//
	//    btn.titleEdgeInsets = UIEdgeInsetsMake(0.0f,(totalWidth - titleSize.width),0.0f,imageSize.width);
	
	
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width, 0, btn.imageView.frame.size.width);
	btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width +spacing, 0, -btn.titleLabel.frame.size.width);
	
	//    UIImageView *appendIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, titleSize.width +spacing, 25)];
	//    appendIcon.image = [UIImage imageNamed:@"next-arrow.png"];
	//    [btn addSubview:appendIcon];
	btn.backgroundColor = bgColor;
	btn.layer.cornerRadius = 5;
	btn.clipsToBounds = YES;
}

+(void)formateButtonCyne:(UIButton *)btn title:(NSString *)title withIcon:(NSString *)imgName titleColor:(UIColor *)textColor {
	
	//    if (IS_IPAD) {
	//        btn.titleLabel.font = FONT_25_BOLD;
	//    }
	//    else {
	//
	//    }
	btn.titleLabel.font = FONT_16_BOLD;
	
	btn.titleLabel.textAlignment = NSTextAlignmentCenter;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	
	[btn setTitleColor:textColor forState:UIControlStateNormal];
	
	btn.backgroundColor = [UIColor clearColor];
	
	CGFloat spacing;
	
	if (btn.tag == 1) {
		// the space between the image and text
		if (IS_IPHONE_5) {
			spacing = 10.0;
		}
		else {
			spacing = 15.0;
		}
	}
	else {
		// the space between the image and text
		spacing = 6.0;
	}
	
	// lower the text and push it left so it appears centered
	//  below the image
	CGSize imageSize = btn.imageView.image.size;
	btn.titleEdgeInsets = UIEdgeInsetsMake(
										   0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
	
	// raise the image and push it right so it appears centered
	//  above the text
	CGSize titleSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: btn.titleLabel.font}];
	btn.imageEdgeInsets = UIEdgeInsetsMake(
										   - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}
+(void)formateButtonCyne:(UIButton *)btn title:(NSString *)title {
	
	btn.titleLabel.font = FONT_BTN_TITLE_15;
	
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	// the space between the image and text
	CGFloat spacing = 10.0;
	
	btn.backgroundColor = BTN_BACKGROUD_COLOR;
	btn.layer.cornerRadius = 5;
	btn.clipsToBounds = YES;
}

+(void)formateButton:(UIButton *)btn withColor:(UIColor *)color  title:(NSString *)title {
	
	btn.titleLabel.font = FONT_BTN_TITLE_15;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:color forState:UIControlStateNormal];
	btn.backgroundColor = [UIColor clearColor];
	btn.layer.borderWidth = 1.0f;
	btn.layer.borderColor = [[UIColor whiteColor] CGColor];
	btn.layer.cornerRadius = 5;
	btn.clipsToBounds = YES;
}

+(void)formatButton:(UIButton *)btn withColor:(UIColor *)color  title:(NSString *)title withIcon:(NSString *)imgName{
	
	btn.titleLabel.font = FONT_BTN_TITLE_18;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:color forState:UIControlStateNormal];
	btn.backgroundColor = [UIColor clearColor];
	btn.layer.borderWidth = 2.0f;
	btn.layer.borderColor = [color CGColor];
	btn.layer.cornerRadius = 5;
	btn.clipsToBounds = YES;
	
	[btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	
	// the space between the image and text
	CGFloat spacing = 10;
	if (IS_IPAD)
	{
		spacing = 15;
	}
	
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0,0);
	btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
}


+(void)formateButtonYellow:(UIButton *)btn withColor:(UIColor *)color  title:(NSString *)title {
	
	btn.titleLabel.font = FONT_18_BOLD;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:color forState:UIControlStateNormal];
	btn.backgroundColor = TEXT_COLOR_LIGHT_YELLOW;
	btn.layer.borderWidth = 1.0f;
	btn.layer.borderColor = [[UIColor clearColor] CGColor];
	btn.layer.cornerRadius = 5;
	btn.clipsToBounds = YES;
}

+(void)formateButton:(UIButton *)btn withBackgourdColor:(UIColor *)bcolor  withTextColor:(UIColor *)tcolor title:(NSString *)title {
	
	btn.titleLabel.font = FONT_18_BOLD;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:tcolor forState:UIControlStateNormal];
	btn.backgroundColor = bcolor;
    btn.layer.cornerRadius = 5;

}

+(void)formatButton:(UIButton *)btn withBgColor:(UIColor *)bgColor  title:(NSString *)title withIcon:(NSString *)imgName{
	
	btn.titleLabel.font = FONT_BTN_TITLE_18;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	btn.backgroundColor = bgColor;
	btn.layer.cornerRadius = 5;
	btn.clipsToBounds = YES;
	
	[btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	
	// the space between the image and text
	CGFloat spacing = 10;
	if (IS_IPAD)
	{
		spacing = 15;
	}
	
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0,0);
	btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
}


+(CGFloat)getHeightForText:(NSString *)text withFont:(UIFont *)font andWidth:(int)width {
	
	//    CGSize maximumSize = CGSizeMake(width, CGFLOAT_MAX);
	//
	//    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
	//    CGSize boundingBox = [text boundingRectWithSize:maximumSize
	//                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:context].size;
	//
	//    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
	//
	//    return size.height;
	
	return 50.0f;
}

+(void)getDropDownBtn:(UIButton *)btn withString:(NSString *)title {
	
	btn.layer.borderWidth = 1.0f;
	btn.layer.borderColor = [[UIColor whiteColor] CGColor];
	
	btn.layer.cornerRadius = 5.0f;
	btn.clipsToBounds = YES;
	
	btn.backgroundColor = [UIColor clearColor];
	[btn setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
	btn.titleLabel.font = FONT_18_SEMIBOLD;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
	
	CGFloat btnWidth = btn.frame.size.width;
	
	if (IS_IPAD) {
		if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
			btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -350);
			btn.titleEdgeInsets = UIEdgeInsetsMake(0, -70, 0, 0);
		}
		else {
			btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -400);
			btn.titleEdgeInsets = UIEdgeInsetsMake(0, -70, 0, 0);
		}
	}
	else {
  //      btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, btnWidth > 70? -220 : -60);
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, btnWidth > 70? -70: -40, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -220);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, btnWidth > 70? -70: -40, 0, 0);

	}
	
	//    UIImageView *dropdownImg = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 - 20, ( (btn.frame.size.height - 20)/2 ), 20, 20)];
	//    dropdownImg.image = [UIImage imageNamed:@"dropdown.png"];
	//    [btn addSubview:dropdownImg];
}

+(void)getDropDownBtn:(UIButton *)btn withString:(NSString *)title width:(CGFloat)width {
	
	btn.layer.borderWidth = 1.0f;
	btn.layer.borderColor = [[UIColor whiteColor] CGColor];
	
	btn.layer.cornerRadius = 5.0f;
	btn.clipsToBounds = YES;
	
	btn.backgroundColor = [UIColor clearColor];
	[btn setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
	btn.titleLabel.font = FONT_18_SEMIBOLD;
	[btn setTitle:title forState:UIControlStateNormal];
	
	[btn setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
	
	btn.imageEdgeInsets = UIEdgeInsetsMake(0, width - 30, 0, 0);
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
}

+(void)getRoundRectTextField:(UITextField *)textField  {
	
	textField.backgroundColor = [UIColor clearColor];
	
	textField.textColor = [UIColor whiteColor];
	textField.font = FONT_16_REGULER;
	textField.layer.borderWidth = 1.0f;
	textField.layer.borderColor = [[UIColor whiteColor] CGColor];
	
	textField.layer.cornerRadius = 5.0f;
	textField.clipsToBounds = YES;
	
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, textField.frame.size.height)];
	
	textField.leftView = paddingView;
	textField.leftViewMode = UITextFieldViewModeAlways;
	
	textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

+(void)getRoundRectTextField:(UITextField *)textField withIcon:(NSString *)iconName andLable:(NSString *)lableText {
	
	textField.backgroundColor = [UIColor clearColor];
	
	textField.textColor = [UIColor whiteColor];
	textField.font = FONT_18_REGULER;
	
	textField.layer.borderWidth = 1.0f;
	textField.layer.borderColor = [[UIColor whiteColor] CGColor];
	
	textField.layer.cornerRadius = 5.0f;
	textField.clipsToBounds = YES;
	
	UIView *paddingView = [[UIView alloc] init];
	UIImageView *icon = [[UIImageView alloc] init];
	icon.contentMode = UIViewContentModeCenter;
	icon.image = [UIImage imageNamed:iconName];
	
	UILabel *contryCode = [[UILabel alloc] init];
	contryCode.text = lableText;
	contryCode.textAlignment = NSTextAlignmentRight;
	contryCode.textColor = [UIColor whiteColor];
	contryCode.font = FONT_18_REGULER;
	
	if (IS_IPAD) {
		paddingView.frame = CGRectMake(0, 0, 100, textField.frame.size.height);
		icon.frame = CGRectMake(12, 10, 30, 30);
		contryCode.frame = CGRectMake(12+icon.frame.size.width, 5, 45, 40);
	}
	else {
		paddingView.frame = CGRectMake(0, 0, 80, textField.frame.size.height);
		icon.frame = CGRectMake(7, 5, 30, 30);
		contryCode.frame = CGRectMake(7+icon.frame.size.width, 5, 35, 30);
	}
	
	[paddingView addSubview:icon];
	[paddingView addSubview:contryCode];
	
	textField.leftView = paddingView;
	textField.leftViewMode = UITextFieldViewModeAlways;
	
	textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

+(void)getRoundRectTextField:(UITextField *)textField withIcon:(NSString *)iconName {
	
	textField.backgroundColor = [UIColor clearColor];
	
	textField.textColor = [UIColor whiteColor];
	textField.font = FONT_18_REGULER;
	textField.layer.borderWidth = 1.0f;
	textField.layer.borderColor = [[UIColor whiteColor] CGColor];
	
	textField.layer.cornerRadius = 5.0f;
	textField.clipsToBounds = YES;
	
	if (textField.tag != 8) {
		
		UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, textField.frame.size.height)];
		UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 20, 20)];
		icon.image = [UIImage imageNamed:iconName];
		icon.contentMode = UIViewContentModeScaleAspectFit;
		[paddingView addSubview:icon];
		
		if (textField.tag == 1) {
			textField.rightView = paddingView;
			textField.rightViewMode = UITextFieldViewModeAlways;
		}
		else {
			textField.leftView = paddingView;
			textField.leftViewMode = UITextFieldViewModeAlways;
		}
	}
	
	textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

+(void)setRoudRectImage:(UIImageView *)img {
	
	img.layer.cornerRadius = img.frame.size.height /2;
	img.layer.masksToBounds = YES;
	img.layer.borderWidth = 1.0f;
	img.layer.borderColor = BTN_BACKGROUD_COLOR.CGColor;
}

+(void)setRoudRectImage:(UIImageView *)img radius:(CGFloat)radius borderColor:(UIColor*)borderColor{
	
	img.layer.cornerRadius = radius;
	img.layer.masksToBounds = YES;
	img.layer.borderWidth = 1.0f;
	img.layer.borderColor = borderColor.CGColor;
}


+(UILabel *)getRowTitleLable:(int)width text:(NSString *)text {
	
	CGFloat size = [self getHeightForText:text withFont:FONT_TBL_ROW_TITLE andWidth:width];
	
	UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, width, size)];
	lable.textColor = TEXT_COLOR_LIGHT_GREEN;
	lable.font = FONT_TBL_ROW_TITLE;
	lable.text = text;
	//    lable.numberOfLines = 0;
	//    lable.lineBreakMode = NSLineBreakByWordWrapping;
	
	return lable;
}

+(UILabel *)getRowDetailLable:(int)width text:(NSString *)text {
	
	CGFloat size = [self getHeightForText:text withFont:FONT_TBL_ROW_DETAIL andWidth:width];
	
	UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, width, size)];
	lable.textColor = TEXT_COLOR_WHITE;
	lable.font = FONT_TBL_ROW_DETAIL;
	lable.text = text;
	
	return lable;
}


+(void)setCynaColorDefultFontLbl:(UILabel *)lable {
	
	lable.textColor = BTN_BACKGROUD_COLOR;
	lable.font = FONT_BTN_TITLE_15;
}
+(void)setCynaColorDefultFontBtn:(UIButton *)btn {
	
	[btn setTitleColor:BTN_BACKGROUD_COLOR forState:UIControlStateNormal];
	btn.titleLabel.font = FONT_BTN_TITLE_17;
}

+(CustomIOS7AlertView *)customAlertDisplay:(NSString *)msgClassObj Btns:(NSMutableArray *)btnArr {
	
	CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
	
	[alertView setContainerView:[self createCustomAlertView:msgClassObj]];
	
	[alertView setButtonTitles:btnArr];
	
	[alertView setUseMotionEffects:true];
	
	return alertView;
}

+(CustomIOS7AlertView *)customAlertDisplay: (NSString *)msgClassObj {
	return [self customAlertDisplay:msgClassObj Btns:[NSMutableArray arrayWithObjects:[GeneralUtil getLocalizedText:@"BTN_OK_TITLE"],[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"], nil] ];
}
+(UIView *)createCustomAlertView : (NSString *) msg {
	
	UIView *MainView = [[UIView alloc] init];
	[MainView setFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20)];
	MainView.backgroundColor = APP_BACKGROUD_COLOR;
	
	UIView *alertView = [[UIView alloc] init];
	alertView.tag = 1000;
	
	if (IS_IPAD) {
		[alertView setFrame:CGRectMake(0, 0, ScreenWidth /2 , ScreenHeight /3)];
	}
	else {
		[alertView setFrame:CGRectMake(0, 0, ScreenWidth - 60, 220)];
		
	}
	
	alertView.backgroundColor = TEXT_COLOR_WHITE;
	
	//alertView.center = CGPointMake(MainView.center.x,MainView.center.y);
	alertView.layer.cornerRadius = 15;
	
	[MainView addSubview:alertView];
	
	UIView *subview = [[UIView alloc]init];
	
	//  subview.backgroundColor = [UIColor redColor];
	
	UILabel *alertTitle = [[UILabel alloc]init];
	[alertTitle setFont:FONT_18_SEMIBOLD];
	alertTitle.textAlignment = NSTextAlignmentCenter;
	alertTitle.text = APPNAME;
	[alertTitle setTextColor:TEXT_COLOR_CYNA];
	
	UIImageView *rightIcon = [[UIImageView alloc]init];
	rightIcon.image = [UIImage imageNamed:@"cs"];
	
	if (IS_IPAD) {
		[subview  setFrame:CGRectMake(0, 0, alertView.frame.size.width, 64)];
		[alertTitle setFrame:CGRectMake(0, 5, subview.frame.size.width, 44)];
		[rightIcon setFrame:CGRectMake(subview.frame.size.width - 50, 10, 30, 30)];
	}
	else {
		[subview  setFrame:CGRectMake(0, 0, alertView.frame.size.width, 64)];
		[alertTitle setFrame:CGRectMake(0, 5, subview.frame.size.width, 44)];
		[rightIcon setFrame:CGRectMake(subview.frame.size.width - 50, 10, 30, 30)];
	}
	
	[subview addSubview:alertTitle];
	[subview addSubview:rightIcon];
	
	UILabel *alertDesc = [[UILabel alloc]init];
	if (IS_IPAD) {
		[alertDesc setFrame:CGRectMake(10, alertTitle.frame.size.height - 5, alertView.frame.size.width-20, 220)];
	}
	else {
		[alertDesc setFrame:CGRectMake(10, alertTitle.frame.size.height - 5, alertView.frame.size.width-20, 120)];
	}
	alertDesc.font = FONT_18_BOLD;
	alertDesc.textColor = APP_BACKGROUD_COLOR;
	alertDesc.textAlignment = NSTextAlignmentCenter;
	
	alertDesc.lineBreakMode = UILineBreakModeWordWrap;
	alertDesc.numberOfLines = 0;
	alertDesc.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	alertDesc.text = msg;
	
	//    CGSize maximumLabelSize = CGSizeMake(alertView.frame.size.width-10, 100);
	//
	//    CGSize expectedLabelSize = [msg sizeWithFont:alertDesc.font constrainedToSize:maximumLabelSize lineBreakMode:alertDesc.lineBreakMode];
	//
	//    //adjust the label the the new height.
	//    CGRect newFrame = alertDesc.frame;
	//    newFrame.size.height = expectedLabelSize.height;
	//    alertDesc.frame = newFrame;
	
	[alertView addSubview:alertDesc];
	[alertView addSubview:subview];
	
	
	return alertView;
}
@end
