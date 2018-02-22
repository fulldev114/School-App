//
//  PerentRegisterViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalkThroughViewController.h"

@interface Page2 : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,WalkthroughPage>
{
    
    __weak IBOutlet UIView *seperatorView;
    __weak IBOutlet UILabel *lblParent2;
    __weak IBOutlet UILabel *lblOptional;
    __weak IBOutlet UIButton *btnNext;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewSize;

@property (weak, nonatomic) IBOutlet UITextField *txtNameP2;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneP2;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailP2;

@property (nonatomic, assign) id <WalkthroughPageDelegate> delegate;

- (IBAction)btnRegisterPress:(id)sender;

@end
