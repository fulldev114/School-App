//
//  GroupMessageViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/10/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLExpandableTableView.h"
#import "HistoryViewController.h"
#import "HPGrowingTextView.h"

@interface GroupMessageViewController : UIViewController<HistoryMessageDeleget,HPGrowingTextViewDelegate>
{

    __weak IBOutlet SLExpandableTableView *tblExpandableView;
    __weak IBOutlet UIButton *btnHistory;
    
    __weak IBOutlet UILabel *lblSelectAll;
    __weak IBOutlet UILabel *lblGrade;
    __weak IBOutlet UILabel *lblInformation;
    __weak IBOutlet UIButton *btnClass;
    __weak IBOutlet UIButton *btnSelectAll;
    __weak IBOutlet UITextField *txtMassage;
    __weak IBOutlet UIButton *btnSend;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet NSLayoutConstraint *bottomSpace;
    __weak IBOutlet NSLayoutConstraint *bottomViewHeight;
    IBOutlet UIView *inputView;
    __weak IBOutlet UIButton *btnDone;
}
- (IBAction)btnHistoryPress:(id)sender;
- (IBAction)btnGradePress:(id)sender;
- (IBAction)btnSelectAll:(UIButton *)sender;
- (IBAction)btnSendPress:(id)sender;
- (IBAction)btnDonePress:(id)sender;

@end

@interface SLExpandableTableViewControllerHeaderCell : UITableViewCell <UIExpandingTableViewCell>

@property (nonatomic, assign, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) UIExpansionStyle expansionStyle;
- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated;

@end
