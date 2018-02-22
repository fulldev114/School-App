//
//  ChatListViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/3/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{

    __weak IBOutlet UIButton *btnClass;
    __weak IBOutlet UITextField *txtSearch;
    __weak IBOutlet UITableView *tblStudantList;
}
- (IBAction)btnSelectClassPress:(id)sender;

- (void)reloadData:(NSString *)from;
@end
