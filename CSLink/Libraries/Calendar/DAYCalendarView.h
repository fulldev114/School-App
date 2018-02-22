//
//  DAYCalendarView.h
//  Daysquare
//
//  Created by 杨弘宇 on 16/6/7.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@protocol CalendarDataAction;
@interface DAYCalendarView : UIControl

@property (nonatomic, weak) id<CalendarDataAction> delegate;

@property (copy, nonatomic) NSDate *selectedDate;

@property (copy, nonatomic) NSArray<NSString *> *localizedStringsOfWeekday;

// Appearance settings:
@property (copy, nonatomic) UIColor *weekdayHeaderTextColor;
@property (copy, nonatomic) UIColor *weekdayHeaderWeekendTextColor;
@property (copy, nonatomic) UIColor *componentTextColor;
@property (copy, nonatomic) UIColor *highlightedComponentTextColor;
@property (copy, nonatomic) UIColor *selectedIndicatorColor;
@property (copy, nonatomic) UIColor *todayIndicatorColor;
@property (assign, nonatomic) CGFloat indicatorRadius;
@property (assign, nonatomic) BOOL boldPrimaryComponentText;
@property (assign, nonatomic) BOOL singleRowMode;

// Additional features:
@property (assign, nonatomic) BOOL showUserEvents;

- (void)reloadViewAnimated:(BOOL)animated;   // Invalidate the original view, use it after changing the appearance settings.

- (void)jumpToNextMonth;
- (void)jumpToPreviousMonth;
- (void)jumpToMonth:(NSUInteger)month year:(NSUInteger)year;
- (void)setEventsInVisibleMonth:(NSMutableArray *)events;

@end

@protocol CalendarDataAction
@optional

- (void)updateDateRegion:(NSString *)fromDate toDate:(NSString *)toDate;

@end
