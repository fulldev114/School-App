//
//  ClassAndGradeListViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ClassAndGradeListViewController.h"
#import "BaseViewController.h"
#import "SelecteStudantViewController.h"
#import "ParentUser.h"
#import "ParentNIDropDown.h"

@interface ClassAndGradeListViewController ()<ParentNIDropDownDelegate>
{
    NSMutableArray *arrFiltered;
    NSMutableArray *arrGread;
    NSDictionary *selectedGread;
    ParentUser *userObj;
    
    ParentNIDropDown *dropDown;
}
@end

@implementation ClassAndGradeListViewController
@synthesize dicSelectedSchool;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrFiltered = [[NSMutableArray alloc] init];
    arrGread = [[NSMutableArray alloc] init];
    userObj = [[ParentUser alloc] init];
    [self filterArr:self.arrSchool];
    [self filterGread:self.arrSchool];
    
    [BaseViewController setBackGroud:self];
    [BaseViewController getDropDownBtn:btnSelectGread withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_CLASS_GRD"]];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_SELECT_CLASS_NAME"] WithSel:@selector(backButtonClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)filterArr:(NSArray *)arrClassAndGread{

    for (NSDictionary *dicValue in arrClassAndGread) {
        
        NSString *sid = [dicValue valueForKey:@"school_id"];
       // NSString *gid = [dicValue valueForKey:@"grade"];
        
        if ([sid isEqualToString:[dicSelectedSchool valueForKey:@"school_id"]]) {
            [arrFiltered addObject:dicValue];
        }
    }
}

-(void)filterGread:(NSArray *)arrAllSchool {
    
    NSMutableArray *greadId = [[NSMutableArray alloc] init];

    for (NSDictionary *dicValue in arrAllSchool) {
        
        NSString *sid = [dicValue valueForKey:@"school_id"];
        
        if ([sid isEqualToString:[dicSelectedSchool valueForKey:@"school_id"]]) {
            
            if (![greadId containsObject:[dicValue valueForKey:@"grade"]] ) {
                [arrGread addObject:dicValue];
                [greadId addObject:[dicValue valueForKey:@"grade"]];
            }
        }
    }
    
    ZDebug(@" fileter Gread :%@", arrGread);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrFiltered.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPAD) {
        return 85;
    }
    else {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    UIImageView *imgClass;
    UILabel *lblSchName;
    UIView *seperator;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        imgClass = [[UIImageView alloc] init];
        imgClass.tag = 100;
        imgClass.contentMode = UIViewContentModeScaleAspectFit;
        
        imgClass.image = [UIImage imageNamed:@"grade.png"];
        
        lblSchName = [BaseViewController getRowTitleLable:SCREEN_WIDTH text:@""];
        lblSchName.font = FONT_17_BOLD;
        lblSchName.tag = 200;
        
        seperator = [[UIView alloc] init];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        if (IS_IPAD) {
            
            imgClass.frame = CGRectMake(25, 18, 50, 50);
            lblSchName.frame = CGRectMake(90, 22, lblSchName.frame.size.width, 40);
            seperator.frame = CGRectMake(90, 84, SCREEN_WIDTH, 1);
        }
        else {
            
            imgClass.frame = CGRectMake(25, 13, 40, 40);
            lblSchName.frame = CGRectMake(80, 13, lblSchName.frame.size.width, 40);
            seperator.frame = CGRectMake(80, 69, SCREEN_WIDTH, 1);
        }
        
        [cell.contentView addSubview:seperator];
        [cell.contentView addSubview:imgClass];
        [cell.contentView addSubview:lblSchName];
    }
    else {
        lblSchName = (UILabel *)[cell.contentView viewWithTag:200];
    }
    
    NSDictionary *dicStudantDetail = [arrFiltered objectAtIndex:indexPath.row];
    
    lblSchName.text = [dicStudantDetail valueForKey:@"class_name"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dicSelectedClass = [arrFiltered objectAtIndex:indexPath.row];
    
    [userObj getStudantList:[dicSelectedClass valueForKey:@"school_id"] graId:[dicSelectedClass valueForKey:@"grade"] classId:[dicSelectedClass valueForKey:@"class_id"] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            SelecteStudantViewController * pvc = [[SelecteStudantViewController alloc] initWithNibName:@"SelecteStudantViewController" bundle:nil];
            pvc.arrStudant = [dicRes valueForKey:@"allStudents"];
            [self.navigationController pushViewController:pvc animated:YES];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (IBAction)btnFilter:(id)sender {
    
    NSMutableArray *arrGreadName  = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicValue in arrGread ) {
        
        [arrGreadName addObject:[dicValue valueForKey:@"grade"]];
    }
    
    //if(dropDown == nil) {
        CGFloat f;
        if (IS_IPAD) {
            f = arrGreadName.count * 50;
        }
        else {
            f = arrGreadName.count * 40;
        }
    
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[ParentNIDropDown alloc]showDropDown:sender :&f :(NSArray *)arrGreadName :nil :@"down"];
        dropDown.delegate = self;
//    }
//    else {
//        [dropDown hideDropDown:sender];
//        dropDown = nil;
//    }
}

- (void) niDropDownDelegateMethod: (ParentNIDropDown *) sender {
    
    dropDown = nil;
    
        selectedGread = [arrGread objectAtIndex:sender.index];
        [arrFiltered removeAllObjects];
        for (NSDictionary *dicValue in self.arrSchool) {
    
            NSString *sid = [dicValue valueForKey:@"school_id"];
            NSString *gid = [dicValue valueForKey:@"grade"];
    
            if ([sid isEqualToString:[dicSelectedSchool valueForKey:@"school_id"]] && [gid isEqualToString:[selectedGread valueForKey:@"grade"]]) {
                [arrFiltered addObject:dicValue];
            }
        }
        [tblClassName reloadData];
}

@end
