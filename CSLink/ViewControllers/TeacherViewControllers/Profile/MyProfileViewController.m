//
//  MyProfileViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/7/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "MyProfileViewController.h"
#import "BaseViewController.h"
#import "IQKeyboardManager.h"
#import "TeacherUser.h"
#import "TeacherConstant.h"

@interface MyProfileViewController ()
{
    TeacherUser *userObj;
    NSMutableDictionary *dicUserDetail;
    UIButton *btnCancel;
    UIButton *btnEdit;
}
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
   // [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_PROFILE"] WithSel:@selector(menuClick)];
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
    
    [BaseViewController formateButtonCyne:btnUpdateProfile title:[GeneralUtil getLocalizedText:@"BTN_UPDATE_PRO_TITLE"] withIcon:@"update-profile" withBgColor:TEXT_COLOR_CYNA];
    
    userObj = [[TeacherUser alloc] init];
    
    btnUpdateProfile.hidden = YES;
    
    [self getTeacherDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)menuClick {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}

-(void)btnCancelClick {
    
    btnCancel.hidden = YES;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    self.navigationItem.rightBarButtonItem = editButton;
    
    txtTeacherName.hidden = YES;
    txtMobileValue.hidden = YES;
    txtEmailValue.hidden = YES;
    
    lblTeacherName.hidden =NO;
    lblMobileValue.hidden = NO;
    lblEmailValue.hidden =NO;
    btnUpdateProfile.hidden = YES;
    btnSelecteProfile.hidden = YES;
}


-(void)editBtnClick {

    btnCancel.hidden = NO;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
  //  txtEmailValue.hidden = NO;
    txtMobileValue.hidden = NO;
    txtTeacherName.hidden = NO;
    
    txtEmailValue.text = lblEmailValue.text;
    txtMobileValue.text = lblMobileValue.text;
    txtTeacherName.text = lblTeacherName.text;
    
 //   lblEmailValue.hidden = YES;
    lblMobileValue.hidden = YES;
    lblTeacherName.hidden = YES;
    
    btnUpdateProfile.hidden = NO;
    btnSelecteProfile.hidden = NO;
}

-(void)getTeacherDetail {
    
    [userObj getTeacherDetail:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj){
    
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            dicUserDetail = [[[dicRes valueForKey:@"profileDetails"] objectAtIndex:0] objectAtIndex:0];
            [self setUpUi];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)setUpUi {

    [BaseViewController getRoundRectTextField:txtEmailValue];
    [BaseViewController getRoundRectTextField:txtMobileValue];
    [BaseViewController getRoundRectTextField:txtTeacherName];
    
    lblTeacherInfo.textColor = TEXT_COLOR_CYNA;
    viewInfo.backgroundColor = TEXT_COLOR_CYNA;
    
    
    
    [BaseViewController setRoudRectImage:profileImg];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[GeneralUtil getUserPreference:key_UserImage]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    lblTeacherName.font = FONT_16_BOLD;
    lblTeacherName.textColor = TEXT_COLOR_CYNA;
    lblTeacherName.text = [dicUserDetail valueForKey:@"name"];
    
    lblTeacherInfo.font = FONT_16_BOLD;
    lblEmailAddress.font = FONT_16_LIGHT;
    lblEmailValue.font = FONT_16_BOLD;
    lblMobile.font = FONT_16_LIGHT;
    lblMobileValue.font = FONT_16_BOLD;
    lblClassInCharge.font = FONT_16_LIGHT;
    lblClassValue.font = FONT_16_BOLD;
    lblSubjectValue.font = FONT_15_BOLD;
    
    lblTeacherInfo.text = [GeneralUtil getLocalizedText:@"LBL_TEACHER_INFO_TITLE"];
    
    lblEmailAddress.text = [GeneralUtil getLocalizedText:@"LBL_EMAIL_TITLE"];
    lblMobile.text = [GeneralUtil getLocalizedText:@"LBL_MOBILE_TITLE"];
    lblClassInCharge.text = [GeneralUtil getLocalizedText:@"LBL_TITLE_CLASS"];
    
    lblEmailValue.text = [dicUserDetail valueForKey:@"emailaddress"];
    lblMobileValue.text = [dicUserDetail valueForKey:@"mobile"];
    
    if ([dicUserDetail valueForKey:@"Classincharge"] == [NSNull null]) {
        lblClassValue.text = @"-";
    }
    else if([[dicUserDetail valueForKey:@"Classincharge"] isEqualToString:@""]) {
        lblClassValue.text = @"-";
    }
    else {
        lblClassValue.text = [dicUserDetail valueForKey:@"Classincharge"];
    }
    
    if ([dicUserDetail valueForKey:@"classsubject"] == [NSNull null]) {
        lblSubjectValue.text = @"";
    }
    else {
        lblSubjectValue.text = [dicUserDetail valueForKey:@"classsubject"];
    }
    
    btnUpdateProfile.hidden = YES;
    btnSelecteProfile.hidden = YES;
}

- (IBAction)btnUpdateProfileClick:(id)sender {
    
    if ([txtTeacherName.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_FULLNAME"]];
    }
    else if([txtMobileValue.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_MOBILE"]];
    }
    else if(![GeneralUtil checkValidMobile:txtMobileValue.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_MOBILE"]];
    }
    else if ([txtEmailValue.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_EMAIL"]];
    }
    else if (![GeneralUtil NSStringIsValidEmail:txtEmailValue.text]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_EMAIL"]];
    }
    else {
        [self updateTeacherDetail];
    }
}

- (IBAction)selecteProImg:(id)sender {
    
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
        
        //[actionSheet showInView:self.view];
        [actionSheet showFromRect:btnSelecteProfile.frame inView: btnSelecteProfile.superview animated: YES];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:[GeneralUtil getLocalizedText:@"LBL_ASHEET_PICKER_TITLE"]
                                      delegate:self
                                      cancelButtonTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CHOOSE"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CAMERA"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_REMOVE"], nil];
        
       // [actionSheet showInView:self.view];
        [actionSheet showFromRect:btnSelecteProfile.frame inView: btnSelecteProfile.superview animated: YES];
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

-(void)updateTeacherDetail {
    
    userObj.userId = [GeneralUtil getUserPreference:key_teacherId];
    userObj.email = txtEmailValue.text;
    userObj.mobile = txtMobileValue.text;
    userObj.profileImg.image = profileImg.image;
    
    [userObj updateTeacherDetail:txtTeacherName.text :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:key_flag] intValue] == 1) {
                
                [self updateDetaile:[[[dicRes valueForKey:@"Teacher"] valueForKey:@"teachers"] objectAtIndex:0]];
                
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
    
    txtTeacherName.hidden = YES;
    txtMobileValue.hidden = YES;
    txtEmailValue.hidden = YES;
    
    lblTeacherName.hidden =NO;
    lblMobileValue.hidden = NO;
    lblEmailValue.hidden =NO;
    
    lblTeacherName.text = [chiled valueForKey:@"username"];
    lblMobileValue.text = [chiled valueForKey:@"mobile"];
    lblEmailValue.text = [chiled valueForKey:@"emailaddress"];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[chiled valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    [GeneralUtil setUserPreference:key_UserImage value:[chiled valueForKey:@"image"]];
    
    btnUpdateProfile.hidden = YES;
    btnSelecteProfile.hidden = YES;
    btnCancel.hidden = YES;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    
    self.navigationItem.rightBarButtonItem = editButton;

}
@end
