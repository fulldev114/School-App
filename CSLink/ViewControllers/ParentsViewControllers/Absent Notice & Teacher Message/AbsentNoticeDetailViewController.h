//
//  AbsentNoticeDetailViewController.h
//  CSLink
//
//  Created by etech-dev on 6/9/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbsentNoticeDetailViewController : UIViewController
{
    __weak IBOutlet UIButton *btnOk;
    __weak IBOutlet UILabel *txvNoticeDetail;
    __weak IBOutlet UIView *popupView;
    __weak IBOutlet NSLayoutConstraint *popViewHeight;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDate:(id)obj;

- (IBAction)btnOkPress:(id)sender;

@end
