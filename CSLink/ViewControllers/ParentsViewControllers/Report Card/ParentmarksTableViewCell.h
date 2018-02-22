//
//  marksTableViewCell.h
//  CSLink
//
//  Created by etech-dev on 7/28/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentmarksTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *marksView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoDataFond;
@end
