//
//  ProfileDetailViewController.h
//  CSLink
//
//  Created by common on 7/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UITableView *studentDetailTable;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblClass;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) NSString *studentID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constButtonLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constButtonRight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(id)obj;

@end
