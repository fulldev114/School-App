//
//  CalendarViewController.m
//  CSLink
//
//  Created by adamlucas on 5/24/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarHolidaysViewCell.h"
#import "BaseViewController.h"
#import "TeacherUser.h"
#import "DAYUtils.h"

#define SUNDAY 1
#define SATURDAY 7

@interface CalendarViewController () <CalendarDataAction, UITableViewDataSource>
{
    TeacherUser *userObj;
    NSString *oldfromDate;
    NSString *oldtoDate;
    NSMutableArray *sessionsData;
    NSMutableArray *holidaysData;
}

@end

@implementation CalendarViewController
@synthesize calendarView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_CALENDAR"] WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];
	
    userObj = [[TeacherUser alloc] init];
    
	[self.calendarView addTarget:self action:@selector(calendarViewDidChange:) forControlEvents:UIControlEventValueChanged];
    calendarView.delegate = self;
	self.calendarView.showUserEvents = YES;
    [self.calendarView reloadViewAnimated:NO];
    
    self.bottomView.backgroundColor = BOTTOM_BAR_COLOR_BLUE;
    
    self.eventListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.eventListView.dataSource = self;
    
    self.firstSessionTitle.textColor = TEXT_COLOR_CYNA;
    self.firstSessionValue.textColor = [UIColor whiteColor];
    
    self.secondSessionTitle.textColor = TEXT_COLOR_CYNA;
    self.secondSessionValue.textColor = [UIColor whiteColor];
    
    [self.firstSessionView.layer setMasksToBounds:YES];
    [self.firstSessionView.layer setCornerRadius:5.0f];
    [self.firstSessionView.layer setBorderColor:TEXT_COLOR_CYNA.CGColor];
    [self.firstSessionView.layer setBorderWidth:2.0f];
    
    [self.secondSessionView.layer setMasksToBounds:YES];
    [self.secondSessionView.layer setCornerRadius:5.0f];
    [self.secondSessionView.layer setBorderColor:TEXT_COLOR_CYNA.CGColor];
    [self.secondSessionView.layer setBorderWidth:2.0f];
    
    if ( [[UIScreen mainScreen] bounds].size.width <= 320 )
    {
        self.firstSessionTitle.font = FONT_17_BOLD;
        self.firstSessionValue.font = FONT_17_BOLD;
        self.secondSessionTitle.font = FONT_17_BOLD;
        self.secondSessionValue.font = FONT_17_BOLD;
    }
    else
    {
        self.firstSessionTitle.font = FONT_18_BOLD;
        self.firstSessionValue.font = FONT_18_BOLD;
        self.secondSessionTitle.font = FONT_18_BOLD;
        self.secondSessionValue.font = FONT_18_BOLD;
    }
    
    self.firstSessionWidth.constant = [[UIScreen mainScreen] bounds].size.width / 2 - 10;
    self.secondSessionWidth.constant = [[UIScreen mainScreen] bounds].size.width / 2 - 10;
    
}

- (void)initSelectedDate
{
    //[calendarView setSelectedDate:[NSDate date]];
    NSDateComponents *comps = [DAYUtils dateComponentsForWeekDayFromDate:[NSDate date]];
    
    if ( comps.weekday == SUNDAY || comps.weekday == SATURDAY )
    {
        self.firstSessionView.hidden = YES;
        self.secondSessionView.hidden = YES;
        return;
    }
    
    self.firstSessionValue.text = @"__:__ - __:__";
    self.secondSessionValue.text = @"__:__ - __:__";
    
    for (int i = 0; i < sessionsData.count; i++)
    {
        NSDictionary *item = [sessionsData objectAtIndex:i];
        if ([item objectForKey:@"weekday"] == [NSNull null])
            continue;
        
        if (comps.weekday == [[item objectForKey:@"weekday"] integerValue])
        {
            self.firstSessionValue.text = [NSString stringWithFormat:@"%@ - %@", [item objectForKey:@"first_from_time"], [item objectForKey:@"first_to_time"]];
            self.secondSessionValue.text = [NSString stringWithFormat:@"%@ - %@", [item objectForKey:@"second_from_time"], [item objectForKey:@"second_to_time"]];
            break;
        }
    }

}

