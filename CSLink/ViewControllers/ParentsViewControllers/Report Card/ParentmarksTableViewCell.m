//
//  marksTableViewCell.m
//  CSLink
//
//  Created by etech-dev on 7/28/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentmarksTableViewCell.h"
#import "ParentConstant.h"

@implementation ParentmarksTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.lblUserName.font = FONT_16_BOLD;
    self.lblUserName.textColor = TEXT_COLOR_WHITE;
    self.lblUserName.text = [GeneralUtil getLocalizedText:@"LBL_SUBJECT_NAME_TITLE"];
    self.lblUserName.tag = 201;
    self.lblUserName.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblUserName.numberOfLines = 0;
    
    self.lblNoDataFond.font = FONT_16_BOLD;
    self.lblNoDataFond.textColor = TEXT_COLOR_WHITE;
    
    self.marksView.backgroundColor = [UIColor clearColor];
    self.seperatorView.backgroundColor = SEPERATOR_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
