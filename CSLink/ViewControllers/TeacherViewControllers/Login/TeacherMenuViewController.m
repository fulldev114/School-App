//
//  MenuViewController.m
//  Onjyb
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "TeacherMenuViewController.h"
#import "AppDelegate.h"
#import "TeacherConstant.h"
#import "BaseViewController.h"
#import "TeacherHomeViewController.h"
#import "TeacherSFOHomeViewController.h"
#import "ChatListViewController.h"
#import "StudantListViewController.h"
#import "MyProfileViewController.h"
#import "GroupMessageViewController.h"
#import "RegisterAbsentViewController.h"
#import "ReportViewController.h"
#import "SettingViewController.h"
#import "ContectUsViewController.h"


@interface TeacherMenuViewController ()
{
    NSMutableArray *mainMenu;
    NSMutableArray *subMenu;
    NSMutableArray *subMenuForAdmin;
    
    int selectedindex;
    
    NSIndexPath *preIndexPath;
    
  //  UIButton *btnCheck;
}

@property (nonatomic, strong) NSArray *firstSectionStrings;
@property (nonatomic, strong) NSArray *secondSectionStrings;

@property (nonatomic, strong) NSMutableArray *sectionsArray;

@property (nonatomic, strong) NSMutableIndexSet *expandableSections;

@end

@implementation TeacherMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainMenu=[[NSMutableArray alloc]init];
    
    subMenu=[[NSMutableArray alloc]init];
    subMenuForAdmin=[[NSMutableArray alloc]init];
    
    _sectionsArray = [[NSMutableArray alloc] init];
    
  //  btnCheck = [[UIButton alloc] init];
    
    self.view.backgroundColor = APP_BACKGROUD_COLOR;
    
    [BaseViewController setRoudRectImage:profileImage];
    
    tblMenu.separatorColor = SEPERATOR_COLOR;
    
    profileView.backgroundColor = COLOR_NAVIGATION_BAR;
    
    lblUserName.textColor = [UIColor whiteColor];
    lblUserName.font = FONT_16_SEMIBOLD;
    lblUserName.text = [GeneralUtil getUserPreference:key_UserName];
    
//    _firstSectionStrings = @[ @"Section 0 Row 0", @"Section 0 Row 1", @"Section 0 Row 2", @"Section 0 Row 3" ];
//    _secondSectionStrings = @[ @"Section 1 Row 0", @"Section 1 Row 1", @"Section 1 Row 2", @"Section 1 Row 3", @"Section 1 Row 4" ];
//    
//    _sectionsArray = @[ _firstSectionStrings, _secondSectionStrings ].mutableCopy;
    
    [self populateMenuArray];
    
    for (NSDictionary  *dicMenu in mainMenu) {
        
        if ([[dicMenu valueForKey:@"name"] isEqualToString:@"Report"]) {
            
            for (NSDictionary *dicSubmenu in subMenuForAdmin) {
                
                [[dicMenu valueForKey:@"subMenu"] addObject:dicSubmenu];
            }
        }
        else if ([[dicMenu valueForKey:@"name"] isEqualToString:@"Admin"]) {
            
            for (NSDictionary *dicSubmenu in subMenu) {
                
                if (![[dicSubmenu valueForKey:@"name"] isEqualToString:@"Absent"]) {
                    [[dicMenu valueForKey:@"subMenu"] addObject:dicSubmenu];
                }
            }
        }
        
        [_sectionsArray addObject:dicMenu];
    }
    
    _expandableSections = [NSMutableIndexSet indexSet];
    
    [tblMenu setContentInset:UIEdgeInsetsMake(0,0,6,0)];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:NOTIFICATION_LANGUAGE_CHANGE object:nil];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    
    NSString *version = infoDictionary[@"CFBundleShortVersionString"];
    
    lblVersone.font = FONT_12_REGULER;
    lblVersone.text = [NSString stringWithFormat:@" %@ %@",[GeneralUtil getLocalizedText:@"LBL_VERSON_TITLE"],version];
}