- (void)updateDateRegion:(NSString *)fromDate toDate:(NSString *)toDate
{
    if (([oldfromDate isEqualToString:fromDate]) &&
        ([oldtoDate isEqualToString:toDate]))
        return;
    
    oldfromDate = fromDate;
    oldtoDate = toDate;
    
    [userObj getCalendarData:fromDate toDate:toDate :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            int resCode = [[dicRes valueForKey:@"flag"] intValue];
            
            if (resCode == RES_CODE_01)
                NSLog (@"Request success");
            else
            {
                NSLog(@"%@", [dicRes valueForKey:@"msg"]);
                return;
            }
        }
        else
        {
            NSLog(@"Request Fail...");
            return;
        }
        
        if (dicRes != nil) {
            sessionsData = [NSMutableArray arrayWithArray:[dicRes valueForKey:@"sessions"]];
            holidaysData = [NSMutableArray arrayWithArray:[dicRes valueForKey:@"holidays"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.eventListView reloadData];
                [self initSelectedDate];
                
            });
            
            [calendarView setEventsInVisibleMonth:holidaysData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (holidaysData != nil)
        return holidaysData.count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CalendarHolidaysViewCell *cell = (CalendarHolidaysViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CalendarHolidaysViewCell"];

    if (cell == nil)
    {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"CalendarHolidaysViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    NSDictionary *item = [holidaysData objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormat dateFromString:[item valueForKey:@"date"]];
    [dateFormat setDateFormat:@"dd MMM"];
    
    cell.dayLabel.text = [dateFormat stringFromDate:date];
    cell.contentLabel.text = [item valueForKey:@"comment"];
    
    if ([[item valueForKey:@"type"] integerValue] == 1)
        cell.detailLabel.text = @"All Day";
    else
        cell.detailLabel.text = @"Half Day";
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)calendarViewDidChange:(id)sender {
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"YYYY-MM-dd";
    NSString *strSelDate = [formatter stringFromDate:self.calendarView.selectedDate];
	NSLog(@"%@", strSelDate);
    
    for (int i = 0; i < holidaysData.count; i++)
    {
        if ([strSelDate isEqualToString:[holidaysData[i] valueForKey:@"date"]])
        {
            self.firstSessionView.hidden = YES;
            self.secondSessionView.hidden = YES;
            return;
        }
    }
    
    self.firstSessionView.hidden = NO;
    self.secondSessionView.hidden = NO;
    
    if (sessionsData == nil)
        return;
    
    NSDateComponents *comps = [DAYUtils dateComponentsForWeekDayFromDate:self.calendarView.selectedDate];
    
    if ( comps.weekday == SUNDAY || comps.weekday == SATURDAY )
    {
        self.firstSessionView.hidden = YES;
        self.secondSessionView.hidden = YES;
        return;
    }
    
    self.firstSessionValue.text = @"__:__ - __:__";
    self.secondSessionValue.text = @"__:__ - __:__";
    
    for (int i = 0; i < sessionsData.count; i++)
    {
        NSDictionary *item = [sessionsData objectAtIndex:i];
        if ([item objectForKey:@"weekday"] == [NSNull null])
            continue;
        
        if (comps.weekday == [[item objectForKey:@"weekday"] integerValue])
        {
            self.firstSessionValue.text = [NSString stringWithFormat:@"%@ - %@", [item objectForKey:@"first_from_time"], [item objectForKey:@"first_to_time"]];
            self.secondSessionValue.text = [NSString stringWithFormat:@"%@ - %@", [item objectForKey:@"second_from_time"], [item objectForKey:@"second_to_time"]];
            break;
        }
    }
}

- (void)onTouchedBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
