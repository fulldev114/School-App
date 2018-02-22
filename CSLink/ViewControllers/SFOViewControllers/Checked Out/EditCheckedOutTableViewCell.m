//
//  CheckedInTableViewCell.m
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "EditCheckedOutTableViewCell.h"
#import "ParentConstant.h"

@implementation EditCheckedOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

	self.status1ImgView.layer.cornerRadius = 12.0f;
	self.status2ImgView.layer.cornerRadius = 12.0f;
	self.status3ImgView.layer.cornerRadius = 12.0f;
	
	self.dayLabel.font = FONT_18_REGULER;
	self.dayLabel.textColor = TEXT_COLOR_CYNA;
	self.statusLabel.font = FONT_18_REGULER;
	self.statusLabel.textColor = TEXT_COLOR_WHITE;
}

@end
