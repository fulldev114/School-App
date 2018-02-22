//
//  SFOItemViewController.h
//  CSLink
//
//  Created by adamlucas on 5/28/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFOItemViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sfoTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
