//
//  SchoolListViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "SchoolListViewController.h"
#import "BaseViewController.h"
#import "ParentUser.h"
#import "ClassAndGradeListViewController.h"

@interface SchoolListViewController ()
{
    NSMutableArray *arrSchoole;
    NSMutableArray *arrSearchSchool;
    NSArray *tempArrSchoole;
    ParentUser *userObj;
    UITextField *txfSearchField;
}
@end

@implementation SchoolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrSchoole = [[NSMutableArray alloc] init];
    userObj = [[ParentUser alloc] init];
    [self getSchoolList];
    
    txtSearchBox.delegate = self;
    txtSearchBox.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH"];
    
    txfSearchField = [searchBox valueForKey:@"_searchField"];
    txfSearchField.tag = 8;
    txfSearchField.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH"];
    [BaseViewController getRoundRectTextField:txfSearchField withIcon:@"searchIcon.png"];
    
    txfSearchField.font = FONT_18_REGULER_FIX;
    
    [BaseViewController setBackGroud:self];
    [BaseViewController getRoundRectTextField:txtSearchBox withIcon:@"searchIcon.png"];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_SELECT_SCHOOL"] WithSel:@selector(backButtonClick)];
    
  //  [tblSchoolList setContentInset:UIEdgeInsetsMake(-70,0,0,0)];
    [txfSearchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getSchoolList {

    [userObj getSchoolList:^(NSObject *resObj) {
    
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            tempArrSchoole = [dicRes valueForKey:@"allClasses"];
            [self fillSchoolList:tempArrSchoole];
            [tblSchoolList  reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)fillSchoolList:(NSArray *)allSchool {

    
    NSMutableArray *arrSchId = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicValue in allSchool) {
        
        if (![arrSchId containsObject:[dicValue valueForKey:@"school_id"]] ) {
            [arrSchoole addObject:dicValue];
            [arrSchId addObject:[dicValue valueForKey:@"school_id"]];
        }
    }
    
    arrSearchSchool = arrSchoole;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrSchoole.count;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    UIImageView *imgSchSybol;
    UILabel *lblSchName;
    UIView *seperator;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        imgSchSybol = [[UIImageView alloc] init];
        imgSchSybol.tag = 100;
        imgSchSybol.contentMode = UIViewContentModeScaleAspectFit;
        imgSchSybol.image = [UIImage imageNamed:@"school-icon.png"];
        
        lblSchName = [BaseViewController getRowTitleLable:SCREEN_WIDTH text:@""];
        lblSchName.font = FONT_17_BOLD;
        lblSchName.tag = 200;
        
        seperator = [[UIView alloc] init];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        if (IS_IPAD) {
            int xPos = 25;
            int yPos = 18;
            imgSchSybol.frame = CGRectMake(xPos, yPos, 45, 45);
            xPos = xPos + imgSchSybol.frame.size.width + 15;
            lblSchName.frame = CGRectMake(xPos, yPos+5, lblSchName.frame.size.width, 40);
            seperator.frame = CGRectMake(xPos, 89, SCREEN_WIDTH, 1);
        }
        else {
            
            int xPos = 25;
            int yPos = 13;
            imgSchSybol.frame = CGRectMake(xPos, yPos, 40, 40);
            xPos = xPos + imgSchSybol.frame.size.width + 15;
            lblSchName.frame = CGRectMake(xPos, yPos, lblSchName.frame.size.width, 40);
            seperator.frame = CGRectMake(xPos, 69, SCREEN_WIDTH, 1);
        }
        
        [cell.contentView addSubview:imgSchSybol];
        [cell.contentView addSubview:lblSchName];
        [cell.contentView addSubview:seperator];
    }
    else {
        lblSchName = (UILabel *)[cell.contentView viewWithTag:200];
    }
    
    NSDictionary *dicStudantDetail = [arrSchoole objectAtIndex:indexPath.row];
    
    lblSchName.text = [dicStudantDetail valueForKey:@"school_name"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassAndGradeListViewController * pvc = [[ClassAndGradeListViewController alloc] initWithNibName:@"ClassAndGradeListViewController" bundle:nil];
    pvc.dicSelectedSchool = [arrSchoole objectAtIndex:indexPath.row];
    pvc.arrSchool = tempArrSchoole;
    [self.navigationController pushViewController:pvc animated:YES];
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
    dummy = arrSchoole;
    if (searchTextString.length != 0) {
        arrSchoole = [NSMutableArray array];
        for ( NSDictionary* item in arrSearchSchool ) {
            if ([[[item objectForKey:@"school_name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
                [arrSchoole addObject:item];
            }
        }
    } else {
        arrSchoole = arrSearchSchool;
    }
    
    [tblSchoolList reloadData];
}
-(void)resignTextView
{
    [txfSearchField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}
@end
