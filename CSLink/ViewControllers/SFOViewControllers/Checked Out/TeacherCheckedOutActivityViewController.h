//
//  CheckInViewController.h
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherCheckedOutActivityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *studentTableView;

@property (weak, nonatomic) IBOutlet UIButton *selectClassButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (assign, nonatomic) NSString* activityID;
@property (nonatomic, assign) BOOL isTeacher;

@end
