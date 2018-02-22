//
//  ParentEditCheckedOutViewController.m
//  CSLink
//
//  Created by adamlucas on 5/30/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ParentEditCheckedOutViewController.h"
#import "BaseViewController.h"
#import "EditCheckedOutTableViewCell.h"
#import "TeacherUser.h"
#import "DAYUtils.h"

@interface ParentEditCheckedOutViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    TeacherUser *userObj;
    int currentTimeEditWeek;
}
@end

@implementation ParentEditCheckedOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *student_name = [_studentDetail valueForKey:@"student_name"];
	[BaseViewController setNavigationBack:self title:student_name titleColor:TEXT_COLOR_LIGHT_YELLOW WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];
	
	self.studentTableView.delegate = self;
	self.studentTableView.dataSource = self;
    
    [_btnSave.layer setMasksToBounds:YES];
    [_btnSave.layer setCornerRadius:5.0f];
    [_btnSave.layer setBorderWidth:1.0f];
    [_btnSave.layer setBorderColor:TEXT_COLOR_CYNA.CGColor];
    [_btnSave setBackgroundColor:TEXT_COLOR_CYNA];
    [_btnSave setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    _btnSave.titleLabel.font = FONT_BTN_TITLE_18;
    
    [_btnCancel.layer setMasksToBounds:YES];
    [_btnCancel.layer setCornerRadius:5.0f];
    [_btnCancel.layer setBorderWidth:1.0f];
    [_btnCancel.layer setBorderColor:TEXT_COLOR_WHITE.CGColor];
    [_btnCancel setBackgroundColor:TEXT_COLOR_WHITE];
    [_btnCancel setTitleColor:TEXT_COLOR_BLACK forState:UIControlStateNormal];
    _btnCancel.titleLabel.font = FONT_BTN_TITLE_18;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTappedView:)];
    [self.datePickerView addGestureRecognizer:tapGesture];
    [self.datePickerView setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f]];
    
    [self.datePicker.layer setMasksToBounds:YES];
    [self.datePicker.layer setCornerRadius:10.0f];
    for (UIView *subView in self.datePicker.subviews)
        [subView setBackgroundColor:[UIColor whiteColor]];
    
    currentTimeEditWeek = -1;
    
    userObj = [[TeacherUser alloc] init];
    
    if ([GeneralUtil screenWidth] <= 320)
    {
        self.constBtnSaveLeft.constant = 40;
        self.constBtnCancelRight.constant = 40;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTouchedBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 + 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//return UITableViewAutomaticDimension;
	if (IS_IPAD) {
		return 85;
	}
	else {
		return 60;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"EditCheckedOutTableViewCell";
	
	EditCheckedOutTableViewCell *cell = (EditCheckedOutTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"EditCheckedOutTableViewCell" owner:self options:nil];
		cell=[nib objectAtIndex:0];
		cell.backgroundColor = [UIColor clearColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    cell.contentView.tag = -1;
    if (indexPath.row < 3)
    {
        [cell.dayLabel setHidden:YES];
        [cell.statusLabel setHidden:YES];
        [cell.status1ImgView setHidden:YES];
        [cell.status2ImgView setHidden:YES];
        
        [cell.titleLabel setHidden:NO];
        [cell.status3ImgView setHidden:NO];
        [cell setBackgroundColor:BOTTOM_BAR_COLOR_BLUE];
    }
    else
    {
        [cell.dayLabel setHidden:NO];
        [cell.statusLabel setHidden:NO];
        [cell.status1ImgView setHidden:NO];
        [cell.status2ImgView setHidden:NO];
        [cell.status3ImgView setHidden:NO];
        
        [cell.titleLabel setHidden:YES];
    }
    
    cell.clockImgView.hidden = YES;

    if (indexPath.row == 0)
    {
        [cell.status3ImgView setHidden:YES];
        
        cell.titleLabel.text = @"CURRENT STATUS";
        cell.titleLabel.font = FONT_BTN_TITLE_18;
        cell.titleLabel.textColor = TEXT_COLOR_LIGHT_YELLOW;
    }
    else if (indexPath.row == 1)
    {
        cell.titleLabel.font = FONT_18_REGULER;
        cell.titleLabel.textColor = TEXT_COLOR_WHITE;
        cell.titleLabel.text = [self getCurrentStatus];
        
        UIImage *img = [self getCurrentStatusImg];
        if (img != nil)
        {
            [cell.status3ImgView setImage:img];
            [cell.status3ImgView setBackgroundColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:150/255.0f alpha:1.0f]];
        }
        else
            [cell.status3ImgView setHidden:YES];
    }
    else if (indexPath.row == 2)
    {
        cell.titleLabel.font = FONT_18_REGULER;
        cell.titleLabel.textColor = TEXT_COLOR_WHITE;
        cell.titleLabel.text = [self getTodayRule];
        UIImage *img = [self getTodayRuleImg];
        if (img != nil)
        {
            [cell.status3ImgView setImage:img];
            [cell.status3ImgView setBackgroundColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:150/255.0f alpha:1.0f]];
        }
        else
            [cell.status3ImgView setHidden:YES];
    }
    else
    {
        [cell.status1ImgView setImage:[UIImage imageNamed:@"bus_selected"]];
        [cell.status2ImgView setImage:[UIImage imageNamed:@"parent"]];
        [cell.status3ImgView setImage:[UIImage imageNamed:@"walking_student"]];
        
        [cell.status1ImgView setBackgroundColor:[UIColor clearColor]];
        [cell.status2ImgView setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:161.0/255.0 blue:0 alpha:1.0f]];
        [cell.status3ImgView setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:161.0/255.0 blue:0 alpha:1.0f]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickCheckOutStatus:)];
        [cell.status1ImgView setTag:(indexPath.row - 3 + 1) * 3];
        [cell.status1ImgView addGestureRecognizer:tapGesture];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickCheckOutStatus:)];
        [cell.status2ImgView setTag:(indexPath.row - 3 + 1) * 3 + 1];
        [cell.status2ImgView addGestureRecognizer:tapGesture];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickCheckOutStatus:)];
        [cell.status3ImgView setTag:(indexPath.row - 3 + 1) * 3 + 2];
        [cell.status3ImgView addGestureRecognizer:tapGesture];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickCheckOutTime:)];
        [cell.statusLabel addGestureRecognizer:tapGesture];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.font = FONT_18_REGULER;
        
        cell.dayLabel.text = [DAYUtils fullStringOfWeekdayInEnglish:indexPath.row - 3 + 2];
        cell.statusLabel.text = [NSString stringWithFormat:@"        %@", [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_BUS"]];
        cell.statusLabel.tag = indexPath.row - 3 + 1;
        
        lbl.text = cell.dayLabel.text;
        [lbl sizeToFit];
        
        if ( indexPath.row > 2)
        {
            cell.clockImgView.hidden = NO;
            [cell.clockImgView setFrame:CGRectMake(23 + lbl.frame.size.width, 22, 15, 15)];
        }
        
        
        NSMutableArray *rules = [_studentDetail objectForKey:@"check_out_rules"];
        cell.contentView.tag = 0;
        if (rules == nil || rules.count == 0)
            return cell;
        
        for (NSDictionary *item in rules)
        {
            NSString *weekday = [item valueForKey:@"weekday"];
            if(weekday == nil || [weekday isEqual:[NSNull null]])
                continue;
            
            if ([weekday intValue] != indexPath.row - 3 + 1)
                continue;
            
            NSString* checkoutRuleType = [item valueForKey:@"type"];
            NSString* status;
            if(checkoutRuleType != nil && ![checkoutRuleType isEqual:[NSNull null]])
            {
                cell.contentView.tag = [checkoutRuleType intValue];
                if([checkoutRuleType intValue] == 0) // bus
                {
                    status = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_BUS"];
                }
                else if([checkoutRuleType intValue] == 1) // parent
                {
                    [cell.status1ImgView setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:161.0/255.0 blue:0 alpha:1.0f]];
                    [cell.status1ImgView setImage:[UIImage imageNamed:@"bus"]];
                    [cell.status2ImgView setBackgroundColor:[UIColor clearColor]];
                    [cell.status2ImgView setImage:[UIImage imageNamed:@"parent_selected"]];
                    status = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_PARENT"];
                }
                else if([checkoutRuleType intValue] == 2) // friends
                {
                    [cell.status1ImgView setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:161.0/255.0 blue:0 alpha:1.0f]];
                    [cell.status1ImgView setImage:[UIImage imageNamed:@"bus"]];
                    [cell.status3ImgView setBackgroundColor:[UIColor clearColor]];
                    [cell.status3ImgView setImage:[UIImage imageNamed:@"walking_student_selected"]];
                    status = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_FRIEND"];
                }
            }
            
            
            NSString *time = [item valueForKey:@"time"];
            if (time == nil || [time isEqual:[NSNull null]])
                time = @"__:__";
            
            cell.statusLabel.text = [NSString stringWithFormat:@" (%@) %@", time, status];
            
            cell.clockImgView.hidden = YES;
        }
    }

	return cell;
}

