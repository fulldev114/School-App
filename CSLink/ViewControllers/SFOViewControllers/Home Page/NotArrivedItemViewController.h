//
//  NotArrivedItemViewController.h
//  CSLink
//
//  Created by adamlucas on 5/28/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotArrivedItemViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate,UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *notArrivedTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (nonatomic,strong) NSMutableArray *notArrivedItemArray;

@end
