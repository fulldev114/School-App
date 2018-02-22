//
//  groupcellTableViewCell.h
//  CSLink
//
//  Created by etech-dev on 6/27/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentgroupcellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackgroud;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfUserlable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfBubble;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOflblContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameWidth;
@end
