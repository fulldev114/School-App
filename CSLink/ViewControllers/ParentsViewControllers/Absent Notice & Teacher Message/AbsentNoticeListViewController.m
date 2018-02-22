//
//  AbsentNoticeListViewController.m
//  CSLink
//
//  Created by etech-dev on 6/9/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "AbsentNoticeListViewController.h"
#import "BaseViewController.h"
#import "ParentUser.h"
#import "AbsentNoticeDetailViewController.h"

@interface AbsentNoticeListViewController ()
{
    NSMutableArray *arrAbsentNotice;
    ParentUser *userObj;
    NSString *isAbFlag;
}
@end

@implementation AbsentNoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrAbsentNotice = [[NSMutableArray alloc] init];
    userObj = [[ParentUser alloc] init];
    self.navigationController.navigationBarHidden = NO;
    
    // arrStudant = [GeneralUtil getUserPreferenceChild:key_saveChild];
    
    ZDebug(@"Arr studant List%@", arrAbsentNotice);
    
    [BaseViewController setBackGroud:self];

    if ([self.isAbsentNotice isEqualToString:@"YES"]) {
        [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_ABSENT_NOTICE"] WithSel:@selector(menuClick)];
        isAbFlag = @"1";
    }
    else {
        [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_TEACHER_MASSAGE"] WithSel:@selector(menuClick)];
        isAbFlag = @"0";
    }
    
    self.navigationItem.hidesBackButton = YES;
}

-(void)menuClick {
    [self.viewDeckController toggleLeftView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAbsentNotice];
    [GeneralUtil clearBadge:[appDelegate getCurrentChildId] badgeType:key_abn_badge];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getAbsentNotice {
    
    [userObj getAbsentNoticeList:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] isAbFlag:isAbFlag :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            arrAbsentNotice = [[dicRes valueForKey:@"All Messages"] valueForKey:@"received"];
            [tblAbsentList reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
    
}
-(CGSize)getSizeOfContent:(NSString *)text {
    
    CGSize maximumSize = CGSizeMake(SCREEN_WIDTH - 100, 2000);
    //  NSString *myString = @"This is a long string which wraps";
    //  UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize myStringSize = [text sizeWithFont:FONT_16_REGULER
                           constrainedToSize:maximumSize
                               lineBreakMode:NSLineBreakByWordWrapping];
    
    return myStringSize;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAbsentNotice.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize contentSize = [self getSizeOfContent:[[arrAbsentNotice objectAtIndex:indexPath.row] valueForKey:@"mm.message_desc"]];
    
    ZDebug(@"indexpath : %d, height of indexpath : %f ", indexPath.row,contentSize.height);
    
    if (IS_IPAD) {
        return contentSize.height + 90 ;
    }
    else {
        return contentSize.height + 70 ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UIImageView *imgProfile;
    UILabel *lblStudantName,*lblNoticeDsce,*lblDate;
    UIView *seperator;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        imgProfile = [[UIImageView alloc] init];
        imgProfile.tag = 100;
        imgProfile.contentMode = UIViewContentModeScaleAspectFit;
        imgProfile.image = [UIImage imageNamed:@"profile.png"];
        
        imgProfile.layer.borderColor = TEXT_COLOR_LIGHT_YELLOW.CGColor;
        
        CGSize contentSize = [self getSizeOfContent:[[arrAbsentNotice objectAtIndex:indexPath.row] valueForKey:@"mm.message_desc"]];
        
        lblStudantName = [BaseViewController getRowTitleLable:250 text:@""];
        lblStudantName.tag = 200;
        lblStudantName.font = FONT_18_BOLD;
        lblStudantName.textColor = TEXT_COLOR_LIGHT_YELLOW;
        
        lblNoticeDsce = [BaseViewController  getRowDetailLable:250 text:@""];
        lblNoticeDsce.tag = 300;
        lblNoticeDsce.lineBreakMode = NSLineBreakByWordWrapping;
        lblNoticeDsce.numberOfLines = 0;
        lblNoticeDsce.textColor = TEXT_COLOR_WHITE;
        lblNoticeDsce.font = FONT_16_REGULER;
        
        lblDate = [BaseViewController  getRowDetailLable:250 text:@""];
        lblDate.tag = 400;
        lblDate.textColor = TEXT_COLOR_LIGHT_GREEN;
        lblDate.font = FONT_14_BOLD;
        
        seperator = [[UIView alloc] init];
        seperator.backgroundColor = SEPERATOR_COLOR_WHITE;
        
        [cell.contentView addSubview:imgProfile];
        [cell.contentView addSubview:lblStudantName];
        [cell.contentView addSubview:lblNoticeDsce];
        [cell.contentView addSubview:lblDate];
        [cell.contentView addSubview:seperator];
    }
    else {
        imgProfile = (UIImageView *)[cell.contentView viewWithTag:100];
        lblStudantName = (UILabel *)[cell.contentView viewWithTag:200];
        lblNoticeDsce = (UILabel *)[cell.contentView viewWithTag:300];
        lblDate = (UILabel *)[cell.contentView viewWithTag:400];
    }
    
    NSDictionary *dicStudantDetail = [arrAbsentNotice objectAtIndex:indexPath.row];
    
    lblStudantName.text = [dicStudantDetail valueForKey:@"fromname"];
    
    lblNoticeDsce.text = [dicStudantDetail valueForKey:@"mm.message_desc"];
    [lblNoticeDsce sizeToFit];
    CGSize contentSize = [self getSizeOfContent:lblNoticeDsce.text];
    
    if (IS_IPAD) {
        imgProfile.frame = CGRectMake(20, 15, 50, 50);
        lblStudantName.frame = CGRectMake(85, 10, 200, 30);
        lblNoticeDsce.frame = CGRectMake(85, 45, contentSize.width, contentSize.height);
        lblDate.frame = CGRectMake(85, contentSize.height + 45, lblNoticeDsce.frame.size.width, 40);
        seperator.frame = CGRectMake(85, contentSize.height + 89, SCREEN_WIDTH, 1);
    }
    else {
        imgProfile.frame = CGRectMake(20, 15, 40, 40);
        lblStudantName.frame = CGRectMake(75, 10, 200, 30);
        lblNoticeDsce.frame = CGRectMake(75, 40, contentSize.width, contentSize.height);
        lblDate.frame = CGRectMake(75, contentSize.height + 35, lblNoticeDsce.frame.size.width, 40);
        seperator.frame = CGRectMake(75, contentSize.height + 69, SCREEN_WIDTH, 1);
    }
    
    [BaseViewController setRoudRectImage:imgProfile];
    
    lblNoticeDsce.text = [dicStudantDetail valueForKey:@"mm.message_desc"];
    lblDate.text = [GeneralUtil formateData:[dicStudantDetail valueForKey:@"created_at"]];
    
    [imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dicStudantDetail = [arrAbsentNotice objectAtIndex:indexPath.row];
    
    AbsentNoticeDetailViewController *custompopup = [[AbsentNoticeDetailViewController alloc] initWithNibName:@"AbsentNoticeDetailViewController" bundle:nil andDate:dicStudantDetail];
    
    [self presentPopupViewController:custompopup animationType:MJPopupViewAnimationFade];
}

@end
