//
//  ApprovedViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/6/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ApprovedViewController.h"
#import "BaseViewController.h"
#import "TeacherConstant.h"
#import "TeacherUser.h"

@interface ApprovedViewController ()
{
    TeacherUser *userObj;
    NSString *parent1;
    NSString *parent2;
    NSString *Both;
    NSString *contect;
    
    int p1;
    int p2;
    int conactOther;
    int pboth;
}
@end

@implementation ApprovedViewController
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
    
    if ([dicStudDetail valueForKey:@"nc_parent_name"] == [NSNull  null] && [dicStudDetail valueForKey:@"parent_name"] == [NSNull  null]) {
        
        btnSave.hidden = YES;
    }
    else {
        btnSave.hidden = NO;
    }
    
    
    lblParentInfo.text = [GeneralUtil getLocalizedText:@"LBL_PRN_INFO_TITLE"];
    lblParentInfo.textColor = TEXT_COLOR_CYNA;
    lblParentInfo.font = FONT_18_SEMIBOLD;
    
    viewInfo.backgroundColor = TEXT_COLOR_CYNA;
    
    [BaseViewController setRoudRectImage:imgProfile];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
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
    
    lblMobile3.text = [GeneralUtil getLocalizedText:@"LBL_MOBILE_TITLE"];
    lblOtherContant.text = [GeneralUtil getLocalizedText:@"LBL_OTHER_CONTACT_TITLE"];
    lblMsgToContactPerson.text = [GeneralUtil getLocalizedText:@"LBL_MSG_TO_CONTACT_TITLE"];
    lblMsgToBothPerson.text = [GeneralUtil getLocalizedText:@"LBL_MSG_TO_BOTH_TITLE"];
    
    lblStudantName.text = [dicStudDetail valueForKey:@"name"];
    lblStudantName.font = FONT_16_BOLD;
    lblStudantName.textColor = TEXT_COLOR_CYNA;
    
    lblclassName.text = [dicStudDetail valueForKey:@"class_name"];
    lblclassName.font = FONT_16_LIGHT;
    
    btnParent1.titleLabel.font = FONT_12_BOLD;
    btnParent2.titleLabel.font = FONT_12_BOLD;
    
    if ([dicStudDetail valueForKey:@"parent_name"] == [NSNull null]) {
        lblParent1Value.text = @"";
    }
     else {
         lblParent1Value.text = [dicStudDetail valueForKey:@"parent_name"];
     }
    
    if ([dicStudDetail valueForKey:@"parent_phone"] == [NSNull null]) {
        lblMobile1Value.text = @"";
    }
    else {
        lblMobile1Value.text = [dicStudDetail valueForKey:@"parent_phone"];
    }
    
    if ([dicStudDetail valueForKey:@"parent2name"] == [NSNull null]) {
        
        lblParent2Value.text = @"";
        btnParent2.hidden = YES;
    }
    else {
        
        if ([[dicStudDetail valueForKey:@"parent2name"] isEqualToString:@""]) {
            btnParent2.hidden = YES;
        }
        else {
           
            btnParent2.hidden = NO;
        }
        lblParent2Value.text = [dicStudDetail valueForKey:@"parent2name"];
    }
    
    if ([dicStudDetail valueForKey:@"parent2mobile"] == [NSNull null]) {
        lblMobile2Value.text = @"";
    }
    else {
        lblMobile2Value.text = [dicStudDetail valueForKey:@"parent2mobile"];
    }
    
    if ([dicStudDetail valueForKey:@"contactmobilem"] == [NSNull null]) {
        txtMobile3.text = @"";
    }
    else {
        txtMobile3.text = [dicStudDetail valueForKey:@"contactmobilem"];
    }
    
    if ([dicStudDetail valueForKey:@"contactname"] == [NSNull null]) {
        txtOtherContect.text = @"";
    }
    else {
        txtOtherContect.text = [dicStudDetail valueForKey:@"contactname"];
    }
    
    if ([dicStudDetail valueForKey:@"status1"] == [NSNull null]) {
        [btnParent1 setTitle:[GeneralUtil getLocalizedText:@""] forState:UIControlStateNormal];
        
        p1 = 0;
        parent1 = @"Y";
    }
    else if ([[dicStudDetail valueForKey:@"status1"] intValue] == 0){
        [btnParent1 setTitle:[GeneralUtil getLocalizedText:@"BTN_UNBOLCK_USER_TITLE"] forState:UIControlStateNormal];
        btnParent1.tintColor = TEXT_COLOR_GREEN;
         p1 = 0;
        parent1 = @"Y";
    }
    else {
        [btnParent1 setTitle:[GeneralUtil getLocalizedText:@"BTN_BOLCK_USER_TITLE"] forState:UIControlStateNormal];
        btnParent1.tintColor = TEXT_COLOR_LIGHT_YELLOW;
         p1 = [[dicStudDetail valueForKey:@"status1"] intValue];
        
        parent1 = @"N";
    }
    
    if ([dicStudDetail valueForKey:@"status2"] == [NSNull null]) {
        [btnParent1 setTitle:[GeneralUtil getLocalizedText:@""] forState:UIControlStateNormal];
        p2 = 0;
        
        parent2 = @"Y";
    }
    else if ([[dicStudDetail valueForKey:@"status2"] intValue] == 0){
        [btnParent2 setTitle:[GeneralUtil getLocalizedText:@"BTN_UNBOLCK_USER_TITLE"] forState:UIControlStateNormal];
        btnParent2.tintColor = TEXT_COLOR_GREEN;
        p2 = 0;
        parent2 = @"Y";
    }
    else {
        [btnParent2 setTitle:[GeneralUtil getLocalizedText:@"BTN_BOLCK_USER_TITLE"] forState:UIControlStateNormal];
        btnParent2.tintColor = TEXT_COLOR_LIGHT_YELLOW;
        p2 = [[dicStudDetail valueForKey:@"status2"] intValue];
        parent2 = @"N";
    }
    
    if (p1 == 1 && p2 == 1) {
        
        [btnMsgToBothCheck setBackgroundImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateNormal];
        pboth = 1;
        Both = @"Y";
    }
    else {
        [btnMsgToBothCheck setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        pboth = 0;
        Both = @"N";
    }
    
    if ([dicStudDetail valueForKey:@"status3"] == [NSNull null]) {
        [btnMsgToContectCheck setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        conactOther = 0;
        contect = @"N";
    }
    else if ([[dicStudDetail valueForKey:@"status3"] intValue] == 0){
        [btnMsgToContectCheck setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        conactOther = 0;
        contect = @"N";
    }
    else {
        [btnMsgToContectCheck setBackgroundImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateNormal];
        conactOther = 1;
        contect = @"Y";
    }
    
    lblParent1.font = FONT_18_LIGHT;
    lblMobile1.font = FONT_18_LIGHT;
    lblParent2.font = FONT_18_LIGHT;
    lblMobile2.font = FONT_18_LIGHT;
    lblOtherContant.font = FONT_18_LIGHT;
    lblMobile3.font = FONT_18_LIGHT;
    lblMsgToBothPerson.font = FONT_18_LIGHT;
    lblMsgToContactPerson.font = FONT_18_LIGHT;
    
    lblParent1Value.font = FONT_18_BOLD;
    lblMobile1Value.font = FONT_18_BOLD;
    lblParent2Value.font = FONT_18_BOLD;
    lblMobile2Value.font = FONT_18_BOLD;
    
    [BaseViewController getRoundRectTextField:txtMobile3];
    [BaseViewController getRoundRectTextField:txtOtherContect];
    
    txtMobile3.delegate = self;
    txtMobile3.keyboardType = UIKeyboardTypeNumberPad;
    
    [BaseViewController formateButtonCyne:btnSave title:[GeneralUtil getLocalizedText:@"BTN_SAVE_TITLE"]];
    
    seperator1.backgroundColor = SEPERATOR_COLOR;
    seperator2.backgroundColor = SEPERATOR_COLOR;
    seperator3.backgroundColor = SEPERATOR_COLOR;
    seperator4.backgroundColor = SEPERATOR_COLOR;
    seperator5.backgroundColor = SEPERATOR_COLOR;
    seperator6.backgroundColor = SEPERATOR_COLOR;
    seperator7.backgroundColor = SEPERATOR_COLOR;
}

- (IBAction)btnSavePress:(id)sender {
    
    NSMutableDictionary *checkDetail = [[NSMutableDictionary alloc] init];
    
    [checkDetail setObject:parent1 forKey:@"checked1"];
    [checkDetail setObject:parent2 forKey:@"checked2"];
    [checkDetail setObject:Both forKey:@"bothchecked"];
    [checkDetail setObject:contect forKey:@"contactchecked"];
    [checkDetail setObject:txtOtherContect.text forKey:@"contact_name"];
    [checkDetail setObject:txtMobile3.text forKey:@"contact_mobile"];
    
    [userObj studCheckedDetail:[GeneralUtil getUserPreference:key_teacherId] childid:[dicStudDetail valueForKey:@"user_id"] checkeddetail:checkDetail :^(NSObject *resObj){
    
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            int resCode = [[dicRes valueForKey:@"flag"] intValue];
            
            if (resCode == RES_CODE_01) {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SETTING_SUCCESS"]];
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

- (IBAction)btnParent1Press:(id)sender {

    if (p1 == 0){
        [btnParent1 setTitle:[GeneralUtil getLocalizedText:@"BTN_BOLCK_USER_TITLE"] forState:UIControlStateNormal];
        btnParent1.tintColor = TEXT_COLOR_LIGHT_YELLOW;
        p1 = 1;
        parent1 = @"N";
        
    }
    else {
        [self showAletrt:[GeneralUtil getLocalizedText:@"MSG_BLOCK_PARENT"] :1];
    }
}

- (IBAction)btnParent2Press:(id)sender {
    
    if (p2 == 0){
        [btnParent2 setTitle:[GeneralUtil getLocalizedText:@"BTN_BOLCK_USER_TITLE"] forState:UIControlStateNormal];
        btnParent2.tintColor = TEXT_COLOR_LIGHT_YELLOW;
        p2 = 2;
        parent2 = @"N";
    }
    else {
        [self showAletrt:[GeneralUtil getLocalizedText:@"MSG_BLOCK_PARENT"] :2];
    }
}

- (IBAction)btnMsgBothPress:(id)sender {

    if (pboth) {
        [btnMsgToBothCheck setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        pboth = 0;
        Both = @"N";
        
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_BOTH_PARENT_OFF"]];
    }
    else if (conactOther == 1){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CAN_NO_SEND_PARENT_AND_CONTECT"]];
    }
    else if (p1 == 1 && p2 == 2 ) {
        
        [btnMsgToBothCheck setBackgroundImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateNormal];
        pboth = 1;
        Both = @"Y";
        
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_BOTH_PARENT_ON"]];
    }
    else if (p1 == 1 && p2 == 1 ) {
        
        [btnMsgToBothCheck setBackgroundImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateNormal];
        pboth = 1;
        Both = @"Y";
        
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_BOTH_PARENT_ON"]];
    }
    else {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_PERANT1_OR_PARENT2_ARE_BLOCK"]];
    }
}

- (IBAction)btnMsgToContectPress:(id)sender {

    if (conactOther) {
        [btnMsgToContectCheck setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        conactOther = 0;
        contect = @"N";
        p1 = 1;
        p2 = 2;
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CONTECT_PARENT_OFF"]];
    }
    else if ([txtOtherContect.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_FULLNAME"]];
    }
    else if ([txtMobile3.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_MOBILE"]];
    }
    else if (![GeneralUtil checkValidMobile:txtMobile3.text]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_MOBILE"]];
    }
    else if (pboth){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CAN_NO_SEND_PARENT_AND_CONTECT"]];
    }
    else {
        [btnMsgToContectCheck setBackgroundImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateNormal];
        conactOther = 1;
        contect = @"Y";
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CONTECT_PARENT_ON"]];
    }
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
        
       // [actionSheet showInView:self.view];
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
        
       // [actionSheet showInView:self.view];
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
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)showAletrt:(NSString *)msg :(int)tag {

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppName" message:msg delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"OK", nil];
//    alert.tag = tag;
//    [alert show];
    
    CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:msg Delegate:self];
    alertView.tag = tag;
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (customAlertView.tag == 1) {
        if (buttonIndex == 1) {
            
        }
        else {
            [btnParent1 setTitle:[GeneralUtil getLocalizedText:@"BTN_UNBOLCK_USER_TITLE"] forState:UIControlStateNormal];
            btnParent1.tintColor = TEXT_COLOR_GREEN;
            p1 = 0;
            parent1 = @"Y";
            Both = @"N";
            [btnMsgToBothCheck setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            pboth = 0;
        }
    }
    if (customAlertView.tag == 2) {
        if (buttonIndex == 1) {
            
        }
        else {
            
            [btnParent2 setTitle:[GeneralUtil getLocalizedText:@"BTN_UNBOLCK_USER_TITLE"] forState:UIControlStateNormal];
            btnParent2.tintColor = TEXT_COLOR_GREEN;
            p2 = 0;
            parent2 = @"Y";
            Both = @"N";
            [btnMsgToBothCheck setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            pboth = 0;
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (txtMobile3== textField) {
        if ([currentString length] > 8) {
            return NO;
        }
    }
    return YES;
}
@end
