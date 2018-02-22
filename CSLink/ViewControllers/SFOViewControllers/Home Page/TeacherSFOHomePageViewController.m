//
//  TeacherSFOHomePageViewController.m
//  CSLink
//
//  Created by MobileMaster on 5/22/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "TeacherSFOHomePageViewController.h"
#import "BaseViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "ActivitiesViewController.h"
#import "TeacherCheckedInViewController.h"
#import "TeacherCheckedOutViewController.h"
#import "TeacherCheckedOutActivityViewController.h"
#import "CalendarViewController.h"
#import "GroupMessageViewController.h"
#import "ChatListViewController.h"
#import "TeacherNotificationViewController.h"
#import "TeacherSFOHomeTableViewCell.h"

#import "SFOItemViewController.h"
#import "NotArrivedItemViewController.h"
#import "CheckedOutItemViewController.h"
#import "ActivitiesItemViewController.h"

#import "SelectDialog.h"
#import "TeacherUser.h"
#import "TeacherConstant.h"

@interface TeacherSFOHomePageViewController ()

@property SelectDialog* checkedSelectdlg;
@end

@implementation TeacherSFOHomePageViewController
{
    TeacherUser *userObj;
    NSMutableArray *arrStudent;
    NSMutableArray *arrNotArrived;
    NSMutableArray *arrCheckedout;
    NSMutableArray *arrActivity;
}
- (void)viewDidLoad
{
    userObj = [[TeacherUser alloc] init];
    arrStudent = [[NSMutableArray alloc] init];
    arrNotArrived = [[NSMutableArray alloc] init];
    arrCheckedout = [[NSMutableArray alloc] init];
    arrActivity = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
	[self setNavigation];
	[self setUI];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getStudentList];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setNavigation {
	
	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"SFO_TITLE_HOME"] WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];
	
	//UIBarButtonItem *btnSearchItem = [BaseViewController getRightButtonWithSel:@selector(onTouchedSearch:) addTarget:self icon:@"search"];
	UIBarButtonItem *btnCalendarItem = [BaseViewController getRightButtonWithSel:@selector(onTouchedCalendar:) addTarget:self icon:@"calendar"];
	UIBarButtonItem *btnBellItem = [BaseViewController getBadgeRightButtonWithSel:@selector(onTouchedBell:) addTarget:self icon:@"bell"];
	btnBellItem.badgeValue = @"0";
	
	//[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnSearchItem, btnCalendarItem, btnBellItem, nil]];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnCalendarItem, btnBellItem, nil]];

	self.bottomView.backgroundColor = BOTTOM_BAR_COLOR_BLUE;
}

