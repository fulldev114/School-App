//
//  VerifyCodeViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/20/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherUser.h"


@interface VerifyCodeViewController : UIViewController {
    
    __weak IBOutlet UIImageView *imgLogo;
    IBOutlet UITextField *txtVerifyCode;
    __weak IBOutlet UIButton *btnNext;
    IBOutlet UILabel *lblPhoneNumber;
}

@property (nonatomic,strong) TeacherUser *userObj;
@property (nonatomic,strong) NSString *phoneNumber;

- (IBAction)btnNext:(id)sender;

@end
