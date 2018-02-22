//
//  SendMessageTableViewCell.h
//  CSLink
//
//  Created by etech-dev on 9/26/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentSendMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblParent;
@property (weak, nonatomic) IBOutlet UIImageView *imgBubel;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnCallPress;

@end
