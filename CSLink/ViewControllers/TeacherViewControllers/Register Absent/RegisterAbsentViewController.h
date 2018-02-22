//
//  RegisterAbsentViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/14/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbsentDetailViewController.h"

@interface RegisterAbsentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CustomPopupLoginViewController>
{
    IBOutlet UITableView *tblStudantList;
    __weak IBOutlet UIButton *btnClass;
    __weak IBOutlet UIButton *btnDate;
    __weak IBOutlet UIButton *btnSave;
    __weak IBOutlet UIButton *btnSendAbsent;
    __weak IBOutlet UILabel *lblStudName;
    __weak IBOutlet UILabel *lblLectureRecords;
    
}

- (IBAction)btnSavePress:(id)sender;
- (IBAction)btnSendAbsendPress:(id)sender;
- (IBAction)btnClassPress:(id)sender;
- (IBAction)btnDatePress:(UIButton *)sender;
@end