-(void)languageChanged:(NSNotification *)notification {
    [self populateMenuArray];
    [_sectionsArray removeAllObjects];
    
    for (NSDictionary  *dicMenu in mainMenu) {
        
        if ([[dicMenu valueForKey:@"name"] isEqualToString:@"Report"]) {
            
            for (NSDictionary *dicSubmenu in subMenuForAdmin) {
                
                [[dicMenu valueForKey:@"subMenu"] addObject:dicSubmenu];
            }
        }
        else if ([[dicMenu valueForKey:@"name"] isEqualToString:@"Admin"]) {
            
            for (NSDictionary *dicSubmenu in subMenu) {
                
                if (![[dicSubmenu valueForKey:@"name"] isEqualToString:@"Absent"]) {
                    [[dicMenu valueForKey:@"subMenu"] addObject:dicSubmenu];
                }
            }
        }
        
        [_sectionsArray addObject:dicMenu];
    }
    [tblMenu reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [profileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[GeneralUtil getUserPreference:key_UserImage]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    [BaseViewController setRoudRectImage:profileImage];
    
    [self.view endEditing:YES];
    
    [self populateMenuArray];
    [tblMenu reloadData];
}

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    return YES;
//        if (section == 2 || section == 3) {
//        return YES;
//    }
//    return NO;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    return ![self.expandableSections containsIndex:section];
    
   // return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"SLExpandableTableViewControllerHeaderCell_%d", (int)section];
    SLExpandableTableViewControllerHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblTital;
    UIImageView *imgView;
    UIButton *dropDwon;
    UIView *seprator;
    
    if (!cell) {
        cell = [[SLExpandableTableViewControllerHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblTital = [[UILabel alloc] init];
        lblTital.textColor  = TEXT_COLOR_WHITE;
        lblTital.font = FONT_18_SEMIBOLD;
        lblTital.tag = 1001;
        
        imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.tag = 1002;
        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        dropDwon = [[UIButton alloc] init];
        dropDwon.contentMode = UIViewContentModeScaleAspectFit;
        [dropDwon setImage:[UIImage imageNamed:@"dropdown-blue"] forState:UIControlStateSelected];
        [dropDwon setImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
        dropDwon.tag = 5000;
        dropDwon.hidden = YES;
        
        seprator = [[UIView alloc] init];
        seprator.backgroundColor = SEPERATOR_COLOR;
        
        if (IS_IPAD) {
            lblTital.frame = CGRectMake(75, 10, 280, 50);
            imgView.frame = CGRectMake(25,20,30,30);
            dropDwon.frame = CGRectMake(SCREEN_WIDTH - 150 ,15,25,25);
            seprator.frame = CGRectMake(0, 69, ScreenWidth, 1);
        }
        else {
            lblTital.frame = CGRectMake(60, 4, 280, 44);
            imgView.frame = CGRectMake(25,15,20,20);
            dropDwon.frame = CGRectMake(cell.contentView.frame.size.width - 100 ,15,20,20);
            seprator.frame = CGRectMake(0, 54, ScreenWidth, 1);
        }
        
        [cell.contentView addSubview:seprator];
        [cell.contentView addSubview:imgView];
        [cell.contentView addSubview:lblTital];
        [cell.contentView addSubview:dropDwon];
    }
    else {
        lblTital = (UILabel *)[cell.contentView viewWithTag:1001];
        imgView = (UIImageView *)[cell.contentView viewWithTag:1002];
        dropDwon = (UIButton *)[cell.contentView viewWithTag:5000];
    }

    NSDictionary *dicMenu = [_sectionsArray objectAtIndex:section];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    if (preIndexPath && preIndexPath.section == indexPath.section) {
        //[bgColorView setBackgroundColor:RGB(0, 0.18, 0.32)];
        cell.backgroundColor = RGB(0, 0.18, 0.32);
        
        imgView.image = [UIImage imageNamed:[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"img_sel"]];
        lblTital.textColor  = TEXT_COLOR_CYNA;
    }
    else {
        
        if (!preIndexPath && indexPath.section == 0) {
            
            cell.backgroundColor = RGB(0, 0.18, 0.32);
            
            imgView.image = [UIImage imageNamed:[[_sectionsArray objectAtIndex:indexPath.section]valueForKey:@"img_sel"]];
            lblTital.textColor  = TEXT_COLOR_CYNA;
            
            preIndexPath = indexPath;
        }
        else {
            cell.backgroundColor = [UIColor clearColor];
            imgView.image = [UIImage imageNamed:[[_sectionsArray objectAtIndex:indexPath.section]valueForKey:@"img"]];
            lblTital.textColor = [UIColor whiteColor];
        }
    }
    
    lblTital.text = [dicMenu valueForKey:@"title"];
    
    if ([[dicMenu valueForKey:@"name"] isEqualToString:@"Report"] || [[dicMenu valueForKey:@"name"] isEqualToString:@"Admin"] ) {
        dropDwon.hidden = NO;
    }
    
    return cell;
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    UILabel *lblTital;
    UIImageView *imgView;
    SLExpandableTableViewControllerHeaderCell *cell;
    
    if (preIndexPath) {
        
        cell = [tableView cellForRowAtIndexPath:preIndexPath];
        cell.backgroundColor = [UIColor clearColor];
        
        lblTital = (UILabel *)[cell.contentView viewWithTag:1001];
        imgView = (UIImageView *)[cell.contentView viewWithTag:1002];
        
        imgView.image = [UIImage imageNamed:[[_sectionsArray objectAtIndex:preIndexPath.section] valueForKey:@"img"]];
        lblTital.textColor  = [UIColor whiteColor];
    }
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = RGB(0, 0.18, 0.32);
    
    lblTital = (UILabel *)[cell.contentView viewWithTag:1001];
    imgView = (UIImageView *)[cell.contentView viewWithTag:1002];
    
    imgView.image = [UIImage imageNamed:[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"img_sel"]];
    lblTital.textColor  = TEXT_COLOR_CYNA;
    
    ZDebug(@"%@", [_sectionsArray objectAtIndex:indexPath.section]);
    
    if([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"name"] isEqualToString:@"Home"]) {
//        TeacherHomeViewController *vc = [[TeacherHomeViewController alloc] initWithNibName:@"TeacherHomeViewController" bundle:nil];
        TeacherSFOHomeViewController *vc = [[TeacherSFOHomeViewController alloc] initWithNibName:@"TeacherSFOHomeViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"title"] isEqualToString:@"Messages"]) {
        
        ChatListViewController *vc = [[ChatListViewController alloc] initWithNibName:@"ChatListViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"name"] isEqualToString:@"My Profile"]) {
        
        MyProfileViewController *vc = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"title"] isEqualToString:@"Group Message"]) {
        GroupMessageViewController *vc = [[GroupMessageViewController alloc] initWithNibName:@"GroupMessageViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"title"] isEqualToString:@"Register absent"]) {
        RegisterAbsentViewController *vc = [[RegisterAbsentViewController alloc] initWithNibName:@"RegisterAbsentViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    
    else if ([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"title"] isEqualToString:@"Students"]) {
        StudantListViewController *vc = [[StudantListViewController alloc] initWithNibName:@"StudantListViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"name"] isEqualToString:@"Contact Us"]) {
        ContectUsViewController *vc = [[ContectUsViewController alloc] initWithNibName:@"ContectUsViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    
    else if ([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"name"] isEqualToString:@"Setting"]) {
        SettingViewController *vc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    
    if ([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"name"] isEqualToString:@"Logout"]) {
        
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_LOGOUT"] Delegate:self];
    }
    
    else {
        
        if ([[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"name"] isEqualToString:@"Report"] || [[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"name"] isEqualToString:@"Admin"] ) {
        }
        else {
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
                    UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
                    cc.navigationItem.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
                    
                    if ([cc respondsToSelector:@selector(tableView)]) {
                        [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];
                    }
                }
            }];
        }
    }
    
    preIndexPath = indexPath;
    
    if (section == 2 || section == 3) {
          [self.expandableSections addIndex:section];
          [tableView expandSection:section animated:YES];
    }
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
    [self.expandableSections removeIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section > 0) {
//        return 44.0 * 2.0;
//    }
    
    if (IS_IPAD) {
        return 70;
    }
    return 55;
    
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataArray = [[_sectionsArray objectAtIndex:section] valueForKey:@"subMenu"];
    return dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblTital;
    UIImageView *imgView;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = COLOR_NAVIGATION_BAR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblTital = [[UILabel alloc] init];
        lblTital.textColor  = TEXT_COLOR_WHITE;
        lblTital.font = FONT_18_SEMIBOLD;
        lblTital.tag = 2001;
        
        imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.tag = 2002;
        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        
        //seprator = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
       // seprator.backgroundColor = SEPERATOR_COLOR;
        
       // [cell.contentView addSubview:seprator];
        
        if (IS_IPAD) {
            imgView.frame = CGRectMake(45,20,30,30);
            lblTital.frame = CGRectMake(90, 13, 280, 44);
        }
        else {
            imgView.frame = CGRectMake(45,15,20,20);
            lblTital.frame = CGRectMake(80, 4, 280, 44);
        }
        [cell.contentView addSubview:imgView];
        [cell.contentView addSubview:lblTital];
    }
    else {
        lblTital = (UILabel *)[cell.contentView viewWithTag:2001];
        imgView = (UIImageView *)[cell.contentView viewWithTag:2002];
    }
    
    NSArray *dataArray = [[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"subMenu"];
    lblTital.text = [[dataArray objectAtIndex:indexPath.row - 1] valueForKey:@"title"];
    imgView.image = [UIImage imageNamed:[[dataArray objectAtIndex:indexPath.row - 1] valueForKey:@"img"]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        [self.sectionsArray removeObjectAtIndex:indexPath.section];
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [tblMenu collapseSection:indexPath.section animated:YES];
    if ([[[[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"subMenu"] objectAtIndex:indexPath.row - 1] valueForKey:@"name"] isEqualToString:@"Marks"]) {
        ReportViewController *vc = [[ReportViewController alloc] initWithNibName:@"ReportViewController" bundle:nil];
        if (indexPath.section == 2) {
            vc.reportOrAdd = @"VIEW_MARK";
        }
        else {
            vc.reportOrAdd = @"ADD_MARK";
        }
        
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"subMenu"] objectAtIndex:indexPath.row - 1] valueForKey:@"name"] isEqualToString:@"Absent"]) {
        
        ReportViewController *vc = [[ReportViewController alloc] initWithNibName:@"ReportViewController" bundle:nil];
        vc.reportOrAdd = @"VIEW_ABSENT";
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[[[_sectionsArray objectAtIndex:indexPath.section] valueForKey:@"subMenu"] objectAtIndex:indexPath.row - 1] valueForKey:@"name"] isEqualToString:@"Character"]){
        ReportViewController *vc = [[ReportViewController alloc] initWithNibName:@"ReportViewController" bundle:nil];
        if (indexPath.section == 2) {
            vc.reportOrAdd = @"VIEW_CHAR";
        }
        else {
            vc.reportOrAdd = @"ADD_CHAR";
        }
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
            cc.navigationItem.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            
            if ([cc respondsToSelector:@selector(tableView)]) {
                [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];
            }
        }
    }];
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 1) {
        
    }
    else {
        
        [GeneralUtil removeUserPreference:key_My_phoneNumber];
        [GeneralUtil removeUserPreference:key_My_Email];
        [GeneralUtil removeUserPreference:key_sucessLoginNow];
        [GeneralUtil removeUserPreference:key_isfromlogin];
        [GeneralUtil removeUserPreference:key_islogin];
        [GeneralUtil removeUserPreference:key_teacherId];
        [GeneralUtil removeUserPreference:key_schoolId];
        [GeneralUtil removeUserPreference:key_incharge];
        [GeneralUtil removeUserPreference:@"RealPinCode"];
        
        [appDelegate Logout];
    }
}


