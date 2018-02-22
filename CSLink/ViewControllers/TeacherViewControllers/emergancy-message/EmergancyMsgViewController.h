//
//  EmergancyMsgViewController.h
//  CSAdmin
//
//  Created by etech-dev on 7/13/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergancyMsgViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{

    __weak IBOutlet UIButton *btnSystemMsg;
    __weak IBOutlet UIButton *btnCustomMsg;
    __weak IBOutlet UIView *viewSysMsg;
    __weak IBOutlet UIView *viewCustMsg;
    __weak IBOutlet UIView *viewSeperator;
    __weak IBOutlet UIView *containtView;
    __weak IBOutlet UIView *msgView;
    __weak IBOutlet UITableView *tblSysMsg;
    __weak IBOutlet UITextView *txvMessage;
    __weak IBOutlet UILabel *lblMessage;
    __weak IBOutlet UIButton *btnSend;
    __weak IBOutlet UIButton *btnCancel;
    __weak IBOutlet NSLayoutConstraint *heightOfContentView;
    __weak IBOutlet UIView *viewMessage;
    __weak IBOutlet UIButton *btnMessage;
    __weak IBOutlet UILabel *lblNoDataFond;
    __weak IBOutlet UIButton *btnESend;
    __weak IBOutlet UIButton *btnEcancel;
    __weak IBOutlet UIButton *btnNext;
}
- (IBAction)btnSysMsgPress:(id)sender;
- (IBAction)btnCustMsgPress:(id)sender;
- (IBAction)btnSendPress:(id)sender;
- (IBAction)btnCancelPress:(id)sender;
- (IBAction)btnMessagePress:(id)sender;

- (IBAction)btnEsendPress:(id)sender;
- (IBAction)btnEcancelPress:(id)sender;
- (IBAction)btnNextPress:(id)sender;

@end
