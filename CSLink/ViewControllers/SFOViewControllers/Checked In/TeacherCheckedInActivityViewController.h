//
//  CheckInViewController.h
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherCheckedInActivityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *studentTableView;

@property (weak, nonatomic) IBOutlet UIButton *selectClassButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) NSString *activityId;
@property (weak, nonatomic) NSString *activityName;
@property (assign, nonatomic) NSInteger activityStatus;
@end
