//
//  ItemTableViewCell.m
//  CSLink
//
//  Created by adamlucas on 5/28/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "ParentConstant.h"

@implementation ItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_nameLabel.font = FONT_18_REGULER;
	
	_classLabel.font = FONT_18_REGULER;
	_classLabel.textColor = TEXT_COLOR_WHITE;
	
	_detailLabel.font = FONT_18_REGULER;
	_detailLabel.textColor = TEXT_COLOR_WHITE;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setItemType:(ItemType)cellType
{
	self.cellType = cellType;
	switch (self.cellType) {
		case SFO :
			_nameLabel.textColor = TEXT_COLOR_CYNA;
			
			break;
		case CHECKED_OUT :
			_nameLabel.textColor = TEXT_COLOR_YELLOW;
			
			break;
		case ACTIVITIES :
			_nameLabel.textColor = TEXT_COLOR_CYNA;
			
			break;
		default:
			break;
	}
	
}

@end
