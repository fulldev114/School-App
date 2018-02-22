//
//  LoginViewController.h
//  Construction
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherUser.h"

@interface TeacherLoginViewController : UIViewController{
    
    __weak IBOutlet UIImageView *imgLogo;
    IBOutlet UITextField *txtEmail;
    IBOutlet UIButton *btnGerman;
    __weak IBOutlet UIButton *btnEnglish;
    __weak IBOutlet UIButton *btnNext;
    
}
- (IBAction)btnNext:(id)sender;

@end
