//
//  SelecteStudantViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "SelecteStudantViewController.h"
#import "BaseViewController.h"
#import "ParentUser.h"
#import "ParentStudantListViewController.h"
#import "ParentCommanTableViewCell.h"
#import "StudantDetailViewController.h"

@interface SelecteStudantViewController ()
{
    ParentUser *userObj;
    NSMutableArray *arrSearchStudant;
    NSArray *tempArrStudant;
    UITextField *txfSearchField;
}
@end

@implementation SelecteStudantViewController
@synthesize arrStudant;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    userObj = [[ParentUser alloc] init];
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_SELECT_STUDANT"] WithSel:@selector(backButtonClick)];
    
    lblNoStudant.text = [GeneralUtil getLocalizedText:@"LBL_NO_ANY_STUDANT"];
    lblNoStudant.textColor = TEXT_COLOR_LIGHT_GREEN;
    lblNoStudant.font = FONT_18_SEMIBOLD;

    arrSearchStudant = [[NSMutableArray alloc] init];
    tempArrStudant = [[NSMutableArray alloc] init];
    
    txfSearchField = [searchBox valueForKey:@"_searchField"];
    txfSearchField.tag = 8;
    txfSearchField.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH"];
    [BaseViewController getRoundRectTextField:txfSearchField withIcon:@"searchIcon.png"];
    
    txfSearchField.font = FONT_18_REGULER_FIX;
    
    tblStudant.rowHeight = UITableViewAutomaticDimension;
    tblStudant.estimatedRowHeight = 70.0;
    
    [txfSearchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if ([arrStudant count] <= 0) {
        tblStudant.hidden = YES;
        lblNoStudant.hidden = NO;
        searchBox.hidden = YES;
    }
    
    for (NSDictionary *dicValue in arrStudant) {
        
            [arrSearchStudant addObject:dicValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)backButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrStudant.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ParentCommanTableViewCell";
    
    ParentCommanTableViewCell *cell = (ParentCommanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ParentCommanTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
    
    cell.lblStudantName.text = [dicStudantDetail valueForKey:@"name"];
    cell.lblClassName.text = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"LBL_CLS_NAME_TITLE"],[dicStudantDetail valueForKey:@"class_name"]];
    
    [cell.imgUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [txfSearchField resignFirstResponder];
    
    NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
    
    StudantDetailViewController *custompopup = [[StudantDetailViewController alloc] initWithNibName:@"StudantDetailViewController" bundle:nil andDate:dicStudantDetail];
    custompopup.delegate = self;
    [self presentPopupViewController:custompopup animationType:MJPopupViewAnimationFade];
}

-(void)Done:(NSDictionary *)dicValue {
    
    NSString *pId = [GeneralUtil getUserPreference:key_parentIdSave];
    NSString *cId = [dicValue valueForKey:@"user_id"];
    
    [userObj addStudant:pId studantId:cId :^(NSObject *resObj) {

        [GeneralUtil hideProgress];

        NSDictionary *dicRes = (NSDictionary *)resObj;

        if (dicRes != nil) {

            if ([[dicRes valueForKey:key_flag]isEqualToNumber:[NSNumber numberWithInt:1]])
            {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SUCCESSFULL_STUDANT_ADD"]];
            }
            else if ([[dicRes valueForKey:key_flag]isEqualToNumber:[NSNumber numberWithInt:0]])
            {
//                NSString * strError = [dicRes valueForKey:@"errcode"];
//                if ([strError isEqualToString:@"2"]) {
//
//                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_UNSUCCESSFULL_STUDANT_ADD"]];
//                }
                    [GeneralUtil alertInfo:[dicRes valueForKey:@"msg"]];
            }
//            else {
//                [GeneralUtil alertInfo:[dicRes valueForKey:@"errcode"]];
//            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *viewcontroller = self.navigationController.viewControllers;
    
    ParentStudantListViewController * pvc = [[ParentStudantListViewController alloc] initWithNibName:@"ParentStudantListViewController" bundle:nil];
    
    for (UIViewController *vc in viewcontroller) {
        if ([vc isKindOfClass:[pvc class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
-(void)textFieldDidChange:(UITextField*)textField
{
    //searchTextString = textField.text;
    [self updateSearchArray:textField.text];
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray:(NSString *)searchTextString
{
    NSMutableArray *dummy = [[NSMutableArray alloc] init];
    dummy = arrStudant;
    if (searchTextString.length != 0) {
        arrStudant = [NSMutableArray array];
        for ( NSDictionary* item in arrSearchStudant ) {
            if ([[[item objectForKey:@"name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
                [arrStudant addObject:item];
            }
        }
    } else {
        arrStudant = arrSearchStudant;
    }
    
    [tblStudant reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}
@end
