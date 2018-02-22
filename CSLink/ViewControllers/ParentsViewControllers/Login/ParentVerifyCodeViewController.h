//
//  VerifyCodeViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/20/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentUser.h"

@interface ParentVerifyCodeViewController : UIViewController{

    __weak IBOutlet UIImageView *imgLogo;
    IBOutlet UILabel *lblPhoneNumber;
    IBOutlet UITextField *txtVerifyCode;
    __weak IBOutlet UIButton *btnNext;
    __weak IBOutlet UIButton *btnBack;
}

@property (nonatomic,strong) ParentUser *userObj;
@property (nonatomic,strong) NSString *phoneNumber;

- (IBAction)btnNext:(id)sender;
- (IBAction)btnBack:(id)sender;
@end
