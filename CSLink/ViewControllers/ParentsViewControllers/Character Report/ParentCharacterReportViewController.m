//
//  CharacterReportViewController.m
//  CSLink
//
//  Created by etech-dev on 7/5/16.
//  Copyright © 2016 eTech. All rights reserved.

#import "ParentCharacterReportViewController.h"
#import "BaseViewController.h"
#import "ParentNIDropDown.h"

@interface ParentCharacterReportViewController ()<ParentNIDropDownDelegate>
{
    NSMutableArray *arrAllSemester;
    NSMutableArray *arrMarkDeatil;
    
    NSMutableArray *arrYear;
    ParentUser *userObj;
    
    int nomberOfsection;
    int selectedSem;
    ParentNIDropDown *dropDown;
    
    NSString *selectedYear;
    
    UIButton *fakeButton;
    UIButton *btnYearselect;
    
    NSMutableArray *arrSelSemId;
    
    NSMutableArray *arrCharacterDetail;
    NSMutableArray *arrAllGrade;
}
@end

@implementation ParentCharacterReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nomberOfsection = 1;
    selectedSem = 0;
    [BaseViewController setBackGroud:self];
    //self.view.backgroundColor = [UIColor whiteColor];
    [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_CHARACTER_REPORT"] WithSel:@selector(menuClick)];
    
    arrAllSemester = [[NSMutableArray alloc] init];
    arrYear = [[NSMutableArray alloc] init];
    arrMarkDeatil = [[NSMutableArray alloc] init];
    userObj = [[ParentUser alloc] init];
    arrSelSemId = [[NSMutableArray alloc] init];
    arrAllGrade = [[NSMutableArray alloc] init];
    [self getSemester];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)menuClick {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}

