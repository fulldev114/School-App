//
//  CheckInViewController.m
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "TeacherCheckedOutViewController.h"
#import "BaseViewController.h"
#import "TeacherUser.h"
#import "CheckedOutTableViewCell.h"
#import "TeacherConstant.h"
#import "TeacherNIDropDown.h"

@interface TeacherCheckedOutViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, TeacherNIDropDownDelegate>
{
	TeacherUser *userObj;
    NSMutableArray *arrStudent;
	NSMutableArray *arrClass;
	NSMutableArray *arrFilterStud;
	NSMutableArray *arrFilterStudSearch;
    
    TeacherNIDropDown *dropDown;
    NSMutableArray *arrSelectedClass;

}

@end

@implementation TeacherCheckedOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	userObj = [[TeacherUser alloc] init];
    arrStudent = [[NSMutableArray alloc] init];
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];
    arrClass = [[NSMutableArray alloc] init];
    
	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_CHECKED_OUT"] WithSel:@selector(onTouchedBack:)];
	
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
    
    [self getCheckedInStudentsList];
    
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
	static NSString *simpleTableIdentifier = @"CheckedOutTableViewCell";
	
	CheckedOutTableViewCell *cell = (CheckedOutTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"CheckedOutTableViewCell" owner:self options:nil];
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
    
    BOOL isCheckedOut = [[one valueForKey:@"sfo_status"] intValue] == CHECKEDOUT ;
    if(isCheckedOut)
    {
        cell.checkoutLabel.hidden = NO;
        [cell.checkoutLabel setText:[NSString stringWithFormat:@"Checked-out, %@",  [one valueForKey:@"check_out_rule_time"]]];

        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ (%@)",[one valueForKey:@"student_name"],  [one valueForKey:@"class_name"]]];
        [cell.curStatusImgView setBackgroundColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:150/255.0f alpha:1.0f]];

        [BaseViewController setRoudRectImage:cell.profileImageView radius:imageRadius borderColor:TEXT_COLOR_WHITE];
    }else
    {
        [cell.curStatusImgView setBackgroundColor:[UIColor colorWithRed:23/255.0f green:153/255.0f blue:65/255.0f alpha:1.0f]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[one valueForKey:@"student_name"],  [one valueForKey:@"class_name"]];
        cell.checkoutLabel.hidden = YES;
        [BaseViewController setRoudRectImage:cell.profileImageView radius:imageRadius borderColor:TEXT_COLOR_LIGHT_YELLOW];
    }
    
    UITapGestureRecognizer *statusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickStatusCheckOut:)];
    [cell.curStatusImgView setTag:indexPath.row];
    [cell.curStatusImgView addGestureRecognizer:statusGesture];
    
    UITapGestureRecognizer *busGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBusCheckOut:)];
    [cell.busImgView setTag:indexPath.row];
    [cell.busImgView addGestureRecognizer:busGesture];
    
    UITapGestureRecognizer *parentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickParentCheckOut:)];
    [cell.parentImgView setTag:indexPath.row];
    [cell.parentImgView addGestureRecognizer:parentGesture];
    
    UITapGestureRecognizer *friendGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickFriendCheckOut:)];
    [cell.friendImgView addGestureRecognizer:friendGesture];
    [cell.friendImgView setTag:indexPath.row];

    cell.busLabel.hidden = YES;
    cell.parentLabel.hidden = YES;
    cell.friendLabel.hidden = YES;

    NSString* checkoutRuleType = @"";
    if ( isCheckedOut )
        checkoutRuleType = [one valueForKey:@"sfo_subtype"];
    else
        checkoutRuleType = [one valueForKey:@"check_out_rule_type"];
    
    if(checkoutRuleType != nil && ![checkoutRuleType isEqual:[NSNull null]])
    {
        if([checkoutRuleType isEqualToString:@"0"]) // bus
        {
            [cell.curStatusImgView setImage:[UIImage imageNamed:@"bus"]];
            [cell.busImgView setImage:[UIImage imageNamed:@"bus_selected"]];
            [cell.busImgView setBackgroundColor:[UIColor clearColor]];
            
            if (isCheckedOut)
            {
                cell.busLabel.hidden = NO;
                cell.busLabel.text = [one valueForKey:@"sco_time"];
            }
        }
        else if([checkoutRuleType isEqualToString:@"1"]) // parent
        {
            [cell.curStatusImgView setImage:[UIImage imageNamed:@"parent"]];
            [cell.parentImgView setImage:[UIImage imageNamed:@"parent_selected"]];
            [cell.parentImgView setBackgroundColor:[UIColor clearColor]];
            
            if (isCheckedOut)
            {
                cell.parentLabel.hidden = NO;
                cell.parentLabel.text = [one valueForKey:@"sco_time"];
            }
            
        }
        
        else if([checkoutRuleType isEqualToString:@"2"]) // friends
        {
            [cell.curStatusImgView setImage:[UIImage imageNamed:@"walking_student"]];
            [cell.friendImgView setImage:[UIImage imageNamed:@"walking_student_selected"]];
            [cell.friendImgView	 setBackgroundColor:[UIColor clearColor]];
            
            if (isCheckedOut)
            {
                cell.friendLabel.hidden = NO;
                cell.friendLabel.text = [one valueForKey:@"sco_time"];
            }
        }
    }
	[BaseViewController setRoudRectImage:cell.profileImageView];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self.searchTextField resignFirstResponder];

}

