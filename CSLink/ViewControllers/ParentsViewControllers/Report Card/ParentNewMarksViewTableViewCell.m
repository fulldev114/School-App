//
//  NewMarksViewTableViewCell.m
//  CSAdmin
//
//  Created by etech-dev on 10/15/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentNewMarksViewTableViewCell.h"
#import "ParentConstant.h"

static NSInteger const kCustomEditControlWidth=42;

@implementation ParentNewMarksViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _lblSubjectName.font = FONT_16_REGULER;
    _lblSubjectName.textColor = TEXT_COLOR_LIGHT_GREEN;
    _bottomSeperatore.backgroundColor = TEXT_COLOR_LIGHT_GREEN;
    
    // Initialization code
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if ([self.delegate isPseudoEditing]) {
        self.pseudoEdit = editing;
        [self beginEditMode];
    } else {
        [super setEditing:editing animated:animated];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.customEditControl.selected = selected;
}

#pragma mark - Cell custom edit control Action

- (IBAction)customEditControlPressed:(id)sender {
   // [self setSelected:YES animated:YES];
    [self.delegate selectCell:self];
}


#pragma mark - Private Method

// Animate view to show/hide custom edit control/button
- (void)beginEditMode { 
    self.leadingSpaceMainViewConstraint.constant = self.isPseudoEditing ? 0 : -kCustomEditControlWidth;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.mainView.superview layoutIfNeeded];
    }];
}
@end
