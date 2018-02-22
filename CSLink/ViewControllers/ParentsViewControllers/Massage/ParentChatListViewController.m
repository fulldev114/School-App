//
//  ChatListViewController.m
//  CSLink
//
//  Created by etech-dev on 6/3/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentChatListViewController.h"
#import "ParentConstant.h"
#import "ParentUser.h"
#import "BaseViewController.h"
#import "ParentChatViewController.h"
#import "MIBadgeButton.h"
#import "Helper.h"

@interface ParentChatListViewController ()
{
    NSMutableArray *arrTeacher;
    NSMutableArray *arrFilterTeacher;
    ParentUser *userObj;
}
@end

@implementation ParentChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrTeacher = [[NSMutableArray alloc] init];
    arrFilterTeacher = [[NSMutableArray alloc] init];
    userObj = [[ParentUser alloc] init];
    
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_MASSAGE"] WithSel:@selector(btnBackClick)];
    
    UIImageView *selectedStud = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    selectedStud.contentMode = UIViewContentModeScaleAspectFit;
    
    [BaseViewController setRoudRectImage:selectedStud];
    [selectedStud setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithCustomView:selectedStud];
    
    self.navigationItem.rightBarButtonItem = btnRight;
    
    [BaseViewController setBackGroud:self];
}

