//
//  VerifyCodeViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/20/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentVerifyCodeViewController.h"
#import "ParentConstant.h"
#import "ParentPincodeViewController.h"
#import "BaseViewController.h"

@interface ParentVerifyCodeViewController ()

@end

@implementation ParentVerifyCodeViewController
@synthesize userObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblPhoneNumber.text = [NSString stringWithFormat:@"+47 %@",[GeneralUtil getUserPreference:key_myParentPhone]];
    lblPhoneNumber.textColor = [UIColor whiteColor];
    lblPhoneNumber.font = FONT_18_REGULER;
    txtVerifyCode.keyboardType = UIKeyboardTypeNumberPad;
    txtVerifyCode.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_VERIFY_CODE"];
    [self setUpUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpUi {
    
    [BaseViewController setBackGroud:self];

    [BaseViewController formateButtonCyne:btnBack title:@"Back"];
    if (IS_IPAD) {
        btnNext.tag = 15;
    }
    [BaseViewController formateButtonCyne:btnNext title:[GeneralUtil getLocalizedText:@"BTN_NEXT_TITLE"] withIcon:@"next-arrow" withBgColor:TEXT_COLOR_CYNA];
    
    [BaseViewController getRoundRectTextField:txtVerifyCode];
}

- (IBAction)btnNext:(id)sender {
    
    userObj.verifyCode = txtVerifyCode.text;
    if ([txtVerifyCode.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_VERIFY_CODE"]];
    }
    else {
        [userObj verifyCode:^(NSObject *resObj){
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    
                    NSArray * ChildDataArray = [[dicRes valueForKey:key_allchilds] valueForKey:key_childs];
                    NSMutableArray *arrayChild = [[NSMutableArray alloc] init];
                    if (![ChildDataArray isEqual:[NSNull null]] && ChildDataArray != nil && ChildDataArray.count > 0)
                        arrayChild= [ChildDataArray mutableCopy]; // set value
                    
                    [GeneralUtil setUserPreference:key_parentIdSave value:[dicRes valueForKey:key_parentid]];
                    [GeneralUtil setUserPreference:key_ParentEmail value:[dicRes valueForKey:key_parentemail]];
                    [GeneralUtil setUserPreference:key_saveParentName value:[dicRes valueForKey:key_parentname]];
                    [GeneralUtil setUserPreference:key_UserId value:[dicRes valueForKey:key_parentid]];
                    
                    [GeneralUtil setUserPreference:key_islogin value:@"YES"];
                    [GeneralUtil setUserPreference:key_isfromlogin value:@"YES"];
                    [GeneralUtil setUserPreference:key_sucessLoginNow value:str_successLogin];
                    [GeneralUtil setUserPreference:key_verifyCode value:txtVerifyCode.text];
                    
                    ParentPincodeViewController * pvc = [[ParentPincodeViewController alloc] initWithNibName:@"ParentPincodeViewController" bundle:nil];
                    [self.navigationController pushViewController:pvc animated:YES];
                }
                else {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_VERIFICATION_CODE_INVALIDE"]];
                }
            }
            else {
                NSLog(@"Request Fail...");
            }
        }];
    }
}
    
    
//    NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"%@device_reg.php?",CSLinkURL]];
//    
//    NSString *str = [NSString stringWithFormat:@"userid=%@&device=IPHONE&token=%@&parent_no=%@",[self.resultDict valueForKey:key_parentid],[[NSUserDefaults standardUserDefaults]stringForKey:@"token_id"], m_parentNo];
//    NSLog(@"%@",str);
//    
//    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:urli];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    NSError *error = nil;
//    NSURLResponse *response = nil;
//    
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSJSONSerialization *json;
//    if(data)
//    {
//        json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//    }
//    
//    NSLog(@"%@",response);
//    NSLog(@"response :%@",json);
//    
//    //        {"msg":"you are successfully logined","flag":1,"teacherid":"7","no of records":1}
//    
//    NSString *responseString = [[NSString alloc] init];
//    // teacherIdString = [[NSString alloc] init];
//    //schoolIdString = [[NSString alloc] init];
//    
//    responseString = [NSString stringWithFormat:@"%@",[json valueForKey:@"flag"]];
//    
//    if ([responseString isEqualToString:@"1"])
//    {
//        NSLog(@"Device Register :%@",@"test");
//        
//        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:key_islogin];
//        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:key_isfromlogin];
//        [[NSUserDefaults standardUserDefaults] setObject:str_successLogin forKey:key_sucessLoginNow];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        PincodeViewController * pvc = [[PincodeViewController alloc] initWithNibName:@"PincodeViewControllerIphone5" bundle:nil];
//        
//        
//        [self.navigationController pushViewController:pvc animated:YES];
//    }


- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
