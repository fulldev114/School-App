//
//  CheckInViewController.m
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "TeacherCheckedInActivityViewController.h"
#import "BaseViewController.h"
#import "TeacherNIDropDown.h"
#import "TeacherUser.h"
#import "CheckedInTableViewCell.h"
#import "TeacherConstant.h"

@interface TeacherCheckedInActivityViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, TeacherNIDropDownDelegate>
{
	TeacherUser *userObj;
    NSMutableArray *arrStudent;
    NSMutableArray *arrOtherStudents;
    NSMutableArray *arrCheckedinStudents;
	NSMutableArray *arrClass;
	NSMutableArray *arrFilterStud;
	NSMutableArray *arrFilterStudSearch;
	NSMutableArray *arrFilterUpdatedStud;
	
	TeacherNIDropDown *dropDown;
    NSMutableArray *arrSelectedClass;

}

@end

@implementation TeacherCheckedInActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	userObj = [[TeacherUser alloc] init];

    arrStudent = [[NSMutableArray alloc] init];
    arrCheckedinStudents = [[NSMutableArray alloc] init];
    arrOtherStudents = [[NSMutableArray alloc] init];
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];
    arrFilterUpdatedStud = [[NSMutableArray alloc] init];
    arrClass = [[NSMutableArray alloc] init];
    
    NSString *title;
    if (self.activityStatus == ACTIVITY_ADD)
        title = [GeneralUtil getLocalizedText:@"TITLE_ADD_ACTIVITY"];
    else
        title = [GeneralUtil getLocalizedText:@"TITLE_CHECKED_IN_ACTIVITY"];
    
	[BaseViewController setNavigationBack:self title:title titleColor:TEXT_COLOR_LIGHT_YELLOW WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];
	CGFloat screenWidth = [GeneralUtil screenWidth];
	[BaseViewController getDropDownBtn:self.selectClassButton withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_CLASS"] width:screenWidth - 30];
	
	[BaseViewController getRoundRectTextField:self.searchTextField withIcon:@"search"];
	//Intent!
	self.searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.searchTextField.frame.size.height)];
	self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
	
	self.studentTableView.delegate = self;
	self.studentTableView.dataSource = self;
	
	self.searchTextField.delegate = self;
	
	[self.selectClassButton setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
	
	self.searchTextField.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH_STUDENTS"];
	self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	
	[self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getStudentList];
    //[self getTeacherClass];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTouchedBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTouchedSelectClass:(id)sender {
	
	if(dropDown == nil) {
        CGFloat f = (arrClass.count + 1) * 40;
		
		if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
			f = [[UIScreen mainScreen] bounds].size.height / 2;
		}
		
        dropDown = [[TeacherNIDropDown alloc]showDropDown:sender :&f :(NSArray *)arrClass :nil :@"down" withSelect:NO withSelectedData:(NSArray *)arrSelectedClass];
		dropDown.delegate = self;
	}
	else {
		[dropDown hideDropDown:sender];
		dropDown = nil;
	}
}
- (void)niDropDownDelegateMethod: (TeacherNIDropDown *) sender {
		
    arrSelectedClass = [[NSMutableArray alloc] init];
    for (int i = 0; i < sender.arrSelectValue.count; i++)
    {
        NSString *index = [sender.arrSelectValue objectAtIndex:i];
        [arrSelectedClass addObject:[arrClass objectAtIndex:[index integerValue]]];
    }
    
    [arrFilterStud removeAllObjects];
	[arrFilterStudSearch removeAllObjects];
	for (NSDictionary *dicValue in arrStudent) {
		
		NSString *cid = [dicValue valueForKey:@"class_name"];
		
        for (NSString *class in arrSelectedClass)
        {
            if ([cid isEqualToString:class]) {
                [arrFilterStud addObject:dicValue];
                [arrFilterStudSearch addObject:dicValue];
                break;
            }
        }

	}
    
    [self updateSearchArray:self.searchTextField.text];
    
	[self.studentTableView reloadData];
}

-(void)textFieldDidChange:(UITextField*)textField
{
	//searchTextString = textField.text;
	[self updateSearchArray:textField.text];
}

