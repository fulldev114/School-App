//
//  MenuViewController.m
//  Onjyb
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentMenuViewController.h"
#import "AppDelegate.h"
#import "ParentConstant.h"
#import "BaseViewController.h"
#import "ParentHomeViewController.h"
#import "ParentMyProfileViewController.h"
#import "ParentChatListViewController.h"
#import "AbsentNoticeListViewController.h"
#import "ParentStudantListViewController.h"
#import "SettingViewController.h"
#import "ParentContectUsViewController.h"
#import "OtherPerentViewController.h"
#import "SendAbsentViewController.h"
#import "StatisticViewController.h"
#import "ParentCharacterReportViewController.h"
#import "ParentReportCardViewController.h"
#import "MIBadgeButton.h"
#import "ParentViewMarksViewController.h"
#import "ParentViewCharecterViewController.h"

@interface ParentMenuViewController ()
{
    NSMutableArray *dataMenu;
    int selectedindex;
    NSIndexPath *preIndexPath;
}
@end

@implementation ParentMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataMenu=[[NSMutableArray alloc]init];
    
    self.view.backgroundColor = APP_BACKGROUD_COLOR;
    
    [profileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    [BaseViewController setRoudRectImage:profileImage];
    
    tblMenu.separatorColor = SEPERATOR_COLOR;
    
    [tblMenu setContentInset:UIEdgeInsetsMake(0,0,6,0)];
    tblMenu.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    profileView.backgroundColor = COLOR_NAVIGATION_BAR;
    
    lblUserName.textColor = [UIColor whiteColor];
    lblUserName.font = FONT_16_SEMIBOLD;
    
    NSDictionary *userDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
    lblUserName.text = [userDetail valueForKey:@"child_name"];
    
   [self populateMenuArray];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:NOTIFICATION_LANGUAGE_CHANGE object:nil];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    
    NSString *version = infoDictionary[@"CFBundleShortVersionString"];
    
    lblVersone.font = FONT_10_REGULER;
    lblVersone.text = [NSString stringWithFormat:@" %@ %@",[GeneralUtil getLocalizedText:@"LBL_VERSON_TITLE"],version];
}

