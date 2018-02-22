//
//  CheckedInTableViewCell.h
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckedOutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkoutLabel;

@property (weak, nonatomic) IBOutlet UIImageView *curStatusImgView;
@property (weak, nonatomic) IBOutlet UIImageView *busImgView;
@property (weak, nonatomic) IBOutlet UIImageView *friendImgView;
@property (weak, nonatomic) IBOutlet UIImageView *parentImgView;
@property (weak, nonatomic) IBOutlet UILabel *busLabel;
@property (weak, nonatomic) IBOutlet UILabel *parentLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@end
