//
//  OtherPerentViewController.m
//  CSLink
//
//  Created by etech-dev on 6/22/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "OtherPerentViewController.h"
#import "BaseViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface OtherPerentViewController ()<CustomIOS7AlertViewDelegate>
{
    NSMutableArray *arrPerant;
    ParentUser *userObj;
    NSString *number;
}
@end

@implementation OtherPerentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_OTHER_PARANTS"] WithSel:@selector(menuClick)];
    
    userObj = [[ParentUser alloc] init];
    [self getPerantList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)menuClick {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}

-(void)getPerantList {
    
    [userObj getPerentList:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            arrPerant = [[dicRes valueForKey:key_allchilds] valueForKey:key_parents];
            [tblOtherPerentList reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrPerant.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPAD) {
        return 120;
    }
    else {
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UIImageView *imgProfile,*imgCallIcon;
    UILabel *lblParentName,*lblStudantName,*lblPhoneNo;
    UIView *seperator;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        imgProfile = [[UIImageView alloc] init];
        imgProfile.tag = 100;
        imgProfile.contentMode = UIViewContentModeScaleAspectFit;
        imgProfile.image = [UIImage imageNamed:@"profile.png"];
        
        
        
        lblParentName = [BaseViewController getRowTitleLable:250 text:@""];
        lblParentName.font = FONT_16_BOLD;
        lblParentName.textColor = TEXT_COLOR_CYNA;
        lblParentName.tag = 200;
        
        imgCallIcon = [[UIImageView alloc] init];
        imgCallIcon.tag = 400;
        //imgCallIcon.contentMode = UIViewContentModeCenter;
        imgCallIcon.image = [UIImage imageNamed:@"mobile-icon"];
        
        lblStudantName = [BaseViewController  getRowDetailLable:250 text:@""];
        
        lblStudantName.font = FONT_16_REGULER;
        lblStudantName.textColor = TEXT_COLOR_LIGHT_GREEN;
        lblStudantName.tag = 700;
        
        lblPhoneNo = [BaseViewController  getRowDetailLable:250 text:@""];
        
        lblPhoneNo.font = FONT_16_REGULER;
        lblPhoneNo.textColor = TEXT_COLOR_WHITE;
        lblPhoneNo.tag = 300;
        
        seperator = [[UIView alloc] init];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        if (IS_IPAD) {
            
            imgProfile.frame = CGRectMake(20, 15, 50, 50);
            lblParentName.frame = CGRectMake(85, 0, SCREEN_WIDTH, lblParentName.frame.size.height);
            lblStudantName.frame = CGRectMake(85, 43, lblStudantName.frame.size.width, 30);
            imgCallIcon.frame = CGRectMake(85, 80, 25, 25);
            lblPhoneNo.frame = CGRectMake(120, 78, lblPhoneNo.frame.size.width, 30);
            seperator.frame = CGRectMake(85, 119, SCREEN_WIDTH, 1);
        }
        else {
            
            imgProfile.frame = CGRectMake(20, 15, 40, 40);
            lblParentName.frame = CGRectMake(75, 0, SCREEN_WIDTH, lblParentName.frame.size.height);
            lblStudantName.frame = CGRectMake(75, 30, lblStudantName.frame.size.width, 30);
            imgCallIcon.frame = CGRectMake(75, 60, 15, 15);
            lblPhoneNo.frame = CGRectMake(100, 53, lblPhoneNo.frame.size.width, 30);
            seperator.frame = CGRectMake(75, 89, cell.frame.size.width, 1);
        }
        
        [BaseViewController setRoudRectImage:imgProfile];
        
        [cell.contentView addSubview:imgProfile];
        [cell.contentView addSubview:lblParentName];
        [cell.contentView addSubview:lblStudantName];
        [cell.contentView addSubview:lblPhoneNo];
        [cell.contentView addSubview:seperator];
        [cell.contentView addSubview:imgCallIcon];
    }
    else {
        lblParentName = (UILabel *)[cell.contentView viewWithTag:200];
        lblStudantName = (UILabel *)[cell.contentView viewWithTag:700];
        lblPhoneNo = (UILabel *)[cell.contentView viewWithTag:300];
        imgProfile = (UIImageView *)[cell.contentView viewWithTag:100];
        imgCallIcon = (UIImageView *)[cell.contentView viewWithTag:400];
    }
    
    NSDictionary *dicStudantDetail = [arrPerant objectAtIndex:indexPath.row];
    
    lblParentName.text = [NSString stringWithFormat:@"%@",[dicStudantDetail valueForKey:@"parentname"]];
    lblStudantName.text = [NSString stringWithFormat:@"(%@)",[dicStudantDetail valueForKey:@"childname"]];
    lblPhoneNo.text = [dicStudantDetail valueForKey:@"mobile"];
    
    [imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dicStudantDetail = [arrPerant objectAtIndex:indexPath.row];
    number = [NSString stringWithFormat:@"+47%@",[dicStudantDetail valueForKey:@"mobile"]];
    NSMutableArray *arrBtn = [[NSMutableArray alloc] initWithObjects:[GeneralUtil getLocalizedText:@"BTN_CALL_TITLE"],[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"], nil];
    CustomIOS7AlertView *aletview = [BaseViewController customAlertDisplay:[NSString stringWithFormat:@"+ 47 %@",[dicStudantDetail valueForKey:@"mobile"]] Btns:arrBtn];
    aletview.delegate =self;
    [aletview show];
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 1) {
        
    }
    else {
       
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
                        // Check if iOS Device supports phone calls
            CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
            CTCarrier *carrier = [netInfo subscriberCellularProvider];
            NSString *mnc = [carrier mobileNetworkCode];
            // User will get an alert error when they will try to make a phone call in airplane mode.
            if (([mnc length] == 0)) {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CALL_NOT_PROVIDE"]];
            } else {
                NSString *num = [NSString stringWithFormat:@"tel:%@",number];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
            }
        } else {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CALL_NOT_PROVIDE"]];
        }
    }
}



@end
