//
//  ApprovedViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/6/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApprovedViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{

    __weak IBOutlet UIImageView *imgProfile;
    
    __weak IBOutlet UILabel *lblStudantName;
    __weak IBOutlet UILabel *lblclassName;
    __weak IBOutlet UILabel *lblParentInfo;
    __weak IBOutlet UIView *viewInfo;
    __weak IBOutlet UILabel *lblParent1;
    __weak IBOutlet UILabel *lblMobile1;
    __weak IBOutlet UILabel *lblParent2;
    __weak IBOutlet UILabel *lblMobile2;
    
    __weak IBOutlet UILabel *lblParent1Value;
    __weak IBOutlet UILabel *lblMobile1Value;
    __weak IBOutlet UILabel *lblParent2Value;
    __weak IBOutlet UILabel *lblMobile2Value;
    
    __weak IBOutlet UIButton *btnParent1;
    __weak IBOutlet UIButton *btnParent2;
    __weak IBOutlet UIButton *btnMsgToBothCheck;
    __weak IBOutlet UIButton *btnMsgToContectCheck;
    __weak IBOutlet UIButton *btnSave;
    
    __weak IBOutlet UILabel *lblOtherContant;
    __weak IBOutlet UILabel *lblMobile3;
    __weak IBOutlet UILabel *lblMsgToBothPerson;
    __weak IBOutlet UILabel *lblMsgToContactPerson;
    
    __weak IBOutlet UITextField *txtOtherContect;
    
    __weak IBOutlet UITextField *txtMobile3;
    
    __weak IBOutlet UIButton *btnChooseProfile;
    
    __weak IBOutlet UIView *seperator1;
    __weak IBOutlet UIView *seperator2;
    __weak IBOutlet UIView *seperator3;
    __weak IBOutlet UIView *seperator4;
    __weak IBOutlet UIView *seperator5;
    __weak IBOutlet UIView *seperator6;
    __weak IBOutlet UIView *seperator7;
    
    __weak IBOutlet NSLayoutConstraint *btnProfileWidth;
    __weak IBOutlet NSLayoutConstraint *btnProfileHeight;
    
    UIImagePickerController *ipc;
}
@property (nonatomic,strong) NSDictionary *dicStudDetail;

- (IBAction)btnSavePress:(id)sender;
- (IBAction)btnParent1Press:(id)sender;
- (IBAction)btnParent2Press:(id)sender;
- (IBAction)btnMsgBothPress:(id)sender;
- (IBAction)btnMsgToContectPress:(id)sender;
- (IBAction)btnChooseProfilePress:(id)sender;

@end
