//
//  SchoolListViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>{

    __weak IBOutlet UITableView *tblSchoolList;
    __weak IBOutlet UITextField *txtSearchBox;
    __weak IBOutlet UISearchBar *searchBox;
}

@end
