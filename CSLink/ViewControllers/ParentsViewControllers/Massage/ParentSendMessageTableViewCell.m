//
//  SendMessageTableViewCell.m
//  CSLink
//
//  Created by etech-dev on 9/26/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentSendMessageTableViewCell.h"
#import "ParentConstant.h"

@implementation ParentSendMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lblMessage.font = FONT_16_REGULER;
    self.lblMessage.textColor = [UIColor blackColor];
    self.lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblMessage.numberOfLines = 0;
    
    self.lblStatus.textColor = [UIColor blackColor];
    self.lblStatus.font = FONT_14_REGULER;
    
    self.lblDate.textColor = TEXT_COLOR_LIGHT_CYNA;
    self.lblDate.font = FONT_14_REGULER;
    
    self.lblParent.textColor = TEXT_COLOR_WHITE;
    self.lblParent.font = FONT_14_REGULER;
    
    self.imgProfile.layer.cornerRadius = 5;
    
    [BaseViewController setRoudRectImage:self.imgProfile];
    self.imgProfile.layer.borderColor = TEXT_COLOR_LIGHT_GREEN.CGColor;
    
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Enter Custom Code
    
    [BaseViewController setRoudRectImage:self.imgProfile];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
