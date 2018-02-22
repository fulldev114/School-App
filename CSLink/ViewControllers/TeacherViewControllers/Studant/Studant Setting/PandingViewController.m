//
//  PandingViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/6/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "PandingViewController.h"
#import "BaseViewController.h"
#import "TeacherUser.h"
#import "TeacherConstant.h"

@interface PandingViewController ()
{
    TeacherUser *userObj;
}
@end

@implementation PandingViewController
@synthesize dicStudDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_STUDENTS_SETTING"] WithSel:@selector(backButtonClick)];
    
    userObj = [[TeacherUser alloc] init];
    
    [self setUpUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpUi {
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    lblParentInfo.text = [GeneralUtil getLocalizedText:@"LBL_PRN_INFO_TITLE"];
    lblParentInfo.textColor = TEXT_COLOR_CYNA;
    lblParentInfo.font = FONT_18_SEMIBOLD;
    
    ViewInfo.backgroundColor = TEXT_COLOR_CYNA;
    
    [BaseViewController setRoudRectImage:imgProfile];
    
    imgProfile.layer.cornerRadius = 50;
    imgProfile.layer.masksToBounds = YES;
    
    [imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@""]];
    
    if ([dicStudDetail valueForKey:@"image"] == nil) {
        
        btnProfileWidth.constant = 80;
        btnProfileHeight.constant = 100;
        [BaseViewController formateButtonCyne:btnChooseProfile title:@"upload Image" withIcon:@"upload-image" titleColor:[UIColor whiteColor]];
    }
    else {
        btnProfileWidth.constant = 40;
        btnProfileHeight.constant = 40;
        [btnChooseProfile setImage:[UIImage imageNamed:@"addIcon"] forState:UIControlStateNormal];
    }
    
    lblParent1.text = [GeneralUtil getLocalizedText:@"LBL_PARENT1_TITLE"];
    lblMobile1.text = [GeneralUtil getLocalizedText:@"LBL_MOBILE1_TITLE"];
    lblParent2.text = [GeneralUtil getLocalizedText:@"LBL_PARENT2_TITLE"];
    lblMobile2.text = [GeneralUtil getLocalizedText:@"LBL_MOBILE2_TITLE"];
    
    lblStudName.text = [dicStudDetail valueForKey:@"name"];
    lblStudName.font = FONT_16_BOLD;
    lblStudName.textColor = TEXT_COLOR_CYNA;

    lblClassName.text = [dicStudDetail valueForKey:@"class_name"];
    lblClassName.font = FONT_16_LIGHT;
    
    if ([dicStudDetail valueForKey:@"nc_parent_name"] == [NSNull null]) {
        lblParent1Value.text = @"";
    }
    else {
        lblParent1Value.text = [dicStudDetail valueForKey:@"nc_parent_name"];
    }
    
    if ([dicStudDetail valueForKey:@"nc_phone"] == [NSNull null]) {
        lblMobile1Value.text = @"";
    }
    else {
        lblMobile1Value.text = [dicStudDetail valueForKey:@"nc_phone"];
    }
    
    if ([dicStudDetail valueForKey:@"nc_parent_name_2"] == [NSNull null]) {
        lblParent2Value.text = @"";
    }
    else {
        lblParent2Value.text = [dicStudDetail valueForKey:@"nc_parent_name_2"];
    }
    
    if ([dicStudDetail valueForKey:@"nc_phone_2"] == [NSNull null]) {
        lblMobile2Value.text = @"";
    }
    else {
        lblMobile2Value.text = [dicStudDetail valueForKey:@"nc_phone_2"];
    }
    
    lblParent1.font = FONT_18_LIGHT;
    lblMobile1.font = FONT_18_LIGHT;
    lblParent2.font = FONT_18_LIGHT;
    lblMobile2.font = FONT_18_LIGHT;
    
    lblParent1Value.font = FONT_18_BOLD;
    lblMobile1Value.font = FONT_18_BOLD;
    lblParent2Value.font = FONT_18_BOLD;
    lblMobile2Value.font = FONT_18_BOLD;
    
    [BaseViewController formateButtonCyne:btnApprove title:[GeneralUtil getLocalizedText:@"BTN_APPROVE_TITLE"]];
    btnApprove.backgroundColor = TEXT_COLOR_GREEN;
    [BaseViewController formateButtonCyne:btnReject title:[GeneralUtil getLocalizedText:@"BTN_REJECT_TITLE"]];
    btnReject.backgroundColor = [UIColor redColor];
    
    seperator1.backgroundColor = SEPERATOR_COLOR;
    seperator2.backgroundColor = SEPERATOR_COLOR;
    seperator3.backgroundColor = SEPERATOR_COLOR;
}

