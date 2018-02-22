//
//  ActivitiesViewController.m
//  CSLink
//
//  Created by adamlucas on 5/23/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "BaseViewController.h"
#import "ActivitiesTableViewCell.h"
#import "ActivityDetailViewController.h"
#import "TeacherConstant.h"
#import "TeacherUser.h"
#import "TeacherCheckedInViewController.h"
#import "TeacherCheckedOutActivityViewController.h"
#import "TeacherCheckedInActivityViewController.h"

@interface ActivitiesViewController ()
{
	NSArray *arrActivities;
	UITextField *searchTextField;
    TeacherUser *userObj;
    ParentUser *userObjParent;
    NSMutableArray *arrFilterStud;
    NSMutableArray *arrFilterStudSearch;
}

@end

@implementation ActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_ACTIVITIES"] titleColor:TEXT_COLOR_LIGHT_YELLOW WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];

	userObj = [[TeacherUser alloc] init];
    userObjParent = [[ParentUser alloc] init];
    
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];

	self.activitiesArray = [NSMutableArray array];
	self.activitiesTableView.delegate = self;
	self.activitiesTableView.dataSource = self;

	
	arrActivities = [[NSMutableArray alloc] init];
	
	searchTextField = [self.searchBar valueForKey:@"_searchField"];
	searchTextField.tag = 8;
	searchTextField.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH"];
	[BaseViewController getRoundRectTextField:searchTextField withIcon:@"searchIcon"];
	
    searchTextField.font = FONT_16_LIGHT;
	
	self.activitiesTableView.rowHeight = UITableViewAutomaticDimension;
	self.activitiesTableView.estimatedRowHeight = 70.0;
	
	[searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getActivities];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTouchedBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}


-(void)textFieldDidChange:(UITextField*)textField
{
	[self updateSearchArray:textField.text];
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray:(NSString *)searchTextString
{
    [arrFilterStud removeAllObjects];
    if (searchTextString.length != 0) {
        
        for ( NSDictionary* item in arrFilterStudSearch ) {
            if ([[[item objectForKey:@"activity_name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
                [arrFilterStud addObject:item];
            }
        }
    }else{
        arrFilterStud = [arrFilterStudSearch mutableCopy];
    }
    
    [self.activitiesTableView reloadData];

}


#pragma UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return self.activitiesArray.count;
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
	static NSString *simpleTableIdentifier = @"ActivitiesTableViewCell";
	ActivitiesTableViewCell *cell = (ActivitiesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ActivitiesTableViewCell" owner:self options:nil];
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
    
    cell.ActivityLabel.text = [one objectForKey:@"activity_name"];
    cell.placeLabel.text = [one objectForKey:@"place"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:[one objectForKey:@"date"]];

    [dateFormat setDateFormat:@"dd"];
    NSString *day = [dateFormat stringFromDate:date];
    
    [dateFormat setDateFormat:@"MMM"];
    NSString *month = [dateFormat stringFromDate:date];
    
    cell.dateLabel.text = day;
    cell.monthLabel.text = month;
    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [searchTextField resignFirstResponder];
    
    NSDictionary* one = [arrFilterStud objectAtIndex:indexPath.row];

    switch(_activityStatus)
    {
        case ACTIVITY_DETAIL:
        {
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc] initWithNibName:@"ActivityDetailViewController" bundle:nil];
            vc.activityId = [one objectForKey:@"activity_id"];
            vc.isTeacher = _isTeacher;
            
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case ACTIVITY_ADD:
        {
            TeacherCheckedInActivityViewController *vc = [[TeacherCheckedInActivityViewController alloc] initWithNibName:@"TeacherCheckedInActivityViewController" bundle:nil];
            vc.activityId = [one objectForKey:@"activity_id"];
            vc.activityStatus = self.activityStatus;
            vc.activityName = [one objectForKey:@"activity_name"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case ACTIVITY_CHECKED:
            if (self.bCheckedIn) {
                TeacherCheckedInActivityViewController *vc = [[TeacherCheckedInActivityViewController alloc] initWithNibName:@"TeacherCheckedInActivityViewController" bundle:nil];
                vc.activityId = [one objectForKey:@"activity_id"];
                vc.activityStatus = self.activityStatus;
                vc.activityName = [one objectForKey:@"activity_name"];
                [self.navigationController pushViewController:vc animated:YES];
                
            } else
            {
                TeacherCheckedOutActivityViewController *vc = [[TeacherCheckedOutActivityViewController alloc] initWithNibName:@"TeacherCheckedOutActivityViewController" bundle:nil];
                vc.activityID = [one objectForKey:@"activity_id"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        default:
            break;
    }

    
}

-(void)getActivities {
    RequestComplitionBlock block = ^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            
            arrActivities = (NSMutableArray *)[dicRes valueForKey:@"activities"];
            
            [arrFilterStudSearch removeAllObjects];
            [arrFilterStudSearch addObjectsFromArray:arrActivities];
            [arrFilterStud removeAllObjects];
            [arrFilterStud addObjectsFromArray:arrFilterStudSearch];
            
            [self.activitiesTableView  reloadData];
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
