//
//  ChatListViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/3/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ChatListViewController.h"
#import "BaseViewController.h"
#import "TeacherConstant.h"
#import "TeacherNIDropDown.h"
#import "ChatViewController.h"
#import "CommanTableViewCell.h"
#import "Helper.h"
#import "IQKeyboardManager.h"

@interface ChatListViewController ()<TeacherNIDropDownDelegate>
{
    NSMutableArray *arrStudant;
    NSMutableArray *arrClass;
    NSMutableArray *arrFilterStud;
    NSMutableArray *arrFilterStudSearch;
    NSMutableArray *arrFilterUpdatedStud;
    TeacherUser *userObj;
    TeacherNIDropDown *dropDown;
    
    NSString *selectedClass;
}
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrStudant = [[NSMutableArray alloc] init];
    arrClass = [[NSMutableArray alloc] init];
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];
    arrFilterUpdatedStud = [[NSMutableArray alloc] init];
    
    userObj = [[TeacherUser alloc] init];
    
  //  [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:[GeneralUtil getLocalizedText:@"BTN_DONE_TITLE"]];
    
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_MESSAGES"] WithSel:@selector(btnBackClick)];
    
    [BaseViewController setBackGroud:self];
    [BaseViewController getDropDownBtn:btnClass withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_CLASS"]];
    [BaseViewController getRoundRectTextField:txtSearch withIcon:@"search"];
    
    [btnClass setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    
    [tblStudantList setContentInset:UIEdgeInsetsMake(-70,0,0,0)];
    
    txtSearch.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, txtSearch.frame.size.height)];
    txtSearch.leftViewMode = UITextFieldViewModeAlways;
    
    txtSearch.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH"];
    txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtSearch.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    tblStudantList.rowHeight = UITableViewAutomaticDimension;
    tblStudantList.estimatedRowHeight = 60.0;
    txtSearch.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    txtSearch.text = @"";
    [self getStudantList];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:@"MessageReceived" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [appDelegate.xmppHelper clearBadgeForUser];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)newMessageReceived:(NSNotification *)notification {
    
    NSLog(@"newMessageReceived > Message Data: %@", notification.object);
    
    NSMutableDictionary *message = (NSMutableDictionary *)notification.object;
    
    NSString *from = [message objectForKey:@"sender"];
    
    int index = -1;
    int count = 0;
    for (NSDictionary *dicStudant in arrFilterStud) {
        
        if ([[from lowercaseString] hasPrefix:[[dicStudant valueForKey:@"jid"] lowercaseString]]) {
            index = count;
            break;
        }
        count++;
    }
    
    if (index > 0) {
        
        NSDictionary *dicStudantDetail = [arrFilterStud objectAtIndex:index];
        
        NSArray *paths = [tblStudantList indexPathsForVisibleRows];
        
        for (NSIndexPath *indexpath in paths) {
            if (indexpath.row == index) {
                
                [arrFilterStud removeObjectAtIndex:indexpath.row];
                [tblStudantList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath]  withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        
        [arrFilterStud insertObject:dicStudantDetail atIndex:0];
        
        NSInteger row = 0;//specify a row where you need to add new row
        NSInteger section = 0; //specify the section where the new row to be added,
        //section = 1 here since you need to add row at second section
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [tblStudantList beginUpdates];
        [tblStudantList insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tblStudantList endUpdates];
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
        
        CommanTableViewCell *cell = (CommanTableViewCell *)[tblStudantList cellForRowAtIndexPath:indexPath];
        
        int badgeCnt = [appDelegate.xmppHelper getBadgeForJid:sender :NO];
        
        if(badgeCnt > 0)
            [cell.btnBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
        else
            [cell.btnBadge setBadgeBackgroundColor:[UIColor clearColor]];
    }
}

-(void)btnBackClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getStudantList {
    
    [userObj getStudantList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrFilterStud removeAllObjects];
            [arrFilterStudSearch removeAllObjects];
            [arrClass removeAllObjects];
            [arrFilterUpdatedStud removeAllObjects];
            
            arrStudant = (NSMutableArray *)[dicRes valueForKey:@"result"];
            
            for (NSDictionary *dicCls in [dicRes valueForKey:@"classes"]) {
                //NSMutableArray* arr = [[NSMutableArray alloc] init];
                //[arr addObject:[dicCls valueForKey:@"class_name"]];
                //[arrClass addObjectsFromArray:[arr objectAtIndex:0]];
                [arrClass addObject:[dicCls valueForKey:@"class_name"]];
            }
            
            Helper *obj = [[Helper alloc] init];
            
            NSMutableArray *newstudant  = [obj getReceiveStudant];
            NSMutableArray *remainigStud = [[NSMutableArray alloc] initWithArray:arrStudant];
            
            if ([newstudant count] > 0) {
                
                for (NSDictionary *user in newstudant) {
                    
                    NSString *sJid = [user valueForKey:@"jid"];
    
                    for (NSDictionary *dicStud in arrStudant) {
                        
                        if ([[[dicStud valueForKey:@"jid"] lowercaseString] isEqualToString:[sJid lowercaseString]]) {
                            [arrFilterUpdatedStud addObject:dicStud];
                            [remainigStud removeObject:dicStud];
                            break;
                        }
                    }
                }
            }
            
            arrFilterStud = [NSMutableArray arrayWithArray:arrFilterUpdatedStud];
            [arrFilterStud addObjectsFromArray: remainigStud];
            
            [arrFilterStudSearch addObjectsFromArray:arrFilterStud];
            //for (NSDictionary *dicCls in arrFilterStud) {
            //    [arrFilterStudSearch addObject:dicCls];
            //}
            
            if (selectedClass != nil && ![selectedClass isEqualToString:@""] ) {
                
                [btnClass setTitle:selectedClass forState:UIControlStateNormal];
                
                [arrFilterStud removeAllObjects];
                [arrFilterStudSearch removeAllObjects];
                for (NSDictionary *dicValue in arrStudant) {
                    
                    NSString *cid = [dicValue valueForKey:@"class_name"];
                    
                    if ([cid isEqualToString:selectedClass] ) {
                        [arrFilterStud addObject:dicValue];
                        [arrFilterStudSearch addObject:dicValue];
                    }
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
//        // imgProfile.image = [UIImage imageNamed:@"profile.png"];
//        
//        [BaseViewController setRoudRectImage:imgProfile];
//        
//        lblStudantName = [BaseViewController getRowTitleLable:250 text:@""];
//        lblStudantName.textColor = TEXT_COLOR_CYNA;
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
    
    NSDictionary *dicStudantDetail = [arrFilterStud objectAtIndex:indexPath.row];
    
    cell.lblStudantName.text = [dicStudantDetail valueForKey:@"kid_name"];
    cell.lblClassName.text = [dicStudantDetail valueForKey:@"class_name"];
    
    [cell.imgUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"kid_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    [cell.btnBadge setBadgeBackgroundColor:[UIColor redColor]];

    int badgeCnt = [appDelegate.xmppHelper getBadgeForJid:[dicStudantDetail valueForKey:@"jid"] :NO];
    
    [cell.btnBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [txtSearch resignFirstResponder];
    ChatViewController * vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    vc.studDetail = [arrFilterStud objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

    [appDelegate.xmppHelper clearBadgeForJid:[[arrFilterStud objectAtIndex:indexPath.row] valueForKey:@"jid"]];
}

- (IBAction)btnSelectClassPress:(id)sender {
    
    if(dropDown == nil) {
        CGFloat f = arrClass.count * 40;

        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:sender :&f :(NSArray *)arrClass :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}
- (void)niDropDownDelegateMethod: (TeacherNIDropDown *) sender {
    
    dropDown = nil;
    
    selectedClass = [arrClass objectAtIndex:sender.index];
    [arrFilterStud removeAllObjects];
    [arrFilterStudSearch removeAllObjects];
    for (NSDictionary *dicValue in arrStudant) {
        
        NSString *cid = [dicValue valueForKey:@"class_name"];
        
        if ([cid isEqualToString:selectedClass]) {
            [arrFilterStud addObject:dicValue];
            [arrFilterStudSearch addObject:dicValue];
        }
    }
    [tblStudantList reloadData];
}

-(void)textFieldDidChange:(UITextField*)textField
{
    //searchTextString = textField.text;
    [self updateSearchArray:textField.text];
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray:(NSString *)searchTextString
{
    if (searchTextString.length != 0) {
        arrFilterStud = [NSMutableArray array];
        for ( NSDictionary* item in arrFilterStudSearch ) {
            if ([[[item objectForKey:@"kid_name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
                [arrFilterStud addObject:item];
            }
        }
    } else {
        arrFilterStud = arrFilterStudSearch;
    }
    
    [tblStudantList reloadData];
}
@end
