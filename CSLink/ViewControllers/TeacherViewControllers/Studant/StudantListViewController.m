//
//  StudantListViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/4/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "StudantListViewController.h"
#import "BaseViewController.h"
#import "TeacherConstant.h"
#import "TeacherNIDropDown.h"
#import "ApprovedViewController.h"
#import "PandingViewController.h"

@interface StudantListViewController ()<TeacherNIDropDownDelegate>
{
    NSMutableArray *arrStudant;
    NSMutableArray *arrClass;
    NSMutableArray *arrFilterClass;
    NSMutableArray *arrGrade;
    NSMutableArray *arrFilterStud;
    TeacherUser *userObj;
    TeacherNIDropDown *dropDown;
    NSString *selectedGrade;
    NSString *selectedClass;
}
@end

@implementation StudantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    arrStudant = [[NSMutableArray alloc] init];
    arrClass = [[NSMutableArray alloc] init];
    arrGrade = [[NSMutableArray alloc] init];
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterClass = [[NSMutableArray alloc] init];
    userObj = [[TeacherUser alloc] init];
    
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_STUDENTS"] WithSel:@selector(btnBackClick)];
    
    [BaseViewController setBackGroud:self];
    
    if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
        btnGread.tag = 10;
    }
    
    [BaseViewController getDropDownBtn:btnGread withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_GRADE"]];
    [BaseViewController getDropDownBtn:btnClass withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_CLASS"]];
    
    [btnGread setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnClass setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    
    lblClassName.font = FONT_16_SEMIBOLD;
    lblClassName.textColor = TEXT_COLOR_CYNA;
    
    lblStudantList.font = FONT_18_SEMIBOLD;
    lblStudantList.textColor = TEXT_COLOR_CYNA;
    lblStudantList.text = [GeneralUtil getLocalizedText:@"LBL_TITLE_STUDANT_LIST"];
    
    //[tblStudantList setContentInset:UIEdgeInsetsMake(-70,0,0,0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getTeacherClass];
}

-(void)btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getTeacherClass {
    
    [userObj getTeacherClass:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                arrGrade = [[dicRes valueForKey:@"grades"] valueForKey:@"grades"];
                arrClass = [[dicRes valueForKey:@"classes"] valueForKey:@"classes"];
                
                [self getRequestStudList];
            }
            else {
                [GeneralUtil hideProgress];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)filterClass:(NSString *)grad {

    [arrFilterClass removeAllObjects];
    
    [btnClass setTitle:[GeneralUtil getLocalizedText:@"BTN_SELECT_CLASS"] forState:UIControlStateNormal];
   
    selectedClass = @"";
    
    for (NSDictionary *dicValue in arrClass) {
        
        NSString *gid = [dicValue valueForKey:@"grade"];
        
        if ([gid isEqualToString:selectedGrade]) {
            [arrFilterClass addObject:[dicValue valueForKey:@"class_name"]];
        }
    }
}

-(void)getRequestStudList {
    
    [userObj getRequestStudantList:[GeneralUtil getUserPreference:key_schoolId] teacherId:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            arrStudant = [dicRes valueForKey:@"allStudents"];
            
            [arrFilterStud removeAllObjects];
            
            if (selectedGrade != nil) {
                
                [self filterClass:selectedGrade];
                
                if (selectedClass != nil && ![selectedClass isEqualToString:@""] ) {
                    
                    [btnClass setTitle:selectedClass forState:UIControlStateNormal];
                    lblClassName.text = [NSString stringWithFormat:@"%@ - %@",[GeneralUtil getLocalizedText:@"LBL_TITLE_CLASS"],selectedClass];
                    
                    [arrFilterStud removeAllObjects];
                    for (NSDictionary *dicValue in arrStudant) {
                        
                        NSString *cid = [dicValue valueForKey:@"class_name"];
                        NSString *gid = [dicValue valueForKey:@"grade"];
                        
                        if ([gid isEqualToString:selectedGrade] && [cid isEqualToString:selectedClass] ) {
                            [arrFilterStud addObject:dicValue];
                        }
                    }
                }
                else {
                    [arrFilterStud removeAllObjects];
                    for (NSDictionary *dicValue in arrStudant) {
                        
                        NSString *gid = [dicValue valueForKey:@"grade"];
                        
                        if ([gid isEqualToString:selectedGrade]) {
                            [arrFilterStud addObject:dicValue];
                        }
                    }
                }
            }
            else {
                lblClassName.text = [GeneralUtil getLocalizedText:@"LBL_TITLE_CLASS_NAME"];
                for (NSDictionary *dicCls in arrStudant) {
                    [arrFilterStud addObject:dicCls];
                }
            }
            [tblStudantList  reloadData];
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
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UIImageView *imgProfile,*imgCheckMark;
    UILabel *lblStudantName,*lblStatus;
    UIView *seperator;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        imgProfile = [[UIImageView alloc] init];
        imgProfile.tag = 100;
        imgProfile.contentMode = UIViewContentModeScaleAspectFit;
        
        // imgProfile.image = [UIImage imageNamed:@"profile.png"];
        
        
        
        lblStudantName = [BaseViewController getRowTitleLable:SCREEN_WIDTH text:@""];
        lblStudantName.textColor = [UIColor whiteColor];
        lblStudantName.font = FONT_17_BOLD;
        lblStudantName.tag = 200;
        lblStudantName.lineBreakMode = NSLineBreakByWordWrapping;
        lblStudantName.numberOfLines = 0;
        
        lblStatus = [BaseViewController  getRowDetailLable:250 text:@""];
        lblStatus.font = FONT_16_SEMIBOLD;
        
        lblStatus.tag = 300;
        
        imgCheckMark = [[UIImageView alloc] init];
        imgCheckMark.tag = 400;
        imgCheckMark.contentMode = UIViewContentModeCenter;
        
        seperator = [[UIView alloc] init];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        if (IS_IPAD) {
            
            imgProfile.frame = CGRectMake(20, 15, 55, 55);
            lblStudantName.frame = CGRectMake(85, 8, SCREEN_WIDTH, 40);
            lblStatus.frame = CGRectMake(85, 37, lblStatus.frame.size.width, 40);
            imgCheckMark.frame = CGRectMake(lblStatus.frame.size.width - 60, 42, 30, 30);
            seperator.frame = CGRectMake(85, 84, SCREEN_WIDTH, 1);
        }
        else {
            
            imgProfile.frame = CGRectMake(20, 15, 40, 40);
            lblStudantName.frame = CGRectMake(75, 0, SCREEN_WIDTH, 40);
            lblStatus.frame = CGRectMake(75, 27, lblStatus.frame.size.width, 40);
            imgCheckMark.frame = CGRectMake(lblStatus.frame.size.width - 105, 35, 25, 25);
            seperator.frame = CGRectMake(75, 69, SCREEN_WIDTH, 1);
        }
        
        [BaseViewController setRoudRectImage:imgProfile];
        
        [cell.contentView addSubview:imgProfile];
        [cell.contentView addSubview:imgCheckMark];
        [cell.contentView addSubview:lblStudantName];
        [cell.contentView addSubview:lblStatus];
        [cell.contentView addSubview:seperator];
    }
    else {
        lblStudantName = (UILabel *)[cell.contentView viewWithTag:200];
        lblStatus = (UILabel *)[cell.contentView viewWithTag:300];
        imgCheckMark = (UIImageView *)[cell.contentView viewWithTag:400];
        imgProfile = (UIImageView *)[cell.contentView viewWithTag:100];
    }
    
    NSDictionary *dicStudantDetail = [arrFilterStud objectAtIndex:indexPath.row];
    
    lblStudantName.text = [dicStudantDetail valueForKey:@"name"];
    
    if ([dicStudantDetail valueForKey:@"nc_parent_name"] == [NSNull  null] && [dicStudantDetail valueForKey:@"parent_name"] == [NSNull  null]) {
        
        lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_TITLE_STATUS_NOT_ASSIGN"];
        lblStatus.textColor = TEXT_COLOR_CYNA;
        imgCheckMark.image = [UIImage imageNamed:@""];
        
    }
    else if ([dicStudantDetail valueForKey:@"nc_parent_name"] == [NSNull  null]) {
        
        lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_TITLE_STATUS_APPROVE"];
        lblStatus.textColor = TEXT_COLOR_GREEN;
        imgCheckMark.image = [UIImage imageNamed:@"approved"];
        
    }
    else {
     
        lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_TITLE_STUDANT_PANDING"];
        lblStatus.textColor = TEXT_COLOR_LIGHT_YELLOW;
        imgCheckMark.image = [UIImage imageNamed:@""];
    }
    
    //lblStatus.text = [dicStudantDetail valueForKey:@"class_name"];
    
    [imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dicStudantDetail = [arrFilterStud objectAtIndex:indexPath.row];
//    if ([dicStudantDetail valueForKey:@"nc_parent_name"] == [NSNull  null] && [dicStudantDetail valueForKey:@"parent_name"] == [NSNull  null]) {
//    }
//    else
    
    if ([dicStudantDetail valueForKey:@"nc_parent_name"] == [NSNull  null]) {
        ApprovedViewController * vc = [[ApprovedViewController alloc] initWithNibName:@"ApprovedViewController" bundle:nil];
        vc.dicStudDetail = [arrFilterStud objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        PandingViewController * vc = [[PandingViewController alloc] initWithNibName:@"PandingViewController" bundle:nil];
        vc.dicStudDetail = [arrFilterStud objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnGreadPress:(id)sender {
    
    if(dropDown == nil) {
        
        CGFloat f;
        if (IS_IPAD) {
            f = [arrGrade count] * 50;
        }
        else {
            f = [arrGrade count] * 40;
        }
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:sender :&f :(NSArray *)arrGrade :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 1;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)btnClassPress:(id)sender {
    
    if ([selectedGrade isEqualToString:@""] || selectedGrade == nil) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_GRADE"]];
    }
    else {
        if(dropDown == nil) {
            
            CGFloat f;
            if (IS_IPAD) {
                f = [arrFilterClass count] * 50;
            }
            else {
                f = [arrFilterClass count] * 40;
            }
            
            if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
                f = [[UIScreen mainScreen] bounds].size.height / 2;
            }
            
            dropDown = [[TeacherNIDropDown alloc]showDropDown:sender :&f :(NSArray *)arrFilterClass :nil :@"down"];
            dropDown.delegate = self;
            dropDown.tag  = 2;
        }
        else {
            [dropDown hideDropDown:sender];
            dropDown = nil;
        }
    }
}

- (void)niDropDownDelegateMethod: (TeacherNIDropDown *) sender {
    
    dropDown = nil;
    
    if (sender.tag == 1) {
        
        selectedGrade = [arrGrade objectAtIndex:sender.index];
        
        [self filterClass:selectedGrade];
        
        [arrFilterStud removeAllObjects];
        for (NSDictionary *dicValue in arrStudant) {
            
            NSString *gid = [dicValue valueForKey:@"grade"];
            
            if ([gid isEqualToString:selectedGrade]) {
                [arrFilterStud addObject:dicValue];
            }
        }
    }
    
    if (sender.tag == 2) {
        
        selectedClass = [arrFilterClass objectAtIndex:sender.index];
        
        lblClassName.text = [NSString stringWithFormat:@"%@ - %@",[GeneralUtil getLocalizedText:@"LBL_TITLE_CLASS"],selectedClass];
        
        [arrFilterStud removeAllObjects];
        for (NSDictionary *dicValue in arrStudant) {
            
            NSString *cid = [dicValue valueForKey:@"class_name"];
            NSString *gid = [dicValue valueForKey:@"grade"];
            
            if ([gid isEqualToString:selectedGrade] && [cid isEqualToString:selectedClass] ) {
                [arrFilterStud addObject:dicValue];
            }
        }
    }
    
    
    [tblStudantList reloadData];
}

@end
