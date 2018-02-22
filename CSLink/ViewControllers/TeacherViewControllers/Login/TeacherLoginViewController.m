//
//  LoginViewController.m
//  Construction
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "TeacherLoginViewController.h"
#import "VerifyCodeViewController.h"
#import "TeacherConstant.h"
#import "BaseViewController.h"
#import "LocalizeLanguage.h"
#import "IQKeyboardManager.h"

@interface TeacherLoginViewController ()
{
    TeacherUser *userObj;
}
@end

@implementation TeacherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userObj = [[TeacherUser alloc] init];
    [BaseViewController setBackGroud:self];
    
    if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangEglish]) {
        [BaseViewController formateButtonCyne:btnEnglish title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
        [BaseViewController formateButton:btnGerman withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    }else{
        [BaseViewController formateButtonCyne:btnGerman title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
        
        [BaseViewController formateButton:btnEnglish withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setUpUi];
}

-(void)setUpUi {
    
    
//    [BaseViewController formateButtonCyne:btnEnglish title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
//    [BaseViewController formateButton:btnGerman withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    [BaseViewController formateButtonCyne:btnNext title:[GeneralUtil getLocalizedText:@"BTN_NEXT_TITLE"] withIcon:@"next-arrow" withBgColor:TEXT_COLOR_CYNA];

    //txtEmail.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_EMAIL_ADD"];
    txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[GeneralUtil getLocalizedText:@"TXT_PLC_EMAIL_ADD"] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName: txtEmail.font}];
    [BaseViewController getRoundRectTextField:txtEmail withIcon:@"email"];
    txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    txtEmail.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (IBAction)btnNext:(id)sender {
    
    userObj.email = txtEmail.text;
    if ([txtEmail.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_EMAIL"]];
    }
    else if(![GeneralUtil NSStringIsValidEmail:txtEmail.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_EMAIL"]];
    }
    else {
        [userObj login:^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    NSLog(@"Respons :%@",dicRes);
                    
                    [GeneralUtil setUserPreference:key_My_phoneNumber value:txtEmail.text];
                    [GeneralUtil setUserPreference:key_My_Email value:txtEmail.text];
                    
                    VerifyCodeViewController *viewController = [[VerifyCodeViewController alloc] initWithNibName:@"VerifyCodeViewController" bundle:nil];
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
- (IBAction)btnEnglishPress:(id)sender {
    [LocalizeLanguage setLocalizeLanguage:value_LangEglish];
    [GeneralUtil setUserPreference:key_selLang value:value_LangEglish];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LANGUAGE_CHANGE object:nil];
    [self setUpUi];
    
    [BaseViewController formateButtonCyne:btnEnglish title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
    [BaseViewController formateButton:btnGerman withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:[GeneralUtil getLocalizedText:@"BTN_DONE_TITLE"]];
}

- (IBAction)btnNorwPress:(id)sender {
    [LocalizeLanguage setLocalizeLanguage:value_LangNorwegian];
    [GeneralUtil setUserPreference:key_selLang value:value_LangNorwegian];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LANGUAGE_CHANGE object:nil];
    
    [self setUpUi];
    
    [BaseViewController formateButtonCyne:btnGerman title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    [BaseViewController formateButton:btnEnglish withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
    
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:[GeneralUtil getLocalizedText:@"BTN_DONE_TITLE"]];
}
@end
