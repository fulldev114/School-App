//
//  marksTableViewCell.h
//  CSAdmin
//
//  Created by etech-dev on 10/6/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentviewMarksTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSubjectName;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomSeperatore;
@end
