//
//  ContectUsViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentContectUsViewController.h"
#import "BaseViewController.h"

@interface ParentContectUsViewController ()
{
    ParentUser *userObj;
}
@end

@implementation ParentContectUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_CONTACT_US"] WithSel:@selector(menuClick)];
    [BaseViewController formateButtonCyne:btnSend title:[GeneralUtil getLocalizedText:@"BTN_SEND_TITLE"] withIcon:@"send" withBgColor:TEXT_COLOR_CYNA];
    txtEmail.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_EMAIL_ADD"];
    [BaseViewController getRoundRectTextField:txtEmail withIcon:@"email"];
    messageView.layer.cornerRadius = 5.0f;
    messageView.layer.borderWidth = 1.0f;
    messageView.layer.borderColor = [UIColor whiteColor].CGColor;
    messageView.backgroundColor = [UIColor clearColor];
    
    lblMessage.font = FONT_16_REGULER;
    lblMessage.textColor = TEXT_COLOR_WHITE;
    lblMessage.text = [GeneralUtil getLocalizedText:@"LBL_MESSAGE_TITLE"];
    
    txvMessage.delegate = self;
    txtEmail.text = [GeneralUtil getUserPreference:key_ParentEmail];
    txvMessage.backgroundColor = [UIColor clearColor];
    txvMessage.textColor = TEXT_COLOR_WHITE;
    txvMessage.font = FONT_16_REGULER;
    lblMessage.font = FONT_16_REGULER;
    userObj = [[ParentUser alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)menuClick {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}

- (IBAction)btnSendPress:(id)sender {
    
    if ([txtEmail.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_EMAIL"]];
    }
    else if (![GeneralUtil NSStringIsValidEmail:txtEmail.text]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_EMAIL"]];
    }
    else if ([txvMessage.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_MESSAGE"]];
    }
    else {
        [userObj sendFeedback:[GeneralUtil getUserPreference:key_saveParentName] email:txtEmail.text message:txvMessage.text :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_FEEDBACK_SEND_SUCCESS"]];
                    txvMessage.text = @"";
                    lblMessage.hidden = NO;
                    imgMsgIcon.hidden = NO;
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
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    lblMessage.hidden = YES;
    imgMsgIcon.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([txvMessage.text isEqualToString:@""]) {
        lblMessage.hidden = NO;
        imgMsgIcon.hidden = NO;
    }
}
@end
