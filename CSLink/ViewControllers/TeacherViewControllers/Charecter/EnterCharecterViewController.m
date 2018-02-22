//
//  EnterCharecterViewController.m
//  CSAdmin
//
//  Created by etech-dev on 7/5/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "EnterCharecterViewController.h"
#import "BaseViewController.h"
#import "TeacherNIDropDown.h"
#import "IQActionSheetPickerView.h"
#import "TeacherUser.h"

@interface EnterCharecterViewController ()<TeacherNIDropDownDelegate,IQActionSheetPickerViewDelegate>
{
    TeacherUser *userObj;
    TeacherNIDropDown *dropDown;
    
    NSMutableArray *arrYear;
    NSMutableArray *arrSem;
    NSMutableArray *arrGrade;
    
    NSMutableArray *arrDescipiline;
    NSMutableArray *arrRemark;
    
    NSMutableArray *arrDesci;
    NSMutableArray *arrRema;
    
    NSMutableArray *arrAllSemester;
    NSMutableArray *arrAllGrade;
    NSMutableArray *arrUserDetail;
    
    NSString *selctedYear;
    NSString *selctedDescipline;
    NSString *selectedRemark;
    
    NSString *selctedYearId;
    NSString *selctedDesciplineId;
    NSString *selectedRemarkId;
    UIButton * fakeButton;
    
    NSString *type;
    NSString *sdate;
    __weak IBOutlet UIView *remarkView;
    __weak IBOutlet UILabel *lblWriteRemark;
}
@end

@implementation EnterCharecterViewController

@synthesize dicStud;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 50)];
    
    UILabel *lblStudName = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 180, 25)];
    [lblStudName setText:[dicStud valueForKey:@"name"]];
    [lblStudName setBackgroundColor:[UIColor clearColor]];
    [lblStudName setFont:FONT_NAVIGATION_TITLE];
    lblStudName.textColor = TEXT_COLOR_CYNA;
    [lblStudName setTextAlignment:NSTextAlignmentLeft];
    lblStudName.font = FONT_BTN_TITLE_18;
    
    UILabel *lblStudClass = [[UILabel alloc]initWithFrame:CGRectMake(35, 20, 180, 25)];
    [lblStudClass setText:[dicStud valueForKey:@"class_name"]];
    [lblStudClass setBackgroundColor:[UIColor clearColor]];
    [lblStudClass setFont:FONT_NAVIGATION_TITLE];
    lblStudClass.textColor = TEXT_COLOR_WHITE;
    [lblStudClass setTextAlignment:NSTextAlignmentLeft];
    lblStudClass.font = FONT_16_BOLD;
    
    [view addSubview:lblStudClass];
    [view addSubview:lblStudName];
    
    UIImageView *profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 30, 30)];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStud valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    profileImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [BaseViewController setRoudRectImage:profileImg];
    
    [view addSubview:profileImg];
    
    [self.navigationItem setTitleView:view];
    
    self.navigationItem.leftBarButtonItem = [BaseViewController getBackButtonWithSel:@selector(backButtonClick) addTarget:self];
    
 //   self.navigationItem.rightBarButtonItem = [BaseViewController getRightButtonWithSel:@selector(infoBtnClick) addTarget:self icon:@"info"];
    
    userObj = [[TeacherUser alloc] init];
    
    [self setUpUi];
    
    arrYear = [[NSMutableArray alloc] init];
    arrSem = [[NSMutableArray alloc] init];
    arrGrade = [[NSMutableArray alloc] init];
    arrAllSemester = [[NSMutableArray alloc] init];
    arrAllGrade = [[NSMutableArray alloc] init];
    arrUserDetail = [[NSMutableArray alloc] init];
    
    arrDescipiline = [[NSMutableArray alloc] init];
    arrRemark = [[NSMutableArray alloc] init];
    
    arrDesci = [[NSMutableArray alloc] init];
    arrRema = [[NSMutableArray alloc] init];
    
    selectedRemarkId =@"";
    [self getSemesterAndSubject];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)infoBtnClick{
    
}

