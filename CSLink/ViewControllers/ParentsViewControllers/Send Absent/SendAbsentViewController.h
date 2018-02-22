//
//  SendAbsentViewController.h
//  CSLink
//
//  Created by etech-dev on 6/22/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendAbsentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UIView *dateView;
    __weak IBOutlet UILabel *lblDate;
    __weak IBOutlet UIButton *btnDate;
    __weak IBOutlet UIButton *btnCheckFullday;
    __weak IBOutlet UILabel *lblFullDay;
    __weak IBOutlet UILabel *lblPeriode;
    __weak IBOutlet UIView *periodView;
    __weak IBOutlet UITableView *tblPeriode;
    __weak IBOutlet UIButton *btnResone;
    __weak IBOutlet UIButton *btnSend;
    __weak IBOutlet NSLayoutConstraint *heightOfTableview;
    __weak IBOutlet UILabel *lblNoAnyLec;
}
- (IBAction)btnDatePress:(id)sender;
- (IBAction)btnCheckFullDayPress:(UIButton *)sender;
- (IBAction)btnResonePress:(id)sender;
- (IBAction)btnSendPress:(id)sender;
@end
