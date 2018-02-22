//
//  BehaviyerTableViewCell.m
//  CSAdmin
//
//  Created by etech-dev on 10/19/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentBehaviyerTableViewCell.h"
#import "BaseViewController.h"

@implementation ParentBehaviyerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lblUserName.font = FONT_12_BOLD;
    self.lblDate.font = FONT_12_REGULER;
    self.lblBehaviyor.font = FONT_17_REGULER;
    self.lblComment.font = FONT_17_REGULER;
    
    self.lblUserName.textColor = TEXT_COLOR_CYNA;
    self.lblDate.textColor = TEXT_COLOR_CYNA;
    self.lblBehaviyor.textColor = TEXT_COLOR_BLACK;
    self.lblComment.textColor = TEXT_COLOR_BLACK;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.lblComment.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblComment.numberOfLines = 0;
    
    self.lblBehaviyor.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblBehaviyor.numberOfLines = 0;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Enter Custom Code
    
    [BaseViewController setRoudRectImage:self.profileImg];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
