//
//  SFOItemViewController.m
//  CSLink
//
//  Created by adamlucas on 5/28/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "SFOItemViewController.h"
#import "BaseViewController.h"
#import "ItemTableViewCell.h"
#import "TeacherUser.h"


@interface SFOItemViewController ()

@end

@implementation SFOItemViewController
{
    NSMutableArray *arrStudant;
    TeacherUser *userObj;
    UITextField *searchTextField;
    NSMutableArray *arrFilterStud;
    NSMutableArray *arrFilterStudSearch;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    userObj = [[TeacherUser alloc] init];
    
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_SFO"] titleColor:TEXT_COLOR_GREEN WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];
	
    searchTextField = [self.searchBar valueForKey:@"_searchField"];
    searchTextField.tag = 8;
    searchTextField.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH"];
    [BaseViewController getRoundRectTextField:searchTextField withIcon:@"searchIcon.png"];
    searchTextField.font = FONT_16_LIGHT;

    [searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

	self.sfoTableView.delegate = self;
	self.sfoTableView.dataSource = self;
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self getStudantList];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:@"MessageReceived" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTouchedBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldDidChange:(UITextField*)textField
{
    //searchTextString = textField.text;
    [self updateSearchArray:textField.text];
}

//update seach method where the textfield acts as seach bar
-(void)updateSearchArray:(NSString *)searchTextString
{
    [arrFilterStud removeAllObjects];
    if (searchTextString.length != 0) {
        
        for ( NSDictionary* item in arrFilterStudSearch ) {
            if ([[[item objectForKey:@"student_name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
                [arrFilterStud addObject:item];
            }
        }
    }else{
        arrFilterStud = [arrFilterStudSearch mutableCopy];
    }
    
    [self.sfoTableView reloadData];
}

#pragma UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return self.notificationArray.count;
	return arrFilterStud.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (IS_IPAD) {
		return 85;
	}
	else {
		return 70;
	}
	
	return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *simpleTableIdentifier = @"ItemTableViewCell";
	ItemTableViewCell *cell = (ItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ItemTableViewCell" owner:self options:nil];
		cell=[nib objectAtIndex:0];
		cell.backgroundColor = [UIColor clearColor];
		
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	//
	//	NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
	//
	//	cell.lblStudantName.text = [dicStudantDetail valueForKey:@"name"];
	//	cell.lblClassName.text = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"LBL_CLS_NAME_TITLE"],[dicStudantDetail valueForKey:@"class_name"]];
	//
	
	//[cell.profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
	
    NSDictionary* oneStudent = [arrFilterStud objectAtIndex:indexPath.row];
    [cell.nameLabel setText:[oneStudent valueForKey:@"student_name"]];
	[cell setItemType:SFO];
    [cell.classLabel setText:[NSString stringWithFormat:@"(%@)", [oneStudent valueForKey:@"class_name"]]];
    NSString* checkoutRuleType = [oneStudent valueForKey:@"check_out_rule_type"];
    NSString *time = [oneStudent valueForKey:@"sco_time"];
    
    if ( time == nil || time == (id)[NSNull null])
        time = @"";
    
    if(checkoutRuleType != nil && ![checkoutRuleType isEqual:[NSNull null]])
    {
        if([checkoutRuleType isEqualToString:@"0"])
        {
            cell.detailLabel.text = [NSString stringWithFormat:@"Take bus %@", time];
        }else if([checkoutRuleType isEqualToString:@"1"])
        {
            cell.detailLabel.text = [NSString stringWithFormat:@"By Parents %@", time];
        }else if([checkoutRuleType isEqualToString:@"2"])
        {
            cell.detailLabel.text = [NSString stringWithFormat:@"Friends %@", time];
        }else
        {
            cell.detailLabel.text = @"";
        }

    }else{
        cell.detailLabel.text = @"";
    }

	[BaseViewController setRoudRectImage:cell.profileImageView];
	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//	[txfSearchField resignFirstResponder];
	//
	//	NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
	//
	//	StudantDetailViewController *custompopup = [[StudantDetailViewController alloc] initWithNibName:@"StudantDetailViewController" bundle:nil andDate:dicStudantDetail];
	//	custompopup.delegate = self;
	//	[self presentPopupViewController:custompopup animationType:MJPopupViewAnimationFade];
}

-(void)getStudantList {
    
    [userObj getStudentsList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrFilterStud removeAllObjects];
            [arrFilterStudSearch removeAllObjects];
            
            arrStudant = (NSMutableArray *)[dicRes valueForKey:@"students"];
            
            /*
            for(NSDictionary* one in arrStudant)
            {
                if([one valueForKey:@"sfo_status"] != [NSNull null])
                    [arrFilterStudSearch addObject:one];
            }*/
            
            [arrFilterStudSearch addObjectsFromArray:arrStudant];
            [arrFilterStud addObjectsFromArray:arrFilterStudSearch];
            
            [self.sfoTableView  reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

@end
