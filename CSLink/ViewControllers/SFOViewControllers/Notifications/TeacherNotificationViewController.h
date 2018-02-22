//
//  TeacherNotificationViewController.h
//  CSLink
//
//  Created by adamlucas on 5/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherNotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate,UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
