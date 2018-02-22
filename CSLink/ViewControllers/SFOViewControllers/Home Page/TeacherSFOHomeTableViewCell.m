//
//  CheckedInTableViewCell.m
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "TeacherSFOHomeTableViewCell.h"
#import "ParentConstant.h"

@implementation TeacherSFOHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_titleLabel.font = FONT_18_BOLD;
	_nameLabel.font = FONT_16_BOLD;
	_nameLabel.textColor = TEXT_COLOR_CYNA;
	
	_statusLabel.font = FONT_16_BOLD;
	_statusLabel.textColor = TEXT_COLOR_WHITE;
	
	_viewAllButton.titleLabel.textColor = TEXT_COLOR_CYNA;
	_viewAllButton.titleLabel.font = FONT_14_BOLD;
	_viewAllButton.tintColor = TEXT_COLOR_CYNA;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSFOType:(enum SFO_STATUS)cellType
{
	self.cellType = cellType;
	switch (self.cellType) {
		case SFO_CHECKEDIN :
			_titleLabel.text = @"SFO";
			_titleLabel.textColor = TEXT_COLOR_GREEN;
			
			break;
		case NOT_ARRIVED :
			_titleLabel.text = @"NOT ARRIVED";
			_titleLabel.textColor = TEXT_COLOR_RED;
			break;
		case CHECKEDOUT :
			_titleLabel.text = @"CHECKED_OUT";
			_titleLabel.textColor = TEXT_COLOR_YELLOW;
			
			break;
		case ACTIVITY_CHECKEDIN :
			_titleLabel.text = @"ACTIVITIES";
			_titleLabel.textColor = TEXT_COLOR_CYNA;
			
			break;
		default:
			break;
	}

}

@end
