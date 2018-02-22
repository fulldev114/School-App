//
//  CheckedInTableViewCell.h
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCheckedOutTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *clockImgView;

@property (weak, nonatomic) IBOutlet UIImageView *status1ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *status2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *status3ImgView;
@end
