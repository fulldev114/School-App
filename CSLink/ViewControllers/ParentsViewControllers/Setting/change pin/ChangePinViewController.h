//
//  ChangePinViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePinViewController : UIViewController<UITextFieldDelegate>
{

    __weak IBOutlet UITextField *txtOldPinCode;
    __weak IBOutlet UITextField *txtPinCode;
    __weak IBOutlet UITextField *txtConformPin;
    __weak IBOutlet UIButton *btnChangePin;
    __weak IBOutlet UIButton *btnCancel;
}
- (IBAction)btnChangePinPress:(id)sender;
- (IBAction)btnCancelPress:(id)sender;
@end
