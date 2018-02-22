//
//  ItemTableViewCell.h
//  CSLink
//
//  Created by adamlucas on 5/28/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ItemType) {
	SFO,
	CHECKED_OUT,
	ACTIVITIES
};

@interface ItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *classLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (assign, nonatomic) ItemType cellType;

- (void)setItemType:(ItemType)cellType;
@end
