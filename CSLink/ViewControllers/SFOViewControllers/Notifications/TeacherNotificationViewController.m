//
//  TeacherNotificationViewController.m
//  CSLink
//
//  Created by adamlucas on 5/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "TeacherNotificationViewController.h"
#import "BaseViewController.h"
#import "NotificationTableViewCell.h"
#import "ContactNotificationTableViewCell.h"
#import "TeacherUser.h"

@interface TeacherNotificationViewController ()
{
    TeacherUser *userObj;
	UITextField *searchTextField;
    NSMutableArray *arrNotifications;
    NSMutableArray *arrFilterStud;
    NSMutableArray *arrFilterStudSearch;
    NSString *todayDate;
}

@end

@implementation TeacherNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_NOTIFICATIONS"] titleColor:TEXT_COLOR_LIGHT_YELLOW WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];
	
	self.notificationTableView.delegate = self;
	self.notificationTableView.dataSource = self;
	
    userObj = [[TeacherUser alloc] init];
    arrNotifications = [[NSMutableArray alloc] init];
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];
	
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    todayDate = [formatter stringFromDate:nowDate];
    
	searchTextField = [self.searchBar valueForKey:@"_searchField"];
	searchTextField.tag = 8;
	searchTextField.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH"];
	[BaseViewController getRoundRectTextField:searchTextField withIcon:@"searchIcon.png"];
	
	searchTextField.font = FONT_16_LIGHT;
	
	self.notificationTableView.rowHeight = UITableViewAutomaticDimension;
	self.notificationTableView.estimatedRowHeight = 70.0;
	
	[searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getNotifications];
    
}

- (void)onTouchedBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
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
            if ([[[item objectForKey:@"activity_name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
                [arrFilterStud addObject:item];
            }
        }
    }else{
        arrFilterStud = [arrFilterStudSearch mutableCopy];
    }
    
    [self.notificationTableView reloadData];
    
}

