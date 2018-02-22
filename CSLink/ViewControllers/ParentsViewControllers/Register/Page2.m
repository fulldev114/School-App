//
//  PerentRegisterViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "Page2.h"
#import "ParentUser.h"
#import "BaseViewController.h"

@interface Page2 ()
{
    ParentUser *userObj;
}
@end

@implementation Page2

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

    self.txtNameP2.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_FULL_NAME"];
    self.txtEmailP2.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_EMAIL"];
    self.txtPhoneP2.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_PHONE_NO"];
    
    [BaseViewController getRoundRectTextField:self.txtNameP2 withIcon:@"my-profile"];
    [BaseViewController getRoundRectTextField:self.txtEmailP2 withIcon:@"email"];
    [BaseViewController getRoundRectTextField:self.txtPhoneP2 withIcon:@"mobile-icon"];
    [BaseViewController formateButtonCyne:btnNext title:[GeneralUtil getLocalizedText:@"BTN_REGISTER_TITLE"] withIcon:@"next-arrow" withBgColor:TEXT_COLOR_CYNA];
    
    self.txtPhoneP2.keyboardType = UIKeyboardTypeNumberPad;
    self.txtEmailP2.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.txtEmailP2.autocorrectionType = UITextAutocorrectionTypeNo;
    
    lblOptional.textColor = TEXT_COLOR_LIGHT_GREEN;
    lblParent2.textColor = TEXT_COLOR_LIGHT_GREEN;
    seperatorView.backgroundColor = TEXT_COLOR_LIGHT_GREEN;
    
    lblParent2.font = FONT_16_REGULER;
    lblParent2.text = [GeneralUtil getLocalizedText:@"LBL_PARENT2_TITLE"];
    lblOptional.text = [GeneralUtil getLocalizedText:@"LBL_PARENT2_OPTINAL_TITLE"];
    lblOptional.font = FONT_18_BOLD;
    
    self.txtPhoneP2.delegate = self;
    self.txtNameP2.delegate = self;
    self.txtEmailP2.delegate = self;
    
    if( IS_IPHONE_5 )
    {
        self.imageViewSize.constant = 80;
    }
}
 -(void)backButtonClick{
     
     [self.navigationController popViewControllerAnimated:YES];
 }
 
- (IBAction)btnRegisterPress:(id)sender {
    
    if (![self.txtPhoneP2.text isEqualToString:@""]) {
        
        if ([GeneralUtil checkValidMobile:self.txtPhoneP2.text]) {
            
            if(![self.txtEmailP2.text isEqualToString:@""]){
                if ([GeneralUtil NSStringIsValidEmail:self.txtEmailP2.text]) {
                    [self.delegate btnRegisterButtonPressed];
                }
                else {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_EMAIL"]];
                }
            }
            else {
                [self.delegate btnRegisterButtonPressed];
            }
        }
        else {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_PHONE"]];
        }
    }
    else {
        [self.delegate btnRegisterButtonPressed];
    }
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
    
    if (self.txtPhoneP2== textField) {
        if ([currentString length] > 8) {
            return NO;
        }
    }
    return YES;
}
@end
