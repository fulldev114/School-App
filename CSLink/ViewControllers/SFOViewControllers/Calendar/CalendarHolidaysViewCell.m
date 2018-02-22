//
//  CalendarHolidaysViewCell.m
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "CalendarHolidaysViewCell.h"
#import "ParentConstant.h"

@implementation CalendarHolidaysViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	self.dayLabel.font = FONT_18_REGULER;
	self.dayLabel.textColor = [UIColor whiteColor];
	
    self.contentLabel.font = FONT_18_REGULER;
    self.contentLabel.textColor = TEXT_COLOR_CYNA;
    
    self.detailLabel.font = FONT_17_LIGHT;
    self.detailLabel.textColor = TEXT_COLOR_WHITE;
}

@end