-(void)setUpUi {
    
    [BaseViewController formateButtonCyne:btnSave title:[GeneralUtil getLocalizedText:@"BTN_SAVE_TITLE"]];
    
    //    [BaseViewController getDropDownBtn:btnSelecteYear withString:@""];
    //    [BaseViewController getDropDownBtn:btnSelecteSem withString:@""];
    //    [BaseViewController getDropDownBtn:btnSelectSub withString:@""];
    
    if (IS_IPAD) {
        [btnSelecteYear setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
        btnSelecteYear.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
        
        [btnSelecteSem setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelecteSem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
        
        [btnSelectSub setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelectSub.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
    }
    else {
        [btnSelecteYear setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
        btnSelecteYear.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
        
        [btnSelecteSem setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelecteSem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
        
        [btnSelectSub setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelectSub.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
    }
    
    lblStudyYear.font = FONT_18_REGULER;
    lblStudyYear.textColor = TEXT_COLOR_WHITE;
//    lblStudyYear.text = [GeneralUtil getLocalizedText:@"LBL_STUDY_YEAR_TITLE"];
    
    lblSemesterNum.font = FONT_18_REGULER;
    lblSemesterNum.textColor = TEXT_COLOR_WHITE;
    lblSemesterNum.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_GRADE_TITLE"];
    
    lblselectSubject.font = FONT_18_REGULER;
    lblselectSubject.textColor = TEXT_COLOR_WHITE;
    lblselectSubject.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_REMARK_TITLE"];
    
    lblSubjectInfo.font = FONT_14_BOLD;
    lblSubjectInfo.textColor = TEXT_COLOR_CYNA;
    lblSubjectInfo.text = [[GeneralUtil getLocalizedText:@"LBL_DECI_AND_BEHAV_TITLE"] uppercaseString];
    
    lblWriteRemark.font = FONT_14_BOLD;
    lblWriteRemark.textColor = TEXT_COLOR_CYNA;
    lblWriteRemark.text = [[GeneralUtil getLocalizedText:@"LBL_WRITE_REMARK_TITLE"] uppercaseString];
    
    txvComments.font = FONT_14_REGULER;
    txvComments.textColor = TEXT_COLOR_WHITE;
    
    txvComments.delegate = self;
    
//    txvComments.textContainer.maximumNumberOfLines = 5;
//    txvComments.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    lblComment.font = FONT_18_REGULER;
    lblComment.textColor = TEXT_COLOR_WHITE;
    lblComment.text = [GeneralUtil getLocalizedText:@"LBL_COMMENT_TITLE"];
    
    commentView.layer.cornerRadius = 5.0f;
    commentView.layer.borderWidth = 1.0f;
    commentView.layer.borderColor = [UIColor whiteColor].CGColor;
    commentView.backgroundColor = [UIColor clearColor];
    
    subjectSepView.backgroundColor = TEXT_COLOR_CYNA;
    remarkView.backgroundColor  = TEXT_COLOR_CYNA;
    
    seperatorView1.backgroundColor = SEPERATOR_COLOR;
    seperatorView2.backgroundColor = SEPERATOR_COLOR;
    
    seperatorView3.backgroundColor = SEPERATOR_COLOR;
    
    arrYear = [GeneralUtil getYear:[GeneralUtil getYearStartDate]];
    
    selctedYear = [arrYear firstObject];
    selctedYearId = [arrYear firstObject];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //  [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    lblStudyYear.text = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    sdate = [formatter stringFromDate:[NSDate date]];
}

-(void)getSemesterAndSubject {
    
    [userObj getSemseterAndSubj:[dicStud valueForKey:@"class_id"] schoolId:[GeneralUtil getUserPreference:key_schoolId] userId:[dicStud valueForKey:@"user_id"] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        [arrAllSemester removeAllObjects];
        [arrAllGrade removeAllObjects];
        [arrUserDetail removeAllObjects];
        [arrDescipiline removeAllObjects];
        [arrRemark removeAllObjects];
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                arrDescipiline = [dicRes valueForKey:@"descipline_list"];
                arrRemark = [dicRes valueForKey:@"remarks_list"];
                arrAllGrade = [dicRes valueForKey:@"character_list"];
                arrUserDetail = [dicRes valueForKey:@"user_marks_details"];
                
                for (NSDictionary *semDetail in arrAllSemester) {
                    [arrSem addObject:[semDetail valueForKey:@"semester_name"]];
                }
                
                for (NSDictionary *subjDetail in arrAllGrade) {
                    [arrGrade addObject:[subjDetail valueForKey:@"character_name"]];
                }
                
                for (NSDictionary *subjDetail in arrDescipiline) {
                    [arrDesci addObject:[subjDetail valueForKey:@"descipline_name"]];
                }
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (IBAction)btnSelectYearPress:(UIButton *)sender {
    
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
    
    [picker setMaximumDate:[GeneralUtil getYearEndDate]];
    [picker setMinimumDate:[GeneralUtil getYearStartDate]];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
    
//    if(dropDown == nil) {
//        
//        CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
//        
//        fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +10, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
//        [fakeButton addTarget:self action:@selector(btnSelectYearPress:) forControlEvents:UIControlEventTouchUpInside];
//        fakeButton.tag = sender.tag;
//        fakeButton.hidden = NO;
//        
//        [self.view addSubview:fakeButton];
//        
//        CGFloat f;
//        if (IS_IPAD) {
//            f = arrYear.count * 50;
//        }
//        else {
//            f = arrYear.count * 40;
//        }
//        
//        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
//            f = [[UIScreen mainScreen] bounds].size.height / 2;
//        }
//        
//        dropDown = [[NIDropDown alloc]showDropDown:fakeButton :&f :(NSArray *)arrYear :nil :@"down"];
//        dropDown.delegate = self;
//        dropDown.tag  = 11;
//    }
//    else {
//        [dropDown hideDropDown:sender];
//        dropDown = nil;
//    }
    
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    //  [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    lblStudyYear.text = [formatter stringFromDate:date];
    
    [btnSelecteYear setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
    btnSelecteYear.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
    
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    sdate = [formatter stringFromDate:date];
}

- (IBAction)btnSelecteSemPress:(UIButton *)sender {
    
    if(dropDown == nil) {
        
        
        //CGRect lastViewRect = [sender convertRect:sender.frame toView:self.view];
        
        CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
        
        fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +10, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        [fakeButton addTarget:self action:@selector(btnSelecteSemPress:) forControlEvents:UIControlEventTouchUpInside];
        fakeButton.tag = 10;
        fakeButton.hidden = NO;
        
        [self.view addSubview:fakeButton];
        
        CGFloat f;
        if (IS_IPAD) {
            f = arrDesci.count * 50;
        }
        else {
            f = arrDesci.count * 40;
        }
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:fakeButton :&f :(NSArray *)arrDesci :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 12;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
        [fakeButton removeFromSuperview];
    }
}

- (IBAction)btnSelecteSubPress:(UIButton *)sender {
    
    if(dropDown == nil) {
        
        CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
        
        fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x + 10, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        [fakeButton addTarget:self action:@selector(btnSelecteSubPress:) forControlEvents:UIControlEventTouchUpInside];
        fakeButton.tag = sender.tag;
        fakeButton.hidden = NO;
        
        [self.view addSubview:fakeButton];
        
        CGFloat f;
        if (IS_IPAD) {
            f = arrRema.count * 50;
        }
        else {
            f = arrRema.count * 40;
        }
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:fakeButton :&f :(NSArray *)arrRema :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 13;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
        [fakeButton removeFromSuperview];
    }
}

- (void)niDropDownDelegateMethod: (TeacherNIDropDown *) sender {
    [fakeButton removeFromSuperview];
    dropDown = nil;
    
//    if (sender.tag == 11) {
//        
//        selctedYear = [arrYear objectAtIndex:sender.index];
//        selctedYearId = [arrYear objectAtIndex:sender.index];
//        [btnSelecteYear setTitle:selctedYear  forState:UIControlStateNormal];
//        [btnSelecteYear setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        btnSelecteYear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        
//        [self getValueForUser:selctedYearId sem:selctedSemId];
//    }
    
    if (sender.tag == 12) {
        
        selctedDescipline = [arrDesci objectAtIndex:sender.index];
//        [btnSelecteSem setTitle:selctedDescipline  forState:UIControlStateNormal];
//        [btnSelecteSem setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        btnSelecteSem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        lblSemesterNum.text = selctedDescipline;
        
        lblselectSubject.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_REMARK_TITLE"];
        
        [arrRema removeAllObjects];
        for (NSDictionary *dicValue in arrDescipiline) {
            
            if ([selctedDescipline isEqualToString:[dicValue valueForKey:@"descipline_name"]] ) {
                selctedDesciplineId = [dicValue valueForKey:@"descipline_id"];
                
                if ([selctedDesciplineId intValue] == 1) {
                    type = @"DESC";
                }
                if ([selctedDesciplineId intValue] == 2) {
                    type = @"BEH";
                }
            }
        }
        
        for (NSDictionary *dicValue in arrRemark) {
            
            if ([selctedDesciplineId isEqualToString:[dicValue valueForKey:@"descipline_id"]] ) {
                
                if (![[dicValue valueForKey:@"remarks_name"] isEqualToString:@""]) {
                    [arrRema addObject:[dicValue valueForKey:@"remarks_name"]];
                }
            }
        }
        
       // [self getValueForUser:selctedYearId sem:selctedDesciplineId];
    }
    if (sender.tag == 13) {
        
        selectedRemark = [arrRema objectAtIndex:sender.index];
//        [btnSelectSub setTitle:selectedRemark  forState:UIControlStateNormal];
//        [btnSelectSub setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        btnSelectSub.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        lblselectSubject.text = selectedRemark;
        
        for (NSDictionary *dicValue in arrRemark) {
            
            if ([selectedRemark isEqualToString:[dicValue valueForKey:@"remarks_name"]] ) {
                selectedRemarkId = [dicValue valueForKey:@"remarks_id"];
            }
        }
    }
}

-(void)getValueForUser:(NSString *)year sem:(NSString *)sem {

    for (NSDictionary *userDetail in arrUserDetail) {
        
        if ([year isEqualToString:[userDetail valueForKey:@"year"]] && [sem isEqualToString:[userDetail valueForKey:@"semester_id"]]) {
            txvComments.text = [userDetail valueForKey:@"comment"];
            [btnSelectSub setTitle:selectedRemark  forState:UIControlStateNormal];
            [btnSelectSub setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            btnSelectSub.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
    }
}

- (IBAction)btnSavePress:(id)sender {
    
    [txvComments resignFirstResponder];
    
    
    if (sdate == nil || [sdate isEqualToString:@""] ) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_DATE"]];
    }
    else if (selctedDesciplineId == nil || [selctedDesciplineId isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_BEHAVIYORE"]];
    }
//    else if ([type isEqualToString:@"DESC"]){
//            if (selectedRemarkId == nil || [selectedRemarkId isEqualToString:@""]) {
//                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_REMARK"]];
//            }else {
//                [self dataSave];
//            }
//    }
//    else if ([txvComments.text isEqualToString:@""]) {
//        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_COMMENT"]];
//    }
    else {
         
        [self dataSave];
    }
}

-(void)dataSave {


    [userObj addStudantBehaviyore:[dicStud valueForKey:@"class_id"] date:sdate desciplineId:selctedDesciplineId userId:[dicStud valueForKey:@"user_id"] teacherId:[GeneralUtil getUserPreference:key_teacherId] remarksId:selectedRemarkId comments:txvComments.text type:type :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CHARECTER_SAVE_SUCCESS"]];
                txvComments.text = @"";
                lblComment.hidden = NO;
                selectedRemarkId = @"";
                selctedDesciplineId = @"";
                lblSemesterNum.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_GRADE_TITLE"];
                lblselectSubject.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_REMARK_TITLE"];
            }
            else {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_FAID_TO_DATA_SAVE"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [fakeButton removeFromSuperview];
    [dropDown hideDropDown:fakeButton];
    dropDown = nil;
    
    lblComment.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([txvComments.text isEqualToString:@""]) {
        lblComment.hidden = NO;
    }
}


@end