-(void)btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllChield];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:@"MessageReceived" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)newMessageReceived:(NSNotification *)notification {
    
    NSLog(@"newMessageReceived > Message Data: %@", notification.object);
    
    NSMutableDictionary *message = (NSMutableDictionary *)notification.object;
    
    NSString *from = [message objectForKey:@"sender"];
    
    int index = -1;
    
    int count = 0;
    
    for (NSDictionary *dicStudant in arrTeacher) {
        
        if ([[from lowercaseString] hasPrefix:[[dicStudant valueForKey:@"jid"] lowercaseString]]) {
            index = count;
            break;
        }
        count++;
    }
    
    if (index > 0) {
        
        NSDictionary *dicStudantDetail = [arrTeacher objectAtIndex:index];
        
        NSArray *paths = [tblChatList indexPathsForVisibleRows];
        
        for (NSIndexPath *indexpath in paths) {
            if (indexpath.row == index) {
                
                [arrTeacher removeObjectAtIndex:indexpath.row];
                [tblChatList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath]  withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        
        [arrTeacher insertObject:dicStudantDetail atIndex:0];
        
        NSInteger row = 0;//specify a row where you need to add new row
        NSInteger section = 0; //specify the section where the new row to be added,
        //section = 1 here since you need to add row at second section
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [tblChatList beginUpdates];
        [tblChatList insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tblChatList endUpdates];
        
    }
    else {
        
        NSRange range= [from rangeOfString: @"/" options: NSBackwardsSearch];
        
        NSString *sender = @"";
        if(range.location == NSNotFound) {
            
        }
        else {
            sender = [[from substringToIndex: range.location] lowercaseString];
        }
        
        NSInteger row = 0;//specify a row where you need to add new row
        NSInteger section = 0; //specify the section where the new row to be added,
        //section = 1 here since you need to add row at second section
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        UITableViewCell *cell = (UITableViewCell *)[tblChatList cellForRowAtIndexPath:indexPath];
        
        MIBadgeButton *btnBadge = (MIBadgeButton *)[cell.contentView viewWithTag:800];
        
        int badgeCnt = [appDelegate.xmppHelper getBadgeForJid:sender];
        
        [btnBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    }
}

- (void)reloadData:(NSString *)from{
    
}

-(void)getAllChield {
    
    [userObj getTeacherList:[[GeneralUtil getUserPreference:key_selectedStudant] valueForKey:@"school_class_id"] userid:[[GeneralUtil getUserPreference:key_selectedStudant] valueForKey:@"user_id"] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        [arrFilterTeacher removeAllObjects];
        [arrTeacher removeAllObjects];
        
        if (dicRes != nil) {
            
           NSArray *tempArrTeacher = [[dicRes valueForKey:@"All Teachers"] valueForKey:@"teachers"];
            
            Helper *obj = [[Helper alloc] init];
            
            NSMutableArray *newstudant  = [obj getReceiveStudant];
            NSMutableArray *remainigStud = [[NSMutableArray alloc] initWithArray:tempArrTeacher];
            
            if ([newstudant count] > 0) {
                
                for (NSDictionary *user in newstudant) {
                    
                    NSString *sJid = [user valueForKey:@"jid"];
                    
                    for (NSDictionary *dicStud in tempArrTeacher) {
                        
                        if ([[[dicStud valueForKey:@"jid"] lowercaseString] isEqualToString:[sJid lowercaseString]]) {
                            [arrFilterTeacher addObject:dicStud];
                            [remainigStud removeObject:dicStud];
                            break;
                        }
                    }
                }
            }
            
            arrTeacher = [NSMutableArray arrayWithArray:arrFilterTeacher];
            [arrTeacher addObjectsFromArray: remainigStud];
            
            [tblChatList  reloadData];
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
    return arrTeacher.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (IS_IPAD) {
        return 90;
    }
    else {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UIImageView *imgProfile;
    UILabel *lblStudantName,*lblClassName;
    UIView *seperator;
    MIBadgeButton *btnBadge;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        imgProfile = [[UIImageView alloc] init];
        imgProfile.tag = 100;
        imgProfile.contentMode = UIViewContentModeScaleAspectFit;
        
        lblStudantName = [BaseViewController getRowTitleLable:250 text:@""];
        lblStudantName.textColor = TEXT_COLOR_CYNA;
        lblStudantName.font = FONT_17_BOLD;
        lblStudantName.tag = 200;
        
        lblClassName = [BaseViewController  getRowDetailLable:250 text:@""];
        lblClassName.frame = CGRectMake(75, 27, 230, 40);
        lblClassName.font = FONT_16_BOLD;
        lblClassName.tag = 300;
        
        btnBadge = [[MIBadgeButton alloc] init];
        btnBadge.tag = 800;
        
        seperator = [[UIView alloc] init];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        if (IS_IPAD) {
            imgProfile.frame = CGRectMake(20, 15, 60, 60);
            lblStudantName.frame = CGRectMake(95, 5, SCREEN_WIDTH - 100, 50);
            lblClassName.frame = CGRectMake(95, 40, SCREEN_WIDTH - 100, 40);
            btnBadge.frame = CGRectMake(SCREEN_WIDTH - 100, 35, 20, 30);
            seperator.frame = CGRectMake(85, 89, SCREEN_WIDTH, 1);
        }
        else {
            imgProfile.frame = CGRectMake(20, 15, 40, 40);
            lblStudantName.frame = CGRectMake(75, 5, 230, 40);
            lblClassName.frame = CGRectMake(75, 27, 230, 40);
            btnBadge.frame = CGRectMake(SCREEN_WIDTH - 50, 35, 20, 30);
            seperator.frame = CGRectMake(75, 69, SCREEN_WIDTH, 1);
        }
        
        [BaseViewController setRoudRectImage:imgProfile];
        
        [cell.contentView addSubview:imgProfile];
        [cell.contentView addSubview:lblStudantName];
        [cell.contentView addSubview:lblClassName];
        [cell.contentView addSubview:btnBadge];
        [cell.contentView addSubview:seperator];
    }
    else {
        imgProfile = (UIImageView *)[cell.contentView viewWithTag:100];
        lblStudantName = (UILabel *)[cell.contentView viewWithTag:200];
        lblClassName = (UILabel *)[cell.contentView viewWithTag:300];
        btnBadge = (MIBadgeButton *)[cell.contentView viewWithTag:800];
    }
    
    NSDictionary *dicStudantDetail = [arrTeacher objectAtIndex:indexPath.row];
    
    lblStudantName.text = [dicStudantDetail valueForKey:@"name"];
    lblClassName.text = [dicStudantDetail valueForKey:@"subject_name"];
    
    [btnBadge setBadgeBackgroundColor:[UIColor redColor]];
    
    int badgeCnt = [appDelegate.xmppHelper getBadgeForJid:[dicStudantDetail valueForKey:@"jid"]];
    
    [btnBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
    [imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ParentChatViewController * vc = [[ParentChatViewController alloc] initWithNibName:@"ParentChatViewController" bundle:nil];
    vc.teacherDetail = [arrTeacher objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
    [appDelegate.xmppHelper clearBadgeForJid:[[arrTeacher objectAtIndex:indexPath.row] valueForKey:@"jid"]];
}

@end