- (void)setUI
{
	self.checkInButton.layer.cornerRadius = 10.0f;
	self.checkOutButton.layer.cornerRadius = 10.0f;
	
	[self.oneMsgButton setBadgeBackgroundColor:[UIColor redColor]];
	[self.groupMsgButton setBadgeBackgroundColor:[UIColor redColor]];
	[self.activitiesButton setBadgeBackgroundColor:[UIColor redColor]];
	if (IS_IPAD) {
		[self.oneMsgButton setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
		[self.groupMsgButton setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
		[self.activitiesButton setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];

	}
	else {
		[self.oneMsgButton setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
		[self.groupMsgButton setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
		[self.activitiesButton setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
	}
	
    self.oneMsgButton.badgeString = @"0";
    self.groupMsgButton.badgeString = @"0";
    self.activitiesButton.badgeString = @"0";
    
	self.oneMsgButton.contentMode = UIViewContentModeCenter;
	self.groupMsgButton.contentMode = UIViewContentModeCenter;
	self.activitiesButton.contentMode = UIViewContentModeCenter;
	
	self.oneMsgLabel.textColor = TEXT_COLOR_CYNA;
	self.groupMsgLabel.textColor = TEXT_COLOR_LIGHT_GREEN;
	self.activitiesLabel.textColor = TEXT_COLOR_LIGHT_YELLOW;
	
	self.oneMsgLabel.font = FONT_16_SEMIBOLD;
	self.groupMsgLabel.font = FONT_16_SEMIBOLD;
	self.activitiesLabel.font = FONT_16_SEMIBOLD;
	
	self.oneMsgLabel.text = [GeneralUtil getLocalizedText:@"BTN_MESSAGE_TITLE"];
	self.groupMsgLabel.text = [GeneralUtil getLocalizedText:@"BTN_GROUP_MESSAGE_TITLE"];
	self.activitiesLabel.text = [GeneralUtil getLocalizedText:@"BTN_ACTIVITIES_TITLE"];
	
	self.sfoTableView.delegate = self;
	self.sfoTableView.dataSource = self;
	
	self.checkedSelectdlg = nil;
}

- (void)showCheckedSelectDialog:(BOOL)isIn
{
	CGRect viewBounds = self.view.bounds;
	self.checkedSelectdlg = [[[NSBundle mainBundle] loadNibNamed:@"SelectDialog" owner:self options:nil] objectAtIndex:0];
	self.checkedSelectdlg.frame = viewBounds;
	self.checkedSelectdlg.dlgView.layer.cornerRadius = 15.0f;
	
	self.checkedSelectdlg.activityButton.titleLabel.font = FONT_18_BOLD;
	self.checkedSelectdlg.sfoButton.titleLabel.font = FONT_18_BOLD;
	self.checkedSelectdlg.titleLabel.font = FONT_22_BOLD;
	self.checkedSelectdlg.titleLabel.textColor = TEXT_COLOR_DARK_BLUE;
	
	self.checkedSelectdlg.sfoButton.layer.cornerRadius = 10.0f;
	self.checkedSelectdlg.activityButton.layer.cornerRadius = 10.0f;
	self.checkedSelectdlg.isCheckedIn = isIn;
	
	if (isIn) {
		self.checkedSelectdlg.titleLabel.text = [GeneralUtil getLocalizedText:@"TITLE_CHECKED_IN"];

		[self.checkedSelectdlg.sfoButton setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
		[self.checkedSelectdlg.sfoButton setBackgroundColor:TEXT_COLOR_CYNA];
	}
	else {
		self.checkedSelectdlg.titleLabel.text = [GeneralUtil getLocalizedText:@"TITLE_CHECKED_OUT"];
		[self.checkedSelectdlg.sfoButton setTitleColor:TEXT_COLOR_DARK_BLUE forState:UIControlStateNormal];
		[self.checkedSelectdlg.sfoButton setBackgroundColor:TEXT_COLOR_YELLOW];
	}
	
	[self.checkedSelectdlg.sfoButton addTarget:self action:@selector(onTouchedCheckedSfo:) forControlEvents:UIControlEventTouchUpInside];
	[self.checkedSelectdlg.activityButton addTarget:self action:@selector(onTouchedCheckedActivity:) forControlEvents:UIControlEventTouchUpInside];
	[self.checkedSelectdlg.closeButton addTarget:self action:@selector(onTouchedCloseSelectDlg:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:self.checkedSelectdlg];
}

- (void)onTouchedCheckedSfo:(id)sender
{
	if (self.checkedSelectdlg.isCheckedIn) {
		TeacherCheckedInViewController *vc = [[TeacherCheckedInViewController alloc] initWithNibName:@"TeacherCheckedInViewController" bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		TeacherCheckedOutViewController *vc = [[TeacherCheckedOutViewController alloc] initWithNibName:@"TeacherCheckedOutViewController" bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
	}

	[self.checkedSelectdlg removeFromSuperview];
	self.checkedSelectdlg = nil;
}

- (void)onTouchedCheckedActivity:(id)sender
{
	if (self.checkedSelectdlg.isCheckedIn) {
        ActivitiesViewController *vc = [[ActivitiesViewController alloc] initWithNibName:@"ActivitiesItemViewController" bundle:nil];
        vc.isTeacher = YES;
        vc.activityStatus = ACTIVITY_CHECKED;
        vc.bCheckedIn = TRUE;
        [self.navigationController pushViewController:vc animated:YES];
	} else {
        TeacherCheckedOutActivityViewController *vc = [[TeacherCheckedOutActivityViewController alloc] initWithNibName:@"TeacherCheckedOutActivityViewController" bundle:nil];
        vc.isTeacher = YES;
        [self.navigationController pushViewController:vc animated:YES];
	}
	
    [self.checkedSelectdlg removeFromSuperview];
	self.checkedSelectdlg = nil;
}

- (void)onTouchedCloseSelectDlg:(id)sender
{
	if (self.checkedSelectdlg) {
		[self.checkedSelectdlg removeFromSuperview];
		self.checkedSelectdlg = nil;
	}
}


- (void)onTouchedBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)onTouchedSearch:(id)sender
{
	
}

- (void)onTouchedCalendar:(id)sender
{
	CalendarViewController *vc = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchedBell:(id)sender
{
	TeacherNotificationViewController *vc = [[TeacherNotificationViewController alloc] initWithNibName:@"TeacherNotificationViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchedCheckIn:(id)sender {

	
	[self showCheckedSelectDialog:YES];
}

- (IBAction)onTouchedCheckOut:(id)sender {
	
	[self showCheckedSelectDialog:NO];
}


- (IBAction)onTouchedOneMessage:(id)sender {
	ChatListViewController * vc = [[ChatListViewController alloc] initWithNibName:@"ChatListViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
	
	[GeneralUtil setUserPreference:key_chat_badge value:@"0"];
	
	[appDelegate.xmppHelper clearBadgeForUser];
}


- (IBAction)onTouchedGroupMessage:(id)sender {
	GroupMessageViewController * vc = [[GroupMessageViewController alloc] initWithNibName:@"GroupMessageViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)onTouchedActivities:(id)sender {
	ActivitiesViewController *evc = [[ActivitiesViewController alloc] initWithNibName:@"ActivitiesViewController" bundle:nil];
    evc.isTeacher = YES;
    evc.activityStatus = ACTIVITY_DETAIL;
	[self.navigationController pushViewController:evc animated:YES];
}


#pragma UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return arrStudant.count;
	return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//return UITableViewAutomaticDimension;
	if (IS_IPAD) {
		return 170;
	}
	else {
		return 140;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"TeacherSFOHomeTableViewCell";
	
	TeacherSFOHomeTableViewCell *cell = (TeacherSFOHomeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TeacherSFOHomeTableViewCell" owner:self options:nil];
		cell=[nib objectAtIndex:0];
		cell.backgroundColor = [UIColor clearColor];
		
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

    cell.nameLabel.text = @"";
    cell.statusLabel.text = @"";
	if(indexPath.row == 0)
    {
        if(arrStudent.count > 0)
        {
            NSDictionary* one = [arrStudent objectAtIndex:0];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [one objectForKey:@"student_name"], [one objectForKey:@"class_name"]];
            if([one objectForKey:@"check_out_rule_type"] != nil)
            {
                int ruleType = [[one objectForKey:@"check_out_rule_type"] intValue];
                NSString* time = [one objectForKey:@"sco_time"];
                
                if ( time == nil || time == (id)[NSNull null])
                    time = @"17:30";
                
                if(ruleType == 0)
                {
                    cell.statusLabel.text = [NSString stringWithFormat:@"Take Bus at (%@)", time];
                }else if(ruleType == 1)
                {
                    cell.statusLabel.text = [NSString stringWithFormat:@"Parents (%@)", time];
                }else if(ruleType == 2)
                {
                    cell.statusLabel.text = [NSString stringWithFormat:@"Friends (%@)", time];
                }
            }
        }
        [cell setSFOType:SFO_CHECKEDIN];
    }else if(indexPath.row == 1)
    {
        if(arrNotArrived.count > 0)
        {
            NSDictionary* one = [arrNotArrived objectAtIndex:0];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [one objectForKey:@"student_name"], [one objectForKey:@"class_name"]];
        }
        [cell setSFOType:NOT_ARRIVED];
    }else if(indexPath.row == 2)
    {
        if(arrCheckedout.count > 0)
        {
            NSDictionary* one = [arrCheckedout objectAtIndex:0];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [one objectForKey:@"student_name"], [one objectForKey:@"class_name"]];
            if([one objectForKey:@"sfo_subtype"] != nil)
            {
                int ruleType = [[one objectForKey:@"sfo_subtype"] intValue];
                NSString* time = [one objectForKey:@"sco_time"];
                
                if ( time == nil || time == (id)[NSNull null])
                    time = @"17:30";
                
                if(ruleType == 0)
                {
                    cell.statusLabel.text = [NSString stringWithFormat:@"Take Bus at (%@)", time];
                }else if(ruleType == 1)
                {
                    cell.statusLabel.text = [NSString stringWithFormat:@"Parents (%@)", time];
                }else if(ruleType == 2)
                {
                    cell.statusLabel.text = [NSString stringWithFormat:@"Friends (%@)", time];
                }
            }
        }
        [cell setSFOType:CHECKEDOUT];
    }
    else if(indexPath.row == 3)
    {
        if(arrActivity.count > 0)
        {
            NSDictionary* one = [arrActivity objectAtIndex:0];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [one objectForKey:@"student_name"], [one objectForKey:@"class_name"]];
        }
        [cell setSFOType:ACTIVITY_CHECKEDIN];
    }
    
	[BaseViewController setRoudRectImage:cell.profileImageView];
	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.row) {
		case 0:
		{
			SFOItemViewController *vc = [[SFOItemViewController alloc] initWithNibName:@"SFOItemViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 1:
		{
			NotArrivedItemViewController *vc = [[NotArrivedItemViewController alloc] initWithNibName:@"NotArrivedItemViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 2:
		{
			CheckedOutItemViewController *vc = [[CheckedOutItemViewController alloc] initWithNibName:@"CheckedOutItemViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 3:
		{
            ActivitiesViewController *evc = [[ActivitiesViewController alloc] initWithNibName:@"ActivitiesViewController" bundle:nil];
            evc.isTeacher = YES;
            evc.activityStatus = ACTIVITY_ADD;
            [self.navigationController pushViewController:evc animated:YES];
		}
			break;
		default:
			break;
	}
}
-(void)getStudentList {
    
    [userObj getStudentsList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrStudent removeAllObjects];
            [arrActivity removeAllObjects];
            [arrCheckedout removeAllObjects];
            [arrNotArrived removeAllObjects];
            
            arrStudent = (NSMutableArray *)[dicRes valueForKey:@"students"];
            for(NSDictionary* one in arrStudent)
            {
                if([one valueForKey:@"sfo_status"] == [NSNull null])
                    [arrNotArrived addObject:one];
                else if([[one valueForKey:@"sfo_status"] intValue] == ACTIVITY_CHECKEDIN)
                    [arrActivity addObject:one];
                else if([[one valueForKey:@"sfo_status"] intValue] == NOT_ARRIVED)
                    [arrNotArrived addObject:one];
                else if([[one valueForKey:@"sfo_status"] intValue] == CHECKEDOUT)
                    [arrCheckedout addObject:one];
            }
            
            [self.sfoTableView  reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}


@end
