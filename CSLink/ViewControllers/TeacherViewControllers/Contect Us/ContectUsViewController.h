//
//  ContectUsViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContectUsViewController : UIViewController<UITextViewDelegate>
{

    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UILabel *lblMessage;
    __weak IBOutlet UITextView *txvMessage;
    __weak IBOutlet UIButton *btnSend;
    __weak IBOutlet UIView *messageView;
    __weak IBOutlet UIImageView *imgMsgIcon;
}
- (IBAction)btnSendPress:(id)sender;
@end
