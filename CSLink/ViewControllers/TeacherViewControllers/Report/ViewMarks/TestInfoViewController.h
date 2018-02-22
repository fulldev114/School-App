//
//  TestInfoViewController.h
//  CSAdmin
//
//  Created by etech-dev on 10/7/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestInfoViewController : UIViewController
{
    __weak IBOutlet UILabel *lblStudantName;
    __weak IBOutlet UILabel *lblClassName;
    __weak IBOutlet UIView *lblTopView;
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UILabel *lblTestTitle;
    __weak IBOutlet UILabel *lblExamAbout;
    __weak IBOutlet UILabel *lblExamAboutValue;
    __weak IBOutlet UIView *seperatoreView;
    __weak IBOutlet UILabel *lblComment;
    __weak IBOutlet UILabel *lblCommentValue;
    __weak IBOutlet UIView *seperartoreView2;
    __weak IBOutlet UILabel *lblMarks;
    __weak IBOutlet UILabel *lblMakrsValue;
    __weak IBOutlet UIButton *btnOk;
    __weak IBOutlet UIButton *btnDownload;
    __weak IBOutlet UIView *popupView;
    __weak IBOutlet UIView *seperatorView3;
    __weak IBOutlet UIButton *btnWithImage;
    __weak IBOutlet UILabel *lblTemsAndCond;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDetail:(id)obj;



- (IBAction)btnEditPress:(id)sender;
- (IBAction)btnOkPress:(id)sender;
- (IBAction)btnDownloadPress:(id)sender;
- (IBAction)btnImageWithPress:(id)sender;
@end
