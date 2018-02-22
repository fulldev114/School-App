//
//  MyProfileViewController.h
//  CSLink
//
//  Created by etech-dev on 6/2/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentMyProfileViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    __weak IBOutlet UIImageView *profileImg;
    
     UIImagePickerController *ipc;
    
    __weak IBOutlet UILabel *lblStudantName;
    
    __weak IBOutlet UITextField *txtStudantName;
    
    __weak IBOutlet UIView *seperatorSview;
    __weak IBOutlet UIView *seperetorPview;
    __weak IBOutlet UILabel *lblSchoolInfo;
    
    __weak IBOutlet UILabel *lblParentInfo;
    
    __weak IBOutlet UIButton *btnChoosProfileImage;
    
    __weak IBOutlet UILabel *lblSchName;
    __weak IBOutlet UILabel *lblClassName;
    __weak IBOutlet UILabel *lblClassInspcName;
    
    __weak IBOutlet UILabel *lblParent1;
    __weak IBOutlet UILabel *lblMobile1;
    
    __weak IBOutlet UILabel *lblParent2;
    __weak IBOutlet UILabel *lblmobile2;
    
    __weak IBOutlet UILabel *lblParent3;
    __weak IBOutlet UILabel *lblmobile3;
    
    __weak IBOutlet UILabel *lblSchNameValue;
    
    __weak IBOutlet UILabel *lblClassNameValue;
    
    __weak IBOutlet UILabel *lblClassinspcNameValue;
    
    __weak IBOutlet UILabel *lblStatus1;
    __weak IBOutlet UILabel *lblStatus2;
    __weak IBOutlet UILabel *lblStatus3;
    
    __weak IBOutlet UILabel *lblParent1Value;
    
    __weak IBOutlet UILabel *lblMobile1Value;
    
    __weak IBOutlet UILabel *lblParent2Value;
    
    __weak IBOutlet UILabel *lblmobile2Value;
    
    __weak IBOutlet UILabel *lblParent3Value;
    
    __weak IBOutlet UILabel *lblmobile3Value;
    
    __weak IBOutlet NSLayoutConstraint *imgViewWidth;
    __weak IBOutlet NSLayoutConstraint *imgviewHeight;
    __weak IBOutlet UIButton *btnUpdateUser;
    
    __weak IBOutlet UIView *bottomView;
    
    __weak IBOutlet UITextField *txtParent1Value;
    
    __weak IBOutlet UITextField *txtMobile1Value;
    
    __weak IBOutlet UITextField *txtParent2Value;
    
    __weak IBOutlet UITextField *txtParent3Value;
    
    __weak IBOutlet UITextField *txtMobile2Value;
    
    __weak IBOutlet UITextField *txtMobile3Value;
}
- (IBAction)btnUpdateUserClick:(id)sender;
- (IBAction)btnSelectProImg:(id)sender;

@end
