//
//  TeacherSFOHomePageViewController.h
//  CSLink
//
//  Created by MobileMaster on 5/22/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBadgeButton.h"

@interface TeacherSFOHomePageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UIButton *checkOutButton;
@property (weak, nonatomic) IBOutlet UITableView *sfoTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet MIBadgeButton *oneMsgButton;
@property (weak, nonatomic) IBOutlet MIBadgeButton *groupMsgButton;
@property (weak, nonatomic) IBOutlet MIBadgeButton *activitiesButton;
@property (weak, nonatomic) IBOutlet UILabel *oneMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMsgLabel;

@property (weak, nonatomic) IBOutlet UILabel *activitiesLabel;

@end
