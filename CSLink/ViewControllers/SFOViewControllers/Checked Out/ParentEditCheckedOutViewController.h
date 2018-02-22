//
//  ParentEditCheckedOutViewController.h
//  CSLink
//
//  Created by adamlucas on 5/30/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentEditCheckedOutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *studentTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBtnSaveLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBtnCancelRight;

@property (strong, nonatomic) NSDictionary *studentDetail;
@end
