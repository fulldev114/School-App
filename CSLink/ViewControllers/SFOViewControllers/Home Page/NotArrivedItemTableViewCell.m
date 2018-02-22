//
//  NotArrivedItemTableViewCell.m
//  CSLink
//
//  Created by adamlucas on 5/28/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "NotArrivedItemTableViewCell.h"
#import "ParentConstant.h"

@implementation NotArrivedItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_nameLabel.font = FONT_18_REGULER;
	_nameLabel.textColor = TEXT_COLOR_RED;
	_classLabel.font = FONT_18_REGULER;
	_classLabel.textColor = TEXT_COLOR_WHITE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
