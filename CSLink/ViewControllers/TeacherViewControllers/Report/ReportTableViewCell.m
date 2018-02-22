//
//  ReportTableViewCell.m
//  CSAdmin
//
//  Created by etech-dev on 8/31/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ReportTableViewCell.h"
#import "BaseViewController.h"

@implementation ReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.profileImg.contentMode = UIViewContentModeScaleAspectFit;
    [BaseViewController setRoudRectImage:self.profileImg];

    self.lblStudantName.textColor = TEXT_COLOR_CYNA;
    self.lblStudantName.font = FONT_16_SEMIBOLD;
    self.lblStudantName.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblStudantName.numberOfLines = 0;
    
    self.btnViewReport.titleLabel.font = FONT_BTN_TITLE_15;
    self.btnViewReport.userInteractionEnabled = NO;
    self.btnViewReport.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.seperatorView.backgroundColor = SEPERATOR_COLOR;
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