/*

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataMenu.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *lblTital;
    UIImageView *imgView;
    UIView *seprator;
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
        
        lblTital = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 280, 44)];
        //  seprator = [[UIView alloc] initWithFrame:CGRectMake(0,43,320,1)];
        
        
        seprator.tag = 1003;
        lblTital.tag = 1001;
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25,17,20,20)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.tag = 1002;
        
        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[imgView setTintColor:MENU_TXT_COLOR];
        
        //SET TEXT FONT COLOR
        //[lblTital setTextColor: MENU_TXT_COLOR];
        //[lblTital setFont:SET_MENU_FONT];
        
        [lblTital setBackgroundColor:[UIColor clearColor]];
        [seprator setBackgroundColor:[UIColor blackColor]];
        
        //   [cell.contentView addSubview:seprator];
        [cell.contentView addSubview:imgView];
        [cell.contentView addSubview:lblTital];
        
    }
    else {
        lblTital = (UILabel *)[cell.contentView viewWithTag:1001];
        imgView = (UIImageView *)[cell.contentView viewWithTag:1002];
    }
    
    if (preIndexPath && preIndexPath.row == indexPath.row) {
        //[bgColorView setBackgroundColor:RGB(0, 0.18, 0.32)];
        cell.backgroundColor = RGB(0, 0.18, 0.32);
        
        imgView.image = [UIImage imageNamed:[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"img_sel"]];
        lblTital.textColor  = TEXT_COLOR_CYNA;
    }
    else {
        
        if (!preIndexPath && indexPath.row == 0) {
            
            cell.backgroundColor = RGB(0, 0.18, 0.32);
            
            imgView.image = [UIImage imageNamed:[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"img_sel"]];
            lblTital.textColor  = TEXT_COLOR_CYNA;
            
            preIndexPath = indexPath;
        }
        else {
         cell.backgroundColor = [UIColor clearColor];
        imgView.image = [UIImage imageNamed:[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"img"]];
        lblTital.textColor = [UIColor whiteColor];
        }
    }
    
    lblTital.font = FONT_18_SEMIBOLD;
    lblTital.text = [[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
    
    
    //if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Home"]) {
        lblTital.text = [[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
    
//    }
//    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Messages"]) {
//        lblTital.text = [[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
//        imgView.image = [UIImage imageNamed:@"report-card.png"];
//    }
//    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"My Profile"]) {
//        lblTital.text = [[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
//        imgView.image = [UIImage imageNamed:@"my-profile.png"];
//    }
//    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Group Message"] ) {
//        lblTital.text =[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
//        imgView.image = [UIImage imageNamed:@"report-card.png"];
//    }
//    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Register absent"] ) {
//        lblTital.text =[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
//        imgView.image = [UIImage imageNamed:@"report-card.png"];
//    }
//    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Report"]) {
//        lblTital.text = [[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
//        imgView.image = [UIImage imageNamed:@"character-report.png"];
//    }
//    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Students"]) {
//        lblTital.text = [[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
//          imgView.image = [UIImage imageNamed:@"report-card.png"];
//    }
//    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Setting"]) {
//        lblTital.text = [[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
//        imgView.image = [UIImage imageNamed:@"setting.png"];
//    }
//    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Contact"]) {
//        lblTital.text = [[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
//        imgView.image = [UIImage imageNamed:@"mobile-icon.png"];
//    }
//    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Logout"]) {
//        lblTital.text = [[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"];
//        imgView.image = [UIImage imageNamed:@"logout.png"];
//    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *lblTital;
    UIImageView *imgView;
    UITableViewCell *cell;
    
    if (preIndexPath) {
        cell = [tableView cellForRowAtIndexPath:preIndexPath];
        cell.backgroundColor = [UIColor clearColor];
        
        lblTital = (UILabel *)[cell.contentView viewWithTag:1001];
        imgView = (UIImageView *)[cell.contentView viewWithTag:1002];
        
        imgView.image = [UIImage imageNamed:[[dataMenu objectAtIndex:preIndexPath.row]valueForKey:@"img"]];
        lblTital.textColor  = [UIColor whiteColor];
    }
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = RGB(0, 0.18, 0.32);
    
    
    lblTital = (UILabel *)[cell.contentView viewWithTag:1001];
    imgView = (UIImageView *)[cell.contentView viewWithTag:1002];
    
    imgView.image = [UIImage imageNamed:[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"img_sel"]];
    lblTital.textColor  = TEXT_COLOR_CYNA;
    
    if([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Home"]) {
        HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Messages"]) {
        
        ChatListViewController *vc = [[ChatListViewController alloc] initWithNibName:@"ChatListViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];

    }
    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"My Profile"]) {
        
        MyProfileViewController *vc = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Group Message"]) {
        GroupMessageViewController *vc = [[GroupMessageViewController alloc] initWithNibName:@"GroupMessageViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Register absent"]) {
        RegisterAbsentViewController *vc = [[RegisterAbsentViewController alloc] initWithNibName:@"RegisterAbsentViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Report"]) {
        ReportViewController *vc = [[ReportViewController alloc] initWithNibName:@"ReportViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    
    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Students"]) {
        StudantListViewController *vc = [[StudantListViewController alloc] initWithNibName:@"StudantListViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Contact Us"]) {
        ContectUsViewController *vc = [[ContectUsViewController alloc] initWithNibName:@"ContectUsViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    
    if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Setting"]) {
        SettingViewController *vc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    if ([[[dataMenu objectAtIndex:indexPath.row]valueForKey:@"title"] isEqualToString:@"Logout"]) {
        
        [GeneralUtil removeUserPreference:key_My_phoneNumber];
        [GeneralUtil removeUserPreference:key_My_Email];
        [GeneralUtil removeUserPreference:key_sucessLoginNow];
        [GeneralUtil removeUserPreference:key_isfromlogin];
        [GeneralUtil removeUserPreference:key_islogin];
        [GeneralUtil removeUserPreference:key_teacherId];
        [GeneralUtil removeUserPreference:key_schoolId];
        [GeneralUtil removeUserPreference:key_incharge];
        [GeneralUtil removeUserPreference:@"RealPinCode"];
        
        [appDelegate Logout];
    }
    
    else {
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
                UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
                cc.navigationItem.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
                
                if ([cc respondsToSelector:@selector(tableView)]) {
                    [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];
                }
            }
        }];
    }
    
    preIndexPath = indexPath;
}

-(void)viewDidLayoutSubviews
{
    if ([tblMenu respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblMenu setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblMenu respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblMenu setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
*/

