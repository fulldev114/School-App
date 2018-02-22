//
//  SendMessageTableViewCell.h
//  CSAdmin
//
//  Created by etech-dev on 9/26/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgBubble;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@end
