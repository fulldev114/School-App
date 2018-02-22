//
//  CheckedInTableViewCell.m
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "CheckedInTableViewCell.h"
#import "ParentConstant.h"

@implementation CheckedInTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.cellType = TEACHER;
	
	self.nameLabel.font = FONT_18_REGULER;
	self.nameLabel.textColor = TEXT_COLOR_YELLOW;
	
	self.checkedInNameLabel.font = FONT_18_REGULER;
	self.checkedInNameLabel.textColor = TEXT_COLOR_WHITE;
	
	self.checkedInStatusLabel.font = FONT_18_REGULER;
	self.checkedInStatusLabel.textColor = TEXT_COLOR_WHITE;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setCheckedInType:(CheckedInType)cellType
//{
//	self.cellType = cellType;
//	switch (self.cellType) {
//		case TEACHER_NORMAL :
//			_titleLabel.text = @"SFO";
//			_titleLabel.textColor = TEXT_COLOR_GREEN;
//			
//			break;
//		case TEACHER_CHECKEDIN :
//			_titleLabel.text = @"NOT ARRIVED";
//			_titleLabel.textColor = TEXT_COLOR_RED;
//			break;
//		case PARENT_NORMAL :
//			_titleLabel.text = @"CHECKED_OUT";
//			_titleLabel.textColor = TEXT_COLOR_YELLOW;
//			
//			break;
//		case PARENT_CHECKEDIN :
//			_titleLabel.text = @"ACTIVITIES";
//			_titleLabel.textColor = TEXT_COLOR_CYNA;
//			
//			break;
//		default:
//			break;
//	}
//	
//}

- (void)setStudentName:(NSString*)name
{
	[self.checkedInView setHidden:YES];
	[self.nameLabel setHidden:NO];

	if (self.cellType == TEACHER)
		self.nameLabel.textColor = TEXT_COLOR_CYNA;
	else
		self.nameLabel.textColor = TEXT_COLOR_WHITE;
	
	self.backgroundColor = [UIColor clearColor];
	self.nameLabel.text = name;
}

- (void)setCheckedInStatus:(NSString*)name status:(NSString*)status
{
	[self.checkedInView setHidden:NO];
	[self.nameLabel setHidden:YES];
	self.backgroundColor = TEXT_COLOR_GREEN;
	
	self.checkedInNameLabel.text = name;
	self.checkedInStatusLabel.text = status;
}
@end
