//
//  ParentSFOHomePageViewController.m
//  CSLink
//
//  Created by adamlucas on 5/30/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ParentSFOHomePageViewController.h"
#import "BaseViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "ActivitiesViewController.h"
#import "ParentCheckedInViewController.h"
#import "ParentCheckedOutViewController.h"
#import "CalendarViewController.h"
#import "NotArrivedItemViewController.h"
#import "CheckedOutItemViewController.h"
#import "ActivitiesItemViewController.h"
#import "ParentGroupMessageViewController.h"
#import "ParentChatListViewController.h"
#import "ParentEditCheckedOutViewController.h"
#import "ProfileDetailViewController.h"
#import "TeacherUser.h"

@interface ParentSFOHomePageViewController ()
{
    TeacherUser *userObj;
    int currentStudentIndex;
}
@end

@implementation ParentSFOHomePageViewController

- (void)viewDidLoad
{
    userObj = [[TeacherUser alloc] init];
    currentStudentIndex = 0;
    
	[super viewDidLoad];
	[self setNavigation];
	[self setUI];
    [self refreshData];
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

	
	//[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnSearchItem, btnCalendarItem, nil]];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnCalendarItem, nil]];

	self.bottomView.backgroundColor = BOTTOM_BAR_COLOR_BLUE;
}

- (void)refreshData
{
    if (!_studentsData.count)
        return;
    
    NSDictionary *studentData = [_studentsData objectAtIndex:currentStudentIndex];
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",[studentData valueForKey:@"student_name"], [studentData valueForKey:@"class_name"]];
    
    if ([studentData valueForKey:@"sci_time"] == [NSNull null])
        self.checkedInStatusLabel.text = [GeneralUtil getLocalizedText:@"TEXT_NONE"];
    else
        self.checkedInStatusLabel.text = [NSString stringWithFormat:@"(%@)", [studentData valueForKey:@"sci_time"]];
    
    if ([studentData valueForKey:@"na_time"] == [NSNull null])
        self.notArrivedLabel.text = [GeneralUtil getLocalizedText:@"TEXT_NONE"];
    else
        self.notArrivedLabel.text = [NSString stringWithFormat:@"(%@)", [studentData valueForKey:@"na_time"]];
    
    if ([studentData valueForKey:@"sco_time"] == [NSNull null])
        self.checkedOutLabel.text = [GeneralUtil getLocalizedText:@"TEXT_NONE"];
    else
    {
        if ([studentData valueForKey:@"sfo_subtype"] == [NSNull null])
            self.checkedOutLabel.text = [NSString stringWithFormat:@"(%@)", [studentData valueForKey:@"sco_time"]];
        else
        {
            int subType = [[studentData valueForKey:@"sfo_subtype"] intValue];
            NSString *subTypeStr;
            if (subType == 0)
                subTypeStr = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_BUS"];
            else if (subType == 1)
                subTypeStr = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_PARENT"];
            else
                subTypeStr = [GeneralUtil getLocalizedText:@"TEXT_SFO_SUBTYPE_FRIEND"];
            
            self.checkedOutLabel.text = [NSString stringWithFormat:@"%@(%@)", subTypeStr, [studentData valueForKey:@"sco_time"]];
        }
    }
    
    if ([studentData valueForKey:@"activity_name"] == [NSNull null])
        self.activitiesItemLabel.text = [GeneralUtil getLocalizedText:@"TEXT_NONE"];
    else
        self.activitiesItemLabel.text = [studentData valueForKey:@"activity_name"];
    
    if (![[studentData valueForKey:@"image"] isEqualToString:@""])
    {
        [self.profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[studentData valueForKey:@"image"]]]
                               placeholderImage:[UIImage imageNamed:@"profile.png"]];
    }
}

- (void)setUI
{
	self.checkInButton.layer.cornerRadius = 10.0f;
	self.checkOutButton.layer.cornerRadius = 10.0f;
	
	[self.oneMsgButton setBadgeBackgroundColor:[UIColor clearColor]];
	[self.groupMsgButton setBadgeBackgroundColor:[UIColor clearColor]];
	[self.activitiesButton setBadgeBackgroundColor:[UIColor clearColor]];
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
	
	//[BaseViewController setRoudRectImage:self.profileImageView];

	self.nameLabel.textColor = TEXT_COLOR_CYNA;
	self.nameLabel.font = FONT_18_BOLD;
	self.nameLabel.text = @"";
    
	self.checkedInStatusButton.titleLabel.text = [GeneralUtil getLocalizedText:@"TITLE_CHECKEDIN_STATUS"];
	[self.checkedInStatusButton setTitleColor:TEXT_COLOR_GREEN forState:UIControlStateNormal];
	self.checkedInStatusButton.titleLabel.font = FONT_18_BOLD;
	
	self.notArrivedButton.titleLabel.text = [GeneralUtil getLocalizedText:@"TITLE_NOT_ARRIVED_LOW"];
	[self.notArrivedButton setTitleColor:TEXT_COLOR_RED forState:UIControlStateNormal];
	self.notArrivedButton.titleLabel.font = FONT_18_BOLD;
	
	self.checkedOutButton.titleLabel.text = [GeneralUtil getLocalizedText:@"TITLE_CHECKED_OUT_LOW"];
	[self.checkedOutButton setTitleColor:TEXT_COLOR_YELLOW forState:UIControlStateNormal];
	self.checkedOutButton.titleLabel.textColor = TEXT_COLOR_YELLOW;
	self.checkedOutButton.titleLabel.font = FONT_18_BOLD;
	
	self.activitiesItemButton.titleLabel.text = [GeneralUtil getLocalizedText:@"TITLE_ACTIVITES_LOW"];
	[self.activitiesItemButton setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
	self.activitiesItemButton.titleLabel.font = FONT_18_BOLD;
	
	self.checkedInStatusLabel.font = FONT_18_REGULER;
	self.notArrivedLabel.font = FONT_18_REGULER;
	self.checkedOutLabel.font = FONT_18_REGULER;
	self.activitiesItemLabel.font = FONT_18_REGULER;

}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
	self.profileImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickProfileImage)];
    gesture.numberOfTapsRequired = 1;
    [self.profileImageView addGestureRecognizer:gesture];
    [self.profileImageView setUserInteractionEnabled:YES];
	
}

