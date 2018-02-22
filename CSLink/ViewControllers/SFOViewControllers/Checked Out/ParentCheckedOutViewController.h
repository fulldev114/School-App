//
//  CheckInViewController.h
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentCheckedOutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *studentTableView;

@property (strong, nonatomic) NSMutableArray *studentsData;
@end
