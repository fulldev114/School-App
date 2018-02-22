//
//  StatisticeViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/16/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticeViewController : UIViewController
{

    __weak IBOutlet UILabel *lblUserName;
    __weak IBOutlet UILabel *lblStartdate;
    __weak IBOutlet UILabel *lblEndDate;
    __weak IBOutlet UILabel *lblDay;
    __weak IBOutlet UILabel *lblHourse;
    __weak IBOutlet UILabel *lblDayValue;
    __weak IBOutlet UILabel *lblHourseValue;
    __weak IBOutlet UIButton *btnOk;
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet UIView *mainView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDate:(id)obj;

- (IBAction)btnOkPress:(id)sender;
@end
