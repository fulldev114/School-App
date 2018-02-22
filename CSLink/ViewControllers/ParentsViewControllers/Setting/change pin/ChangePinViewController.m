//
//  ChangePinViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ChangePinViewController.h"
#import "BaseViewController.h"

@interface ChangePinViewController ()
{
    ParentUser *userObj;
}
@end

@implementation ChangePinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_CHANGE_PINCODE"] WithSel:@selector(backButtonClick)];
    [BaseViewController formateButtonCyne:btnChangePin title:[GeneralUtil getLocalizedText:@"BTN_SAVE_PINCODE_TITLE"]];
    btnCancel.titleLabel.font = FONT_16_BOLD;
    [btnCancel setTitleColor:TEXT_COLOR_LIGHT_GREEN forState:UIControlStateNormal];
    [btnCancel setTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"] forState:UIControlStateNormal];
    
    txtOldPinCode.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_OLD_PINCODE"];
    txtPinCode.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_NEW_PINCODE"];
    txtConformPin.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_CONF_NEW_PINCODE"];
    
    [BaseViewController getRoundRectTextField:txtOldPinCode withIcon:@"change-pincode"];
    [BaseViewController getRoundRectTextField:txtPinCode withIcon:@"change-pincode"];
    [BaseViewController getRoundRectTextField:txtConformPin withIcon:@"change-pincode"];
    
    txtOldPinCode.delegate = self;
    txtPinCode.delegate = self;
    txtConformPin.delegate = self;
    
    txtOldPinCode.keyboardType = UIKeyboardTypeNumberPad;
    txtPinCode.keyboardType = UIKeyboardTypeNumberPad;
    txtConformPin.keyboardType = UIKeyboardTypeNumberPad;
    
    txtOldPinCode.secureTextEntry = YES;
    txtPinCode.secureTextEntry = YES;
    txtConformPin.secureTextEntry = YES;
    
    userObj = [[ParentUser alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnChangePinPress:(id)sender {

    if ([txtOldPinCode.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_OLDPIN"]];
    }
    else if(![GeneralUtil checkPinCode:txtOldPinCode.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_OLDPIN"]];
    }
    else if ([txtPinCode.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_NEW_PIN"]];
    }
    else if(![GeneralUtil checkPinCode:txtPinCode.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_NEW_PIN"]];
    }
    else if ([txtConformPin.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_CONF_PIN"]];
    }
    else if(![GeneralUtil checkPinCode:txtConformPin.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_CONF_PIN"]];
    }
    else if (![txtPinCode.text isEqualToString:txtConformPin.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_PINCODE_NOT_METCH"]];
    }
    else {
        
        [userObj changePincode:[GeneralUtil getUserPreference:key_myParentNo] phoneNo:[GeneralUtil getUserPreference:key_myParentPhone] oldPin:txtOldPinCode.text newPin:txtPinCode.text :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CHANGE_SUCCESS"]];
                }
                else if ([[dicRes valueForKey:@"flag"] intValue] == 0){
                    [GeneralUtil alertInfo:[dicRes valueForKey:@"msg"]];
                }
                else {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INTERNAL_SERVER_ERROR"]];
                }
            }
            else {
                NSLog(@"Request Fail...");
            }
        }];
    }
}

- (IBAction)btnCancelPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (txtOldPinCode== textField || txtConformPin== textField || txtPinCode== textField) {
        if ([currentString length] > 4) {
            return NO;
        }
    }
    return YES;
}
@end
