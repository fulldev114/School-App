//
//  SelectDialog.h
//  CSLink
//
//  Created by adamlucas on 6/17/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDialog : UIView
@property (weak, nonatomic) IBOutlet UIView *dlgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sfoButton;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *onCloseTouched;
@property (weak, nonatomic) IBOutlet UIButton *onSFOTouched;
@property (weak, nonatomic) IBOutlet UIButton *onActivityTouched;

@property (assign, nonatomic) BOOL isCheckedIn;
@end
