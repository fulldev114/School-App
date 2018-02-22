//
//  ContactNotificationTableViewCell.h
//  CSLink
//
//  Created by adamlucas on 5/27/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactNotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *memeberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *clockImageView;
@end