-(void)getSemester {
    
    [userObj getSemseterAndSubj:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"school_class_id"] schoolId:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"school_id"] userId:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSMutableDictionary *dicRes = (NSMutableDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                arrAllSemester = (NSMutableArray *)[dicRes valueForKey:@"semester_list"];
            }
            
            arrYear = [GeneralUtil getYear:[GeneralUtil getYearStartDate]];
            
            selectedYear = [arrYear firstObject];
            [btnYearselect setTitle:selectedYear  forState:UIControlStateNormal];
            [btnYearselect setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            btnYearselect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            [tblSemesterList reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    ZDebug(@"section %d",nomberOfsection + selectedSem);
    return nomberOfsection + selectedSem;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 150)];
        
        UILabel *lblYear = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, tableView.frame.size.width/2, 45)];
        lblYear.font = FONT_18_BOLD;
        lblYear.textColor = TEXT_COLOR_WHITE;
        lblYear.text = [GeneralUtil getLocalizedText:@"LBL_STUDY_YEAR_TITLE"];
        
        btnYearselect = [[UIButton alloc] initWithFrame:CGRectMake(lblYear.frame.size.width - 10, 5, tableView.frame.size.width/2, 45)];
        btnYearselect.titleLabel.font = FONT_18_BOLD;
        [btnYearselect addTarget:self action:@selector(btnselecteYearPress:) forControlEvents:UIControlEventTouchUpInside];
        
        if (selectedYear != nil) {
            [btnYearselect setTitle:selectedYear  forState:UIControlStateNormal];
            [btnYearselect setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            btnYearselect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        else {
            [btnYearselect setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
            btnYearselect.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -123);
        }
        
        UIView *sepratorview = [[UIView alloc] initWithFrame:CGRectMake(50, btnYearselect.frame.size.height +10, tableView.frame.size.width-65, 1)];
        sepratorview.backgroundColor = [UIColor whiteColor];
        
        int y = sepratorview.frame.origin.y + 10;
        
        for (int i =0 ; i < [arrAllSemester count] ; i++) {
            
            int x = 12;
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 25, 25)];
            icon.image = [UIImage imageNamed:@"calendar"];
            
            x = x + icon.frame.size.width;
            
            UILabel *lblSemsterName = [[UILabel alloc] initWithFrame:CGRectMake(x + 10, y - 10, tableView.frame.size.width/2, 45)];
            lblSemsterName.font = FONT_18_BOLD;
            lblSemsterName.textColor = TEXT_COLOR_WHITE;
            lblSemsterName.text = [[arrAllSemester objectAtIndex:i] valueForKey:@"semester_name"];
            
            UIButton *btnCheckbox = [[UIButton alloc] initWithFrame:CGRectMake(lblSemsterName.frame.size.width - 15, y - 10, tableView.frame.size.width/2, 45)];
            btnCheckbox.titleLabel.font = FONT_18_BOLD;
            [btnCheckbox addTarget:self action:@selector(btnCheckBoxPress:) forControlEvents:UIControlEventTouchUpInside];
            [btnCheckbox setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [btnCheckbox setImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateSelected];
            btnCheckbox.tag = i+100;
            
            btnCheckbox.selected = [[[arrAllSemester objectAtIndex:i] valueForKey:@"selected"] boolValue];
            
            UIView *sepratorview = [[UIView alloc] initWithFrame:CGRectMake(x + 10, lblSemsterName.frame.size.height + y - 10, tableView.frame.size.width-65, 1)];
            sepratorview.backgroundColor = [UIColor whiteColor];
            
            [view addSubview:icon];
            [view addSubview:lblSemsterName];
            [view addSubview:btnCheckbox];
            
            if (i < [arrAllSemester count] - 1) {
                [view addSubview:sepratorview];
            }
            
            y = y + sepratorview.frame.size.height + lblSemsterName.frame.size.height ;
        }
        
        [view addSubview:lblYear];
        [view addSubview:btnYearselect];
        [view addSubview:sepratorview];
        [view setBackgroundColor:[UIColor clearColor]];
        
        return view;
    }
    else {
        
        NSString *semName = @"";
        
//        if ([arrCharacterDetail count] > 0 && [arrCharacterDetail count] > section-1) {
//            NSDictionary *gradeDetail = [arrCharacterDetail objectAtIndex:section-1];
//            semName = [gradeDetail valueForKey:@"semester_name"];
//        }
//        else {
            NSString *same1 = [arrSelSemId objectAtIndex:section - 1];
            
            for (NSDictionary *dic in arrAllSemester) {
                NSString *selcteSem =  [dic valueForKey:@"semester_id"];
                
                //for (NSString *same in arrSelSemId) {
                if ([same1 isEqualToString:selcteSem]) {
                    
                    semName = [dic valueForKey:@"semester_name"];
                    break;
                }
                //}
          //  }
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
        
        UILabel *lblFirstSection = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width/2, 35)];
        lblFirstSection.font = FONT_18_BOLD;
        lblFirstSection.textColor = TEXT_COLOR_CYNA;
        lblFirstSection.text = [semName uppercaseString];
        
        UIView *sepratorview = [[UIView alloc] initWithFrame:CGRectMake(lblFirstSection.frame.size.width + 7, 23, tableView.frame.size.width - 180, 1)];
        sepratorview.backgroundColor = TEXT_COLOR_CYNA;
        
        UILabel *lblSubjectName = [[UILabel alloc] initWithFrame:CGRectMake(0, lblFirstSection.frame.size.height, 100, 35)];
        lblSubjectName.font = FONT_16_BOLD;
        lblSubjectName.textColor = TEXT_COLOR_CYNA;
        lblSubjectName.textAlignment = NSTextAlignmentCenter;
        lblSubjectName.text = [GeneralUtil getLocalizedText:@"LBL_GRADE_TITLE"];
        
        lblSubjectName.center = [view convertPoint:view.center fromView:view.superview];
        
        UIButton *btnInfo = [[UIButton alloc] initWithFrame:CGRectMake(lblSubjectName.frame.origin.x + lblSubjectName.frame.size.width , lblFirstSection.frame.size.height, 30, 35)];
        [btnInfo addTarget:self action:@selector(btnInfoPress:) forControlEvents:UIControlEventTouchUpInside];
        [btnInfo setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
        
        btnInfo.hidden = YES;
        
        NSString *same = [arrSelSemId objectAtIndex:section - 1];
        
        for (NSDictionary *gradeDetail in arrCharacterDetail) {
            
            if ([same isEqualToString:[gradeDetail valueForKey:@"semester_id"]]) {
                
                btnInfo.tag = [[gradeDetail valueForKey:@"semester_id"] intValue];
                btnInfo.hidden = NO;
            }
        }
        
        [view addSubview:lblFirstSection];
        [view addSubview:sepratorview];
        [view addSubview:lblSubjectName];
        [view addSubview:btnInfo];
        [view setBackgroundColor:[UIColor clearColor]];
        
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50 + [arrAllSemester count]*50;
    }
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    else {
        
//        NSArray *dataArray = [dicMarkDetail objectAtIndex:section -1];
//        
//        if (dataArray) {
        
            return [arrAllGrade count];
     //   }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UIButton *btnInfo,*btnCheckMark;
    UILabel *lblSubjectName;
    UIView *seper;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblSubjectName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width/2, 35)];
        lblSubjectName.font = FONT_16_REGULER;
        lblSubjectName.textColor = TEXT_COLOR_LIGHT_BLUE;
        lblSubjectName.text = [GeneralUtil getLocalizedText:@"LBL_SUBJECT_NAME_TITLE"];
        lblSubjectName.tag = 201;
        
        btnCheckMark = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 70, 8, 20, 35)];
        [btnCheckMark setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        btnCheckMark.tag = 101;
        
//        btnInfo = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 40, 8, 30, 35)];
//        [btnInfo addTarget:self action:@selector(btnInfoPress:) forControlEvents:UIControlEventTouchUpInside];
//        [btnInfo setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
//        btnInfo.tag = 1000;
        
        seper = [[UIView alloc] initWithFrame:CGRectMake(10 , 49, tableView.frame.size.width-25, 1)];
        seper.backgroundColor = SEPERATOR_COLOR;
        seper.tag = 301;
        
        [cell.contentView addSubview:btnCheckMark];
        [cell.contentView addSubview:lblSubjectName];
      //  [cell.contentView addSubview:btnInfo];
        [cell.contentView addSubview:seper];
    }
    else {
        
        btnCheckMark = (UIButton *)[cell.contentView viewWithTag:101];
        lblSubjectName = (UILabel *)[cell.contentView viewWithTag:201];
      //  btnInfo = (UIButton *)[cell.contentView viewWithTag:1000];
        seper = (UIView *)[cell.contentView viewWithTag:301];
    }
    
    lblSubjectName.textColor = TEXT_COLOR_LIGHT_BLUE;
    lblSubjectName.font = FONT_16_REGULER;
    
    btnInfo.hidden = YES;
    btnCheckMark.hidden = YES;
    
    lblSubjectName.text = [[arrAllGrade objectAtIndex:indexPath.row] valueForKey:@"character_name"];
    
    if (indexPath.row == [arrAllGrade count] -1) {
        seper.hidden = YES;
    }
    else {
        seper.hidden = NO;
    }
    
    if ([arrCharacterDetail count] > 0) {
        NSString *same = [arrSelSemId objectAtIndex:indexPath.section - 1];
        
        for (NSDictionary *gradeDetail in arrCharacterDetail) {
            
            if ([same isEqualToString:[gradeDetail valueForKey:@"semester_id"]]) {
                
                if ([[gradeDetail valueForKey:@"character_id"] isEqualToString:
                     [[arrAllGrade objectAtIndex:indexPath.row] valueForKey:@"character_id"]]) {
                    
                    lblSubjectName.textColor = TEXT_COLOR_LIGHT_GREEN;
                    lblSubjectName.font = FONT_16_BOLD;
                    btnInfo.hidden = NO;
                    btnCheckMark.hidden = NO;
                }
                
                break;
            }
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (IBAction)btnInfoPress:(UIButton *)sender {
 
    for (NSDictionary *gradeDetail in arrCharacterDetail) {
        
        if ([[gradeDetail valueForKey:@"semester_id"] intValue] == sender.tag) {
            
            NSString *msg = [gradeDetail valueForKey:@"comment"];
            [GeneralUtil alertInfo:msg];
            break;
        }
    }
}

- (IBAction)btnselecteYearPress:(UIButton *)sender {
    
    CGFloat f = arrYear.count * 40;
    
    if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
        f = [[UIScreen mainScreen] bounds].size.height / 2;
    }
    
    dropDown = [[ParentNIDropDown alloc] showDropDown:sender :&f :(NSArray *)arrYear :nil :@"down"];
    dropDown.delegate = self;
    dropDown.tag  = 11;
}



- (IBAction)btnCheckBoxPress:(UIButton *)sender {
    
    if ([selectedYear isEqualToString:@""] || selectedYear == nil) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_YEAR"]];
    }
    else {
        
        
        sender.selected = !sender.selected;
        
        NSString *selcteSem =  [[arrAllSemester objectAtIndex:sender.tag - 100] valueForKey:@"semester_id"];
        
        if (sender.selected) {
            selectedSem = selectedSem + 1;
            
            if (![arrSelSemId containsObject:selcteSem]) {
                [arrSelSemId addObject:selcteSem];
                [[arrAllSemester objectAtIndex:sender.tag - 100] setValue:@"YES" forKey:@"selected"];
            }
            
            if (![selectedYear isEqualToString:@""]) {
                [self getSubjectAndMarks];
            }
        }
        else {
            selectedSem = selectedSem - 1;
            if ([arrSelSemId containsObject:selcteSem]) {
                
                int inx = [arrSelSemId indexOfObject:selcteSem];
                
                for (int i = 0; i < [arrCharacterDetail count]; i++) {
                    NSDictionary *d = [arrCharacterDetail objectAtIndex:i];
                    if ([[d valueForKey:@"semester_id"] isEqualToString:selcteSem]) {
                        inx = i;
                        [arrCharacterDetail removeObject:d];
                    }
                }
                
                
                [arrSelSemId removeObject:selcteSem];
                [[arrAllSemester objectAtIndex:sender.tag - 100] setValue:@"NO" forKey:@"selected"];
                
                [tblSemesterList reloadData];
//                NSIndexSet *deleSet = [NSIndexSet indexSetWithIndex:inx + 1];
//                [tblSemesterList deleteSections:deleSet withRowAnimation:UITableViewRowAnimationBottom];
            }
        }
    }
}