#pragma UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return self.notificationArray.count;
	return arrFilterStud.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (IS_IPAD) {
        return 85;
	}
	else {
        return 70;
	}
	
	return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *simpleTableIdentifier = @"NotificationTableViewCell";
    
    NotificationTableViewCell *cell = (NotificationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary* one = [arrFilterStud objectAtIndex:indexPath.row];
    
    NSString *date = [one valueForKey:@"date"];
    BOOL bToday = [todayDate isEqualToString:date];
    
    if (bToday) {
        cell.backgroundColor = CELL_BACKGROUD_COLOR_YELLOW;
        cell.statusLabel.font = FONT_18_REGULER;
        cell.statusLabel.textColor = TEXT_COLOR_DARK_BLUE;
        
        cell.timeLabel.font = FONT_16_REGULER;
        cell.timeLabel.textColor = TEXT_COLOR_DARK_BLUE;
        cell.clockImageView.image = [UIImage imageNamed:@"clock_blue"];
        [BaseViewController setRoudRectImage:cell.profileImageView];
    } else {
        cell.backgroundColor = [UIColor clearColor];
        
        cell.statusLabel.font = FONT_18_REGULER;
        cell.statusLabel.textColor = TEXT_COLOR_WHITE;
        cell.timeLabel.font = FONT_16_REGULER;
        cell.timeLabel.textColor = TEXT_COLOR_WHITE;
        [BaseViewController setRoudRectImage:cell.profileImageView];
    }


    cell.routineImageView.hidden = YES;
    
    NSString *status = @"";
    switch ([[one valueForKey:@"type"] intValue]) {
        case 0:
            status = @"Not Arrived";
            break;
        case 1:
            status = @"SFO Checked In";
            break;
        case 2:
            status = @"Activity Checked In";
            break;
        case 3:
            status = @"Checked Out";
            break;
        case 4:
            status = @"     Please Contact a staff member";
            cell.routineImageView.hidden = NO;
        default:
            break;
    }

    NSString *name = [one valueForKey:@"student_name"];
    NSString *class = [one valueForKey:@"class_name"];
    NSString *data = [NSString stringWithFormat:@"%@ (%@) %@", name, class, status];
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : TEXT_COLOR_WHITE,
                                 NSFontAttributeName: FONT_18_REGULER
                                 };
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:data attributes:attributes];
    NSRange yellowRange = [data rangeOfString:name];
    
    [attributedText setAttributes:@{NSForegroundColorAttributeName:TEXT_COLOR_YELLOW} range:yellowRange];
    cell.nameLabel.attributedText = attributedText;
    
    if (!cell.routineImageView.hidden)
    {
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = [NSString stringWithFormat:@"%@ %@", name, class];
        lbl.font = FONT_18_REGULER;
        [lbl sizeToFit];
        
        [cell.routineImageView setFrame:CGRectMake(90 + lbl.frame.size.width * 0.95f, 6, 17, 17)];
    }
    
    UILabel *lblData = [[UILabel alloc] init];
    lblData.text = data;
    lblData.font = FONT_18_REGULER;
    [lblData sizeToFit];
    
    if ( 90 + lblData.frame.size.width * 0.95f > [GeneralUtil screenWidth])
    {
        cell.consTimerBottom.constant = -8;
        cell.consTimeLabelBottom.constant = -8;
        cell.consNameTop.constant = -4;
    }
    
    NSString *strDate = [NSString stringWithFormat:@"%@ %@", [one valueForKey:@"date"], [one valueForKey:@"time"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    NSDate *sDate = [formatter dateFromString:strDate];
    cell.timeLabel.text = [self formattedDate:sDate];

    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//	[txfSearchField resignFirstResponder];
	//
	//	NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
	//
	//	StudantDetailViewController *custompopup = [[StudantDetailViewController alloc] initWithNibName:@"StudantDetailViewController" bundle:nil andDate:dicStudantDetail];
	//	custompopup.delegate = self;
	//	[self presentPopupViewController:custompopup animationType:MJPopupViewAnimationFade];
}

-(void)getNotifications {
    
    [userObj getNotifications:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            arrNotifications = (NSMutableArray *)[dicRes valueForKey:@"notifications"];
            
            [arrFilterStudSearch removeAllObjects];
            [arrFilterStudSearch addObjectsFromArray:arrNotifications];
            [arrFilterStud removeAllObjects];
            [arrFilterStud addObjectsFromArray:arrFilterStudSearch];
            
            [self.notificationTableView  reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(NSString *)formattedDate:(NSDate *)date
{
    NSString *result = @"";
    NSTimeInterval timeSinceDate = [[NSDate date] timeIntervalSinceDate:date];
    NSInteger oneDay = 24 * 60 * 60;
    
    if (timeSinceDate < oneDay)
    {
        NSUInteger hours = (NSUInteger)(timeSinceDate / (60 * 60));
        
        switch(hours)
        {
            default:
                result = [NSString stringWithFormat:@"%lu hours ago", (unsigned long)hours];
                break;
            case 1:
                result = @"1 hour ago";
                break;
            case 0:
            {
                NSUInteger mins = (NSUInteger)(timeSinceDate / 60);
                result = [NSString stringWithFormat:@"%lu minutes ago", (unsigned long)mins];
                break;
            }
        }
    }
    else if ( timeSinceDate < oneDay * 2 )
    {
        result = @"Yesterday";
    }
    else if ( timeSinceDate < oneDay * 3 )
    {
        result = @"2 Days Ago";
    }
    else if ( timeSinceDate < oneDay * 7 )
    {
        result = @"1 Week Ago";
    }
    else if ( timeSinceDate < oneDay * 14 )
    {
        result = @"2 Week Ago";
    }
    else if ( timeSinceDate < oneDay * 30 )
    {
        result = @"1 Month Ago";
    }
    
    return result;
    
}

@end
