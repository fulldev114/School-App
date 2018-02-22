//
//  CheckInViewController.m
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "TeacherCheckedOutActivityViewController.h"
#import "BaseViewController.h"
#import "TeacherUser.h"
#import "TeacherNIDropDown.h"
#import "CheckedOutTableViewCell.h"
#import "CheckedInTableViewCell.h"
#import "TeacherConstant.h"

@interface TeacherCheckedOutActivityViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, TeacherNIDropDownDelegate>
{
	TeacherUser *userObj;
    ParentUser *userObjParent;
    
    NSMutableArray *arrStudent;
    NSMutableArray *arrOtherStudents;
    NSMutableArray *arrCheckedoutStudents;

	NSMutableArray *arrClass;
	NSMutableArray *arrFilterStud;
	NSMutableArray *arrFilterStudSearch;
	NSMutableArray *arrFilterUpdatedStud;
    
    TeacherNIDropDown *dropDown;
    NSMutableArray *arrSelectedClass;
    
    NSMutableDictionary *dicActivity;

}

@end

@implementation TeacherCheckedOutActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	userObj = [[TeacherUser alloc] init];
    userObjParent = [[ParentUser alloc] init];

    arrStudent = [[NSMutableArray alloc] init];
    arrCheckedoutStudents = [[NSMutableArray alloc] init];
    arrOtherStudents = [[NSMutableArray alloc] init];
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];
    arrFilterUpdatedStud = [[NSMutableArray alloc] init];
    arrClass = [[NSMutableArray alloc] init];
	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_CHECKED_OUT_ACTIVITY"] titleColor:TEXT_COLOR_LIGHT_YELLOW WithSel:@selector(onTouchedBack:)];
	
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
    
    [self getCheckedInStudentsList:self.activityID];
    
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
	
	//return UITableViewAutomaticDimension;
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
	
	//
	//	NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
	//
	//	cell.lblStudantName.text = [dicStudantDetail valueForKey:@"name"];
	//	cell.lblClassName.text = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"LBL_CLS_NAME_TITLE"],[dicStudantDetail valueForKey:@"class_name"]];
	//
	
	//[cell.profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    CGFloat imageRadius = 50/2;
    if (IS_IPAD) {
        imageRadius = 65/2;
    }
    
    
    NSDictionary* one = [arrFilterStud objectAtIndex:indexPath.row];
    if ([one valueForKey:@"sfo_status"] == [NSNull null])
        return cell;
    
    int isCheckedOut = [[one valueForKey:@"sfo_status"] intValue] == SFO_CHECKEDIN ;
    if(isCheckedOut)
    {
        cell.backgroundColor = TEXT_COLOR_GREEN;
        [cell.checkedInNameLabel setTextColor:TEXT_COLOR_WHITE];
        [cell.checkedInStatusLabel setTextColor:TEXT_COLOR_WHITE];
        cell.checkedInNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [one valueForKey:@"student_name"], [one valueForKey:@"class_name"]] ;
        cell.nameLabel.hidden = YES;
        cell.checkedInView.hidden = NO;
        
        NSString *time = [one valueForKey:@"aco_time"];

        if ([time isEqual:[NSNull null]])
             time = @"16:30";
        
        cell.checkedInStatusLabel.text = [NSString stringWithFormat:@"Checked-out, %@", [one valueForKey:@"aco_time"]];
        [BaseViewController setRoudRectImage:cell.profileImageView radius:imageRadius borderColor:TEXT_COLOR_WHITE];
    }else
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.checkedInView.hidden = YES;
        cell.nameLabel.hidden = NO;
        [cell.nameLabel setTextColor:TEXT_COLOR_YELLOW];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[one valueForKey:@"student_name"],  [one valueForKey:@"class_name"]];
        [BaseViewController setRoudRectImage:cell.profileImageView radius:imageRadius borderColor:TEXT_COLOR_LIGHT_YELLOW];
    }   
	
	/*
	//For UI Testing
	if (indexPath.row == 0 || indexPath.row == 1) {
		cell.backgroundColor = TEXT_COLOR_GREEN;
		cell.nameLabel.hidden = YES;
		cell.checkedInView.hidden = NO;
		
		[BaseViewController setRoudRectImage:cell.profileImageView radius:imageRadius borderColor:TEXT_COLOR_WHITE];
		
	} else {
		cell.backgroundColor = [UIColor clearColor];
		cell.nameLabel.hidden = NO;
		cell.nameLabel.textColor = TEXT_COLOR_LIGHT_YELLOW;
		cell.checkedInView.hidden = YES;
		
		[BaseViewController setRoudRectImage:cell.profileImageView radius:imageRadius borderColor:TEXT_COLOR_LIGHT_YELLOW];
	}
	*/
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableDictionary *dic = [arrFilterStud objectAtIndex:indexPath.row];
    
    if ([dic valueForKey:@"sfo_status"] == [NSNull null])
        return;
    
    if ([[dic valueForKey:@"sfo_status"] intValue] == ACTIVITY_CHECKEDIN)
    //{
      //  [self setCheckedInStudentByTeacher:indexPath.row];
    //}
    //else
    {
        [self setCheckedOutStudentByTeacher:indexPath.row];
    }
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setCheckedOutStudentByTeacher:(NSInteger) index {
    
    NSMutableDictionary *dic = [arrFilterStud objectAtIndex:index];
    NSString *activityID = [dic valueForKey:@"activity_id"];
    NSString *activityName = [dicActivity valueForKey:activityID];
    
    
    [userObj checkOutStudent:[GeneralUtil getUserPreference:key_teacherId] studentId:[dic valueForKey:@"student_id"] activityId:activityID checkOutType:@"" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
            {
                /*
                [dic setValue:[NSString stringWithFormat:@"%d", SFO_CHECKEDIN] forKey:@"sfo_status"];

                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"hh:mm";
                [dic setValue:[formatter stringFromDate:date] forKey:@"aco_time"];
                
                NSInteger index = [arrFilterStudSearch indexOfObject:dic];
                [arrFilterStudSearch replaceObjectAtIndex:index withObject:dic];
                
                [self.studentTableView reloadData];
                 */
                
                NSString *msg = [NSString stringWithFormat:@"You have checked out from activity \"%@\"", activityName];
                
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

-(void)setCheckedInStudentByTeacher:(NSInteger) index {
    
    NSMutableDictionary *dic = [arrFilterStud objectAtIndex:index];

    [userObj checkInStudent:[GeneralUtil getUserPreference:key_teacherId] studentId:[dic valueForKey:@"student_id"] activityId:self.activityID :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
                               
        NSDictionary *dicRes = (NSDictionary *)resObj;

        if (dicRes != nil) {
           if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
           {
               [dic setValue:[NSString stringWithFormat:@"%d", ACTIVITY_CHECKEDIN] forKey:@"sfo_status"];
               NSInteger index = [arrFilterStudSearch indexOfObject:dic];
               [arrFilterStudSearch replaceObjectAtIndex:index withObject:dic];
               
               [self.studentTableView reloadData];
           }
           else
               NSLog(@"Request Fail...");
           
        }
        else {
           NSLog(@"Request Fail...");
        }
    }];

}

-(void)getCheckedInStudentsList:(NSString *)activityId {
    
    [userObj getStudentsList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrFilterStud removeAllObjects];
            [arrFilterStudSearch removeAllObjects];
            [arrClass removeAllObjects];

            arrStudent = [[NSMutableArray alloc] init];

            NSMutableArray *arrData = (NSMutableArray *)[dicRes valueForKey:@"students"];
            
            for(NSDictionary* one in arrData)
            {
                if ([one valueForKey:@"sfo_status"] == [NSNull null])
                    continue;
                
                int status = [[one valueForKey:@"sfo_status"] intValue];

                if ( status == ACTIVITY_CHECKEDIN)
                    [arrStudent addObject:(NSMutableDictionary*)one];
            }
            
            [arrFilterStudSearch addObjectsFromArray:arrStudent];
            [arrFilterStud addObjectsFromArray:arrFilterStudSearch];

            //[self getCheckedOutStudentsList:self.activityID];
            [self.studentTableView reloadData];

            [self getTeacherClass];

        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)getCheckedOutStudentsList:(NSString *)activityId {
    
    [userObj getCheckedOutStudentsList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" activityId:@"" :^(NSObject *resObj) {
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {

            [arrFilterUpdatedStud removeAllObjects];
            
            NSMutableArray *arrData = (NSMutableArray *)[dicRes valueForKey:@"students"];
            
            for (NSDictionary *one in arrData)
            {
                [arrStudent addObject:one];
                [arrFilterStudSearch addObject:one];
            }
            
            [arrFilterStud addObjectsFromArray:arrFilterStudSearch];

        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}


-(void)getTeacherClass {
    
    [GeneralUtil hideProgress];
    arrClass = [NSMutableArray arrayWithArray:[GeneralUtil getClassFromStudents:arrStudent]];
    [self getActivities];

}

-(void)getActivities {
    RequestComplitionBlock block = ^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            dicActivity = [[NSMutableDictionary alloc] init];
            NSMutableArray *arrActivities = (NSMutableArray *)[dicRes valueForKey:@"activities"];
            for (int i = 0; i < arrActivities.count; i++)
            {
                NSDictionary *dic = arrActivities[i];
                [dicActivity setValue:[dic valueForKey:@"activity_name"] forKey:[dic valueForKey:@"activity_id"]];
            }
            
        }
        else {
            NSLog(@"Request Fail...");
        }
    };
    
    NSString *keyId;
    if (!self.isTeacher)
    {
        keyId = [GeneralUtil getUserPreference:key_parentIdSave];
        [userObjParent getActivities:keyId :block];
    }
    else
    {
        keyId = [GeneralUtil getUserPreference:key_teacherId];
        [userObj getActivities:keyId :block];
    }
    
}


@end
