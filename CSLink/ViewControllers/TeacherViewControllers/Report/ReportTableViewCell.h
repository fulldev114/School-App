//
//  ReportTableViewCell.h
//  CSAdmin
//
//  Created by etech-dev on 8/31/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *lblStudantName;
@property (weak, nonatomic) IBOutlet UIButton *btnViewReport;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@end
