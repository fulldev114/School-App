//
//  LoginViewController.h
//  Construction
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentUser.h"

@interface ParentLoginViewController : UIViewController<UITextFieldDelegate>{
    
    __weak IBOutlet UIImageView *imgLogo;
    IBOutlet UITextField *txtPhoneNumber;
    IBOutlet UIButton *btnGerman;
    __weak IBOutlet UILabel *lblContryCode;
    __weak IBOutlet UIButton *btnEnglish;
    __weak IBOutlet UIButton *btnNext;
    __weak IBOutlet UIButton *btnRegister;
    __weak IBOutlet UILabel *lblDoyouAc;
    
}
- (IBAction)btnNext:(id)sender;

- (IBAction)btnRegister:(id)sender;
@end
