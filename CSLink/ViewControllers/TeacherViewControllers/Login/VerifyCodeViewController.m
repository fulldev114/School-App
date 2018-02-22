//
//  VerifyCodeViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/20/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "VerifyCodeViewController.h"
#import "TeacherConstant.h"
#import "TeacherPincodeViewController.h"
#import "BaseViewController.h"


@interface VerifyCodeViewController ()

@end

@implementation VerifyCodeViewController
@synthesize userObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblPhoneNumber.text = [GeneralUtil getUserPreference:key_My_Email];
    lblPhoneNumber.textColor = [UIColor whiteColor];
    lblPhoneNumber .font = FONT_18_REGULER;
    [lblPhoneNumber sizeToFit];
    txtVerifyCode.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_VERIFY_CODE"];
    
    [self setUpUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpUi {
    
    [BaseViewController setBackGroud:self];
    if (IS_IPAD) {
        btnNext.tag = 15;
    }
    [BaseViewController formateButtonCyne:btnNext title:[GeneralUtil getLocalizedText:@"BTN_NEXT_TITLE"] withIcon:@"next-arrow" withBgColor:TEXT_COLOR_CYNA];
    
    [BaseViewController getRoundRectTextField:txtVerifyCode];
    
    txtVerifyCode.keyboardType = UIKeyboardTypeNumberPad;
}

- (IBAction)btnNext:(id)sender {
    
    userObj.verifyCode = txtVerifyCode.text;
    
    if ([txtVerifyCode.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_VERIFY_CODE"]];
    }
    else{
        
        [userObj verifyCode:^(NSObject *resObj){
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                NSString *responseString = [NSString stringWithFormat:@"%@",[dicRes valueForKey:@"flag"]];
                
                if ([responseString isEqualToString:@"1"]) //success
                {
                    
                    [GeneralUtil setUserPreference:key_teacherId value:[dicRes valueForKey:@"teacherid"]];
                    [GeneralUtil setUserPreference:key_schoolId value:[dicRes valueForKey:@"schoolid"]];
                    [GeneralUtil setUserPreference:key_incharge value:[dicRes valueForKey:@"incharge"]];
                    
                    //NSString *jid = [dicRes valueForKey:@"jid"];
                    //jid = [NSString stringWithFormat:@"%@@%@", [jid substringToIndex:[jid rangeOfString:@"@"].location], @"192.168.14.136"];
    
                    [GeneralUtil setUserPreference:key_jid value:[dicRes valueForKey:@"jid"]];
                    [GeneralUtil setUserPreference:key_jpassword value:[dicRes valueForKey:@"key"]];
                    
                    //[[NSUserDefaults standardUserDefaults] setValue:_textFieldEmail.text forKey:@"UserEmailID"];
                    //[[NSUserDefaults standardUserDefaults] setValue:userNameString forKey:@"UserName"];
                    //[[NSUserDefaults standardUserDefaults] setValue:userImageString forKey:@"UserImage"];
                    
                    [GeneralUtil setUserPreference:key_islogin value:@"Yes"];
                    [GeneralUtil setUserPreference:key_isfromlogin value:@"Yes"];
                    [GeneralUtil setUserPreference:key_sucessLoginNow value:str_successLogin];
                    
                    [appDelegate.xmppHelper disConnect];
                    
                    appDelegate.curJabberId = [GeneralUtil getUserPreference:key_jid];
                    appDelegate.curJIdwd = [GeneralUtil getUserPreference:key_jpassword];
                    
                    [appDelegate connectXmpp:appDelegate.curJabberId];
                    
                    TeacherPincodeViewController * pvc = [[TeacherPincodeViewController alloc] initWithNibName:@"TeacherPincodeViewController" bundle:nil];
                    [self.navigationController pushViewController:pvc animated:YES];
                }
                else if ([responseString isEqualToString:@"0"])
                {
                    [GeneralUtil alertInfo:[dicRes valueForKey:@"msg"]];
                }
                else {
                    
                }
            }
            else {
                NSLog(@"Request Fail...");
            }
        }];
    }
}


- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