- (NSString *)getCurrentStatus
{
    NSString *sfo_status = [_studentDetail valueForKey:@"sfo_status"];
    if ([_studentDetail valueForKey:@"sfo_status"] == [NSNull null])
        return [GeneralUtil getLocalizedText:@"TEXT_NONE"];
    
    if ([sfo_status intValue] != 3)
        return [GeneralUtil getLocalizedText:@"TEXT_NONE"];
    
    NSString *sfo_subType = [_studentDetail valueForKey:@"sfo_subtype"];
    if ([_studentDetail valueForKey:@"sfo_subtype"] == [NSNull null])
        return [GeneralUtil getLocalizedText:@"TEXT_NONE"];
    
    NSString *subType;
    if ([sfo_subType intValue] == 0)
        subType = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_BUS"];
    else if ([sfo_subType intValue] == 1)
        subType = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_PARENT"];
    else if ([sfo_subType intValue] == 2)
        subType = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_FRIEND"];
    
    return [NSString stringWithFormat:@"%@(%@)", subType, [_studentDetail valueForKey:@"sco_time"]];
}

- (UIImage *)getCurrentStatusImg
{
    NSString *sfo_subType = [_studentDetail valueForKey:@"sfo_subtype"];
    if ([_studentDetail valueForKey:@"sfo_subtype"] == [NSNull null])
        return nil;
        
    if ([sfo_subType intValue] == 0)
        return [UIImage imageNamed:@"bus"];
    else if ([sfo_subType intValue] == 1)
        return [UIImage imageNamed:@"parent"];
    else if ([sfo_subType intValue] == 2)
        return [UIImage imageNamed:@"walking_student"];
    
    return nil;
}

