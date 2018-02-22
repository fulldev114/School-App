//
//  SelecteGroupForEmgViewController.h
//  CSAdmin
//
//  Created by etech-dev on 3/29/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLExpandableTableView.h"
#import "GroupMessageViewController.h"

@interface SelecteGroupForEmgViewController : UIViewController<SLExpandableTableViewDelegate,SLExpandableTableViewDatasource>
{
    __weak IBOutlet SLExpandableTableView *tblGroupList;

    __weak IBOutlet UIButton *btnSelecteAllGroup;
    __weak IBOutlet UIView *seperateView1;
    __weak IBOutlet UIView *seperateView2;
    __weak IBOutlet UILabel *lblOr;
    __weak IBOutlet UIButton *btnSend;
    __weak IBOutlet UIButton *btnCencel;
}
@property (nonatomic , strong) NSString *Msg;
- (IBAction)btnSendPress:(id)sender;
- (IBAction)btnCancelPress:(id)sender;

- (IBAction)btnSelecteAlllGroupPress:(id)sender;
@end
