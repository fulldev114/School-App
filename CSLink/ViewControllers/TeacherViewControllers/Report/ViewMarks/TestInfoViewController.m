//
//  TestInfoViewController.m
//  CSAdmin
//
//  Created by etech-dev on 10/7/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "TestInfoViewController.h"
#import "TeacherConstant.h"
#import "EnterMarkViewController.h"

@interface TestInfoViewController ()<EnterMarkViewControllerDelegate>
{
    NSMutableDictionary *testDetail;
    
    NSMutableArray *arrSelectedSubject;
    
    BOOL checkBoxSelected;
    NSString *isImagWith;
}
@end

@implementation TestInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDetail:(id)obj {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    testDetail = (NSMutableDictionary *) obj;
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUi];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:lblTopView.frame byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight ) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = lblTopView.bounds;
    maskLayer.path  = maskPath.CGPath;
    lblTopView.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.frame =  lblTopView.bounds;
    borderLayer.path  = maskPath.CGPath;
    borderLayer.lineWidth   = 1.0f;
    borderLayer.strokeColor = [UIColor clearColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [lblTopView.layer addSublayer:borderLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpUi{

    popupView.layer.cornerRadius = 10;
    
    lblTopView.backgroundColor = TEXT_COLOR_CYNA;
    
    lblExamAbout.font = FONT_16_BOLD;
    lblExamAbout.text = [GeneralUtil getLocalizedText:@"LBL_EXAM_ABOUT_TITLE"];
    
    lblExamAboutValue.font = FONT_12_LIGHT;
    lblExamAboutValue.text = [[testDetail valueForKey:@"mark_Detail"] valueForKey:@"exam_about"];
    
    lblComment.font = FONT_16_BOLD;
    lblComment.text = [GeneralUtil getLocalizedText:@"LBL_COMMENTS_TITLE"];
    lblCommentValue.font = FONT_12_LIGHT;
    
    if ([[[testDetail valueForKey:@"mark_Detail"] valueForKey:@"comment"] isEqualToString:@""]) {
        lblCommentValue.text = [GeneralUtil getLocalizedText:@"LBL_NO_COMMENT_TITLE"];
    }
    else {
        lblCommentValue.text = [[testDetail valueForKey:@"mark_Detail"] valueForKey:@"comment"];
    }
    
    
    lblMarks.font = FONT_16_BOLD;
    lblMarks.text = [GeneralUtil getLocalizedText:@"LBL_MARKS_TITLE"];
    lblMakrsValue.font = FONT_12_LIGHT;
    
    if ([[[testDetail valueForKey:@"mark_Detail"] valueForKey:@"marks"] isEqualToString:@""]) {
        lblMakrsValue.text = [GeneralUtil getLocalizedText:@"LBL_NO_MARKS_TITLE"];
    }
    else {
        lblMakrsValue.text = [[testDetail valueForKey:@"mark_Detail"] valueForKey:@"marks"];
    }
    
    
    lblStudantName.font = FONT_16_BOLD;
    lblStudantName.textColor = TEXT_COLOR_WHITE;
    lblStudantName.text = [[testDetail valueForKey:@"studant_Detail"] valueForKey:@"name"];
    
    lblClassName.font = FONT_16_BOLD;
    lblClassName.textColor = TEXT_COLOR_WHITE;
    lblClassName.text = [[testDetail valueForKey:@"studant_Detail"] valueForKey:@"class_name"];
    
    lblTestTitle.font = FONT_16_REGULER;
   // lblClassName.textColor = TEXT_COLOR_WHITE;
    lblTestTitle.text =[NSString stringWithFormat:@"%@ (%@ %@)" ,[testDetail valueForKey:@"subject_name"],[GeneralUtil getLocalizedText:@"LBL_TEST_NO_TITLE"],[[testDetail valueForKey:@"mark_Detail"] valueForKey:@"exam_no"]];
    
    headerView.backgroundColor = TEXT_COLOR_LIGHT_GRAY;
    seperatoreView.backgroundColor = TEXT_COLOR_LIGHT_GRAY;
    seperartoreView2.backgroundColor = TEXT_COLOR_LIGHT_GRAY;
    seperatorView3.backgroundColor = TEXT_COLOR_LIGHT_GRAY;
    
    [BaseViewController formateButtonCyne:btnDownload title:[GeneralUtil getLocalizedText:@"BTN_DOWNLOAD_PDF_TITLE"]];
    [BaseViewController formateButtonCyne:btnOk title:[GeneralUtil getLocalizedText:@"BTN_OK_TITLE"]];
    
    lblTemsAndCond.font = FONT_16_LIGHT;
    lblTemsAndCond.text = [GeneralUtil getLocalizedText:@"LBL_INCLU_IMG_TITLE"];
    checkBoxSelected = false;
    [btnWithImage setBackgroundImage:[UIImage imageNamed:@"icon_uncheck.png"]
                            forState:UIControlStateNormal];
    [btnWithImage setBackgroundImage:[UIImage imageNamed:@"icon_check.png"]
                            forState:UIControlStateSelected];
    
    isImagWith = @"no";
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [lblTemsAndCond addGestureRecognizer:tapGestureRecognizer];
    lblTemsAndCond.userInteractionEnabled = YES;
}

- (IBAction)btnEditPress:(id)sender {
    
    EnterMarkViewController * vc = [[EnterMarkViewController alloc] initWithNibName:@"EnterMarkViewController" bundle:nil];
    vc.isEdit = YES;
    vc.dicEditMark = testDetail;
    vc.dicStud = [testDetail valueForKey:@"studant_Detail"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnOkPress:(id)sender {
    
    NSDictionary *dicStatus = [testDetail  valueForKey:@"mark_Detail"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTestInfo" object:dicStatus];
    
    [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (IBAction)btnDownloadPress:(id)sender {
    
    NSMutableArray *arrSubject = [NSMutableArray arrayWithObject:[testDetail objectForKey:@"mark_Detail"]];
    
    NSMutableDictionary *dicMarksDetail = [[NSMutableDictionary alloc] init];
    
    [dicMarksDetail setObject:[testDetail valueForKey:@"subject_name"] forKey:@"subject_name"];
    [dicMarksDetail setObject:[testDetail valueForKey:@"subject_id"] forKey:@"subject_id"];
    [dicMarksDetail setObject:[testDetail valueForKey:@"teacher_name"] forKey:@"teacher_name"];
    [dicMarksDetail setObject:[testDetail valueForKey:@"semester_id"] forKey:@"semester_id"];
    [dicMarksDetail setObject:arrSubject forKey:@"marks"];
    
    arrSelectedSubject = [NSMutableArray arrayWithObject:dicMarksDetail];
    
    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_IS_SEND_MAIL_PDF"] Delegate:self];
}

- (void)onSaveCompleted:(NSMutableDictionary *)dicMarkDetail {

    [testDetail setObject:dicMarkDetail forKey:@"mark_Detail"];
    
    ZDebug(@"%@", testDetail);
    [self setUpUi];
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *isSend;
    
    if (buttonIndex == 1) {
        isSend = @"No";
    }
    else {
        isSend = @"Yes";
    }
    
    [appDelegate generateAndUploadPdf:[testDetail valueForKey:@"studant_Detail"] andSubjectDetail:arrSelectedSubject isMmailSend:isSend withImg:isImagWith isIndividual:YES];
}
- (IBAction)btnImageWithPress:(id)sender {
    
    if (checkBoxSelected) {
        isImagWith = @"no";
    }
    else {
        isImagWith = @"yes";
    }
    checkBoxSelected = !checkBoxSelected; /* Toggle */
    [btnWithImage setSelected:checkBoxSelected];
}

-(void)labelTapped {
    
    if (checkBoxSelected) {
        isImagWith = @"no";
        
    }
    else {
        isImagWith = @"yes";
    }
    checkBoxSelected = !checkBoxSelected; /* Toggle */
    [btnWithImage setSelected:checkBoxSelected];
}

@end
