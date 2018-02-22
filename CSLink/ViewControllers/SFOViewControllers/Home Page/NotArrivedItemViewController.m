//
//  NotArrivedItemViewController.m
//  CSLink
//
//  Created by adamlucas on 5/28/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "NotArrivedItemViewController.h"
#import "BaseViewController.h"
#import "NotArrivedItemTableViewCell.h"
#import "TeacherUser.h"
#import "TeacherConstant.h"

@interface NotArrivedItemViewController ()

@end

@implementation NotArrivedItemViewController
{
    NSMutableArray *arrStudent;
    TeacherUser *userObj;
    UITextField *searchTextField;
    NSMutableArray *arrFilterStud;
    NSMutableArray *arrFilterStudSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_NOT_ARRIVED"] titleColor:TEXT_COLOR_RED WithSel:@selector(onTouchedBack:)];
	
	[BaseViewController setBackGroud:self];
	
    userObj = [[TeacherUser alloc] init];
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];
    
    searchTextField = [self.searchBar valueForKey:@"_searchField"];
    searchTextField.tag = 8;
    searchTextField.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH"];
    [BaseViewController getRoundRectTextField:searchTextField withIcon:@"searchIcon.png"];
    searchTextField.font = FONT_16_LIGHT;
    
    [searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
	self.notArrivedItemArray = [NSMutableArray array];
	self.notArrivedTableView.delegate = self;
	self.notArrivedTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getStudentList];

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
    
    [self.notArrivedTableView reloadData];
}

#pragma UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
	static NSString *simpleTableIdentifier = @"NotArrivedItemTableViewCell";
	NotArrivedItemTableViewCell *cell = (NotArrivedItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"NotArrivedItemTableViewCell" owner:self options:nil];
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
    [cell.classLabel setText:[NSString stringWithFormat:@"(%@)", [oneStudent valueForKey:@"class_name"]]];
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

-(void)getStudentList {
    
    [userObj getStudentsList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
           
            arrStudent = (NSMutableArray *)[dicRes valueForKey:@"students"];
            [self.notArrivedItemArray removeAllObjects];
            for(NSDictionary* one in arrStudent)
            {
                if([one valueForKey:@"sfo_status"] == [NSNull null] || [[one valueForKey:@"sfo_status"] intValue] == NOT_ARRIVED)
                    [self.notArrivedItemArray addObject:one];
            }
            
            [arrFilterStudSearch removeAllObjects];
            [arrFilterStudSearch addObjectsFromArray:self.notArrivedItemArray];
            [arrFilterStud removeAllObjects];
            [arrFilterStud addObjectsFromArray:arrFilterStudSearch];

            
            [self.notArrivedTableView  reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}
@end
