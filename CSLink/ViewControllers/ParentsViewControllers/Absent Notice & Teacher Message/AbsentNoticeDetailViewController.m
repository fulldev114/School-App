//
//  AbsentNoticeDetailViewController.m
//  CSLink
//
//  Created by etech-dev on 6/9/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "AbsentNoticeDetailViewController.h"
#import "BaseViewController.h"

@interface AbsentNoticeDetailViewController ()
{
    NSDictionary *noticeDetail;
}
@end

@implementation AbsentNoticeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDate:(id)obj {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    noticeDetail = (NSDictionary *) obj;
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
    }
    return self;
}

- (IBAction)btnOkPress:(id)sender {
    
    //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [BaseViewController formateButtonCyne:btnOk title:[GeneralUtil getLocalizedText:@"BTN_OK_TITLE"]];
    
    txvNoticeDetail.textColor = APP_BACKGROUD_COLOR;
    txvNoticeDetail.font = FONT_16_BOLD;
    
    txvNoticeDetail.text = [noticeDetail valueForKey:@"mm.message_desc"];
    
   // CGSize popsize = [self getSizeOfContent:txvNoticeDetail.text];
    
    [txvNoticeDetail sizeToFit];
    CGSize sizeThatFitsTextView = [self getSizeOfContent:txvNoticeDetail.text];
    
    // TextViewHeightConstraint.constant = sizeThatFitsTextView.height;
    
    if (IS_IPAD) {
        popViewHeight.constant = 80 + sizeThatFitsTextView.height;
    }
    else {
        popViewHeight.constant = 100 + sizeThatFitsTextView.height;
    }
    popupView.layer.cornerRadius = 10.0f;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setUpUi];
}

-(CGSize)getSizeOfContent:(NSString *)text {
    
    CGSize maximumSize = CGSizeMake(220, CGFLOAT_MAX);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:maximumSize
                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_16_BOLD} context:context].size;
    
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size;
}

-(void)setUpUi {
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    UILabel *lblTitleNotice = [[UILabel alloc] init];
    
    lblTitleNotice.frame = CGRectMake(0, 0, popupView.frame.size.width , 40);
    
   // lblTitleNotice.backgroundColor = TEXT_COLOR_CYNA;
    
    lblTitleNotice.font = FONT_18_BOLD;
    lblTitleNotice.textColor = APP_BACKGROUD_COLOR;
    lblTitleNotice.textAlignment = NSTextAlignmentCenter;
    lblTitleNotice.text = [GeneralUtil getLocalizedText:@"TITLE_ABSENT_NOTICE"];
    [popupView addSubview:lblTitleNotice];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:lblTitleNotice.frame byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight ) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = lblTitleNotice.bounds;
    maskLayer.path  = maskPath.CGPath;
    lblTitleNotice.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.frame =  lblTitleNotice.bounds;
    borderLayer.path  = maskPath.CGPath;
    borderLayer.lineWidth   = 1.0f;
    borderLayer.strokeColor = [UIColor clearColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [lblTitleNotice.layer addSublayer:borderLayer];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
