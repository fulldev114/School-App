//
//  PerentRegisterViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalkThroughViewController.h"



@interface Page1 : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,WalkthroughPage,UITextFieldDelegate>
{

    __weak IBOutlet UIView *seperatorView;
    __weak IBOutlet UILabel *lblParent1;
    __weak IBOutlet UIButton *btnNext;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewSize;

@property (weak, nonatomic) IBOutlet UITextField *txtNameP1;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneP1;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailP1;
@property (weak, nonatomic) IBOutlet UITextField *txtPinCode;
@property (weak, nonatomic) IBOutlet UITextField *txtConformPin;

@property (nonatomic, assign) id <WalkthroughPageDelegate> delegate;

- (IBAction)btnRegisterPress:(id)sender;

@end
