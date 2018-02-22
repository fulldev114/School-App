//
//  NewMarksViewTableViewCell.h
//  CSAdmin
//
//  Created by etech-dev on 10/15/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>



@class NewMarksViewTableViewCell;

@protocol NewMarksViewTableViewCellDelegate

@optional

@property (nonatomic, readonly, getter=isPseudoEditing) BOOL pseudoEdit;

//-(BOOL)isPseudoEditing;

- (void)selectCell:(NewMarksViewTableViewCell *)cell;

@end

@interface NewMarksViewTableViewCell : UITableViewCell


@property (nonatomic, getter=isPseudoEditing) BOOL pseudoEdit;
@property (nonatomic, getter=isDeleting) BOOL deleting;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *customEditControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingSpaceMainViewConstraint;

@property (weak, nonatomic) IBOutlet UILabel *lblSubjectName;
@property (weak, nonatomic) IBOutlet UIView *testView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTestView;
@property (weak, nonatomic) IBOutlet UIView *bottomSeperatore;

- (void)configureCell:(NSDictionary *)infoDictionary;
@property (nonatomic, assign) id <NewMarksViewTableViewCellDelegate> delegate;

@end
