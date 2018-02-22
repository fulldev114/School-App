//
//  AbsentInfoViewController.h
//  CSAdmin
//
//  Created by etech-dev on 7/20/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbsentInfoViewController : UIViewController
{

    __weak IBOutlet UIView *popupView;
    
    __weak IBOutlet UIView *teacheNoticeView;
    __weak IBOutlet UIView *parentNoticeView;
    __weak IBOutlet UIView *presentView;
    
    
    __weak IBOutlet UILabel *lblScreenInfo;
    __weak IBOutlet UILabel *lblPresent;
    __weak IBOutlet UILabel *lblParentNotice;
    __weak IBOutlet UILabel *lblTeacherNotice;
    __weak IBOutlet UILabel *lblslectionInfo;
    __weak IBOutlet UILabel *lblNameAndPeriodInfo;
    __weak IBOutlet NSLayoutConstraint *heightOfPopup;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(id)obj;
- (IBAction)btnClosePress:(id)sender;
@end
