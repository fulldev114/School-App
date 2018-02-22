//
//  ActivitiesItemViewController.h
//  CSLink
//
//  Created by adamlucas on 5/28/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitiesItemViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate,UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, assign) BOOL bCheckedIn;
@property (nonatomic, strong) NSMutableArray *activitiesItemArray;
@end
