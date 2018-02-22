//
//  groupcellTableViewCell.m
//  CSLink
//
//  Created by etech-dev on 6/27/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentgroupcellTableViewCell.h"
#import "ParentConstant.h"
#import "BaseViewController.h"

@implementation ParentgroupcellTableViewCell

- (void)awakeFromNib {
    
    self.lblContent.font = FONT_16_REGULER;
    self.lblContent.textColor = TEXT_COLOR_WHITE;
    self.lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblContent.numberOfLines = 0;
    
    self.lblUserName.textColor = TEXT_COLOR_LIGHT_GREEN;
    self.lblUserName.font = FONT_16_BOLD;
    //self.lblUserName.backgroundColor = [UIColor redColor];
    //self.lblUserName.preferredMaxLayoutWidth = 200;
    
    self.lblDate.textColor = TEXT_COLOR_CYNA;
    self.lblDate.font = FONT_14_BOLD;
    
    self.imgBackgroud.layer.cornerRadius = 5;
    
    self.profileImg.layer.borderColor = TEXT_COLOR_LIGHT_GREEN.CGColor;
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
