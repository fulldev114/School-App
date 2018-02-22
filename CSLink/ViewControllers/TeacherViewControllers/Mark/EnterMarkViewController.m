//
//  EnterMarkViewController.m
//  CSAdmin
//
//  Created by etech-dev on 7/4/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "EnterMarkViewController.h"
#import "BaseViewController.h"
#import "TeacherNIDropDown.h"
#import "IQActionSheetPickerView.h"
#import "ViewMarksViewController.h"
#import "TeacherUser.h"

#define NO_OF_EXAM 20

@interface EnterMarkViewController ()<TeacherNIDropDownDelegate,IQActionSheetPickerViewDelegate>
{
    TeacherUser *userObj;
    TeacherNIDropDown *dropDown;
    
    NSMutableArray *arrYear;
    NSMutableArray *arrSem;
    NSMutableArray *arrSubject;
    NSMutableArray *arrExams;
    
    NSMutableArray *arrAllSemester;
    NSMutableArray *arrAllSubject;
    NSMutableArray *arrAllExam;
    
    NSMutableArray *arrSelectedExam;
    NSMutableArray *arrSelectedExamLocal;
    
    NSMutableArray *arrUserDetail;
    
    NSString *selctedYear;
    NSString *selctedSem;
    NSString *selctedSubj;
    NSString *selctedExam;
    
    NSString *selctedYearId;
    NSString *selctedSemId;
    NSString *selctedSubjId;
    NSString *selctedExamNo;
    UIButton * fakeButton;
    
    NSString *sdate;
    NSString *isRemoveImage;
    
    NSMutableDictionary *testDetail;
    
    UIImage *smllImage;
}
@end