- (IBAction)btnApprovePress:(id)sender {
    
    [userObj studRequestApproveOrReject:[GeneralUtil getUserPreference:key_teacherId] userId:[dicStudDetail valueForKey:@"user_id"] parentId:[dicStudDetail valueForKey:@"nc_parent_id"] value:@"Y" :^(NSObject *resObj){
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            int resCode = [[dicRes valueForKey:@"flag"] intValue];
            
            if (resCode == RES_CODE_00) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] > 4) {
                    
                    
                   CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_REQUEST_REJECT_SUCCESS"] WithDelegate:self];
                    alertView.tag = 2;
                    
                    NSString *studBadge = [GeneralUtil getUserPreference:key_studant_req_badge];
                    
                    if ([studBadge intValue] > 0) {
                        int tempStudBadge = [studBadge intValue] - 1;
                        
                        [GeneralUtil setUserPreference:key_studant_req_badge value:[NSString stringWithFormat:@"%d",tempStudBadge]];
                    }
                }
            }
            else if (resCode == RES_CODE_01) {
                
                CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_REQUEST_APPROVE_SUCCESS"] WithDelegate:self];
                alertView.tag = 2;
                
                NSString *studBadge = [GeneralUtil getUserPreference:key_studant_req_badge];
                
                if ([studBadge intValue] > 0) {
                    int tempStudBadge = [studBadge intValue] - 1;
                    
                    [GeneralUtil setUserPreference:key_studant_req_badge value:[NSString stringWithFormat:@"%d",tempStudBadge]];
                }
            }
            else {
                [GeneralUtil alertInfo:[dicRes valueForKey:@"msg"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (IBAction)btnRejectPress:(id)sender {
    
    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_REQUEST_REJECT_STUDENT"] Delegate:self];
}

- (IBAction)btnChooseProfilePress:(id)sender {
    
    UIImage *secondImage = [UIImage imageNamed:@"profile"];
    
    NSData *imgData1 = UIImagePNGRepresentation(imgProfile.image);
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
        [actionSheet showFromRect:btnChooseProfile.frame inView:btnChooseProfile.superview animated: YES];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:[GeneralUtil getLocalizedText:@"LBL_ASHEET_PICKER_TITLE"]
                                      delegate:self
                                      cancelButtonTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CHOOSE"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_CAMERA"],[GeneralUtil getLocalizedText:@"BTN_TTL_ASHEET_REMOVE"], nil];
        
        //[actionSheet showInView:self.view];
        [actionSheet showFromRect:btnChooseProfile.frame inView:btnChooseProfile.superview animated: YES];
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
        imgProfile.image = [UIImage imageNamed:@"profile"];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    imgProfile.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [userObj updateStudantProfile:[dicStudDetail valueForKey:@"user_id"] image:imgProfile :^(NSObject *resObj){
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            int resCode = [[dicRes valueForKey:@"flag"] intValue];
            
            if (resCode == RES_CODE_00) {
                
            }
            else if (resCode == RES_CODE_01) {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_UPLOAD_IMAGE_SUCCESS"]];
            }
            else {
                
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (customAlertView.tag == 2 ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        if (buttonIndex == 1) {
            
        }
        else {
            
            [userObj studRequestApproveOrReject:[GeneralUtil getUserPreference:key_teacherId] userId:[dicStudDetail valueForKey:@"user_id"] parentId:[dicStudDetail valueForKey:@"nc_parent_id"] value:@"N" :^(NSObject *resObj){
                
                [GeneralUtil hideProgress];
                
                NSDictionary *dicRes = (NSDictionary *)resObj;
                
                if (dicRes != nil) {
                    int resCode = [[dicRes valueForKey:@"flag"] intValue];
                    
                    if (resCode == RES_CODE_00) {
                        [GeneralUtil alertInfo:[dicRes valueForKey:@"msg"]];
                    }
                    else if (resCode == RES_CODE_01) {
                        
                        CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_REQUEST_REJECT_SUCCESS"] WithDelegate:self];
                        alertView.tag = 2;
                        
                        NSString *studBadge = [GeneralUtil getUserPreference:key_studant_req_badge];
                        
                        int tempStudBadge = [studBadge intValue] - 1;
                        
                        [GeneralUtil setUserPreference:key_studant_req_badge value:[NSString stringWithFormat:@"%d",tempStudBadge]];
                    }
                    else {
                        [GeneralUtil alertInfo:[dicRes valueForKey:@"msg"]];
                    }
                }
                else {
                    NSLog(@"Request Fail...");
                }
            }];
        }
    }
}

@end
