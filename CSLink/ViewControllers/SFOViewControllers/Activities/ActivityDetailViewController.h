//
//  ActivityDetailViewController.h
//  CSLink
//
//  Created by adamlucas on 5/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNamesLabel;
@property (weak, nonatomic) IBOutlet UITextView *studentNamesTextView;
@property (weak, nonatomic) IBOutlet UILabel *studentNamesLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentTitleLabel;
@property (weak, nonatomic) NSString *activityId;
@property (assign, nonatomic) BOOL isTeacher;
@end
