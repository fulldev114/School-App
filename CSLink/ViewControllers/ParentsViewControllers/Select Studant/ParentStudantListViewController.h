//
//  StudantListViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentStudantListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
    __weak IBOutlet UITableView *tblStudantList;
    __weak IBOutlet UIButton *btnAddNewStudant;
}

@property (nonatomic, assign) BOOL isSelected;
- (IBAction)btnAddNewStudant:(id)sender;

@end
