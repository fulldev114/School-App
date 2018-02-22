//
//  CalendarViewController.h
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAYCalendarView.h"

@interface CalendarViewController : UIViewController
@property (weak, nonatomic) IBOutlet DAYCalendarView *calendarView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITableView *eventListView;
@property (weak, nonatomic) IBOutlet UIView *firstSessionView;
@property (weak, nonatomic) IBOutlet UIView *secondSessionView;
@property (weak, nonatomic) IBOutlet UITextView *firstSessionTitle;
@property (weak, nonatomic) IBOutlet UITextView *secondSessionTitle;
@property (weak, nonatomic) IBOutlet UILabel *firstSessionValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstSessionWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondSessionWidth;
@property (weak, nonatomic) IBOutlet UILabel *secondSessionValue;
@end
