//
//  SelecteGroupForEmgViewController.m
//  CSAdmin
//
//  Created by etech-dev on 3/29/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "SelecteGroupForEmgViewController.h"
#import "BaseViewController.h"
#import "TeacherUser.h"

@interface SelecteGroupForEmgViewController ()
{
    NSString *seletedGroupId;
    TeacherUser *userObj;
    
    NSMutableArray *arrAllgroups;
    NSMutableIndexSet *expandableSections;
}
@end

@implementation SelecteGroupForEmgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_EMERGANCY_MESSAGE"] WithSel:@selector(backButtonClick)];
    
    [BaseViewController formateButton:btnSelecteAllGroup withBackgourdColor:[UIColor clearColor] withTextColor:TEXT_COLOR_WHITE title:[GeneralUtil getLocalizedText:@"BTN_SEND_MSG_TO_ALL_TITLE"]];
    lblOr.font = FONT_18_SEMIBOLD;
    lblOr.textColor = TEXT_COLOR_CYNA;
    lblOr.text = [GeneralUtil getLocalizedText:@"LBL_OR_TITLE"];
    seperateView1.backgroundColor = TEXT_COLOR_CYNA;
    seperateView2.backgroundColor = TEXT_COLOR_CYNA;
    
    [BaseViewController formateButtonCyne:btnSend title:[GeneralUtil getLocalizedText:@"BTN_SEND_MESSAGE_TITLE"]];
    [BaseViewController formateButton:btnCencel withColor:TEXT_COLOR_CYNA title:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]];
    
    userObj = [[TeacherUser alloc] init];
    arrAllgroups = [[NSMutableArray alloc] init];
    expandableSections = [NSMutableIndexSet indexSet];
    
    [self getAllGroupOfSchool];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSendPress:(id)sender {
    
     [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_EMERGANCY_ALERT_MSG_TITLE"] Delegate:self];
}

- (IBAction)btnCancelPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSelecteAlllGroupPress:(id)sender {
    
    btnSelecteAllGroup.selected = !btnSelecteAllGroup.selected;
    
    if (btnSelecteAllGroup.selected) {
        seletedGroupId = @"selected";
        [self makeFormetedValue:arrAllgroups];
    }
    else {
        seletedGroupId = @"Not selected";
    }
    
    ZDebug(@"%@", seletedGroupId);
}

-(void)getAllGroupOfSchool {

    [userObj getAllGroupOfSchool:[GeneralUtil getUserPreference:key_schoolId] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        [arrAllgroups removeAllObjects];
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
           NSMutableArray *tempArrAllgroups = [dicRes valueForKey:@"groups"];
            
            [self makeFormetedValue:tempArrAllgroups];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

#pragma mark - SLExpandableTableViewDatasource

-(void)makeFormetedValue:(NSMutableArray *)ArrAllgroups{
    
    for (NSDictionary *dicValue in ArrAllgroups) {
        
        NSMutableDictionary *dicGroup = [dicValue mutableCopy];
        [dicGroup setObject:@"0" forKey:@"selected"];
        
        NSMutableArray *arrMember = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dicMember in [dicValue valueForKey:@"group_mobile"]) {
            
            NSMutableDictionary *dicMemValue = [dicMember mutableCopy];
            [dicMemValue setObject:@"0" forKey:@"selected"];
            
            [arrMember addObject:dicMemValue];
        }
        
        [dicGroup setObject:arrMember forKey:@"group_mobile"];
        [arrAllgroups addObject:dicGroup];
    }
    
    [tblGroupList reloadData];
}

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"SLExpandableTableViewControllerHeaderCell";
    SLExpandableTableViewControllerHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblGroupName;
    UIButton *btnCheck;
    UIView *seperator;
    
    if (!cell) {
        
        cell = [[SLExpandableTableViewControllerHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
        [btnCheck addTarget:self action:@selector(btnCheckPress:) forControlEvents:UIControlEventTouchUpInside];
        [btnCheck setImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateSelected];
        [btnCheck setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        btnCheck.tag = 500;
        
        lblGroupName = [BaseViewController  getRowDetailLable:200 text:@""];
        lblGroupName.textColor = TEXT_COLOR_LIGHT_GREEN;
        lblGroupName.font = FONT_18_BOLD;
        lblGroupName.frame = CGRectMake(btnCheck.frame.origin.y + btnCheck.frame.size.width, 0, lblGroupName.frame.size.width, 40);
        lblGroupName.tag = 300;
        
        seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        [cell.contentView addSubview:seperator];
        [cell.contentView addSubview:lblGroupName];
        [cell.contentView addSubview:btnCheck];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        
        lblGroupName = (UILabel *)[cell.contentView viewWithTag:300];
        btnCheck = (UIButton *)[cell.contentView viewWithTag:500];
    }
    
    NSDictionary *dicClass = [arrAllgroups objectAtIndex:section];
    
    lblGroupName.text = [dicClass valueForKey:@"group_name"];
    
    NSString *strName = [dicClass valueForKey:@"group_name"];
    
    CGSize maximumSize = CGSizeMake(200, CGFLOAT_MAX);
    
    CGSize expectedLabelSize = [strName sizeWithFont:lblGroupName.font
                                   constrainedToSize:maximumSize
                                       lineBreakMode:lblGroupName.lineBreakMode];
    
    
    lblGroupName.frame = CGRectMake(btnCheck.frame.origin.y + btnCheck.frame.size.width + 10, 0, expectedLabelSize.width, 40);
    
    if ([[dicClass valueForKey:@"selected"] isEqualToString:@"1"]) {
        [btnCheck setSelected:YES];
    }
    else {
        [btnCheck setSelected:NO];
    }
    
    //    NSDictionary *dicClass = [sectionsArray objectAtIndex:section];
    //
    //    cell.textLabel.text = [dicClass valueForKey:@"name"];//[NSString stringWithFormat:@"Section %ld", (long)section];
    
    return cell;
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    [expandableSections addIndex:section];
    [tableView expandSection:section animated:YES];
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
    [expandableSections removeIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section > 0) {
    //
    //    }
    
    if (indexPath.row == 0) {
        return 60;
    }
    else {
        return 50;
    }
    //return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrAllgroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataArray = [[arrAllgroups objectAtIndex:section] valueForKey:@"group_mobile"];
    return dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblMemberName;
    UIButton *btnCheck;
    UIView *seperator;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        lblMemberName = [BaseViewController  getRowDetailLable:250 text:@""];
        lblMemberName.textColor = TEXT_COLOR_WHITE;
        lblMemberName.font = FONT_18_SEMIBOLD;
        lblMemberName.frame = CGRectMake(30, 0, lblMemberName.frame.size.width, 40);
        lblMemberName.tag = 700;
        
        btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 10, 25, 25)];
        [btnCheck setImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateSelected];
        [btnCheck setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [btnCheck addTarget:self action:@selector(btnSelectePress:) forControlEvents:UIControlEventTouchUpInside];
        btnCheck.tag = indexPath.row;
        
        seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        [cell.contentView addSubview:seperator];
        [cell.contentView addSubview:lblMemberName];
        [cell.contentView addSubview:btnCheck];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        
        lblMemberName = (UILabel *)[cell.contentView viewWithTag:700];
        btnCheck = (UIButton *)[cell.contentView viewWithTag:indexPath.row];
        
    }
    NSArray *dataArray = [[arrAllgroups objectAtIndex:indexPath.section] valueForKey:@"group_mobile"];
    
    lblMemberName.text = [[dataArray objectAtIndex:indexPath.row - 1] valueForKey:@"gm_name"];
    
    if ([[[dataArray objectAtIndex:indexPath.row - 1] valueForKey:@"selected"] isEqualToString:@"1"]) {
        [btnCheck setSelected:YES];
    }
    else {
        [btnCheck setSelected:NO];
    }
    
    ZDebug(@"%@", [[dataArray objectAtIndex:indexPath.row - 1] valueForKey:@"gm_name"]);
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [arrAllgroups removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)btnSelectePress:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (btnSelecteAllGroup.selected) {
        btnSelecteAllGroup.selected = NO;
    }
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tblGroupList]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [tblGroupList indexPathForRowAtPoint:touchPoint];

    [[arrAllgroups objectAtIndex:clickedButtonIndexPath.section] setObject:@"0" forKey:@"selected"];
    
    NSArray *dataArray = [[arrAllgroups objectAtIndex:clickedButtonIndexPath.section] valueForKey:@"group_mobile"];
    
    [[dataArray objectAtIndex:clickedButtonIndexPath.row - 1] setObject:@"1" forKey:@"selected"];
    
    [tblGroupList reloadRowsAtIndexPaths:[NSArray arrayWithObjects:clickedButtonIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [tblGroupList reloadSections:[NSIndexSet indexSetWithIndex:clickedButtonIndexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
  //  [tblGroupList reloadData];
}

-(void)btnCheckPress:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    
    if (btnSelecteAllGroup.selected) {
        btnSelecteAllGroup.selected = NO;
    }
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tblGroupList]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [tblGroupList indexPathForRowAtPoint:touchPoint];
    
    [[arrAllgroups objectAtIndex:clickedButtonIndexPath.section] setObject:@"1" forKey:@"selected"];
    
    NSArray *dataArray = [[arrAllgroups objectAtIndex:clickedButtonIndexPath.section] valueForKey:@"group_mobile"];

//    for (int i = 0; i < dataArray.count - 1 ; i++) {
//        [[dataArray objectAtIndex:i] setObject:@"0" forKey:@"selected"];
//    }
    
    NSMutableArray *allCell = [[NSMutableArray alloc] init];
    
    for (int i = 1 ; i <= dataArray.count; i++) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:clickedButtonIndexPath.section];
        [[dataArray objectAtIndex:i - 1] setObject:@"0" forKey:@"selected"];
        [allCell addObject:path];
    }

    [tblGroupList reloadSections:[NSIndexSet indexSetWithIndex:clickedButtonIndexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    [tblGroupList reloadRowsAtIndexPaths:(NSArray *)allCell withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 1) {
        
    }
    else {
        
        // [self sendMesaage:self.Msg];
    }
}

-(void)sendMesaage:(NSString *)msg {
    
    NSString *groupId = @"";
    NSString *memberId = @"";
    
    NSString *tempClaId;
    
    // NSArray *dtail = sectionsArray;
    
    
    for (NSDictionary *dicValue in arrAllgroups) {
        
        if (btnSelecteAllGroup.selected) {
            tempClaId = [dicValue valueForKey:@"group_id"];
            groupId = [groupId stringByAppendingFormat:@"%@,",[dicValue valueForKey:@"group_id"]];
        }
        else {
            if ([[dicValue valueForKey:@"selected"] isEqualToString:@"1"]) {
                tempClaId = [dicValue valueForKey:@"group_id"];
                groupId = [groupId stringByAppendingFormat:@"%@,",[dicValue valueForKey:@"group_id"]];
            }
            else if ([[dicValue valueForKey:@"selected"] isEqualToString:@"0"]) {
                
                for (NSDictionary *dicVal in [dicValue valueForKey:@"Studant"]) {
                    memberId = [memberId stringByAppendingFormat:@"%@,",[dicVal valueForKey:@"gm_id"]];
                    groupId = [groupId stringByAppendingFormat:@"%@,",[dicValue valueForKey:@"class_id"]];
                }
            }
        }
    }
    
    ZDebug(@"Class ID :%@", groupId);
    ZDebug(@"stud ID :%@", memberId);
    
    if ([groupId isEqualToString:@""] && [memberId isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_ANY_GROUP_OR_MEMBER"]];
    }
    else {
        
    [userObj sendEmgMessage:[GeneralUtil getUserPreference:key_teacherId]  groupid:groupId memberid:memberId message:msg :^(NSObject *resObj) {
    
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_MESSAGE_SEND_SUCCESS"]];
                
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
    }
}

@end