-(void)populateMenuArray{
    
    [mainMenu removeAllObjects];
    
    NSMutableDictionary *val=[[NSMutableDictionary alloc]init];
    
    
    //Add Home
    [val setObject:@"Home" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_HOME"] forKey:@"title"];
    [val setObject:@"home" forKey:@"img"];
    [val setObject:@"home-blue" forKey:@"img_sel"];
    [val setObject:[[NSMutableArray alloc] init] forKey:@"subMenu"];
    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add MESSAGES
    
//    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_MESSAGES"] forKey:@"name"];
//    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_MESSAGES"] forKey:@"title"];
//    [val setObject:@"report-card" forKey:@"img"];
//    [val setObject:@"report-card-blue" forKey:@"img_sel"];
//    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
//    [val removeAllObjects];
    
    //Add PROFILE
    
    [val setObject:@"My Profile" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_PROFILE"] forKey:@"title"];
    [val setObject:@"my-profile" forKey:@"img"];
    [val setObject:@"my-profile-blue" forKey:@"img_sel"];
    [val setObject:[[NSMutableArray alloc] init] forKey:@"subMenu"];
    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add PROFILE
    
//    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_GROUP_MASSAGE"] forKey:@"name"];
//    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_GROUP_MASSAGE"] forKey:@"title"];
//    [val setObject:@"report-card" forKey:@"img"];
//    [val setObject:@"report-card-blue" forKey:@"img_sel"];
//    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
//    [val removeAllObjects];
    
    //Add ABSENT_NOTICE
    
//    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_REGISTER_ABSENT"] forKey:@"name"];
//    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_REGISTER_ABSENT"] forKey:@"title"];
//    [val setObject:@"report-card" forKey:@"img"];
//    [val setObject:@"report-card-blue" forKey:@"img_sel"];
//    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
//    [val removeAllObjects];
    
    //Add REPORT_CARD
    
    [val setObject:@"Report" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_REPORT"] forKey:@"title"];
    [val setObject:@"character-report" forKey:@"img"];
    [val setObject:@"character-report-blue" forKey:@"img_sel"];
    [val setObject:[[NSMutableArray alloc] init] forKey:@"subMenu"];
    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add REPORT_CARD
    
    [val setObject:@"Admin" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_ADMIN"] forKey:@"title"];
    [val setObject:@"admin" forKey:@"img"];
    [val setObject:@"admin-blue" forKey:@"img_sel"];
    [val setObject:[[NSMutableArray alloc] init] forKey:@"subMenu"];
    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add SELECT_STUDANT
    
//    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_STUDENTS"] forKey:@"name"];
//    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_STUDENTS"] forKey:@"title"];
//    [val setObject:@"report-card" forKey:@"img"];
//    [val setObject:@"report-card-blue" forKey:@"img_sel"];
//    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
//    [val removeAllObjects];
    
    //Add SETTING
    
    [val setObject:@"Setting" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_SETTING"] forKey:@"title"];
    [val setObject:@"settings" forKey:@"img"];
    [val setObject:@"settings-blue" forKey:@"img_sel"];
    [val setObject:[[NSMutableArray alloc] init] forKey:@"subMenu"];
    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add CONTACT_US
    
    [val setObject:@"Contact Us" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_CONTACT"] forKey:@"title"];
    [val setObject:@"mobile-icon" forKey:@"img"];
    [val setObject:@"mobile-blue" forKey:@"img_sel"];
    [val setObject:[[NSMutableArray alloc] init] forKey:@"subMenu"];
    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add LOGOUT
    
    [val setObject:@"Logout" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_LOGOUT"] forKey:@"title"];
    [val setObject:@"logout" forKey:@"img"];
    [val setObject:@"logout-blue" forKey:@"img_sel"];
    [val setObject:[[NSMutableArray alloc] init] forKey:@"subMenu"];
//    [mainMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
// ADD SUB MENU
    
    [subMenu removeAllObjects];
    
    //Add Mark
    [val setObject:@"Marks" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_MENU_MARK"] forKey:@"title"];
    [val setObject:@"mark" forKey:@"img"];
    [val setObject:@"mark-blue" forKey:@"img_sel"];
    [subMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add Absent
    [val setObject:@"Absent" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_ABSENT"] forKey:@"title"];
    [val setObject:@"absent" forKey:@"img"];
    [val setObject:@"admin-blue" forKey:@"img_sel"];
    [subMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add Charecter
    [val setObject:@"Character" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_CHARECTER_SIDE_MENU"] forKey:@"title"];
    [val setObject:@"report-card" forKey:@"img"];
    [val setObject:@"report-card-blue" forKey:@"img_sel"];
    [subMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
// ADD SUB MENU FOR ADMIN
    
    [subMenuForAdmin removeAllObjects];
    
    //Add Mark
    [val setObject:@"Marks" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_MENU_MARK"] forKey:@"title"];
    [val setObject:@"mark" forKey:@"img"];
    [val setObject:@"mark-blue" forKey:@"img_sel"];
    [subMenuForAdmin addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add Absent
    [val setObject:@"Absent" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_ABSENT"] forKey:@"title"];
    [val setObject:@"absent" forKey:@"img"];
    [val setObject:@"admin-blue" forKey:@"img_sel"];
    [subMenuForAdmin addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add Charecter
    [val setObject:@"Character" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_CHARECTER_SIDE_MENU"] forKey:@"title"];
    [val setObject:@"report-card" forKey:@"img"];
    [val setObject:@"report-card-blue" forKey:@"img_sel"];
    [subMenuForAdmin addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    [tblMenu reloadData];
}

@end