-(void)onClickProfileImage
{
    NSString *studentID = [[GeneralUtil getUserPreference:key_selectedStudant] valueForKey:@"user_id"];
    NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    [userObj getStudentDetail:studentID Language:lang :^(NSObject *resObj) {
        //    [userObj getStudentDetail:@"579" Language:lang :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([dicRes objectForKey:@"flag"] == [NSNull null])
                return;
            
            if ([[dicRes objectForKey:@"flag"] intValue] != 1)
                return;
            
            ProfileDetailViewController *vc = [[ProfileDetailViewController alloc] initWithNibName:@"ProfileDetailViewController" bundle:nil andData:dicRes];
            [self presentPopupViewController:vc animationType:MJPopupViewAnimationFade];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (void)onTouchedBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)onTouchedSearch:(id)sender
{
	
}
- (IBAction)onTouchedEditCheckedOut:(id)sender {
    if (!_studentsData.count)
        return;
    
    NSDictionary *studentData = [_studentsData objectAtIndex:currentStudentIndex];
    NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    [userObj getStudentDetail:[studentData objectForKey:@"student_id"] Language:lang :^(NSObject *resObj) {
//    [userObj getStudentDetail:@"579" Language:lang :^(NSObject *resObj) {
    
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([dicRes objectForKey:@"flag"] == [NSNull null])
                return;
            
            if ([[dicRes objectForKey:@"flag"] intValue] != 1)
                return;
            
            ParentEditCheckedOutViewController* pvc = [[ParentEditCheckedOutViewController alloc] initWithNibName:@"ParentEditCheckedOutViewController" bundle:nil];
            pvc.studentDetail = [NSDictionary dictionaryWithDictionary:dicRes];
            [self.navigationController pushViewController:pvc animated:YES];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (void)onTouchedCalendar:(id)sender
{
	CalendarViewController *vc = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchedNext:(id)sender {
    if (currentStudentIndex == _studentsData.count - 1)
        return;
    
    currentStudentIndex++;
    [self refreshData];
}

- (IBAction)onTouchedBefore:(id)sender {
    if (currentStudentIndex == 0)
        return;
    
    currentStudentIndex--;
    [self refreshData];
}

- (IBAction)onTouchedCheckIn:(id)sender {
	ParentCheckedInViewController *vc = [[ParentCheckedInViewController alloc] initWithNibName:@"ParentCheckedInViewController" bundle:nil];
    vc.studentsData = _studentsData;
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchedCheckOut:(id)sender {
	ParentCheckedOutViewController *vc = [[ParentCheckedOutViewController alloc] initWithNibName:@"ParentCheckedOutViewController" bundle:nil];
    vc.studentsData = _studentsData;
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchedOneMessage:(id)sender {

	ParentChatListViewController * pvc = [[ParentChatListViewController alloc] initWithNibName:@"ParentChatListViewController" bundle:nil];
	[self.navigationController pushViewController:pvc animated:YES];
	
	[GeneralUtil clearBadge:[appDelegate getCurrentChildId] badgeType:key_chat_badge];
}


- (IBAction)onTouchedGroupMessage:(id)sender {
	ParentGroupMessageViewController * pvc = [[ParentGroupMessageViewController alloc] initWithNibName:@"ParentGroupMessageViewController" bundle:nil];
	[self.navigationController pushViewController:pvc animated:YES];
	
	[GeneralUtil clearBadge:[appDelegate getCurrentChildId] badgeType:key_abi_badge];

}


- (IBAction)onTouchedActivities:(id)sender {
	ActivitiesViewController *evc = [[ActivitiesViewController alloc] initWithNibName:@"ActivitiesViewController" bundle:nil];
    evc.isTeacher = NO;
    evc.activityStatus = ACTIVITY_DETAIL;
	[self.navigationController pushViewController:evc animated:YES];
}

@end
