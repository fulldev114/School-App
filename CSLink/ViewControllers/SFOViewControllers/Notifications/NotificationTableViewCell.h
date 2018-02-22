//
//  OldNotificationTableViewCell.h
//  CSLink
//
//  Created by adamlucas on 5/27/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *clockImageView;
@property (weak, nonatomic) IBOutlet UIImageView *routineImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTimerBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTimeLabelBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNameTop;

@property (assign, nonatomic) BOOL isNew;
@end
