//
//  CheckedInTableViewCell.m
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "CheckedOutTableViewCell.h"
#import "ParentConstant.h"

@implementation CheckedOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.curStatusImgView.layer.cornerRadius = 12.0f;
	self.busImgView.layer.cornerRadius = 12.0f;
	self.parentImgView.layer.cornerRadius = 12.0f;
	self.friendImgView.layer.cornerRadius = 12.0f;
    self.nameLabel.font = FONT_18_REGULER;
    self.nameLabel.textColor = TEXT_COLOR_CYNA;
    self.checkoutLabel.font = FONT_14_REGULER;
    self.checkoutLabel.textColor = TEXT_COLOR_WHITE;
    
    self.busLabel.layer.cornerRadius = 5.0f;
    self.busLabel.layer.masksToBounds = YES;
    self.busLabel.font = FONT_10_BOLD;
    
    self.parentLabel.layer.cornerRadius = 5.0f;
    self.parentLabel.layer.masksToBounds = YES;
    self.parentLabel.font = FONT_10_BOLD;

    self.friendLabel.layer.cornerRadius = 5.0f;
    self.friendLabel.layer.masksToBounds = YES;
    self.friendLabel.font = FONT_10_BOLD;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
