//
//  ChatViewController.h
//  CSAdmin
//
//  Created by etech-dev on 7/1/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface ParentChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate>
{
    
    __weak IBOutlet UIView *statusBgView;
    __weak IBOutlet UILabel *lblConectionStatus;
    __weak IBOutlet UITableView *tblMessages;
    __weak IBOutlet UITextField *txtMessageBox;
    __weak IBOutlet UIButton *btnSend;
    
    __weak IBOutlet UIView *containerView;
    
    __weak IBOutlet NSLayoutConstraint *heightOfTableView;
    __weak IBOutlet NSLayoutConstraint *heightOfContaintView;
}
- (IBAction)btnSendPress:(id)sender;
@property (nonatomic ,strong) NSDictionary *teacherDetail;

-(void)setNewFream:(BOOL)isCall;

@end
