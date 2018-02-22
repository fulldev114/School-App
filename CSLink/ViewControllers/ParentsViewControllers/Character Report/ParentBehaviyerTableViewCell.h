//
//  BehaviyerTableViewCell.h
//  CSAdmin
//
//  Created by etech-dev on 10/19/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentBehaviyerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleView;
@property (weak, nonatomic) IBOutlet UILabel *lblBehaviyor;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIView *seperatoreView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@end
