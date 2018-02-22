//
//  CheckInViewController.m
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ParentCheckedInViewController.h"
#import "BaseViewController.h"
#import "TeacherNIDropDown.h"
#import "TeacherUser.h"
#import "TeacherConstant.h"
#import "CheckedInTableViewCell.h"

@interface ParentCheckedInViewController () <UITableViewDataSource,UITableViewDelegate>
{
    ParentUser *userObj;
}

@end

@implementation ParentCheckedInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    userObj = [[ParentUser alloc] init];
    
	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_CHECKED_IN"] titleColor:TEXT_COLOR_GREEN WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];
	
	self.studentTableView.delegate = self;
	self.studentTableView.dataSource = self;
	
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
    if (_studentsData != nil)
        return _studentsData.count;
    
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (IS_IPAD) {
		return 85;
	}
	else {
		return 70;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *simpleTableIdentifier = @"CheckedInTableViewCell";
	
	CheckedInTableViewCell *cell = (CheckedInTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

	if (cell == nil) {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"CheckedInTableViewCell" owner:self options:nil];
		cell=[nib objectAtIndex:0];
		cell.backgroundColor = [UIColor clearColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	cell.cellType = PARENT;
    NSDictionary *studentData = [_studentsData objectAtIndex:indexPath.row];
    
    int status = NOT_ARRIVED;
    if ( [studentData valueForKey:@"sfo_status"] == [NSNull null])
        status = NOT_ARRIVED;
    else
        status = [[studentData valueForKey:@"sfo_status"] intValue];
    
    if(status == SFO_CHECKEDIN || status == ACTIVITY_CHECKEDIN)
    {
        [cell setCheckedInStatus:[NSString stringWithFormat:@"%@(%@)", [studentData valueForKey:@"student_name"], [studentData valueForKey:@"class_name"]]
                          status:[NSString stringWithFormat:@"(%@)", [studentData valueForKey:@"sci_time"]]];
    }
    else
        [cell setStudentName:[NSString stringWithFormat:@"%@(%@)", [studentData valueForKey:@"student_name"], [studentData valueForKey:@"class_name"]]];        
    
    if (![[studentData valueForKey:@"image"] isEqualToString:@""])
    {
        [cell.profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[studentData valueForKey:@"image"]]]
                              placeholderImage:[UIImage imageNamed:@"profile.png"]];
    }
    
	[BaseViewController setRoudRectImage:cell.profileImageView];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dicStudentDetail = [_studentsData objectAtIndex:indexPath.row];
    
    if ([dicStudentDetail valueForKey:@"sfo_status"] != [NSNull null])
    {
        int status = [[dicStudentDetail valueForKey:@"sfo_status"] intValue];
        if(status == SFO_CHECKEDIN || status == ACTIVITY_CHECKEDIN)
        {
            return;
        }
    }
    
    [self setCheckedInStudentByTeacher:indexPath.row];
    
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setCheckedInStudentByTeacher:(NSInteger)index {
    
    NSDictionary *dicStudentDetail = [_studentsData objectAtIndex:index];

    NSString *studentId = [dicStudentDetail valueForKey:@"student_id"];

    [userObj checkInStudent:[GeneralUtil getUserPreference:key_parentIdSave] studentId:studentId activityId:@"" :^(NSObject *resObj) {
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
            {
                [dicStudentDetail setValue:@"1" forKey:@"sfo_status"];
                
                NSString *msg = [NSString stringWithFormat:@"You are logged in SFO."];
                
                CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:msg WithDelegate:self];
                [alertView show];
                
                
            }
            else
                NSLog(@"Request Fail...");
            
        }
        else {
            NSLog(@"Request Fail...");
        }
        
    }];
}

@end
