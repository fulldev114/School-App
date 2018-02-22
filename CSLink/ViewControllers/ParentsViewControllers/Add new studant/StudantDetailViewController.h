//
//  StudantDetailViewController.h
//  CSLink
//
//  Created by etech-dev on 7/20/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPopupViewController;

@interface StudantDetailViewController : UIViewController
{

    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblStudName;
    __weak IBOutlet UIButton *btnOk;
    __weak IBOutlet UIButton *btnCancel;
    __weak IBOutlet UIView *popupView;
    __weak IBOutlet UILabel *lblSchAndClass;
    __weak IBOutlet UILabel *birthDate;
    __weak IBOutlet UILabel *lblClass;
}

@property (assign, nonatomic) id <CustomPopupViewController>delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDate:(id)obj;

- (IBAction)btnOkPress:(id)sender;
- (IBAction)btnCancelPress:(id)sender;
@end

@protocol CustomPopupViewController<NSObject>

@optional
- (void)Done:(NSDictionary *)dicValue;

@end