- (void)niDropDownDelegateMethod: (ParentNIDropDown *) sender {
    
    selectedYear = [arrYear objectAtIndex:sender.index];
    [btnYearselect setTitle:selectedYear  forState:UIControlStateNormal];
    [btnYearselect setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    btnYearselect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    if ([arrSelSemId count] > 0) {
        [self getSubjectAndMarks];
    }
}

-(void)getSubjectAndMarks {
    
    [arrSelSemId sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSString *selectedSemId = [arrSelSemId componentsJoinedByString:@","];
    
    if ([selectedYear isEqualToString:@""] || selectedYear == nil) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_YEAR"]];
    }
    else {
        [userObj getCharecterAndGrade:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"school_class_id"] year:selectedYear semesterId:selectedSemId userId:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] schoolId:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"school_id"] :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            if (resObj != nil) {
                
                if ([[resObj valueForKey:@"flag"] intValue] == 1) {
                    arrCharacterDetail = [resObj valueForKey:@"character_details"];
                }
                
                arrAllGrade = [resObj valueForKey:@"school_character"];
                
                int rowcount = [arrAllGrade count];
                
                tableViewHeight.constant = 150 + (selectedSem * 70) + ((rowcount * selectedSem) *50);
                
                [tblSemesterList reloadData];
            }
            else {
                NSLog(@"Request Fail...");
            }
        }];
    }
}
@end
