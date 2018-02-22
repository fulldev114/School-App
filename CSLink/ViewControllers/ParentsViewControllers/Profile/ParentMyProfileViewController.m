//
//  MyProfileViewController.m
//  CSLink
//
//  Created by etech-dev on 6/2/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentMyProfileViewController.h"
#import "ParentConstant.h"
#import "BaseViewController.h"
#import "ParentUser.h"
#import "TeacherUser.h"

@interface ParentMyProfileViewController ()
{
    ParentUser *userObj;
    NSMutableDictionary *dicUserDetail;
    UIButton *btnCancel;
    UIButton *btnEdit;
    BOOL isEdit;
}
@end

@implementation ParentMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_MY_PROFILE"] WithSel:@selector(menuClick)];
    [BaseViewController setBackGroud:self];
    
    btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnEdit setFrame:CGRectMake(0, 0, 25, 25)];
    [btnEdit addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"edit-icon"];
    
    [btnEdit setBackgroundImage:image forState:UIControlStateNormal];
    [btnEdit setBackgroundImage:image forState:UIControlStateHighlighted];
    
    btnEdit.contentMode = UIViewContentModeCenter;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_IPAD) {
        [btnCancel setFrame:CGRectMake(0, 0, 100, 25)];
    }
    else {
        [btnCancel setFrame:CGRectMake(0, 0, 50, 25)];
    }
    btnCancel.titleLabel.font = FONT_16_BOLD;
    [btnCancel setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnCancel setTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.hidden = YES;
    
    bottomView.backgroundColor = APP_BACKGROUD_COLOR;
    
    btnUpdateUser.hidden = YES;
    bottomView.hidden = YES;
    
    userObj = [[ParentUser alloc] init];
    
    isEdit = NO;
    
    [self getUserDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserDetail {
    
    [userObj getUserProfile:[[GeneralUtil getUserPreference:key_selectedStudant] valueForKey:@"user_id"] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            dicUserDetail = [[[dicRes valueForKey:@"Child"] valueForKey:key_childs] objectAtIndex:0];
            [self setUpUi];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}


-(void)btnCancelClick {
    
    btnCancel.hidden = YES;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    self.navigationItem.rightBarButtonItem = editButton;
    
    txtParent1Value.hidden = YES;
    txtParent2Value.hidden = YES;
    txtParent3Value.hidden = YES;
    txtMobile1Value.hidden = YES;
    txtMobile2Value.hidden = YES;
    txtMobile3Value.hidden = YES;
    txtStudantName.hidden = YES;
    
    btnChoosProfileImage.hidden = YES;
    bottomView.hidden = YES;
    
    lblParent1Value.hidden =NO;
    lblMobile1Value.hidden = NO;
    lblParent2Value.hidden =NO;
    lblmobile2Value.hidden = NO;
    lblParent3Value.hidden =NO;
    lblmobile3Value.hidden = NO;
    lblStatus1.hidden = NO;
    lblStatus2.hidden = NO;
    lblStudantName.hidden =NO;
    
    if ([[dicUserDetail valueForKey:@"parent3name"] isEqualToString:@""]) {
        lblStatus3.hidden = YES;
    }
    else {
        lblStatus3.hidden = NO;
    }
    
    if ([[dicUserDetail valueForKey:@"parent2name"] isEqualToString:@""]) {
        lblStatus2.hidden = YES;
    }
    else {
        lblStatus2.hidden = NO;
    }
}

-(void)setUpUi {
    
    btnChoosProfileImage.hidden =YES;
    
    if (IS_IPHONE_5) {
        
        imgviewHeight.constant = 120;
        imgViewWidth.constant = 120;
        
        [BaseViewController setRoudRectImage:profileImg];
    }
    else {
        [BaseViewController setRoudRectImage:profileImg];
    }
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    lblStudantName.font = FONT_14_SEMIBOLD;
    lblStudantName.text = [dicUserDetail valueForKey:@"username"];
    
    lblSchoolInfo.textColor = TEXT_COLOR_CYNA;
    lblSchoolInfo.font = FONT_12_BOLD;
    lblSchoolInfo.text = [GeneralUtil getLocalizedText:@"LBL_SCH_INFO_TITLE"];
    
    seperatorSview.backgroundColor = TEXT_COLOR_CYNA;
    
    lblParentInfo.textColor = TEXT_COLOR_LIGHT_GREEN;
    lblParentInfo.font = FONT_12_BOLD;
    lblParentInfo.text = [GeneralUtil getLocalizedText:@"LBL_PRN_INFO_TITLE"];
    
    seperetorPview.backgroundColor = TEXT_COLOR_LIGHT_GREEN;
    
    lblSchName.text = [GeneralUtil getLocalizedText:@"LBL_SCH_NAME_TITLE"];
    lblSchName.font = FONT_14_LIGHT;
    
    lblClassName.text = [GeneralUtil getLocalizedText:@"LBL_CLS_NAME_TITLE"];
    lblClassName.font = FONT_14_LIGHT;
    
    lblClassInspcName.text = [GeneralUtil getLocalizedText:@"LBL_CLS_INS_NAME_TITLE"];
    lblClassInspcName.font = FONT_14_LIGHT;
    
    lblParent1.text = [GeneralUtil getLocalizedText:@"LBL_PARENT1_TITLE"];
    lblParent1.font = FONT_14_LIGHT;
    
    lblMobile1.text = [GeneralUtil getLocalizedText:@"LBL_MOBILE1_TITLE"];
    lblMobile1.font = FONT_14_LIGHT;
    
    lblParent2.text = [GeneralUtil getLocalizedText:@"LBL_PARENT2_TITLE"];
    lblParent2.font = FONT_14_LIGHT;
    
    lblmobile2.text = [GeneralUtil getLocalizedText:@"LBL_MOBILE1_TITLE"];
    lblmobile2.font = FONT_14_LIGHT;
    
    lblParent3.text = [GeneralUtil getLocalizedText:@"LBL_PARENT3_TITLE"];
    lblParent3.font = FONT_14_LIGHT;
    
    lblmobile3.text = [GeneralUtil getLocalizedText:@"LBL_MOBILE1_TITLE"];
    lblmobile3.font = FONT_14_LIGHT;
    
    lblSchNameValue.text = [dicUserDetail valueForKey:@"school_name"];
    lblSchNameValue.font = FONT_14_SEMIBOLD;
    
    lblClassNameValue.text = [dicUserDetail valueForKey:@"class_name"];
    lblClassNameValue.font = FONT_14_SEMIBOLD;
    
    if ([dicUserDetail valueForKey:@"teachername"] == [NSNull null]) {
        lblClassinspcNameValue.text = @"";
        lblClassinspcNameValue.font = FONT_14_SEMIBOLD;
    }
    else {
        lblClassinspcNameValue.text = [dicUserDetail valueForKey:@"teachername"];
        lblClassinspcNameValue.font = FONT_14_SEMIBOLD;
    }
    
    lblParent1Value.text = [dicUserDetail valueForKey:@"parent1name"];
    lblParent1Value.font = FONT_14_SEMIBOLD;
    
    lblMobile1Value.text = [dicUserDetail valueForKey:@"parent1phone"];
    lblMobile1Value.font = FONT_14_SEMIBOLD;
    
    lblParent2Value.text = [dicUserDetail valueForKey:@"parent2name"];
    lblParent2Value.font = FONT_14_SEMIBOLD;
    
    lblmobile2Value.text = [dicUserDetail valueForKey:@"parent2phone"];
    lblmobile2Value.font = FONT_14_SEMIBOLD;
    
    if ([dicUserDetail valueForKey:@"parent3name"] == [NSNull null]) {
        lblParent3Value.text = @"";
        lblParent3Value.font = FONT_14_SEMIBOLD;
    }
    else {
        lblParent3Value.text = [dicUserDetail valueForKey:@"parent3name"];
        lblParent3Value.font = FONT_14_SEMIBOLD;
    }
    
    if ([dicUserDetail valueForKey:@"parent3mobile"] == [NSNull null]) {
        lblmobile3Value.text = @"";
        lblmobile3Value.font = FONT_14_SEMIBOLD;
    }
    else {
        lblmobile3Value.text = [dicUserDetail valueForKey:@"parent3mobile"];
        lblmobile3Value.font = FONT_14_SEMIBOLD;
    }
    
    lblStatus1.font = FONT_12_LIGHT;
    lblStatus2.font = FONT_12_LIGHT;
    lblStatus3.font = FONT_12_LIGHT;
    
    if ([[dicUserDetail valueForKey:@"status1"] intValue] == 1) {
        lblStatus1.text = [GeneralUtil getLocalizedText:@"LBL_ACTIVE_TITLE"];
    }
    else if ([[dicUserDetail valueForKey:@"status1"] intValue] == 0) {
        lblStatus1.text = [GeneralUtil getLocalizedText:@"LBL_BLOCK_TITLE"];
    }
    else {
        lblStatus1.text = [GeneralUtil getLocalizedText:@"LBL_INACTIVE_TITLE"];
    }
    if ([[dicUserDetail valueForKey:@"status2"] intValue] == 1) {
        lblStatus2.text = [GeneralUtil getLocalizedText:@"LBL_ACTIVE_TITLE"];
    }
    else if ([[dicUserDetail valueForKey:@"status2"] intValue] == 0) {
        lblStatus2.text = [GeneralUtil getLocalizedText:@"LBL_BLOCK_TITLE"];
    }
    else {
        lblStatus2.text = [GeneralUtil getLocalizedText:@"LBL_INACTIVE_TITLE"];
    }
    if ([[dicUserDetail valueForKey:@"status3"] intValue] == 1) {
        lblStatus3.text = [GeneralUtil getLocalizedText:@"LBL_ACTIVE_TITLE"];
    }
    else if ([[dicUserDetail valueForKey:@"status3"] intValue] == 0) {
        lblStatus3.text = [GeneralUtil getLocalizedText:@"LBL_BLOCK_TITLE"];
    }
    else {
        lblStatus3.text = [GeneralUtil getLocalizedText:@"LBL_INACTIVE_TITLE"];
    }
    
    [BaseViewController formateButtonCyne:btnUpdateUser title:[GeneralUtil getLocalizedText:@"BTN_UPDATE_PRO_TITLE"] withIcon:@"update-profile" withBgColor:TEXT_COLOR_CYNA];
    
    if ([[dicUserDetail valueForKey:@"parent3name"] isEqualToString:@""]) {
        lblStatus3.hidden = YES;
    }
    else {
        lblStatus3.hidden = NO;
    }
    if ([[dicUserDetail valueForKey:@"parent2name"] isEqualToString:@""]) {
        lblStatus2.hidden = YES;
    }
    else {
        lblStatus2.hidden = NO;
    }
}

-(void)menuClick {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}
-(void)editBtnClick {
    
    btnChoosProfileImage.hidden = NO;
    
    btnCancel.hidden = NO;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    lblParent1Value.hidden = NO;
    lblMobile1Value.hidden = NO;
    lblParent2Value.hidden = NO;
    lblmobile2Value.hidden = NO;
    lblParent3Value.hidden = NO;
    lblmobile3Value.hidden = NO;
    
    lblStatus1.hidden = YES;
    lblStatus2.hidden = YES;
    lblStatus3.hidden = YES;
    lblStudantName.hidden =YES;
    
    txtParent1Value.hidden = YES;
    txtParent2Value.hidden = YES;
    txtParent3Value.hidden = YES;
    txtMobile1Value.hidden = YES;
    txtMobile2Value.hidden = YES;
    txtMobile3Value.hidden = YES;
    txtStudantName.hidden = NO;
    
    txtMobile1Value.delegate = self;
    txtMobile2Value.delegate = self;
    txtMobile3Value.delegate = self;
    
    txtMobile1Value.keyboardType = UIKeyboardTypeNumberPad;
    txtMobile2Value.keyboardType = UIKeyboardTypeNumberPad;
    txtMobile3Value.keyboardType = UIKeyboardTypeNumberPad;
    
    //    txtMobile1Value.userInteractionEnabled = NO;
    //    txtMobile2Value.userInteractionEnabled = NO;
    //    txtMobile3Value.userInteractionEnabled = NO;
    
    txtParent1Value.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_FULL_NAME"];
    txtParent2Value.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_FULL_NAME"];
    txtParent3Value.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_FULL_NAME"];
    txtMobile1Value.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_PHONE_NO"];
    txtMobile2Value.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_PHONE_NO"];
    txtMobile3Value.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_PHONE_NO"];
    txtStudantName.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_FULL_NAME"];
    
    [BaseViewController getRoundRectTextField:txtParent1Value];
    [BaseViewController getRoundRectTextField:txtParent2Value];
    [BaseViewController getRoundRectTextField:txtParent3Value];
    [BaseViewController getRoundRectTextField:txtMobile1Value];
    [BaseViewController getRoundRectTextField:txtMobile2Value];
    [BaseViewController getRoundRectTextField:txtMobile3Value];
    [BaseViewController getRoundRectTextField:txtStudantName];
    
    txtStudantName.text = lblStudantName.text;
    txtParent1Value.text = lblParent1Value.text;
    txtParent2Value.text = lblParent2Value.text;
    txtParent3Value.text = lblParent3Value.text;
    
    txtMobile1Value.text = lblMobile1Value.text;
    txtMobile2Value.text = lblmobile2Value.text;
    txtMobile3Value.text = lblmobile3Value.text;
    
    btnUpdateUser.hidden = NO;
    bottomView.hidden = NO;
    
    ZDebug(@"%@", [GeneralUtil getUserPreference:key_myParentNo]);
    ZDebug(@"%@", lblMobile1Value.text);
    ZDebug(@"%@", lblmobile2Value.text);
    ZDebug(@"%@", txtMobile3Value.text);
    
    lblStatus1.hidden = YES;
    lblStatus2.hidden = YES;
    lblStatus3.hidden = YES;
    
    if ([lblMobile1Value.text isEqualToString:[GeneralUtil getUserPreference:key_myParentPhone]]) {
        lblMobile1Value.hidden =NO;
        txtMobile1Value.hidden = YES;
        lblStatus1.hidden = NO;
    }
    else if ([lblmobile2Value.text isEqualToString:[GeneralUtil getUserPreference:key_myParentPhone]]) {
        lblmobile2Value.hidden = NO;
        txtMobile2Value.hidden = YES;
        lblStatus2.hidden = NO;
    }
    else {
        lblmobile3Value.hidden = NO;
        txtMobile3Value.hidden = YES;
        lblStatus3.hidden = NO;
    }
    
    if ([[dicUserDetail valueForKey:@"parent3name"] isEqualToString:@""]) {
        lblStatus3.hidden = YES;
    }
    else {
        lblStatus3.hidden = NO;
    }
    if ([[dicUserDetail valueForKey:@"parent2name"] isEqualToString:@""]) {
        lblStatus2.hidden = YES;
    }
    else {
        lblStatus2.hidden = NO;
    }
}
- (IBAction)btnUpdateUserClick:(id)sender {
    
//    if ([txtStudantName.text isEqualToString:@""]) {
//        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_USERNAME"]];
//    }
//    else{
//        [self updateUser];
//    }
    
    //*
    
    if ([txtStudantName.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_USERNAME"]];
    }
    else if([txtParent1Value.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_FULLNAME"]];
    }
    else if([txtMobile1Value.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_PHONE"]];
    }
    else if(![GeneralUtil checkValidMobile:txtMobile1Value.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_PHONE"]];
    }
    else if (![txtParent2Value.text isEqualToString:@""]) {
        
        if([txtMobile2Value.text isEqualToString:@""]){
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_PHONE"]];
        }
        else  if ([GeneralUtil checkValidMobile:txtMobile2Value.text]) {
            
            if (![txtParent3Value.text isEqualToString:@""]) {
                
                if([txtMobile3Value.text isEqualToString:@""]){
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_PHONE"]];
                }
                else  if ([GeneralUtil checkValidMobile:txtMobile3Value.text]) {
                    [self updateUser];
                    return;
                }
                else {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_PHONE"]];
                }
            }
            else if (![txtMobile3Value.text isEqualToString:@""]) {
                
                if([txtParent3Value.text isEqualToString:@""]){
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_FULLNAME"]];
                }
                else  {
                    [self updateUser];
                }
            }
            else {
                [self updateUser];
            }
        }
        else {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_PHONE"]];
        }
    }
    else if (![txtParent3Value.text isEqualToString:@""]) {
        
        if([txtMobile3Value.text isEqualToString:@""]){
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_PHONE"]];
        }
        else  if ([GeneralUtil checkValidMobile:txtMobile3Value.text]) {
            [self updateUser];
        }
        else {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_PHONE"]];
        }
    }
    else if (![txtMobile2Value.text isEqualToString:@""]) {
        
        if([txtParent2Value.text isEqualToString:@""]){
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_FULLNAME"]];
        }
        else  if (![txtMobile3Value.text isEqualToString:@""]) {
            
            if([txtParent3Value.text isEqualToString:@""]){
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_FULLNAME"]];
            }
            else  {
                [self updateUser];
            }
        }
        else {
            [self updateUser];
        }
    }
    else if (![txtMobile3Value.text isEqualToString:@""]) {
        
        if([txtParent3Value.text isEqualToString:@""]){
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_FULLNAME"]];
        }
        else  {
            [self updateUser];
        }
    }
    else {
        [self updateUser];
    }
     /**/
}

- (IBAction)btnSelectProImg:(id)sender {
    
    UIImage *secondImage = [UIImage imageNamed:@"profile"];
    
    NSData *imgData1 = UIImagePNGRepresentation(profileImg.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(isCompare)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:[GeneralUtil getLocalizedText:@"LBL_ASHEET_PICKER_TITLE"]
                                      delegate:self
                                      cancelButtonTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CHOOSE"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CAMERA"], nil];
        
       // [actionSheet showInView:self.view];
        [actionSheet showFromRect:btnChoosProfileImage.frame inView:btnChoosProfileImage.superview animated: YES];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:[GeneralUtil getLocalizedText:@"LBL_ASHEET_PICKER_TITLE"]
                                      delegate:self
                                      cancelButtonTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CHOOSE"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CAMERA"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_REMOVE"], nil];
        
      //  [actionSheet showInView:self.view];
        [actionSheet showFromRect:btnChoosProfileImage.frame inView:btnChoosProfileImage.superview animated: YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CHOOSE"]]) {
        
        ipc=[[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        ipc.delegate=self;
        [ipc setAllowsEditing:YES];
        
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
        [ipc setAllowsEditing:YES];
        
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
        profileImg.image = [UIImage imageNamed:@"profile"];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    profileImg.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateUser {
    
    userObj.userId = [[GeneralUtil getUserPreference:key_selectedStudant] valueForKey:@"user_id"];
    userObj.persen1Name = txtParent1Value.text;
    userObj.persen1Phone = txtMobile1Value.text;
    userObj.persen2Name = txtParent2Value.text;
    userObj.persen2Phone = txtMobile2Value.text;
    userObj.persen3Name = txtParent3Value.text;
    userObj.persen3Phone = txtMobile3Value.text;
    userObj.profileImg.image = profileImg.image;
    
    [userObj updateUserProfile:[dicUserDetail valueForKey:@"school_id"] userName:txtStudantName.text  :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:key_flag] intValue] == 1) {
                
                NSArray *updateChiled = [[dicRes valueForKey:@"All childs"] valueForKey:@"allchilds"];
                
                NSMutableArray *arrStudtemp = [[NSMutableArray alloc] init];
                
                for (NSDictionary *stud in updateChiled) {
                    
                    if ([stud valueForKey:@"sfo_type"] == [NSNull null])
                        [stud setValue:@"0" forKey:@"sfo_type"];

                    [arrStudtemp addObject:stud];
                }
                
                NSMutableArray *arrStud = [[NSMutableArray alloc] initWithArray:arrStudtemp];
                
                [GeneralUtil setUserChildPreference:key_saveChild value:arrStud];
                
                [self updateDetaile:[[[dicRes valueForKey:@"Child"] valueForKey:key_childs] objectAtIndex:0]];
                
                dicUserDetail = [[[dicRes valueForKey:@"Child"] valueForKey:key_childs] objectAtIndex:0];
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_UPDATE_PROFILE_SUCCESSFULLY"]];
            }
            else if([[dicRes valueForKey:key_flag] intValue] == 0) {
                
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_UPDATE_PROFILE_FAIL"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)updateDetaile:(NSDictionary *)chiled {
    
    txtParent1Value.hidden = YES;
    txtParent2Value.hidden = YES;
    txtParent3Value.hidden = YES;
    txtMobile1Value.hidden = YES;
    txtMobile2Value.hidden = YES;
    txtMobile3Value.hidden = YES;
    txtStudantName.hidden = YES;
    
    lblParent1Value.hidden =NO;
    lblMobile1Value.hidden = NO;
    lblParent2Value.hidden =NO;
    lblmobile2Value.hidden = NO;
    lblParent3Value.hidden =NO;
    lblmobile3Value.hidden = NO;
    lblStatus1.hidden = NO;
    lblStatus2.hidden = NO;
    lblStatus3.hidden = NO;
    lblStudantName.hidden =NO;
    
    lblParent1Value.text = [chiled valueForKey:@"parent1name"];
    lblMobile1Value.text = [chiled valueForKey:@"parent1phone"];
    lblParent2Value.text = [chiled valueForKey:@"parent2name"];
    lblmobile2Value.text = [chiled valueForKey:@"parent2phone"];
    lblParent3Value.text = [chiled valueForKey:@"parent3name"];
    lblmobile3Value.text = [chiled valueForKey:@"parent3mobile"];
    
    lblStudantName.text = [chiled valueForKey:@"username"];
    
    if ([[chiled valueForKey:@"status1"] intValue] == 1) {
        lblStatus1.text = [GeneralUtil getLocalizedText:@"LBL_ACTIVE_TITLE"];
    }
    else if ([[dicUserDetail valueForKey:@"status1"] intValue] == 0) {
        lblStatus1.text = [GeneralUtil getLocalizedText:@"LBL_BLOCK_TITLE"];
    }
    else {
        lblStatus1.text = [GeneralUtil getLocalizedText:@"LBL_INACTIVE_TITLE"];
    }
    if ([[chiled valueForKey:@"status2"] intValue] == 1) {
        lblStatus2.text = [GeneralUtil getLocalizedText:@"LBL_ACTIVE_TITLE"];
    }
    else if ([[dicUserDetail valueForKey:@"status2"] intValue] == 0) {
        lblStatus2.text = [GeneralUtil getLocalizedText:@"LBL_BLOCK_TITLE"];
    }
    else {
        lblStatus2.text = [GeneralUtil getLocalizedText:@"LBL_INACTIVE_TITLE"];
    }
    if ([[chiled valueForKey:@"status3"] intValue] == 1) {
        lblStatus3.text = [GeneralUtil getLocalizedText:@"LBL_ACTIVE_TITLE"];
    }
    else if ([[dicUserDetail valueForKey:@"status3"] intValue] == 0) {
        lblStatus3.text = [GeneralUtil getLocalizedText:@"LBL_BLOCK_TITLE"];
    }
    else {
        lblStatus3.text = [GeneralUtil getLocalizedText:@"LBL_INACTIVE_TITLE"];
    }
    
    if ([[chiled valueForKey:@"parent3name"] isEqualToString:@""]) {
        lblStatus3.hidden = YES;
    }
    else {
        lblStatus3.hidden = NO;
    }
    
    if ([[chiled valueForKey:@"parent2name"] isEqualToString:@""]) {
        lblStatus2.hidden = YES;
    }
    else {
        lblStatus2.hidden = NO;
    }
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[chiled  valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    NSDictionary *selectedStud = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
    
    NSMutableDictionary *dicTempStud = [[NSMutableDictionary alloc] init];
    
    [dicTempStud setValue:[selectedStud  valueForKey:@"abi_badge"] forKey:@"abi_badge"];
    [dicTempStud setValue:[selectedStud valueForKey:@"abn_badge"] forKey:@"abn_badge"];
    [dicTempStud setValue:[selectedStud valueForKey:@"badge"] forKey:@"badge"];
    [dicTempStud setValue:[selectedStud  valueForKey:@"child_age"] forKey:@"child_age"];
    [dicTempStud setValue:[selectedStud valueForKey:@"child_gender"] forKey:@"child_gender"];
    [dicTempStud setValue:[selectedStud valueForKey:@"child_moblie"] forKey:@"child_moblie"];
    [dicTempStud setValue:[selectedStud valueForKey:@"jid"] forKey:@"jid"];
    [dicTempStud setValue:[selectedStud valueForKey:@"key"] forKey:@"key"];
    [dicTempStud setValue:[selectedStud valueForKey:@"parentemail"] forKey:@"parentemail"];
    [dicTempStud setValue:[selectedStud  valueForKey:@"school_class_id"] forKey:@"school_class_id"];
    [dicTempStud setValue:[selectedStud valueForKey:@"school_id"] forKey:@"school_id"];
    [dicTempStud setValue:[selectedStud valueForKey:@"school_name"] forKey:@"school_name"];
    [dicTempStud setValue:[selectedStud valueForKey:@"user_id"] forKey:@"user_id"];
    
    [dicTempStud setValue:[chiled  valueForKey:@"image"] forKey:@"child_image"];
    [dicTempStud setValue:[chiled valueForKey:@"parent1name"] forKey:@"parentname"];
    [dicTempStud setValue:[chiled valueForKey:@"username"] forKey:@"child_name"];
    
    ZDebug(@"%@", selectedStud);
    
    [GeneralUtil setUserChildDetailPreference:key_selectedStudant value:dicTempStud];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    btnUpdateUser.hidden = YES;
    bottomView.hidden = YES;
    btnChoosProfileImage.hidden = YES;
    btnCancel.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (txtMobile1Value == textField) {
        if ([currentString length] > 8) {
            return NO;
        }
    }
    if (txtMobile2Value == textField) {
        if ([currentString length] > 8) {
            return NO;
        }
    }
    if (txtMobile3Value == textField) {
        if ([currentString length] > 8) {
            return NO;
        }
    }
    return YES;
}

@end
