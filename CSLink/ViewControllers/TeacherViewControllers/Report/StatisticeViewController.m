//
//  StatisticeViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/16/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "StatisticeViewController.h"
#import "TeacherConstant.h"
#import "BaseViewController.h"

@interface StatisticeViewController ()
{
    NSMutableDictionary *statisticDetail;
}
@end

@implementation StatisticeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDate:(id)obj {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    statisticDetail = (NSMutableDictionary *)obj;
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblUserName.textColor = [UIColor whiteColor];
    lblUserName.font = FONT_18_BOLD;
    lblUserName.text = [statisticDetail valueForKey:@"userName"];
    
    lblStartdate.textColor = [UIColor blackColor];
    lblStartdate.font = FONT_18_LIGHT;
    lblStartdate.text = [statisticDetail valueForKey:@"sdate"];
    
    lblEndDate.textColor = [UIColor blackColor];
    lblEndDate.font = FONT_18_LIGHT;
    lblEndDate.text = [statisticDetail valueForKey:@"edate"];
    
    lblDay.textColor = APP_BACKGROUD_COLOR;
    lblDay.font = FONT_18_BOLD;
    lblDay.text = [GeneralUtil getLocalizedText:@"LBL_DAY_TITLE"];
    
    lblHourse.textColor = APP_BACKGROUD_COLOR;
    lblHourse.font = FONT_18_BOLD;
    lblHourse.text = [GeneralUtil getLocalizedText:@"LBL_HOUR_TITLE"];
    
    lblDayValue.textColor = APP_BACKGROUD_COLOR;
    lblDayValue			.font = FONT_18_REGULER;
    lblDayValue.text = [NSString stringWithFormat:@"%@",[statisticDetail valueForKey:@"day"]];
    
    lblHourseValue.textColor = APP_BACKGROUD_COLOR;
    lblHourseValue.font = FONT_18_REGULER;
    lblHourseValue.text = [NSString stringWithFormat:@"%@",[statisticDetail valueForKey:@"hour"]];
    
    titleView.backgroundColor = TEXT_COLOR_CYNA;
    
    [BaseViewController formateButtonCyne:btnOk title:[GeneralUtil getLocalizedText:@"BTN_OK_TITLE"]];
    
    [self setUpUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setUpUi];
}

-(void)setUpUi {
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    mainView.layer.cornerRadius = 10.0f;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleView.frame byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight ) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleView.bounds;
    maskLayer.path  = maskPath.CGPath;
    titleView.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.frame =  titleView.bounds;
    borderLayer.path  = maskPath.CGPath;
    borderLayer.lineWidth   = 1.0f;
    borderLayer.strokeColor = [UIColor clearColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [titleView.layer addSublayer:borderLayer];
    
}

- (IBAction)btnOkPress:(id)sender {
    
    [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
@end
