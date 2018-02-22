//
//  AbsentTableViewCell.h
//  CSAdmin
//
//  Created by etech-dev on 7/30/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbsentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UILabel *lblReason;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoLac;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@end
