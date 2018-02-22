//
//  StudantListViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/4/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudantListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    __weak IBOutlet UITableView *tblStudantList;
    __weak IBOutlet UIButton *btnGread;
    __weak IBOutlet UIButton *btnClass;
    __weak IBOutlet UILabel *lblStudantList;
    __weak IBOutlet UILabel *lblClassName;
}

- (IBAction)btnGreadPress:(id)sender;
- (IBAction)btnClassPress:(id)sender;


@end
