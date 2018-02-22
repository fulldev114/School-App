//
//  marksTableViewCell.m
//  CSAdmin
//
//  Created by etech-dev on 10/6/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentviewMarksTableViewCell.h"
#import "BaseViewController.h"

@implementation ParentviewMarksTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lblSubjectName.font = FONT_16_REGULER;
    _lblSubjectName.textColor = TEXT_COLOR_LIGHT_GREEN;
    _bottomSeperatore.backgroundColor = TEXT_COLOR_LIGHT_GREEN;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
