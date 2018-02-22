//
//  ChatViewController.h
//  CSAdmin
//
//  Created by etech-dev on 7/1/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,HPGrowingTextViewDelegate>
{
    
    __weak IBOutlet UIView *statusBgView;
    __weak IBOutlet UILabel *lblChateStatus;
    __weak IBOutlet UITableView *tblMessages;
    __weak IBOutlet UITextField *txtMessageBox;
    __weak IBOutlet UIButton *btnSend;
    __weak IBOutlet UIView *containerView;
    
    __weak IBOutlet NSLayoutConstraint *heightOfTableView;
    __weak IBOutlet NSLayoutConstraint *heightOfContaintView;
}
-(void)setNewFream:(BOOL)isCall;
- (IBAction)btnSendPress:(id)sender;
@property (nonatomic ,strong) NSDictionary *studDetail;
@property (nonatomic ,assign) BOOL isTeacher;

@end
