//
//  CommanTableViewCell.h
//  CSLink
//
//  Created by etech-dev on 7/18/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBadgeButton.h"

@interface CommanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblStudantName;
@property (weak, nonatomic) IBOutlet UILabel *lblClassName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIView *seperator;
@property (weak, nonatomic) IBOutlet MIBadgeButton *btnBadge;

@end
