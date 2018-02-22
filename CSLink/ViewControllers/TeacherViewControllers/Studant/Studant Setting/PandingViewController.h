//
//  PandingViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/6/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PandingViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    
    __weak IBOutlet UIImageView *imgProfile;
    __weak IBOutlet UIButton *btnChooseProfile;
    __weak IBOutlet UILabel *lblStudName;
    __weak IBOutlet UILabel *lblClassName;
    __weak IBOutlet UILabel *lblParentInfo;
    __weak IBOutlet UIView *ViewInfo;
    __weak IBOutlet UILabel *lblParent1;
    __weak IBOutlet UILabel *lblMobile1;
    __weak IBOutlet UILabel *lblParent2;
    __weak IBOutlet UILabel *lblMobile2;
    __weak IBOutlet UILabel *lblParent1Value;
    __weak IBOutlet UILabel *lblMobile1Value;
    __weak IBOutlet UILabel *lblParent2Value;
    __weak IBOutlet UILabel *lblMobile2Value;
    
    __weak IBOutlet UIView *seperator1;
    __weak IBOutlet UIView *seperator2;
    __weak IBOutlet UIView *seperator3;
    
    __weak IBOutlet UIButton *btnApprove;
    __weak IBOutlet UIButton *btnReject;
    __weak IBOutlet NSLayoutConstraint *btnProfileWidth;
    __weak IBOutlet NSLayoutConstraint *btnProfileHeight;
    
    UIImagePickerController *ipc;
}
@property (nonatomic,strong) NSDictionary *dicStudDetail;
- (IBAction)btnApprovePress:(id)sender;
- (IBAction)btnRejectPress:(id)sender;
- (IBAction)btnChooseProfilePress:(id)sender;


@end
