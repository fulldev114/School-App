//
//  ProfileDetailTableViewCell.m
//  CSLink
//
//  Created by common on 7/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ProfileDetailTableViewCell.h"
#import "ParentConstant.h"

@implementation ProfileDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lblCaption.textColor = TEXT_COLOR_DARK_BLUE;
    self.lblCaption.font = FONT_16_LIGHT;
    
    self.lblContent.textColor = TEXT_COLOR_GRAY;
    self.lblContent.font = FONT_16_LIGHT;
    
    self.txtEditContent.hidden = YES;
    self.txtEditContent.font = FONT_16_LIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
