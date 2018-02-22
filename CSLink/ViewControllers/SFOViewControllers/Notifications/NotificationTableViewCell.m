//
//  OldNotificationTableViewCell.m
//  CSLink
//
//  Created by adamlucas on 5/27/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_isNew = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
