//
//  ParentSFOHomePageViewController.h
//  CSLink
//
//  Created by adamlucas on 5/30/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBadgeButton.h"

@interface ParentSFOHomePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UIButton *checkOutButton;
//@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *checkedInStatusView;
@property (weak, nonatomic) IBOutlet UIButton *checkedInStatusButton;
@property (weak, nonatomic) IBOutlet UILabel *checkedInStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *notArrivedView;
@property (weak, nonatomic) IBOutlet UIButton *notArrivedButton;
@property (weak, nonatomic) IBOutlet UILabel *notArrivedLabel;
@property (weak, nonatomic) IBOutlet UIView *checkedOutView;
@property (weak, nonatomic) IBOutlet UIButton *checkedOutButton;
@property (weak, nonatomic) IBOutlet UIButton *checkedOutEditButton;
@property (weak, nonatomic) IBOutlet UILabel *checkedOutLabel;
@property (weak, nonatomic) IBOutlet UIView *activitiesView;
@property (weak, nonatomic) IBOutlet UIButton *activitiesItemButton;
@property (weak, nonatomic) IBOutlet UILabel *activitiesItemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *beforeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet MIBadgeButton *oneMsgButton;
@property (weak, nonatomic) IBOutlet MIBadgeButton *groupMsgButton;
@property (weak, nonatomic) IBOutlet MIBadgeButton *activitiesButton;
@property (weak, nonatomic) IBOutlet UILabel *oneMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMsgLabel;

@property (weak, nonatomic) IBOutlet UILabel *activitiesLabel;

@property (strong, nonatomic) IBOutlet NSMutableArray *studentsData;
@end
