//
//  CommanTableViewCell.m
//  CSLink
//
//  Created by etech-dev on 7/18/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentCommanTableViewCell.h"
#import "ParentConstant.h"

@implementation ParentCommanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    self.lblStudantName.textColor = TEXT_COLOR_LIGHT_GREEN;
    self.lblStudantName.font = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? FONT_27_BOLD : FONT_TBL_ROW_TITLE;
    
    self.lblClassName.textColor = TEXT_COLOR_WHITE;
    self.lblClassName.font = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? FONT_25_SEMIBOLD : FONT_TBL_ROW_DETAIL;
    
    self.imgUser.contentMode = UIViewContentModeScaleAspectFit;
    self.imgUser.image = [UIImage imageNamed:@"profile.png"];
    
    self.seperator.backgroundColor = SEPERATOR_COLOR;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Enter Custom Code
    
    [BaseViewController setRoudRectImage:self.imgUser];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
