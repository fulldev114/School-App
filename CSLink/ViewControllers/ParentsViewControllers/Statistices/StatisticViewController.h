//
//  StatisticViewController.h
//  CSLink
//
//  Created by etech-dev on 6/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressBar.h"

@interface StatisticViewController : UIViewController
{

    __weak IBOutlet UIImageView *profileImg;
    __weak IBOutlet UILabel *lblUserName;
   
    __weak IBOutlet UILabel *lblEndDate;
    __weak IBOutlet UILabel *lblTo;
    __weak IBOutlet UILabel *lblStartDate;
    __weak IBOutlet UIButton *btnDownload;
    __weak IBOutlet UILabel *lblDays;
    __weak IBOutlet UILabel *lblHours;
}
@property (weak, nonatomic) IBOutlet CircleProgressBar *dayProcess;
@property (weak, nonatomic) IBOutlet CircleProgressBar *hourProcess;

- (IBAction)btnEndDatePress:(id)sender;
- (IBAction)startDatePress:(id)sender;

- (IBAction)btnDownload:(id)sender;
@end
