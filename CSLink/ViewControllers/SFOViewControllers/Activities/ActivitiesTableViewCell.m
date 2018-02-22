//
//  ActivitiesTableViewCell.m
//  CSLink
//
//  Created by adamlucas on 5/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ActivitiesTableViewCell.h"

@implementation ActivitiesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.dateBackgroundView.layer.cornerRadius = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
