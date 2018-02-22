//
//  TeacherMessageViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/24/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "TeacherMessageViewController.h"
#import "BaseViewController.h"
#import "CommanTableViewCell.h"
#import "ChatViewController.h"
#import "Helper.h"
#import "TeacherUser.h"

@interface TeacherMessageViewController ()
{
    NSMutableArray *arrTeacher;
    NSMutableArray *arrFilterTeacher;
    TeacherUser *userObj;
    ParentUser *pUserObj;

}
@end

@implementation TeacherMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:@"MessageReceived" object:nil];
    
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_TEACHERS"] WithSel:@selector(btnBackClick)];
    
    userObj = [[TeacherUser alloc] init];
    pUserObj = [[ParentUser alloc] init];
    
    tblTeacherList.rowHeight = UITableViewAutomaticDimension;
    tblTeacherList.estimatedRowHeight = 70.0;
    
    arrTeacher = [[NSMutableArray alloc] init];
    arrFilterTeacher = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)btnBackClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.bTeacherMode)
        [self getAllTeacher];
    else
        [self getChildAllTeacher];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:@"MessageReceived" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [appDelegate.xmppHelper clearBadgeForTeacher];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)getChildAllTeacher {
    
    [pUserObj getTeacherList:[[GeneralUtil getUserPreference:key_selectedStudant] valueForKey:@"school_class_id"] userid:[[GeneralUtil getUserPreference:key_selectedStudant] valueForKey:@"user_id"] :^(NSObject *resObj) {
        
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
            
            [tblTeacherList  reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];

}

-(void)getAllTeacher {
    
    [userObj getAllTeacherList:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        [arrFilterTeacher removeAllObjects];
        [arrTeacher removeAllObjects];
        
        if (dicRes != nil) {
            NSArray *tempArrTeacher = [dicRes valueForKey:@"teacherDetails"];
            
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
            [tblTeacherList reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
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
        
        NSArray *paths = [tblTeacherList indexPathsForVisibleRows];
        
        for (NSIndexPath *indexpath in paths) {
            if (indexpath.row == index) {
                
                [arrTeacher removeObjectAtIndex:indexpath.row];
                [tblTeacherList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath]  withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        
        [arrTeacher insertObject:dicStudantDetail atIndex:0];
        
        NSInteger row = 0;//specify a row where you need to add new row
        NSInteger section = 0; //specify the section where the new row to be added,
        //section = 1 here since you need to add row at second section
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [tblTeacherList beginUpdates];
        [tblTeacherList insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tblTeacherList endUpdates];
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
        
        CommanTableViewCell *cell = (CommanTableViewCell *)[tblTeacherList cellForRowAtIndexPath:indexPath];
        
        [cell.btnBadge setBadgeBackgroundColor:[UIColor redColor]];
        
        int badgeCnt = [appDelegate.xmppHelper getBadgeForJid:sender :YES];
        
        [cell.btnBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrTeacher.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CommanTableViewCell";
    
    CommanTableViewCell *cell = (CommanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"CommanTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    static NSString *simpleTableIdentifier = @"SimpleTableItem";
//    
//    UIImageView *imgProfile;
//    UILabel *lblStudantName,*lblClassName;
//    UIView *seperator;
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
//        
//        cell.backgroundColor = [UIColor clearColor];
//        
//        imgProfile = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 40, 40)];
//        imgProfile.tag = 100;
//        imgProfile.contentMode = UIViewContentModeScaleAspectFit;
//        imgProfile.image = [UIImage imageNamed:@"profile.png"];
//        
//        [BaseViewController setRoudRectImage:imgProfile];
//        
//        lblStudantName = [BaseViewController getRowTitleLable:250 text:@""];
//        lblStudantName.tag = 200;
//        
//        lblClassName = [BaseViewController  getRowDetailLable:250 text:@""];
//        lblClassName.frame = CGRectMake(75, 27, lblClassName.frame.size.width, 40);
//        lblClassName.tag = 300;
//        
//        seperator = [[UIView alloc] initWithFrame:CGRectMake(75, 69, cell.frame.size.width, 1)];
//        seperator.backgroundColor = SEPERATOR_COLOR;
//        
//        [cell.contentView addSubview:imgProfile];
//        [cell.contentView addSubview:lblStudantName];
//        [cell.contentView addSubview:lblClassName];
//        [cell.contentView addSubview:seperator];
//    }
//    else {
//        lblStudantName = (UILabel *)[cell.contentView viewWithTag:200];
//        lblClassName = (UILabel *)[cell.contentView viewWithTag:300];
//    }
    
    NSDictionary *dicStudantDetail = [arrTeacher objectAtIndex:indexPath.row];
    
    cell.lblStudantName.text = [dicStudantDetail valueForKey:@"name"];
    cell.lblClassName.text = [dicStudantDetail valueForKey:@"emailaddress"];
    
  //  cell.lblClassName.backgroundColor = [UIColor redColor];
    
    [cell.btnBadge setBadgeBackgroundColor:[UIColor redColor]];
    
    int badgeCnt = [appDelegate.xmppHelper getBadgeForJid:[dicStudantDetail valueForKey:@"jid"] :YES];
    
    [cell.btnBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
   
    [cell.imgUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *studDetail = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *teacherDetail = [arrTeacher objectAtIndex:indexPath.row];
//    [teacherDetail valueForKey:@"jid"]
//    [teacherDetail valueForKey:@"name"]
//    [teacherDetail valueForKey:@"emailaddress"]
//    [teacherDetail valueForKey:@"image"]
    
    [studDetail setObject:[teacherDetail valueForKey:@"jid"] forKey:@"jid"];
    [studDetail setObject:[teacherDetail valueForKey:@"name"] forKey:@"kid_name"];
   // [studDetail setObject:[teacherDetail valueForKey:@"emailaddress"] forKey:@"class_name"];
    [studDetail setObject:@"" forKey:@"class_name"];
    [studDetail setObject:[teacherDetail valueForKey:@"image"] forKey:@"kid_image"];
    
    ChatViewController * vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    vc.studDetail = studDetail;
    vc.isTeacher = true;
    [self.navigationController pushViewController:vc animated:YES];
        
    [appDelegate.xmppHelper clearBadgeForJid:[[arrTeacher objectAtIndex:indexPath.row] valueForKey:@"jid"]];
    
//    TeacherChatViewController * vc = [[TeacherChatViewController alloc] initWithNibName:@"TeacherChatViewController" bundle:nil];
//    vc.teacherDetail = [arrStudant objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}
@end