//update seach method where the textfield acts as seach bar
-(void)updateSearchArray:(NSString *)searchTextString
{
	[arrFilterStud removeAllObjects];
	if (searchTextString.length != 0) {
		
		for ( NSDictionary* item in arrFilterStudSearch ) {
			if ([[[item objectForKey:@"student_name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
				[arrFilterStud addObject:item];
			}
		}
	}else{
		arrFilterStud = [arrFilterStudSearch mutableCopy];
	}
	
	[self.studentTableView reloadData];
}

#pragma UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return arrStudant.count;
	return arrFilterStud.count;
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
		
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    CGFloat imageRadius = 50/2;
    if (IS_IPAD) {
        imageRadius = 65/2;
    }
    NSDictionary* one = [arrFilterStud objectAtIndex:indexPath.row];
    if ([one valueForKey:@"sfo_status"] == [NSNull null])
        return cell;
    
    BOOL isCheckedIn = [[one valueForKey:@"sfo_status"] intValue] == ACTIVITY_CHECKEDIN ;
    if(isCheckedIn)
    {
        cell.backgroundColor = TEXT_COLOR_CYNA;
        cell.checkedInNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [one valueForKey:@"student_name"], [one valueForKey:@"class_name"]] ;
        cell.nameLabel.hidden = YES;
        cell.checkedInView.hidden = NO;
        
        NSString *time = [one valueForKey:@"aci_time"];
        if (time == nil || time == (id)[NSNull null])
            time = @"9:00";
        cell.checkedInStatusLabel.text = [NSString stringWithFormat:@"Checked-in, %@", time];
        [BaseViewController setRoudRectImage:cell.profileImageView radius:imageRadius borderColor:TEXT_COLOR_WHITE];
        
    }else
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.checkedInView.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[one valueForKey:@"student_name"],  [one valueForKey:@"class_name"]];
        [BaseViewController setRoudRectImage:cell.profileImageView radius:imageRadius borderColor:TEXT_COLOR_LIGHT_YELLOW];
        
    }

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [self.searchTextField resignFirstResponder];
    NSDictionary *dicStudentDetail = [arrFilterStud objectAtIndex:indexPath.row];
    
    if ([dicStudentDetail valueForKey:@"sfo_status"] == [NSNull null])
        return;
    
    int status = [[dicStudentDetail valueForKey:@"sfo_status"] intValue];
    if(status == ACTIVITY_CHECKEDIN)
    {
        return;
    }
    NSString *studentId = [dicStudentDetail valueForKey:@"student_id"];
    [self setCheckedInStudentByTeacher:studentId activityId:self.activityId];
}
- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSArray *aryController =  [self.navigationController viewControllers];
    UIViewController *vc = [aryController objectAtIndex:aryController.count - 3];
    [self.navigationController popToViewController:vc animated:YES];
}

-(void)setCheckedInStudentByTeacher:(NSString *)studentId activityId:(NSString *) activityId {
    
    [userObj checkInStudent:[GeneralUtil getUserPreference:key_teacherId] studentId:studentId activityId:activityId :^(NSObject *resObj) {
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
            {
                if (activityId.length == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSString *msg = [NSString stringWithFormat:@"You have logged in activity \"%@\"", self.activityName];
                    
                    CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:msg WithDelegate:self];
                    [alertView show];

                   
                }
            }
            else
                NSLog(@"Request Fail...");
            
        }
        else {
            NSLog(@"Request Fail...");
        }
        
    }];
}

-(void)getStudentList {
    
    [userObj getStudentsList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrFilterStudSearch removeAllObjects];
            [arrClass removeAllObjects];
            [arrFilterUpdatedStud removeAllObjects];

            
            NSMutableArray *arrData = (NSMutableArray *)[dicRes valueForKey:@"students"];
            [arrCheckedinStudents removeAllObjects];
            [arrOtherStudents removeAllObjects];
            
            arrStudent = [[NSMutableArray alloc] init];

            for(NSDictionary* one in arrData)
            {
                if ([one valueForKey:@"sfo_status"] != [NSNull null])
                    [arrStudent addObject:one];
            }
                
            for(NSDictionary* one in arrStudent)
            {                
                int status = [[one valueForKey:@"sfo_status"] intValue];
                if( status == ACTIVITY_CHECKEDIN && [[one valueForKey:@"activity_id"] isEqualToString:self.activityId])
                    [arrCheckedinStudents addObject:one];
                else if ( status == SFO_CHECKEDIN )
                    [arrOtherStudents addObject:one];
            }
            
            [arrFilterStudSearch addObjectsFromArray:arrCheckedinStudents];
            [arrFilterStudSearch addObjectsFromArray:arrOtherStudents];
            [arrFilterStud removeAllObjects];
            [arrFilterStud addObjectsFromArray:arrFilterStudSearch];
            
            [arrStudent removeAllObjects];
            [arrStudent addObjectsFromArray:arrFilterStudSearch];
            
            [self.studentTableView  reloadData];
            
            [self getTeacherClass];

        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)getTeacherClass {
    
    [GeneralUtil hideProgress];
    arrClass = [NSMutableArray arrayWithArray:[GeneralUtil getClassFromStudents:arrStudent]];
    
    /*
    [userObj getTeacherClass:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                for (NSDictionary *dicCls in [[dicRes valueForKey:@"classes"] valueForKey:@"classes"]) {
                    
                    [arrClass addObject:[dicCls valueForKey:@"class_name"]];
                }
                
            }
            
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
     */
}


@end
