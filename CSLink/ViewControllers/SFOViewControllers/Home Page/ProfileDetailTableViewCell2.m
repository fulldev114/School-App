//
//  ProfileDetailTableViewCell2.m
//  CSLink
//
//  Created by common on 7/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ProfileDetailTableViewCell2.h"
#import "ParentConstant.h"

@implementation ProfileDetailTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lblType.textColor = TEXT_COLOR_GRAY;
    self.lblType.font = FONT_16_LIGHT;
    self.imgStatus.layer.cornerRadius = 12.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
