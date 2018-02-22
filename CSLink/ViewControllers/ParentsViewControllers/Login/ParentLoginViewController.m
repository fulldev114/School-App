//
//  LoginViewController.m
//  Construction
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentLoginViewController.h"
#import "ParentVerifyCodeViewController.h"
#import "ParentConstant.h"
#import "BaseViewController.h"
#import "PerentRegisterViewController.h"
#import "LocalizeLanguage.h"
#import "IQKeyboardManager.h"

@interface ParentLoginViewController ()
{
     ParentUser *userObj;
}
@end

@implementation ParentLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userObj = [[ParentUser alloc] init];
   // txtPhoneNumber.text = @"11111112";
    txtPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [BaseViewController setBackGroud:self];
    
    txtPhoneNumber.delegate = self;
    if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangEglish]) {
        [BaseViewController formateButtonCyne:btnEnglish title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
        [BaseViewController formateButton:btnGerman withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    }else{
        [BaseViewController formateButtonCyne:btnGerman title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
        
        [BaseViewController formateButton:btnEnglish withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
    }
    [self setUpUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}

-(void)setUpUi {
    
    [btnRegister setTitle:[GeneralUtil getLocalizedText:@"BTN_TTL_NEW_REGISTER"] forState:UIControlStateNormal];
    [btnRegister setTitle:[GeneralUtil getLocalizedText:@"BTN_TTL_NEW_REGISTER"] forState:UIControlStateSelected];
    
    txtPhoneNumber.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_PHONE_NUMBER"];
    [BaseViewController setCynaColorDefultFontLbl:lblContryCode];
    [BaseViewController setCynaColorDefultFontBtn:btnRegister];
    [BaseViewController getRoundRectTextField:txtPhoneNumber withIcon:@"mobile-icon.png" andLable:@"+47"];
    [BaseViewController formateButtonCyne:btnNext title:[GeneralUtil getLocalizedText:@"BTN_NEXT_TITLE"] withIcon:@"next-arrow" withBgColor:TEXT_COLOR_CYNA];
    lblDoyouAc.font = FONT_16_REGULER;
    lblDoyouAc.text = [GeneralUtil getLocalizedText:@"LBL_DO_YOU_AC_TITLE"];
    lblDoyouAc.textColor = TEXT_COLOR_WHITE;
}

- (IBAction)btnNext:(id)sender {
    
    userObj.mobile = txtPhoneNumber.text;
    
    if([txtPhoneNumber.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_PHONE"]];
    }
    else if(![GeneralUtil checkValidMobile:txtPhoneNumber.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_PHONE"]];
    }
    else {
        [userObj login:^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (resObj != nil) {
                
                NSLog(@"Respons :%@",resObj);
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    [GeneralUtil setUserPreference:key_myParentNo value:[dicRes valueForKey:@"parent_no"]];
                    [GeneralUtil setUserPreference:key_myParentPhone value:txtPhoneNumber.text];
                    
                    ParentVerifyCodeViewController *viewController = [[ParentVerifyCodeViewController alloc] initWithNibName:@"ParentVerifyCodeViewController" bundle:nil];
                    viewController.userObj = userObj;
                    [self.navigationController pushViewController:viewController animated:YES];
                    
                    [appDelegate checkUpdateVersone:[dicRes valueForKey:@"update_info"]];
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

- (IBAction)btnRegister:(id)sender {
    
    PerentRegisterViewController * pvc = [[PerentRegisterViewController alloc] initWithNibName:@"PerentRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (txtPhoneNumber== textField) {
        if ([currentString length] > 8) {
            return NO;
        }
    }
    return YES;
}

- (IBAction)btnEnglishPress:(id)sender {
    [LocalizeLanguage setLocalizeLanguage:value_LangEglish];
    [GeneralUtil setUserPreference:key_selLang value:value_LangEglish];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LANGUAGE_CHANGE object:nil];
    [self setUpUi];
    [BaseViewController formateButtonCyne:btnEnglish title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
    [BaseViewController formateButton:btnGerman withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:[GeneralUtil getLocalizedText:@"BTN_TTL_PICKER_DONE"]];
}

- (IBAction)btnNorwPress:(id)sender {
    [LocalizeLanguage setLocalizeLanguage:value_LangNorwegian];
    [GeneralUtil setUserPreference:key_selLang value:value_LangNorwegian];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LANGUAGE_CHANGE object:nil];
    [self setUpUi];
    [BaseViewController formateButtonCyne:btnGerman title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    [BaseViewController formateButton:btnEnglish withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:[GeneralUtil getLocalizedText:@"BTN_TTL_PICKER_DONE"]];
}
@end
