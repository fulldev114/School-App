//
//  AbsentTableViewCell.m
//  CSAdmin
//
//  Created by etech-dev on 7/30/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "AbsentTableViewCell.h"
#import "TeacherConstant.h"
#import "BaseViewController.h"

@implementation AbsentTableViewCell

- (void)awakeFromNib {
    
    self.lblUserName.textColor = TEXT_COLOR_CYNA;
    self.lblUserName.font = FONT_16_BOLD;
    
    self.lblReason.textColor = TEXT_COLOR_WHITE;
    self.lblReason.font = FONT_14_LIGHT;
    
    self.lblNoLac.textColor = TEXT_COLOR_WHITE;
    self.lblNoLac.font = FONT_14_BOLD;
    self.lblNoLac.text = [GeneralUtil getLocalizedText:@"LBL_HOLIDAY_TITLE"];
    self.buttonView.backgroundColor = [UIColor clearColor];
    
    self.seperatorView.backgroundColor = SEPERATOR_COLOR;
    [BaseViewController setRoudRectImage:self.profileImg];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Enter Custom Code
    
    [BaseViewController setRoudRectImage:self.profileImg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
