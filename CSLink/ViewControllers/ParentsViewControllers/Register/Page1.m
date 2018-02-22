//
//  PerentRegisterViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "Page1.h"
#import "ParentUser.h"
#import "BaseViewController.h"

@interface Page1 ()
{
    ParentUser *userObj;
}
@end

@implementation Page1

- (void)viewDidLoad {
    [super viewDidLoad];
    userObj = [[ParentUser alloc] init];
    [self setUpUi];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpUi {
    
    self.navigationController.navigationBarHidden = NO;
    
    //[BaseViewController setBackGroud:self];
    //[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_REGISTER"] WithSel:@selector(backButtonClick)];

    lblParent1.textColor = TEXT_COLOR_CYNA;
    lblParent1.font = FONT_16_REGULER;
    
    lblParent1.text = [GeneralUtil getLocalizedText:@"LBL_PARENT1_TITLE"];
    seperatorView.backgroundColor = TEXT_COLOR_CYNA;
    
    self.txtNameP1.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_FULL_NAME"];
    self.txtEmailP1.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_EMAIL"];
    self.txtPhoneP1.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_PHONE_NO"];
    self.txtPinCode.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_PINCODE"];
    self.txtConformPin.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_CONF_PINCODE"];
    
    [BaseViewController getRoundRectTextField:self.txtNameP1 withIcon:@"my-profile"];
    [BaseViewController getRoundRectTextField:self.txtEmailP1 withIcon:@"email"];
    [BaseViewController getRoundRectTextField:self.txtPhoneP1 withIcon:@"mobile-icon"];
    [BaseViewController getRoundRectTextField:self.txtPinCode withIcon:@"change-pincode"];
    [BaseViewController getRoundRectTextField:self.txtConformPin withIcon:@"change-pincode"];
    [BaseViewController formateButtonCyne:btnNext title:[GeneralUtil getLocalizedText:@"BTN_NEXT_TITLE"] withIcon:@"next-arrow" withBgColor:TEXT_COLOR_CYNA];
    
    self.txtPinCode.keyboardType = UIKeyboardTypeNumberPad;
    self.txtConformPin.keyboardType = UIKeyboardTypeNumberPad;
    self.txtPhoneP1.keyboardType = UIKeyboardTypeNumberPad;
    self.txtEmailP1.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.txtNameP1.delegate = self;
    self.txtPinCode.delegate = self;
    self.txtConformPin.delegate = self;
    self.txtPhoneP1.delegate = self;
    self.txtEmailP1.delegate = self;
    
    self.txtConformPin.secureTextEntry = YES;
    self.txtPinCode.secureTextEntry = YES;
    
    self.txtEmailP1.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if( IS_IPHONE_5 )
    {
        self.imageViewSize.constant = 80;
    }
}
 -(void)backButtonClick{
     
     [self.navigationController popViewControllerAnimated:YES];
 }
 
- (IBAction)btnRegisterPress:(id)sender {
    
    if ([self.txtNameP1.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_FULLNAME"]];
    }
    else if([self.txtPhoneP1.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_PHONE"]];
    }
    else if(![GeneralUtil checkValidMobile:self.txtPhoneP1.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_PHONE"]];
    }
    else if([self.txtPinCode.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_PIN_CODE"]];
    }
    else if(![GeneralUtil checkPinCode:self.txtPinCode.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_PINCODE"]];
    }
    else if([self.txtConformPin.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CONFIRM_PIN_CODE"]];
    }
    else if(![GeneralUtil checkPinCode:self.txtConformPin.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_CONFIRM_PINCODE"]];
    }
    else if(![self.txtConformPin.text isEqualToString:self.txtPinCode.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CONFIRM_PIN_CODE_MISSMATCH"]];
    }
    else if(![self.txtEmailP1.text isEqualToString:@""]){
        if ([GeneralUtil NSStringIsValidEmail:self.txtEmailP1.text]) {
            [self.delegate btnNextButtonPressed];
        }
        else {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_EMAIL"]];
        }
    }
    else {
        [self.delegate btnNextButtonPressed];
    }

    //[self.delegate btnNextButtonPressed];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)walkthroughDidScroll:(CGFloat)position offset:(CGFloat)offset {
    
    CATransform3D tr = CATransform3DIdentity;
    tr.m34 = -1/500.0;
    CGFloat tmpOffset = offset;
    if (tmpOffset > 1.0){
        tmpOffset = 1.0 + (1.0 - tmpOffset);
    }
    // imageviewInvoice.layer.transform = CATransform3DTranslate(tr, 0 , (1.0 - tmpOffset) * 200, 0);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.txtPhoneP1== textField) {
        if ([currentString length] > 8) {
            return NO;
        }
    }
    if (self.txtPinCode == textField) {
        if ([currentString length] > 4) {
            return NO;
        }
    }
    if (self.txtConformPin == textField) {
        if ([currentString length] > 4) {
            return NO;
        }
    }
    return YES;
}

@end
