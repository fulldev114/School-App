//
//  ActivitiesTableViewCell.h
//  CSLink
//
//  Created by adamlucas on 5/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitiesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *dateBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end
