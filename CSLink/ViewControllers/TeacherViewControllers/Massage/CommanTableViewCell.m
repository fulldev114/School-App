//
//  CommanTableViewCell.m
//  CSLink
//
//  Created by etech-dev on 7/18/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "CommanTableViewCell.h"
#import "TeacherConstant.h"

@implementation CommanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.lblStudantName.textColor = TEXT_COLOR_CYNA;
    self.lblStudantName.font = FONT_17_BOLD;
    
    self.lblClassName.textColor = TEXT_COLOR_WHITE;
    self.lblClassName.font = FONT_16_BOLD;
    
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