- (NSString *)getTodayRule
{
    NSDateComponents *comps = [DAYUtils dateComponentsForWeekDayFromDate:[NSDate date]];
    if (comps.weekday < 2 || comps.weekday > 6)
        return [GeneralUtil getLocalizedText:@"TEXT_NONE"];
    
    NSString *weekDayEngStr = [DAYUtils fullStringOfWeekdayInEnglish:comps.weekday];
    
    NSMutableArray *rules = [_studentDetail objectForKey:@"check_out_rules"];
    if (rules == nil || rules.count == 0)
        return [NSString stringWithFormat:@"%@ - %@", weekDayEngStr, [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_BUS"]];
    
    for (NSDictionary *item in rules)
    {
        NSString *weekday = [item valueForKey:@"weekday"];
        NSString *time = [item valueForKey:@"time"];
        NSString *checkoutRuleType = [item valueForKey:@"type"];
        NSString* status;
        
        if(weekday == nil || [weekday isEqual:[NSNull null]])
            continue;
        
        if(checkoutRuleType == nil || [checkoutRuleType isEqual:[NSNull null]])
            continue;

        if([checkoutRuleType intValue] == 0) // bus
            status = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_BUS"];
        else if([checkoutRuleType intValue] == 1) // parent
            status = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_PARENT"];
        else if([checkoutRuleType intValue] == 2) // friends
            status = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_FRIEND"];
        
        if (comps.weekday == [weekday intValue] + 1)
        {
            return [NSString stringWithFormat:@"%@ - %@ (%@)", weekDayEngStr, status, time];
        }
    }
    
    return [NSString stringWithFormat:@"%@ - %@", weekDayEngStr, [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_BUS"]];
}

- (UIImage *)getTodayRuleImg
{
    NSDateComponents *comps = [DAYUtils dateComponentsForWeekDayFromDate:[NSDate date]];
    if (comps.weekday < 2 || comps.weekday > 6)
        return nil;
    
    NSMutableArray *rules = [_studentDetail objectForKey:@"check_out_rules"];
    if (rules == nil || rules.count == 0)
        return [UIImage imageNamed:@"bus"];
    
    for (NSDictionary *item in rules)
    {
        NSString *weekday = [item valueForKey:@"weekday"];
        NSString *checkoutRuleType = [item valueForKey:@"type"];
        UIImage *img;
        if(checkoutRuleType != nil && ![checkoutRuleType isEqual:[NSNull null]])
        {
            if([checkoutRuleType intValue] == 0) // bus
                img = [UIImage imageNamed:@"bus"];
            else if([checkoutRuleType intValue] == 1) // parent
                img = [UIImage imageNamed:@"parent"];
            else if([checkoutRuleType intValue] == 2) // friends
                img = [UIImage imageNamed:@"walking_student"];
        }
        
        if(weekday == nil || [weekday isEqual:[NSNull null]])
            continue;
        
        if (comps.weekday == [weekday intValue] + 1)
            return img;
    }
    
    return [UIImage imageNamed:@"bus"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (IBAction)onSave:(id)sender
{
    [userObj sendCheckOutRule:[_studentDetail valueForKey:@"student_id"] rules:[_studentDetail objectForKey:@"check_out_rules"] : ^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
                NSLog(@"Request Success...");
            else
                NSLog(@"Request Fail...");
        }
        else {
            NSLog(@"Request Fail...");
        }
        
    }];
}

- (IBAction)onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickCheckOutStatus:(UITapGestureRecognizer*)sender {
    int tag = (int)sender.view.tag;
    int weekday = tag / 3;
    int selectedRuleType = tag % 3;
    int curRuleType = (int)sender.view.superview.tag;
    
    if (selectedRuleType == curRuleType)
        return;
    
    NSMutableArray *rules = [_studentDetail objectForKey:@"check_out_rules"];
    NSMutableDictionary *newItem;
    if (rules == nil)
        rules = [[NSMutableArray alloc] init];
    
    if (rules.count == 0)
    {
        newItem = [[NSMutableDictionary alloc] init];
        [newItem setObject:[NSString stringWithFormat:@"%d", weekday] forKey:@"weekday"];
        [newItem setObject:@"__:__" forKey:@"time"];
        [newItem setObject:[NSString stringWithFormat:@"%d", selectedRuleType] forKey:@"type"];
        [rules addObject:newItem];
        
        [self.studentTableView reloadData];
        return;
    }
    
    BOOL isChanged = NO;
    for (NSMutableDictionary *item in rules)
    {
        NSString *weekDayStr = [item valueForKey:@"weekday"];
        if(weekDayStr == nil || [weekDayStr isEqual:[NSNull null]])
            continue;
        
        if (weekday == [weekDayStr intValue])
        {
            isChanged = YES;
            [item setObject:[NSString stringWithFormat:@"%d", selectedRuleType] forKey:@"type"];
            break;
        }
    }
    
    if (!isChanged)
    {
        newItem = [[NSMutableDictionary alloc] init];
        [newItem setObject:[NSString stringWithFormat:@"%d", weekday] forKey:@"weekday"];
        [newItem setObject:@"__:__" forKey:@"time"];
        [newItem setObject:[NSString stringWithFormat:@"%d", selectedRuleType] forKey:@"type"];
        [rules addObject:newItem];
    }
    
    [self.studentTableView reloadData];
}

- (void)onClickCheckOutTime:(UITapGestureRecognizer*)sender {
    self.datePickerView.hidden = NO;
    currentTimeEditWeek = (int)sender.view.tag;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    
    NSMutableArray *rules = [_studentDetail objectForKey:@"check_out_rules"];
    if (rules == nil || rules.count == 0)
    {
        [self.datePicker setDate:[NSDate date]];
        return;
    }
    
    for (NSDictionary *item in rules)
    {
        NSString *weekDayStr = [item valueForKey:@"weekday"];
        if(weekDayStr == nil || [weekDayStr isEqual:[NSNull null]])
            continue;
        
        if (currentTimeEditWeek == [weekDayStr intValue])
        {
            NSString *time = [item valueForKey:@"time"];
            if (![time isEqualToString:@"__:__"])
            {
                [self.datePicker setDate:[dateFormat dateFromString:time]];
                return;
            }
        }
    }
    
    [self.datePicker setDate:[NSDate date]];
}

- (void)onTappedView:(UITapGestureRecognizer*)sender {
    self.datePickerView.hidden = YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    
    NSString *timeStr = [dateFormat stringFromDate:self.datePicker.date];
    
    NSMutableArray *rules = [_studentDetail objectForKey:@"check_out_rules"];
    NSMutableDictionary *newItem;
    if (rules == nil)
        rules = [[NSMutableArray alloc] init];
    
    if (rules.count == 0)
    {
        newItem = [[NSMutableDictionary alloc] init];
        [newItem setObject:[NSString stringWithFormat:@"%d", currentTimeEditWeek] forKey:@"weekday"];
        [newItem setObject:timeStr forKey:@"time"];
        [newItem setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"type"];
        [rules addObject:newItem];
        
        [self.studentTableView reloadData];
        return;
    }
    
    BOOL isChanged = NO;
    for (NSMutableDictionary *item in rules)
    {
        NSString *weekDayStr = [item valueForKey:@"weekday"];
        if(weekDayStr == nil || [weekDayStr isEqual:[NSNull null]])
            continue;
        
        if (currentTimeEditWeek == [weekDayStr intValue])
        {
            isChanged = YES;
            [item setObject:timeStr forKey:@"time"];
            break;
        }
    }
    
    if (!isChanged)
    {
        newItem = [[NSMutableDictionary alloc] init];
        [newItem setObject:[NSString stringWithFormat:@"%d", currentTimeEditWeek] forKey:@"weekday"];
        [newItem setObject:timeStr forKey:@"time"];
        [newItem setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"type"];
        [rules addObject:newItem];
    }
    
    [self.studentTableView reloadData];
}
@end
