//
//  StudantListViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentStudantListViewController.h"
#import "ParentConstant.h"
#import "SchoolListViewController.h"
#import "BaseViewController.h"
#import "ParentUser.h"
#import "ParentCommanTableViewCell.h"

@interface ParentStudantListViewController ()
{
    NSMutableArray *arrStudant;
    ParentUser *userObj;
}
@end

@implementation ParentStudantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrStudant = [[NSMutableArray alloc] init];
    userObj = [[ParentUser alloc] init];
    self.navigationController.navigationBarHidden = NO;
    
    [BaseViewController setBackGroud:self];
    [BaseViewController formateButtonCyne:btnAddNewStudant title:[GeneralUtil getLocalizedText:@"BTN_ADD_NEW_STUDANT_TITLE"]];
    
    if (self.isSelected) {
        [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_SELECT_STUDANT"] WithSel:@selector(menuClick)];
    }
    else {
        [BaseViewController setNavigation:self title:[GeneralUtil getLocalizedText:@"TITLE_SELECT_STUDANT"]];
    }
    
    tblStudantList.rowHeight = UITableViewAutomaticDimension;
    tblStudantList.estimatedRowHeight = 70.0;
    
   self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllChield];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)menuClick {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}
-(void)getAllChield {
    
    [userObj getSelectedStudList:[GeneralUtil getUserPreference:key_parentIdSave] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            arrStudant = [[dicRes valueForKey:key_allchilds] valueForKey:key_childs];
            
            NSMutableArray *arrStudtemp = [[NSMutableArray alloc] init];
            
            for (NSDictionary *stud in arrStudant) {
                
                if ([stud valueForKey:@"sfo_type"] == [NSNull null])
                    [stud setValue:@"0" forKey:@"sfo_type"];

                [arrStudtemp addObject:stud];
            }
            //   NSMutableArray *arrStud = [[NSMutableArray alloc] initWithArray:arrStudtemp];
            
            [GeneralUtil setUserChildPreference:key_saveChild value:arrStudtemp];
            [tblStudantList reloadData];
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
    
    cell.lblStudantName.text = [dicStudantDetail valueForKey:@"child_name"];
    cell.lblClassName.text = [dicStudantDetail valueForKey:@"school_name"];
    
    [BaseViewController setRoudRectImage:cell.imgUser];
    [cell.imgUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
    
    if ([[dicStudantDetail valueForKey:@"parentname"] isEqualToString:@""] || [dicStudantDetail valueForKey:@"parentname"] == nil) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_STUDANT_IS_NOT_ACTIVE"]];
    }
    else {
        
        [appDelegate.xmppHelper disConnect];
        
        appDelegate.curJabberId = [dicStudantDetail objectForKey:@"jid"];
        appDelegate.curJIdwd = [dicStudantDetail objectForKey:@"key"];
        
        [appDelegate connectXmpp:appDelegate.curJabberId];
        
        [GeneralUtil setUserPreference:key_isStudantSelected value:@"Yes"];
        [GeneralUtil setUserChildDetailPreference:key_selectedStudant value:[arrStudant objectAtIndex:indexPath.row]];
        
        //[GeneralUtil setUserPreference:key_abi_badge value:[dicStudantDetail valueForKey:@"abi_badge"]];
        //[GeneralUtil setUserPreference:key_abn_badge value:[dicStudantDetail valueForKey:@"abn_badge"]];
        
        //int total = [[dicStudantDetail valueForKey:@"abi_badge"] intValue] + [[dicStudantDetail valueForKey:@"abn_badge"] intValue];
        
        //[GeneralUtil setUserPreference:key_total_badge value:[NSString stringWithFormat:@"%d",total]];
        
        //NSString *to = [GeneralUtil getUserPreference:key_total_badge];
        
        [appDelegate setParentHomeAsRootView];
    }
}

- (IBAction)btnAddNewStudant:(id)sender {
    
    SchoolListViewController * pvc = [[SchoolListViewController alloc] initWithNibName:@"SchoolListViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
}
@end