- (void)onClickStatusCheckOut:(UITapGestureRecognizer*)sender {
    
    [self.searchTextField resignFirstResponder];

    UIImageView *imgView = (UIImageView*) sender.view;
    NSMutableDictionary *dic = [arrFilterStud objectAtIndex:imgView.tag];
    
    if ([dic valueForKey:@"sfo_status"] == [NSNull null])
        return;
    
    if ([[dic valueForKey:@"sfo_status"] intValue] == CHECKEDOUT)
    {
        [userObj checkInStudent:[GeneralUtil getUserPreference:key_teacherId]
                      studentId:[dic valueForKey:@"student_id"]
                     activityId:@""
                               :^(NSObject *resObj) {
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
                {
                    [dic setValue:[NSString stringWithFormat:@"%d", SFO_CHECKEDIN] forKey:@"sfo_status"];
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
    else
    {
        NSString *checkOutRuleType = [dic valueForKey:@"check_out_rule_type"];
        if ( [checkOutRuleType isEqual: [NSNull null]] || checkOutRuleType == nil)
        {
            checkOutRuleType = @"0";
        }
        
        [userObj checkOutStudent:[GeneralUtil getUserPreference:key_teacherId]
                       studentId:[dic valueForKey:@"student_id"]
                      activityId:@""
                    checkOutType:checkOutRuleType
                                :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
                {
                    [dic setValue:[NSString stringWithFormat:@"%d", CHECKEDOUT] forKey:@"sfo_status"];
                    
                    NSDate *date = [NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"hh:mm";
                    [dic setValue:[formatter stringFromDate:date] forKey:@"sco_time"];
                    
                    [dic setValue:checkOutRuleType forKey:@"sfo_subtype"];

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
    
    
}

- (void)onClickBusCheckOut:(UITapGestureRecognizer*)sender {
    
    [self.searchTextField resignFirstResponder];

    [self setCheckedInStudentByTeacher:sender ruleType:@"0"];
    
}

- (void)onClickParentCheckOut:(UITapGestureRecognizer*)sender {
    
    [self.searchTextField resignFirstResponder];
    
    [self setCheckedInStudentByTeacher:sender ruleType:@"1"];

}

- (void)onClickFriendCheckOut:(UITapGestureRecognizer*)sender {
    
    [self.searchTextField resignFirstResponder];
    
    [self setCheckedInStudentByTeacher:sender ruleType:@"2"];

}

- (void)setCheckedInStudentByTeacher:(UITapGestureRecognizer*)sender ruleType:(NSString*) ruleType {

    UIImageView *imgView = (UIImageView*) sender.view;
    NSMutableDictionary *dic = [arrFilterStud objectAtIndex:imgView.tag];

    if ([dic valueForKey:@"sfo_status"] == [NSNull null])
        return;
    
    if ([[dic valueForKey:@"sfo_status"] intValue] == CHECKEDOUT)
        return;
    
    [userObj checkOutStudent:[GeneralUtil getUserPreference:key_teacherId] studentId:[dic valueForKey:@"student_id"] activityId:@"" checkOutType:ruleType :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
            {
                [dic setValue:[NSString stringWithFormat:@"%d", CHECKEDOUT] forKey:@"sfo_status"];
                [dic setValue:ruleType forKey:@"sfo_subtype"];
                
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"hh:mm";
                [dic setValue:[formatter stringFromDate:date] forKey:@"sco_time"];
                
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

-(void)getCheckedInStudentsList
{
    
    [userObj getStudentsList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrFilterStud removeAllObjects];
            [arrFilterStudSearch removeAllObjects];

            arrStudent = [[NSMutableArray alloc] init];

            NSMutableArray *arrData = (NSMutableArray *)[dicRes valueForKey:@"students"];
            
            for(NSDictionary* one in arrData)
            {
                if ([one valueForKey:@"sfo_status"] == [NSNull null])
                    continue;
                
                int status = [[one valueForKey:@"sfo_status"] intValue];
                
                if( status == SFO_CHECKEDIN || status == ACTIVITY_CHECKEDIN )
                    [arrStudent addObject:(NSMutableDictionary*)one];
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

}

@end
