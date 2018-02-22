//
//  ActivitiesViewController.h
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitiesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;

@property (nonatomic,strong) NSMutableArray * activitiesArray;

@property (nonatomic, assign) BOOL bCheckedIn;
@property (nonatomic, assign) BOOL isTeacher;
@property (nonatomic, assign) NSInteger activityStatus;

@end