-(void)languageChanged:(NSNotification *)notification {
    [self populateMenuArray];
    [tblMenu reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tblMenu reloadData];
    
    [profileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    [BaseViewController setRoudRectImage:profileImage];
    
    tblMenu.separatorColor = SEPERATOR_COLOR;
    
    profileView.backgroundColor = COLOR_NAVIGATION_BAR;
    
    lblUserName.textColor = [UIColor whiteColor];
    lblUserName.font = FONT_14_SEMIBOLD;
    
    NSDictionary *userDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
    lblUserName.text = [userDetail valueForKey:@"child_name"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataMenu.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (IS_IPAD) {
        return 70;
    }
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *lblTital;
    UIImageView *imgView;
    UIView *seprator;
    MIBadgeButton *badgebtn;
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d%d",(int)indexPath.section,(int)indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        lblTital = [[UILabel alloc] init];
        
        seprator.tag = 1003;
        lblTital.tag = 1001;
        imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.tag = 1002;
        
        imgView.image = [imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        badgebtn = [[MIBadgeButton alloc] init];
        badgebtn.frame = CGRectMake(200, 0, 30, 30);
        badgebtn.tag = 1004;
        
        badgebtn.hidden = YES;
        
        if (IS_IPAD) {
            badgebtn.frame = CGRectMake(270, 3, 30, 30);
        }
        else {
            if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian])
                badgebtn.frame = CGRectMake(210, 0, 30, 30);
            else
                badgebtn.frame = CGRectMake(200, 0, 30, 30);
        }
        
        [lblTital setBackgroundColor:[UIColor clearColor]];
        [seprator setBackgroundColor:[UIColor blackColor]];
        
        [badgebtn setBadgeBackgroundColor:[UIColor redColor]];
        [badgebtn setBadgeEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 10)];
        
        [cell.contentView addSubview:imgView];
        [cell.contentView addSubview:lblTital];
        [cell.contentView addSubview:badgebtn];
        
    }else {
        lblTital = (UILabel *)[cell.contentView viewWithTag:1001];
        imgView = (UIImageView *)[cell.contentView viewWithTag:1002];
        badgebtn = (MIBadgeButton *)[cell.contentView viewWithTag:1004];
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:RGB(0, 0.18, 0.32)];
    [cell setSelectedBackgroundView:bgColorView];
    
    if (IS_IPAD) {
        lblTital.frame = CGRectMake(70, 12, 280, 44);
        imgView.frame = CGRectMake(25,20,30,30);
    }
    else {
        lblTital.frame = CGRectMake(65, 5, 280, 44);
        imgView.frame = CGRectMake(25,17,20,20);
    }
    if (preIndexPath && preIndexPath.row == indexPath.row) {
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
    lblTital.text = [[dataMenu objectAtIndex:indexPath.row] valueForKey:@"title"];
    
    int badgeCnt = [GeneralUtil getBadge:[appDelegate getCurrentChildId] badgeType:key_abn_badge];
    [badgebtn setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
    if ([[[dataMenu objectAtIndex:indexPath.row] valueForKey:@"title"] isEqualToString:[GeneralUtil getLocalizedText:@"TITLE_ABSENT_NOTICE"]]) {
        badgebtn.hidden = NO;
    }
    else {
        badgebtn.hidden = YES;
    }
    
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
    
    
    NSString *selMenuName = [[dataMenu objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    if([selMenuName isEqualToString:@"Home"]) {
         ParentHomeViewController *vc = [[ParentHomeViewController alloc] initWithNibName:@"ParentHomeViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([selMenuName isEqualToString:@"My Profile"]) {
         ParentMyProfileViewController *vc = [[ParentMyProfileViewController alloc] initWithNibName:@"ParentMyProfileViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([selMenuName isEqualToString:@"Character Report"]) {
        
//        CharacterReportViewController *vc = [[CharacterReportViewController alloc] initWithNibName:@"CharacterReportViewController" bundle:nil];
//        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
        
        ParentViewCharecterViewController *vc = [[ParentViewCharecterViewController alloc] initWithNibName:@"ParentViewCharecterViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([selMenuName isEqualToString:@"Absent Notice"]) {
        AbsentNoticeListViewController *vc = [[AbsentNoticeListViewController alloc] initWithNibName:@"AbsentNoticeListViewController" bundle:nil];
        vc.isAbsentNotice = @"YES";
        [GeneralUtil clearBadge:[appDelegate getCurrentChildId] badgeType:key_abn_badge];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([selMenuName isEqualToString:@"Select Student"]) {
        ParentStudantListViewController *vc = [[ParentStudantListViewController alloc] initWithNibName:@"ParentStudantListViewController" bundle:nil];
        vc.isSelected = true;
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([selMenuName isEqualToString:@"Report Card"]) {
        
        ParentViewMarksViewController *vc = [[ParentViewMarksViewController alloc] initWithNibName:@"ParentViewMarksViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
        
//        ReportCardViewController *vc = [[ReportCardViewController alloc] initWithNibName:@"ReportCardViewController" bundle:nil];
//        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([selMenuName isEqualToString:@"Absent Statistics"]) {
        StatisticViewController *vc = [[StatisticViewController alloc] initWithNibName:@"StatisticViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([selMenuName isEqualToString:@"Other Parents"]) {
        OtherPerentViewController *vc = [[OtherPerentViewController alloc] initWithNibName:@"OtherPerentViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([selMenuName isEqualToString:@"Contact Us"]) {
        ParentContectUsViewController *vc = [[ParentContectUsViewController alloc] initWithNibName:@"ParentContectUsViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    else if ([selMenuName isEqualToString:@"Setting"]) {
        SettingViewController *vc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [((UINavigationController *)self.viewDeckController.centerController) pushViewController:vc animated:YES];
    }
    if ([selMenuName isEqualToString:@"Logout"]) {
        
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_LOGOUT"] Delegate:self];
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

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 1) {
        
    }
    else {
        
        [GeneralUtil removeUserPreference:key_myParentNo];
        [GeneralUtil removeUserPreference:key_myParentPhone];
        [GeneralUtil removeUserPreference:key_sucessLoginNow];
        [GeneralUtil removeUserPreference:key_isfromlogin];
        [GeneralUtil removeUserPreference:key_islogin];
        [GeneralUtil removeUserPreference:key_parentIdSave];
        [GeneralUtil removeUserPreference:key_ParentEmail];
        [GeneralUtil removeUserPreference:key_saveParentName];
        [GeneralUtil removeUserPreference:key_UserId];
        [GeneralUtil removeUserPreference:key_saveChild];
        
        [GeneralUtil removeUserPreference:key_ParentStatus];
        [GeneralUtil removeUserPreference:key_isStudantSelected];
        [GeneralUtil removeUserPreference:key_selectedStudant];
        
        [appDelegate Logout];
    }
}

-(void)populateMenuArray {
    
    [dataMenu removeAllObjects];
    
    NSMutableDictionary *val = [[NSMutableDictionary alloc]init];
    
    //Add Home
    [val setObject:@"Home" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_HOME"] forKey:@"title"];
    [val setObject:@"home" forKey:@"img"];
    [val setObject:@"home-blue" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add PROFILE
    
    [val setObject:@"My Profile" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_PROFILE"] forKey:@"title"];
    [val setObject:@"my-profile" forKey:@"img"];
    [val setObject:@"my-profile-blue" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add ABSENT_NOTICE
    
    [val setObject:@"Absent Notice" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_ABSENT_NOTICE"] forKey:@"title"];
    [val setObject:@"Fmessage" forKey:@"img"];
    [val setObject:@"Fmessage" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add SELECT_STUDANT
    
    [val setObject:@"Select Student" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_SELECT_STUDANT"] forKey:@"title"];
    [val setObject:@"select-student" forKey:@"img"];
    [val setObject:@"select-student-blue" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add CHARACTER_REPORT
    
    [val setObject:@"Character Report" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_CHARACTER_REPORT"] forKey:@"title"];
    [val setObject:@"character-report" forKey:@"img"];
    [val setObject:@"character-report-blue" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];

//    //Add REPORT_CARD
    
    [val setObject:@"Report Card" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_MARKS_REPORT"] forKey:@"title"];
    [val setObject:@"report-card" forKey:@"img"];
    [val setObject:@"report-card-blue" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add STATISTICS
    
    [val setObject:@"Absent Statistics" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_STATISTICS"] forKey:@"title"];
    [val setObject:@"statistics" forKey:@"img"];
    [val setObject:@"statistics-blue" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add OTHER_PARANTS
    
    [val setObject:@"Other Parents" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_OTHER_PARANTS"] forKey:@"title"];
    [val setObject:@"other-parents" forKey:@"img"];
    [val setObject:@"other-parents-blue" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add CONTACT_US
    
    [val setObject:@"Contact Us" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_CONTACT_US"] forKey:@"title"];
    [val setObject:@"mobile-icon" forKey:@"img"];
    [val setObject:@"mobile-blue" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add SETTING
    
    [val setObject:@"Setting" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_SETTING"] forKey:@"title"];
    [val setObject:@"settings" forKey:@"img"];
    [val setObject:@"settings-blue" forKey:@"img_sel"];
    [dataMenu addObject:[NSDictionary dictionaryWithDictionary:val]];
    [val removeAllObjects];
    
    //Add LOGOUT
    
    [val setObject:@"Logout" forKey:@"name"];
    [val setObject:[GeneralUtil getLocalizedText:@"TITLE_LOGOUT"] forKey:@"title"];
    [val setObject:@"logout" forKey:@"img"];
    [val setObject:@"logout-blue" forKey:@"img_sel"];
    [val removeAllObjects];
    
    [tblMenu reloadData];
}

@end