@implementation EnterMarkViewController
@synthesize dicStud,dicEditMark;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = NO;
    
    [BaseViewController setBackGroud:self];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.rightBarButtonItem = [BaseViewController getRightButtonWithSel:@selector(repotBtnClick) addTarget:self icon:@"info"];
    
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
    arrExams = [[NSMutableArray alloc] init];
    arrSubject = [[NSMutableArray alloc] init];
    arrAllSemester = [[NSMutableArray alloc] init];
    arrAllSubject = [[NSMutableArray alloc] init];
    arrAllExam = [[NSMutableArray alloc] init];
    arrUserDetail = [[NSMutableArray alloc] init];
    arrSelectedExam = [[NSMutableArray alloc] init];
    arrSelectedExamLocal = [[NSMutableArray alloc] init];
    
    [self getSemesterAndSubject];
    
    if (_isEdit) {
        [self setUpUiEdit];
    }
    
    isRemoveImage = @"no";
    txvComments.delegate = self;
    txtExamAbout.delegate = self;
    txtEnterMark.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)repotBtnClick{
    
    ViewMarksViewController * vc = [[ViewMarksViewController alloc] initWithNibName:@"ViewMarksViewController" bundle:nil];
    vc.dicStudantDetail = self.dicStud;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)setUpUiEdit {

    testDetail = [[NSMutableDictionary alloc] init];
    
    txtExamAbout.text = [[dicEditMark valueForKey:@"mark_Detail"] valueForKey:@"exam_about"];
    txtEnterMark.text = [[dicEditMark valueForKey:@"mark_Detail"] valueForKey:@"marks"];
    txvComments.text = [[dicEditMark valueForKey:@"mark_Detail"] valueForKey:@"comment"];

    selctedSemId = [dicEditMark valueForKey:@"semester_id"];
    selctedSubjId = [dicEditMark valueForKey:@"subject_id"];
    selctedExamNo = [[dicEditMark valueForKey:@"mark_Detail"] valueForKey:@"exam_no"];
    
    if (![[[dicEditMark valueForKey:@"mark_Detail"] valueForKey:@"image"] isEqualToString:@""]) {
        [imgMarks setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[dicEditMark valueForKey:@"mark_Detail"] valueForKey:@"image"]]]];
        btnDeleteImage.hidden = NO;
        [btnTackeOrZoomPhoto setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    else {
        btnDeleteImage.hidden = YES;
        btnTackeOrZoomPhoto.hidden = NO;
        
//        CGRect rect = CGRectMake(0, 0, 1, 1);
//        UIGraphicsBeginImageContext(rect.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, TEXT_COLOR_CYNA.CGColor);
//        CGContextFillRect(context, rect);
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        imgMarks.image = image;
    }
    
    if (![[dicEditMark valueForKey:@"comment"] isEqualToString:@""]) {
        lblComment.hidden = YES;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSDate  *date = [formatter dateFromString:[[dicEditMark valueForKey:@"mark_Detail"] valueForKey:@"exam_date"]];
    
     [formatter setDateFormat:@"dd-MMM-yyyy"];
    ZDebug(@"%@", date);
    lblSelecteDate.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    sdate = [formatter stringFromDate:date];
    //btnSelecteDate.userInteractionEnabled = NO;
}

-(void)setUpUi {
    
    txtExamAbout.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_EXAM_ABOUT"];
    txtEnterMark.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_ENTER_MARKS"];
  //  txtEnterMark.keyboardType = UIKeyboardTypeNumberPad;
    
    [BaseViewController getRoundRectTextField:txtEnterMark];
    [BaseViewController getRoundRectTextField:txtExamAbout];
    
    [BaseViewController formateButtonCyne:btnSave title:[GeneralUtil getLocalizedText:@"BTN_SAVE_TITLE"]];
    
//    [BaseViewController getDropDownBtn:btnSelecteYear withString:@""];
//    [BaseViewController getDropDownBtn:btnSelecteSem withString:@""];
//    [BaseViewController getDropDownBtn:btnSelectSub withString:@""];
    
    if (IS_IPAD) {
        [btnSelecteYear setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelecteYear.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
        
        [btnSelecteSem setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelecteSem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
        
        [btnSelectSub setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelectSub.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
        
        [btnSelectExam setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelectExam.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
        
        [btnSelecteDate setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
        btnSelecteDate.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
    }
    else {
        [btnSelecteYear setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelecteYear.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
        
        [btnSelecteSem setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelecteSem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
        
        [btnSelectSub setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelectSub.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
        
        [btnSelectExam setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        btnSelectExam.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
        
        [btnSelecteDate setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
        btnSelecteDate.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
    }
    lblStudyYear.font = FONT_18_REGULER;
    lblStudyYear.textColor = TEXT_COLOR_WHITE;
    lblStudyYear.text = [GeneralUtil getLocalizedText:@"LBL_STUDY_YEAR_TITLE"];
    
    lblSemesterNum.font = FONT_18_REGULER;
    lblSemesterNum.textColor = TEXT_COLOR_WHITE;
    lblSemesterNum.text = [GeneralUtil getLocalizedText:@"LBL_SEM_NUMEBER_TITLE"];
    
    lblselectSubject.font = FONT_18_REGULER;
    lblselectSubject.textColor = TEXT_COLOR_WHITE;
    lblselectSubject.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_SUB_TITLE"];
    
    lblExamNo.font = FONT_18_REGULER;
    lblExamNo.textColor = TEXT_COLOR_WHITE;
    lblExamNo.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_TEST_NO_TITLE"];
    
    lblSelecteDate.font = FONT_18_REGULER;
    lblSelecteDate.textColor = TEXT_COLOR_WHITE;
    lblSelecteDate.text = [GeneralUtil getLocalizedText:@"LBL_SELECTE_DATE_TITLE"];
    
    lblEnterMark.font = FONT_18_REGULER;
    lblEnterMark.textColor = TEXT_COLOR_WHITE;
    lblEnterMark.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_TEST_NO_TITLE"];
    
    lblSubjectInfo.font = FONT_14_BOLD;
    lblSubjectInfo.textColor = TEXT_COLOR_CYNA;
    lblSubjectInfo.text = [GeneralUtil getLocalizedText:@"LBL_SUBJ_INFO_TITLE"];
    
    lblSetMark.font = FONT_14_BOLD;
    lblSetMark.textColor = TEXT_COLOR_CYNA;
    lblSetMark.text = [GeneralUtil getLocalizedText:@"LBL_SET_MARK_TITLE"];
    
    arrYear = [GeneralUtil getYear:[GeneralUtil getYearStartDate]];
    
    selctedYear = [arrYear firstObject];
    selctedYearId = [arrYear firstObject];
    
    lblCurrentYear.font = FONT_14_BOLD;
    lblCurrentYear.textColor = TEXT_COLOR_CYNA;
    lblCurrentYear.text = selctedYear;
    
    txvComments.font = FONT_14_REGULER;
    txvComments.textColor = TEXT_COLOR_WHITE;
    
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
    setMarkView.backgroundColor = TEXT_COLOR_CYNA;
    
    seperatorView1.backgroundColor = SEPERATOR_COLOR;
    seperatorView2.backgroundColor = SEPERATOR_COLOR;
    seperatorView3.backgroundColor = SEPERATOR_COLOR;
    seperatorView4.backgroundColor = SEPERATOR_COLOR;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    imgMarks.backgroundColor = TEXT_COLOR_CYNA;
    [BaseViewController setRoudRectImage:imgMarks];
    
    //[BaseViewController formateButtonCyne:btnTackePhoto title:@"upload Image" withIcon:@"upload-image" titleColor:[UIColor whiteColor]];
    
    [btnDeleteImage setImage:[UIImage imageNamed:@"deleteRed"] forState:UIControlStateNormal];
    [btnTackeOrZoomPhoto setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    
    btnDeleteImage.hidden = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"dd-MMM-yyyy, HH:mm"];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    lblSelecteDate.text = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    sdate = [formatter stringFromDate:[NSDate date]];
}

-(void)getSemesterAndSubject {

    [userObj getSemseterAndSubj:[dicStud valueForKey:@"class_id"] schoolId:[GeneralUtil getUserPreference:key_schoolId] userId:[dicStud valueForKey:@"user_id"] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        [arrUserDetail removeAllObjects];
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                arrAllSemester = [dicRes valueForKey:@"semester_list"];
                arrAllSubject = [dicRes valueForKey:@"subject_list"];
                arrUserDetail = [dicRes valueForKey:@"user_marks_details"];
                
                if (_isEdit) {
                    
                    for (NSDictionary *semDetail in arrAllSemester) {
                        
                        if ([[semDetail valueForKey:@"semester_id"] isEqualToString:selctedSemId]) {
                            lblSemesterNum.text = [semDetail valueForKey:@"semester_name"];
                            btnSelecteSem.userInteractionEnabled = NO;
                        }
                    }
                    
                    for (NSDictionary *subjDetail in arrAllSubject) {
                        
                        if ([[subjDetail valueForKey:@"subject_id"] isEqualToString:selctedSubjId]) {
                            lblselectSubject.text = [subjDetail valueForKey:@"subject_name"];
                            btnSelectSub.userInteractionEnabled = NO;
                        }
                    }
                    
                    arrYear = [GeneralUtil getYear:[GeneralUtil getYearStartDate]];
                    
                    selctedYear = [arrYear firstObject];
                    selctedYearId = [arrYear firstObject];
                    [btnSelecteYear setTitle:selctedYear  forState:UIControlStateNormal];
                    [btnSelecteYear setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    btnSelecteYear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    
                    for (int i = 1; i <= NO_OF_EXAM; i++) {
                        NSString *str = [NSString stringWithFormat:@"%@-%d",[GeneralUtil getLocalizedText:@"LBL_TEST_NO_TITLE"],i];
                        NSMutableDictionary *dicExam = [[NSMutableDictionary alloc] init];
                        [dicExam setObject:[NSString stringWithFormat:@"%d",i] forKey:@"No"];
                        [dicExam setObject:str forKey:@"Exam"];
                        [arrExams addObject:str];
                        [arrAllExam addObject:dicExam];
                    }
                    
                    for (NSDictionary *dicValue in arrAllExam) {
                        
                        if ([selctedExamNo isEqualToString:[dicValue valueForKey:@"No"]]) {
                            lblExamNo.text = [dicValue valueForKey:@"Exam"];
                            btnSelectExam.userInteractionEnabled = NO;
                        }
                    }
                }
                else {
                    
                    for (NSDictionary *semDetail in arrAllSemester) {
                        [arrSem addObject:[semDetail valueForKey:@"semester_name"]];
                    }
                    
                    for (NSDictionary *subjDetail in arrAllSubject) {
                        [arrSubject addObject:[subjDetail valueForKey:@"subject_name"]];
                    }
                    
                    arrYear = [GeneralUtil getYear:[GeneralUtil getYearStartDate]];
                    
                    selctedYear = [arrYear firstObject];
                    selctedYearId = [arrYear firstObject];
                    [btnSelecteYear setTitle:selctedYear  forState:UIControlStateNormal];
                    [btnSelecteYear setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    btnSelecteYear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd-MMM-yyyy"];
                    
                    NSString *cDate = [formatter stringFromDate:[NSDate date]];
                    NSString *seDate = [formatter stringFromDate:[GeneralUtil getSemEndDate]];
                    
                    if ([[formatter dateFromString:seDate] compare:[formatter dateFromString:cDate]] == NSOrderedDescending) {
                        
                        selctedSem = [arrSem objectAtIndex:0];
                        
                    }
                    else {
                        selctedSem = [arrSem objectAtIndex:1];
                    }
                    
                    [btnSelecteSem setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
                    if (IS_IPAD) {
                        btnSelecteSem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
                    }
                    else {
                        btnSelecteSem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
                    }
                    
                    lblSemesterNum.text = selctedSem;
                    
                    for (NSDictionary *dicValue in arrAllSemester) {
                        
                        if ([selctedSem isEqualToString:[dicValue valueForKey:@"semester_name"]] ) {
                            selctedSemId = [dicValue valueForKey:@"semester_id"];
                        }
                    }
                }
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (IBAction)btnTackeOrZoomPhoto:(id)sender {
    
    [txtEnterMark resignFirstResponder];
    
//    UIImage *secondImage = [UIImage imageNamed:@"profile"];
//    
//    NSData *imgData1 = UIImagePNGRepresentation(imgMarks.image);
//    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
//    
//    BOOL isCompare =  [imgData1 isEqual:imgData2];
//    if(isCompare)
//    {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                      initWithTitle:[GeneralUtil getLocalizedText:@"LBL_ASHEET_PICKER_TITLE"]
//                                      delegate:self
//                                      cancelButtonTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]
//                                      destructiveButtonTitle:nil
//                                      otherButtonTitles:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CHOOSE"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CAMERA"], nil];
//        
//        // [actionSheet showInView:self.view];
//        [actionSheet showFromRect:btnTackePhoto.frame inView:btnTackePhoto.superview animated: YES];
//    }
//    else
//    {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                      initWithTitle:[GeneralUtil getLocalizedText:@"LBL_ASHEET_PICKER_TITLE"]
//                                      delegate:self
//                                      cancelButtonTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]
//                                      destructiveButtonTitle:nil
//                                      otherButtonTitles:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CHOOSE"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CAMERA"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_REMOVE"], nil];
//        
//        // [actionSheet showInView:self.view];
//        [actionSheet showFromRect:btnTackePhoto.frame inView:btnTackePhoto.superview animated: YES];
//    }
    
    UIImage *img = [btnTackeOrZoomPhoto imageForState:UIControlStateNormal];
    UIImage *secondImage = [UIImage imageNamed:@"camera"];
    
    NSData *imgData1 = UIImagePNGRepresentation(img);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);

    BOOL isCompare =  [imgData1 isEqual:imgData2];
    
    if(isCompare) {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:[GeneralUtil getLocalizedText:@"LBL_ASHEET_PICKER_TITLE"]
                                  delegate:self
                                  cancelButtonTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CHOOSE"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CAMERA"], nil];
    
        // [actionSheet showInView:self.view];
        [actionSheet showFromRect:btnTackeOrZoomPhoto.frame inView:btnTackeOrZoomPhoto.superview animated: YES];
    }
    else {
        if (imgMarks.image != nil) {
            _slideImageViewController = [PEARImageSlideViewController new];
            _slideImageViewController.dele = self;
            NSArray *imageLists = @[imgMarks.image].copy;
            [_slideImageViewController setImageLists:imageLists];
            [_slideImageViewController showAtIndex:0];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CHOOSE"]]) {
        
        ipc=[[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        ipc.delegate=self;
       // [ipc setAllowsEditing:YES];
        
        if(IS_IPAD)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self presentViewController:ipc animated:YES completion:nil];
            }];
            
        }
        else{
            
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }
    
    if([buttonTitle isEqualToString:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CAMERA"]]) {
        
        ipc=[[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate=self;
       // [ipc setAllowsEditing:YES];
        
        if(IS_IPAD)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self presentViewController:ipc animated:YES completion:nil];
            }];
        }
        else{
            
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }
    if ([buttonTitle isEqualToString:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]]) {
        
    }
    if ([buttonTitle isEqualToString:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_REMOVE"]]) {
        imgMarks.image = [UIImage imageNamed:@"profile"];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    imgMarks.image = chosenImage;
    
    CGFloat scaleSize = 0.2f;
    UIImage *smallImage = [UIImage imageWithCGImage:[chosenImage CGImage]
                                              scale:scaleSize
                                        orientation:chosenImage.imageOrientation];
    
    smllImage = smallImage;
    
    
    if (smallImage.imageOrientation == UIImageOrientationUp) {
        
        smllImage = smallImage;
    }
    else {
        UIGraphicsBeginImageContextWithOptions(smallImage.size, NO, smallImage.scale);
        [smallImage drawInRect:(CGRect){0, 0, smallImage.size}];
        UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        smllImage = normalizedImage;
    }
    isRemoveImage = @"No";
    [btnTackeOrZoomPhoto setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    btnDeleteImage.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnDeleteImg:(id)sender {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, TEXT_COLOR_CYNA.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imgMarks.image = image;
    isRemoveImage = @"Yes";
    
    btnTackeOrZoomPhoto.hidden = NO;
    btnDeleteImage.hidden = YES;
    [btnTackeOrZoomPhoto setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
}

- (IBAction)btnSelecteExamPress:(UIButton *)sender {
    
    if(dropDown == nil) {
        
        CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
        
        if (IS_IPAD) {
            fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +30, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        }
        else {
            fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +15, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        }
        
        
        [fakeButton addTarget:self action:@selector(btnSelecteExamPress:) forControlEvents:UIControlEventTouchUpInside];
        fakeButton.tag = sender.tag;
        fakeButton.hidden = NO;
        
        [self.view addSubview:fakeButton];
        
        CGFloat f = arrExams.count * 40;
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:fakeButton :&f :(NSArray *)arrExams :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 14;
        
        if ([arrExams count] > 0) {
            scrollView.scrollEnabled = FALSE;
        }
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
        [fakeButton removeFromSuperview];
        scrollView.scrollEnabled = TRUE;
    }
}

- (IBAction)btnSelectYearPress:(UIButton *)sender {
    
    if(dropDown == nil) {
        
        CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
        
        if (IS_IPAD) {
            fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +30, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        }
        else {
            fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +15, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        }
        [fakeButton addTarget:self action:@selector(btnSelectYearPress:) forControlEvents:UIControlEventTouchUpInside];
        fakeButton.tag = sender.tag;
        fakeButton.hidden = NO;
        
        [self.view addSubview:fakeButton];
        
        CGFloat f;
        if (IS_IPAD) {
            f = arrYear.count * 50;
        }
        else {
            f = arrYear.count * 40;
        }
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:fakeButton :&f :(NSArray *)arrYear :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 11;
        scrollView.scrollEnabled = FALSE;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
        scrollView.scrollEnabled = TRUE;
        [fakeButton removeFromSuperview];
    }
}

- (IBAction)btnSelecteSemPress:(UIButton *)sender {
    
    if(dropDown == nil) {
        
        //CGRect lastViewRect = [sender convertRect:sender.frame toView:self.view];
        
        CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
        
        if (IS_IPAD) {
            fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +30, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        }
        else {
            fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +15, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        }
        [fakeButton addTarget:self action:@selector(btnSelecteSemPress:) forControlEvents:UIControlEventTouchUpInside];
        fakeButton.tag = 10;
        fakeButton.hidden = NO;
        
        [self.view addSubview:fakeButton];
        
        CGFloat f;
        if (IS_IPAD) {
            f = arrSem.count * 50;
        }
        else {
            f = arrSem.count * 40;
        }
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:fakeButton :&f :(NSArray *)arrSem :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 12;
        
        scrollView.scrollEnabled = FALSE;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
        [fakeButton removeFromSuperview];
        scrollView.scrollEnabled = TRUE;
    }
}

- (IBAction)btnSelecteSubPress:(UIButton *)sender {

    if(dropDown == nil) {
        
        CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
        
        if (IS_IPAD) {
            fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +30, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        }
        else {
            fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +15, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        }
        [fakeButton addTarget:self action:@selector(btnSelecteSubPress:) forControlEvents:UIControlEventTouchUpInside];
        fakeButton.tag = sender.tag;
        fakeButton.hidden = NO;
        
        [self.view addSubview:fakeButton];
        
        CGFloat f;
        if (IS_IPAD) {
            f = arrSubject.count * 50;
        }
        else {
            f = arrSubject.count * 40;
        }
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:fakeButton :&f :(NSArray *)arrSubject :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 13;
        scrollView.scrollEnabled = FALSE;
    }
    else {
        [fakeButton removeFromSuperview];
        [dropDown hideDropDown:sender];
        dropDown = nil;
        scrollView.scrollEnabled = TRUE;
    }
}


- (void)niDropDownDelegateMethod: (TeacherNIDropDown *) sender {
    
    [fakeButton removeFromSuperview];
    dropDown = nil;
    scrollView.scrollEnabled = TRUE;
    
    if (sender.tag == 11) {
        
        selctedYear = [arrYear objectAtIndex:sender.index];
        selctedYearId = [arrYear objectAtIndex:sender.index];
        [btnSelecteYear setTitle:selctedYear  forState:UIControlStateNormal];
        [btnSelecteYear setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        btnSelecteYear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
    if (sender.tag == 12) {
        
        selctedSem = [arrSem objectAtIndex:sender.index];
       // [btnSelecteSem setTitle:selctedSem  forState:UIControlStateNormal];
       // [btnSelecteSem setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
      //  btnSelecteSem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        [btnSelecteSem setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        if (IS_IPAD) {
            btnSelecteSem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
        }
        else {
            btnSelecteSem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
        }
        
        lblSemesterNum.text = selctedSem;
        
        for (NSDictionary *dicValue in arrAllSemester) {
            
            if ([selctedSem isEqualToString:[dicValue valueForKey:@"semester_name"]] ) {
                selctedSemId = [dicValue valueForKey:@"semester_id"];
            }
        }
        
        lblExamNo.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_TEST_NO_TITLE"];
        selctedExamNo = @"";
        
        [arrSelectedExam removeAllObjects];
        
        for (NSDictionary *dicUserDetail in arrUserDetail) {
            
            if ([[dicUserDetail valueForKey:@"semester_id"] isEqualToString:selctedSemId] && [[dicUserDetail valueForKey:@"subject_id"] isEqualToString:selctedSubjId]) {
                
                [arrSelectedExam addObject:[dicUserDetail valueForKey:@"exam_no"]];
            }
        }
        for (NSDictionary *dicUserDetail in arrSelectedExamLocal) {
            
            if ([[dicUserDetail valueForKey:@"semester_id"] isEqualToString:selctedSemId] && [[dicUserDetail valueForKey:@"subject_id"] isEqualToString:selctedSubjId]) {
                
                [arrSelectedExam addObject:[dicUserDetail valueForKey:@"exam_no"]];
            }
        }
        
        [self filterExam:arrSelectedExam];
        
      //  [self getValueForUser:selctedYearId sem:selctedSemId tno:selctedExamNo subj:selctedSubjId];
    }
    if (sender.tag == 13) {
        
        selctedSubj = [arrSubject objectAtIndex:sender.index];
       // [btnSelectSub setTitle:selctedSubj  forState:UIControlStateNormal];
       // [btnSelectSub setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
       // btnSelectSub.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [btnSelectSub setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        if (IS_IPAD) {
            btnSelectSub.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
        }
        else {
            btnSelectSub.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
        }
        
        lblselectSubject.text = selctedSubj;
        
        for (NSDictionary *dicValue in arrAllSubject) {
            
            if ([selctedSubj isEqualToString:[dicValue valueForKey:@"subject_name"]] ) {
                selctedSubjId = [dicValue valueForKey:@"subject_id"];
            }
        }
        
        lblExamNo.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_TEST_NO_TITLE"];
        selctedExamNo = @"";
        [arrSelectedExam removeAllObjects];
        
        for (NSDictionary *dicUserDetail in arrUserDetail) {
            
            if ([[dicUserDetail valueForKey:@"semester_id"] isEqualToString:selctedSemId] && [[dicUserDetail valueForKey:@"subject_id"] isEqualToString:selctedSubjId]) {
                
                [arrSelectedExam addObject:[dicUserDetail valueForKey:@"exam_no"]];
            }
        }
        for (NSDictionary *dicUserDetail in arrSelectedExamLocal) {
            
            if ([[dicUserDetail valueForKey:@"semester_id"] isEqualToString:selctedSemId] && [[dicUserDetail valueForKey:@"subject_id"] isEqualToString:selctedSubjId]) {
                
                [arrSelectedExam addObject:[dicUserDetail valueForKey:@"exam_no"]];
            }
        }
        
        [self filterExam:arrSelectedExam];
        
        
     //   [self getValueForUser:selctedYearId sem:selctedSemId tno:selctedExamNo subj:selctedSubjId];
    }
    if (sender.tag == 14) {
        
        selctedExam = [arrExams objectAtIndex:sender.index];
//        [btnSelectExam setTitle:selctedExam  forState:UIControlStateNormal];
//        [btnSelectExam setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        btnSelectExam.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [btnSelectExam setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
        if (IS_IPAD) {
            btnSelectExam.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 90));
        }
        else {
            btnSelectExam.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
        }
        
        lblExamNo.text = selctedExam;
        
        for (NSDictionary *dicValue in arrAllExam) {
            
            if ([selctedExam isEqualToString:[dicValue valueForKey:@"Exam"]] ) {
                selctedExamNo = [dicValue valueForKey:@"No"];
            }
        }
        
     //   [self getValueForUser:selctedYearId sem:selctedSemId tno:selctedExamNo subj:selctedSubjId];
    }
}

-(void)filterExam:(NSMutableArray *)arr {

    [arrExams removeAllObjects];
    [arrAllExam removeAllObjects];
    
    for (int i = 1; i <= NO_OF_EXAM; i++) {
        NSString *str = [NSString stringWithFormat:@"%@ %d",[GeneralUtil getLocalizedText:@"LBL_TEST_NO_TITLE"],i];
        NSMutableDictionary *dicExam = [[NSMutableDictionary alloc] init];
        [dicExam setObject:[NSString stringWithFormat:@"%d",i] forKey:@"No"];
        [dicExam setObject:str forKey:@"Exam"];
        
        NSString *test = [NSString stringWithFormat:@"%d",i];
        
        if (![arr containsObject:test]) {
            [arrExams addObject:str];
            [arrAllExam addObject:dicExam];
        }
    }
    
    if (arrExams.count > 0) {
        selctedExam = [arrExams firstObject];
        lblExamNo.text = selctedExam;
        selctedExamNo = [[arrAllExam firstObject] valueForKey:@"No"];
    }
}

- (IBAction)btnSavePress:(id)sender {
    
    [txvComments resignFirstResponder];
    [txtEnterMark resignFirstResponder];
    [txtExamAbout resignFirstResponder];
    
    if (selctedYearId == nil || [selctedYearId isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_YEAR"]];
    }
    else if (selctedSemId == nil || [selctedSemId isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_SEMESTER"]];
    }
    else if (selctedSubjId == nil || [selctedSubjId isEqualToString:@""] ) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_SUBJECT"]];
    }
    else if (selctedExamNo == nil || [selctedExamNo isEqualToString:@""] ) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_EXAM"]];
    }
    else if (sdate == nil || [sdate isEqualToString:@""] ) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_DATE"]];
    }
    else if ([txtExamAbout.text isEqualToString:@""] ) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_EXAM_ABOUT"]];
    }
//    else if ([txvComments.text isEqualToString:@""]) {
//        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_COMMENT"]];
//    }
    
    
//    else if ([txtEnterMark.text isEqualToString:@""] ) {
//        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_MARKS"]];
//    }
    else {
        [userObj addStudantMark:[dicStud valueForKey:@"class_id"] year:selctedYearId subjectId:selctedSubjId userId:[dicStud valueForKey:@"user_id"] semId:selctedSemId examNo:selctedExamNo marks:txtEnterMark.text comments:txvComments.text image:smllImage removeimage:isRemoveImage examDate:sdate examAbout:txtExamAbout.text teacherId:[GeneralUtil getUserPreference:key_teacherId]  :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    
                    [testDetail setObject:txtEnterMark.text forKey:@"marks"];
                    [testDetail setObject:txtExamAbout.text forKey:@"exam_about"];
                    [testDetail setObject:txvComments.text forKey:@"comment"];
                    [testDetail setObject:sdate forKey:@"exam_date"];
                    [testDetail setObject:selctedExamNo forKey:@"exam_no"];
                    [testDetail setObject:[dicRes valueForKey:@"url"] forKey:@"image"];
                    
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_MARKS_SAVE_SUCCESS"] WithDelegate:self];
                    
                    NSMutableDictionary *dicSelectedExam = [[NSMutableDictionary alloc] init];
                    
                    [dicSelectedExam setObject:selctedSubjId forKey:@"subject_id"];
                    [dicSelectedExam setObject:selctedSemId forKey:@"semester_id"];
                    [dicSelectedExam setObject:selctedExamNo forKey:@"exam_no"];
                    
                    
                    [arrSelectedExamLocal addObject:dicSelectedExam];
                    
                    txtEnterMark.text = @"";
                    txtExamAbout.text = @"";
                    txvComments.text =@"";
                    selctedSemId = @"";
                    selctedSubjId = @"";
                    selctedExamNo = @"";
                    lblSemesterNum.text = [GeneralUtil getLocalizedText:@"LBL_SEM_NUMEBER_TITLE"];
                    lblselectSubject.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_SUB_TITLE"];
                    lblExamNo.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_TEST_NO_TITLE"];
                    imgMarks.image = [UIImage imageNamed:@""];
                    btnDeleteImage.hidden = YES;
                    lblComment.hidden = NO;
                }
                else {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_FAID_TO_DATA_SAVE"]];
                }
            }
            else {
                NSLog(@"Request Fail...");
            }
            
            [btnTackeOrZoomPhoto setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        }];
    }
}

- (IBAction)btnSelecteDatePress:(id)sender {

    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
    
    [picker setMaximumDate:[GeneralUtil getYearEndDate]];
    [picker setMinimumDate:[GeneralUtil getYearStartDate]];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
  //  [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    lblSelecteDate.text = [formatter stringFromDate:date];
    
    [btnSelectExam setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
    btnSelectExam.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(SCREEN_WIDTH - 50));
    
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    sdate = [formatter stringFromDate:date];
}

-(void)getValueForUser:(NSString *)year sem:(NSString *)sem tno:(NSString *)tNo subj:(NSString *)subject {
    
    BOOL isfind = false;
    
    for (NSDictionary *userDetail in arrUserDetail) {
        
        if ([year isEqualToString:[userDetail valueForKey:@"year"]] && [sem isEqualToString:[userDetail valueForKey:@"semester_id"]] && [subject isEqualToString:[userDetail valueForKey:@"subject_id"]] && [tNo isEqualToString:[userDetail valueForKey:@"exam_no"]]) {
            
            lblComment.hidden = YES;
            txvComments.text = [userDetail valueForKey:@"comment"];
            
           // imgMarks.image = [userDetail valueForKey:@"image"];
            
            if (![[userDetail valueForKey:@"image"] isEqualToString:@""]) {
                
                [imgMarks setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[userDetail valueForKey:@"image"]]]];
                
                [btnTackeOrZoomPhoto setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                btnDeleteImage.hidden = NO;
            }
            else {
                imgMarks.image = [UIImage imageNamed:@""];
                [btnTackeOrZoomPhoto setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
                btnTackeOrZoomPhoto.hidden = NO;
                btnDeleteImage.hidden = YES;
            }
            isfind = true;
            
            txtExamAbout.text = [userDetail valueForKey:@"exam_about"];
            txtEnterMark.text = [userDetail valueForKey:@"marks"];
            
            break;
        }
    }
    
    if (!isfind) {
        
        lblComment.hidden = NO;
        txvComments.text = @"";
        txtExamAbout.text = @"";
        txtEnterMark.text = @"";
        imgMarks.image = [UIImage imageNamed:@""];
        [btnTackeOrZoomPhoto setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        btnTackeOrZoomPhoto.hidden = NO;
        btnDeleteImage.hidden = YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    scrollView.scrollEnabled = TRUE;
    [fakeButton removeFromSuperview];
    [dropDown hideDropDown:fakeButton];
    dropDown = nil;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    scrollView.scrollEnabled = TRUE;
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

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_isEdit) {
        [self.delegate onSaveCompleted:testDetail];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
