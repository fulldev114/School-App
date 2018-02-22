//
//  CheckedInTableViewCell.h
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CheckedInType) {
	TEACHER,
	PARENT
};

@interface CheckedInTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *checkedInView;
@property (weak, nonatomic) IBOutlet UILabel *checkedInNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkedInStatusLabel;
@property (assign, nonatomic) CheckedInType  cellType;

- (void)setStudentName:(NSString*)name;
- (void)setCheckedInStatus:(NSString*)name status:(NSString*)status;
@end
