//
//  ReportViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/16/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{

    __weak IBOutlet UIButton *startDate;
    __weak IBOutlet UIButton *endDate;
    __weak IBOutlet UILabel *lblStartDate;
    __weak IBOutlet UILabel *lblEndDate;
    __weak IBOutlet UIButton *btnGrade;
    __weak IBOutlet UIButton *btnClass;
    __weak IBOutlet UITableView *tblStudentList;
    __weak IBOutlet UIButton *btnSend;
    __weak IBOutlet UIView *celenderView;
    __weak IBOutlet UITextField *txtSearchStud;
}

@property (nonatomic ,strong) NSString *reportOrAdd;

- (IBAction)btnSendPress:(id)sender;
- (IBAction)btnStartDatePress:(id)sender;
- (IBAction)btnEndDatePress:(id)sender;
- (IBAction)btnClassPress:(id)sender;
- (IBAction)btnGradePress:(id)sender;
@end
