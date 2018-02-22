//
//  CheckInViewController.m
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "TeacherCheckedInViewController.h"
#import "BaseViewController.h"
#import "TeacherNIDropDown.h"
#import "TeacherUser.h"
#import "CheckedInTableViewCell.h"
#import "TeacherConstant.h"

@interface TeacherCheckedInViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, TeacherNIDropDownDelegate>
{
	TeacherUser *userObj;
	NSMutableArray *arrStudent;
	NSMutableArray *arrClass;
	NSMutableArray *arrFilterStud;
	NSMutableArray *arrFilterStudSearch;
	NSMutableArray *arrFilterUpdatedStud;
	
	TeacherNIDropDown *dropDown;
	
    NSMutableArray *arrSelectedClass;

}

@end

@implementation TeacherCheckedInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	userObj = [[TeacherUser alloc] init];

    arrStudent = [[NSMutableArray alloc] init];
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];
    arrFilterUpdatedStud = [[NSMutableArray alloc] init];
    arrClass = [[NSMutableArray alloc] init];
    
    NSString *title;
    title = [GeneralUtil getLocalizedText:@"TITLE_CHECKED_IN"];
    
	[BaseViewController setNavigationBack:self title:title WithSel:@selector(onTouchedBack:)];
	
	
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
    
    [self getCheckedInStudentsList:@""];

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
		
        //dropDown = [[TeacherNIDropDown alloc]showDropDown:sender :&f :(NSArray *)arrClass :nil :@"down"];
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

	//
	//	NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
	//
	//	cell.lblStudantName.text = [dicStudantDetail valueForKey:@"name"];
	//	cell.lblClassName.text = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"LBL_CLS_NAME_TITLE"],[dicStudantDetail valueForKey:@"class_name"]];
	//
	
	//[cell.profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];

    
    NSDictionary* one = [arrFilterStud objectAtIndex:indexPath.row];
    
    int status = -1;
    
    if ([one valueForKey:@"sfo_status"] == [NSNull null])
        status = NOT_ARRIVED;
    else
        status = [[one valueForKey:@"sfo_status"] intValue];
    
    if(status == SFO_CHECKEDIN || status == ACTIVITY_CHECKEDIN)
    {
        cell.backgroundColor = TEXT_COLOR_GREEN;
        cell.checkedInNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [one valueForKey:@"student_name"], [one valueForKey:@"class_name"]] ;
        cell.nameLabel.hidden = YES;
        cell.checkedInView.hidden = NO;
        cell.checkedInStatusLabel.text = [NSString stringWithFormat:@"Checked-in, %@", [one valueForKey:@"sci_time"]];
        
    }else
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.checkedInView.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[one valueForKey:@"student_name"],  [one valueForKey:@"class_name"]];
    }
    
    [BaseViewController setRoudRectImage:cell.profileImageView];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [self.searchTextField resignFirstResponder];
    NSDictionary *dicStudentDetail = [arrFilterStud objectAtIndex:indexPath.row];
    
    int status = -1;
    if ([dicStudentDetail valueForKey:@"sfo_status"] == [NSNull null])
        status = NOT_ARRIVED;
    else
        status = [[dicStudentDetail valueForKey:@"sfo_status"] intValue];
    if(status == SFO_CHECKEDIN || status == ACTIVITY_CHECKEDIN)
    {
        return;
    }
    NSString *studentId = [dicStudentDetail valueForKey:@"student_id"];
    [self setCheckedInStudentByTeacher:studentId activityId:@""];
    
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setCheckedInStudentByTeacher:(NSString *)studentId activityId:(NSString *) activityId {
    
    [userObj checkInStudent:[GeneralUtil getUserPreference:key_teacherId] studentId:studentId activityId:@"" :^(NSObject *resObj) {
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
            {
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

-(void)getCheckedInStudentsList:(NSString *)activityId {

    [userObj getStudentsList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrFilterStud removeAllObjects];
            [arrFilterStudSearch removeAllObjects];
            [arrClass removeAllObjects];
            [arrFilterUpdatedStud removeAllObjects];
            
            arrStudent = [[NSMutableArray alloc] init];

            NSMutableArray *arrData = (NSMutableArray *)[dicRes valueForKey:@"students"];
            for(NSDictionary* one in arrData)
            {
                //if ([one valueForKey:@"sfo_status"] != [NSNull null])
                    [arrStudent addObject:(NSMutableArray*)one];

            }
            
            [arrFilterStudSearch addObjectsFromArray:arrStudent];
            [arrFilterStud addObjectsFromArray:arrFilterStudSearch];
            
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
                
                arrSelectedClass = [NSMutableArray arrayWithArray:arrClass];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }]*/
}


@end
