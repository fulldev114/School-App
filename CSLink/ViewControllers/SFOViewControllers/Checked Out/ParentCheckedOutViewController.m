//
//  CheckInViewController.m
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ParentCheckedOutViewController.h"
#import "BaseViewController.h"
#import "TeacherUser.h"
#import "TeacherConstant.h"
#import "CheckedOutTableViewCell.h"

@interface ParentCheckedOutViewController () <UITableViewDataSource,UITableViewDelegate>
{
    ParentUser *userObj;
}

@end

@implementation ParentCheckedOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_CHECKED_OUT"] titleColor:TEXT_COLOR_LIGHT_YELLOW WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];
	
    userObj = [[ParentUser alloc] init];
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
	
	cell.nameLabel.font = FONT_18_REGULER;
	cell.nameLabel.textColor = TEXT_COLOR_CYNA;
    
    NSDictionary *studentData = [_studentsData objectAtIndex:indexPath.row];
    if (![[studentData valueForKey:@"image"] isEqualToString:@""])
    {
        [cell.profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[studentData valueForKey:@"image"]]]
                              placeholderImage:[UIImage imageNamed:@"profile.png"]];
    }
    
    BOOL isCheckedOut = NO;
    if ([studentData valueForKey:@"sfo_status"] == [NSNull null])
        isCheckedOut = NO;
    else
        isCheckedOut = [[studentData valueForKey:@"sfo_status"] intValue] == CHECKEDOUT ;

    [cell.nameLabel setText:[NSString stringWithFormat:@"%@ (%@)",[studentData valueForKey:@"student_name"],  [studentData valueForKey:@"class_name"]]];
    
    if(isCheckedOut)
    {
        cell.checkoutLabel.hidden = NO;
        [cell.checkoutLabel setText:[NSString stringWithFormat:@"Checked-out, %@",  [studentData valueForKey:@"check_out_rule_time"]]];
        [cell.curStatusImgView setBackgroundColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:150/255.0f alpha:1.0f]];
        
        [BaseViewController setRoudRectImage:cell.profileImageView radius:25 borderColor:TEXT_COLOR_WHITE];
    }else
    {
        [cell.curStatusImgView setBackgroundColor:[UIColor colorWithRed:23/255.0f green:153/255.0f blue:65/255.0f alpha:1.0f]];
        cell.checkoutLabel.hidden = YES;
        [BaseViewController setRoudRectImage:cell.profileImageView radius:25 borderColor:TEXT_COLOR_LIGHT_YELLOW];
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

    
    NSString* checkoutRuleType = @"";
    if ( isCheckedOut )
        checkoutRuleType = [studentData valueForKey:@"sfo_subtype"];
    else
        checkoutRuleType = [studentData valueForKey:@"check_out_rule_type"];
    
    if ([checkoutRuleType isEqual:[NSNull null]])
    {
        [cell.curStatusImgView setImage:[UIImage imageNamed:@"bus"]];
        [cell.busImgView setImage:[UIImage imageNamed:@"bus_selected"]];
        [cell.busImgView setBackgroundColor:[UIColor clearColor]];

    }
    
    cell.busLabel.hidden = YES;
    cell.parentLabel.hidden = YES;
    cell.friendLabel.hidden = YES;

    if(checkoutRuleType != nil && ![checkoutRuleType isEqual:[NSNull null]])
    {
        if([checkoutRuleType intValue] == 0) // bus
        {
            [cell.curStatusImgView setImage:[UIImage imageNamed:@"bus"]];
            [cell.busImgView setImage:[UIImage imageNamed:@"bus_selected"]];
            [cell.busImgView setBackgroundColor:[UIColor clearColor]];
            
            if (isCheckedOut)
            {
                cell.busLabel.hidden = NO;
                cell.busLabel.text = [studentData valueForKey:@"sco_time"];
            }
        }
        else if([checkoutRuleType intValue] == 1) // parent
        {
            [cell.curStatusImgView setImage:[UIImage imageNamed:@"parent"]];
            [cell.parentImgView setImage:[UIImage imageNamed:@"parent_selected"]];
            [cell.parentImgView setBackgroundColor:[UIColor clearColor]];
            
            if (isCheckedOut)
            {
                cell.parentLabel.hidden = NO;
                cell.parentLabel.text = [studentData valueForKey:@"sco_time"];
            }
        }
        
        else if([checkoutRuleType intValue] == 2) // friends
        {
            [cell.curStatusImgView setImage:[UIImage imageNamed:@"walking_student"]];
            [cell.friendImgView setImage:[UIImage imageNamed:@"walking_student_selected"]];
            [cell.friendImgView	 setBackgroundColor:[UIColor clearColor]];
            
            if (isCheckedOut)
            {
                cell.friendLabel.hidden = NO;
                cell.friendLabel.text = [studentData valueForKey:@"sco_time"];
            }
        }
        
    }
    
	[BaseViewController setRoudRectImage:cell.profileImageView];

	return cell;
}

- (void)onClickStatusCheckOut:(UITapGestureRecognizer*)sender {
    
    UIImageView *imgView = (UIImageView*) sender.view;
    NSMutableDictionary *dic = [_studentsData objectAtIndex:imgView.tag];
    
    if ([dic valueForKey:@"sfo_status"] == [NSNull null])
        return;
    
    if ([[dic valueForKey:@"sfo_status"] intValue] == CHECKEDOUT)
    {
        [userObj checkInStudent:[GeneralUtil getUserPreference:key_parentIdSave]
                      studentId:[dic valueForKey:@"student_id"]
                     activityId:@""
                               :^(NSObject *resObj) {
                                   [GeneralUtil hideProgress];
                                   
                                   NSDictionary *dicRes = (NSDictionary *)resObj;
                                   
                                   if (dicRes != nil) {
                                       if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
                                       {
                                           [dic setValue:[NSString stringWithFormat:@"%d", SFO_CHECKEDIN] forKey:@"sfo_status"];
                                           NSInteger index = [_studentsData indexOfObject:dic];
                                           [_studentsData replaceObjectAtIndex:index withObject:dic];
                                           
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
       
        
        [userObj checkOutStudent:[GeneralUtil getUserPreference:key_parentIdSave]
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
                                            
                                            NSInteger index = [_studentsData indexOfObject:dic];
                                            [_studentsData replaceObjectAtIndex:index withObject:dic];
                                            
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
    
    [self setCheckedInStudentByTeacher:sender ruleType:@"0"];
    
}

- (void)onClickParentCheckOut:(UITapGestureRecognizer*)sender {
    
    [self setCheckedInStudentByTeacher:sender ruleType:@"1"];
    
}

- (void)onClickFriendCheckOut:(UITapGestureRecognizer*)sender {
    
    [self setCheckedInStudentByTeacher:sender ruleType:@"2"];

}

- (void)setCheckedInStudentByTeacher:(UITapGestureRecognizer*)sender ruleType:(NSString*) ruleType {
    
    UIImageView *imgView = (UIImageView*) sender.view;
    NSMutableDictionary *dic = [_studentsData objectAtIndex:imgView.tag];
    
    if ([dic valueForKey:@"sfo_status"] == [NSNull null])
        return;
    
    if ([[dic valueForKey:@"sfo_status"] intValue] == CHECKEDOUT)
        return;
    
    [userObj checkOutStudent:[GeneralUtil getUserPreference:key_parentIdSave] studentId:[dic valueForKey:@"student_id"] activityId:@"" checkOutType:ruleType :^(NSObject *resObj) {
        
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
                
                NSInteger index = [_studentsData indexOfObject:dic];
                [_studentsData replaceObjectAtIndex:index withObject:dic];
                
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
