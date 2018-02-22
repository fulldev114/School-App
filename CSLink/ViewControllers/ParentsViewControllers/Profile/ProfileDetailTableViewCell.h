//
//  ProfileDetailTableViewCell.h
//  CSLink
//
//  Created by common on 7/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblSeparator;
@property (weak, nonatomic) IBOutlet UITextField *txtEditContent;

@end
