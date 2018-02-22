//
//  MyProfileViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/7/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{

    __weak IBOutlet UIImageView *profileImg;

    __weak IBOutlet UIButton *btnSelecteProfile;
    __weak IBOutlet UITextField *txtTeacherName;
    
    __weak IBOutlet UILabel *lblTeacherName;
    __weak IBOutlet UITextField *txtEmailValue;
    __weak IBOutlet UITextField *txtMobileValue;
    
    UIImagePickerController *ipc;
    
    __weak IBOutlet UILabel *lblTeacherInfo;
    __weak IBOutlet UIView *viewInfo;
    __weak IBOutlet UILabel *lblEmailAddress;
    __weak IBOutlet UILabel *lblMobile;
    __weak IBOutlet UILabel *lblClassInCharge;
    
    __weak IBOutlet UILabel *lblSubjectValue;
    __weak IBOutlet UILabel *lblClassValue;
    __weak IBOutlet UILabel *lblEmailValue;
    __weak IBOutlet UILabel *lblMobileValue;
    __weak IBOutlet UIButton *btnUpdateProfile;
}
- (IBAction)btnUpdateProfileClick:(id)sender;
- (IBAction)selecteProImg:(id)sender;

@end
