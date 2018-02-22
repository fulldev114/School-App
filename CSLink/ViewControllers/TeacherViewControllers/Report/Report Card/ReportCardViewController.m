//
//  ReportCardViewController.m
//  CSLink
//
//  Created by etech-dev on 7/5/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ReportCardViewController.h"
#import "BaseViewController.h"
#import "TeacherNIDropDown.h"
#import "marksTableViewCell.h"
#import "TeacherUser.h"

@interface ReportCardViewController ()<TeacherNIDropDownDelegate>
{
    NSMutableArray *arrAllSemester;
    NSMutableArray *arrMarkDeatil;
    
    NSMutableArray *arrYear;
    TeacherUser *userObj;
    
    int nomberOfsection;
    int selectedSem;
    TeacherNIDropDown *dropDown;
    
    NSString *selectedYear;
    
    UIButton *fakeButton;
    UIButton *btnYearselect;
    
    NSMutableArray *arrSelSemId;
    
    NSMutableArray *dicMarkDetail;
    UIButton *btnClicked;
}
@end

@implementation ReportCardViewController
@synthesize dicStudantDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nomberOfsection = 1;
    selectedSem = 0;
    [BaseViewController setBackGroud:self];
    //self.view.backgroundColor = [UIColor whiteColor];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_REPORT"] WithSel:@selector(btnBackClick)];
    
    arrAllSemester = [[NSMutableArray alloc] init];
    arrYear = [[NSMutableArray alloc] init];
    arrMarkDeatil = [[NSMutableArray alloc] init];
    userObj = [[TeacherUser alloc] init];
    arrSelSemId = [[NSMutableArray alloc] init];
    
    tblSemesterList.rowHeight = UITableViewAutomaticDimension;
    tblSemesterList.estimatedRowHeight = 50.0;
    
    [self getSemester];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getSemester {
    
    [userObj getSemseterAndSubj:[dicStudantDetail valueForKey:@"class_id"] schoolId:[GeneralUtil getUserPreference:key_schoolId] userId:[dicStudantDetail valueForKey:@"user_id"] :^(NSObject *resObj) {
        
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
        
        NSString *same = [arrSelSemId objectAtIndex:section - 1];
        
        for (NSDictionary *dic in arrAllSemester) {
            NSString *selcteSem =  [dic valueForKey:@"semester_id"];
            
            //for (NSString *same in arrSelSemId) {
            if ([same isEqualToString:selcteSem]) {
                
                semName = [dic valueForKey:@"semester_name"];
                break;
            }
            //}
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
        
        UILabel *lblFirstSection = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width/2, 35)];
        lblFirstSection.font = FONT_16_BOLD;
        lblFirstSection.textColor = TEXT_COLOR_CYNA;
        lblFirstSection.text = [semName uppercaseString];
        
        UIView *sepratorview = [[UIView alloc] initWithFrame:CGRectMake(lblFirstSection.frame.size.width , 25, tableView.frame.size.width-180, 1)];
        sepratorview.backgroundColor = TEXT_COLOR_CYNA;
        
        UILabel *lblSubjectName = [[UILabel alloc] initWithFrame:CGRectMake(10, lblFirstSection.frame.size.height, tableView.frame.size.width/2, 35)];
        lblSubjectName.font = FONT_16_BOLD;
        lblSubjectName.textColor = TEXT_COLOR_WHITE;
        lblSubjectName.text = [GeneralUtil getLocalizedText:@"LBL_SUBJECT_NAME_TITLE"];
        
        UILabel *lblMarks = [[UILabel alloc] initWithFrame:CGRectMake(lblSubjectName.frame.size.width, lblFirstSection.frame.size.height, tableView.frame.size.width/2, 35)];
        lblMarks.font = FONT_16_BOLD;
        lblMarks.textColor = TEXT_COLOR_WHITE;
        lblMarks.text = [GeneralUtil getLocalizedText:@"LBL_MARKS_TITLE"];
        
        [view addSubview:lblFirstSection];
        [view addSubview:sepratorview];
        [view addSubview:lblSubjectName];
        [view addSubview:lblMarks];
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
        
        NSArray *dataArray = [dicMarkDetail objectAtIndex:section -1];
        
        if (dataArray) {
            
            if ([dataArray count] > 0) {
                return [dataArray count];
            }
            else{
                return 1;
            }
            
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return 50;
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    //
    //    UIButton *btnInfo;
    //    UILabel *lblSubjectName,*lblMarks;
    //    UIView *seper;
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    static NSString *simpleTableIdentifier = @"marksTableViewCell";
    
    marksTableViewCell *cell = (marksTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"marksTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        //        lblSubjectName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width/2, 35)];
        //        lblSubjectName.font = FONT_16_BOLD;
        //        lblSubjectName.textColor = TEXT_COLOR_WHITE;
        //        lblSubjectName.text = [GeneralUtil getLocalizedText:@"LBL_SUBJECT_NAME_TITLE"];
        //        lblSubjectName.tag = 201;
        //
        //        lblMarks = [[UILabel alloc] initWithFrame:CGRectMake(lblSubjectName.frame.size.width, 5, 30, 35)];
        //        lblMarks.font = FONT_16_BOLD;
        //        lblMarks.textColor = TEXT_COLOR_WHITE;
        //        lblMarks.text = [GeneralUtil getLocalizedText:@"LBL_SUBJECT_NAME_TITLE"];
        //        lblMarks.tag = 101;
        //
        //        btnInfo = [[UIButton alloc] initWithFrame:CGRectMake(lblMarks.frame.origin.x + lblMarks.frame.size.width, 10, 30, 30)];
        //        btnInfo.titleLabel.font = FONT_18_BOLD;
        //        [btnInfo addTarget:self action:@selector(btnInfoPress:) forControlEvents:UIControlEventTouchUpInside];
        //        [btnInfo setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
        //        btnInfo.tag = 1000;
        //
        //        seper = [[UIView alloc] initWithFrame:CGRectMake(10 , 49, tableView.frame.size.width-25, 1)];
        //        seper.backgroundColor = SEPERATOR_COLOR;
        //
        //        [cell.contentView addSubview:lblMarks];
        //        [cell.contentView addSubview:lblSubjectName];
        //        [cell.contentView addSubview:btnInfo];
        //        [cell.contentView addSubview:seper];
        
        //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        //        view.backgroundColor = [UIColor redColor];
        
    }
    //    else {
    //
    //        lblMarks = (UILabel *)[cell.contentView viewWithTag:101];
    //        lblSubjectName = (UILabel *)[cell.contentView viewWithTag:201];
    //        btnInfo = (UIButton *)[cell.contentView viewWithTag:1000];
    //    }
    
    NSArray *dataArray = [dicMarkDetail objectAtIndex:indexPath.section -1];
    
    //    if ([dataArray count] > 0 ) {
    //        lblMarks.hidden = NO;
    //        btnInfo.hidden = NO;
    //        lblSubjectName.frame = CGRectMake(10, 5, tableView.frame.size.width/2, 35);
    //        lblSubjectName.textAlignment = NSTextAlignmentLeft;
    //        lblSubjectName.text = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"subject_name"];
    //        lblMarks.text = [[dataArray objectAtIndex:indexPath.row ] valueForKey:@"marks"];
    //    }
    //    else {
    //        btnInfo.hidden = YES;
    //        lblMarks.hidden = YES;
    //        lblSubjectName.frame = CGRectMake(0, 5, tableView.frame.size.width, 35);
    //        lblSubjectName.textAlignment = NSTextAlignmentCenter;
    //        lblSubjectName.text = [GeneralUtil getLocalizedText:@"LBL_NO_DATA_FOUND_TITLE"];
    //    }
    
    if ([dataArray count] > 0 ) {
    
        cell.lblNoDataFond.hidden = YES;
        cell.lblUserName.hidden = NO;
        
        cell.lblUserName.text = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"subject_name"];//@" has been the industry's standard dummy text ever since the 1500s,";
        
        [cell.marksView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        NSArray *noExam = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"marks"];
        int x = 10;
        int pading = 2;
        
        for (int i = 0; i < [noExam count]; i++) {
            
            UILabel *lblMarks = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 26, 30)];
            lblMarks.font = FONT_16_BOLD;
            lblMarks.textColor = TEXT_COLOR_WHITE;
            lblMarks.text = [[noExam objectAtIndex:i] valueForKey:@"marks"];
            lblMarks.textAlignment = NSTextAlignmentRight;
            lblMarks.tag = 101;
            
            UIButton *btnInfo = [[UIButton alloc] initWithFrame:CGRectMake(lblMarks.frame.origin.x + lblMarks.frame.size.width, 0, 26, 30)];
            btnInfo.titleLabel.font = FONT_18_BOLD;
            [btnInfo addTarget:self action:@selector(btnInfoPress:) forControlEvents:UIControlEventTouchUpInside];
            [btnInfo setImage:[UIImage imageNamed:@"info-green"] forState:UIControlStateNormal];
            btnInfo.tag = i + 100;
            
            x = x + lblMarks.frame.size.width + btnInfo.frame.size.width + pading;
            
            [cell.marksView addSubview:lblMarks];
            [cell.marksView addSubview:btnInfo];
        }
        
        //    NSArray *noExam = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"marks"];
        //
        //    for (int i = 0; i < [noExam count]; i++) {
        //
        //    }
    }
    else {
        
        cell.lblUserName.hidden = YES;
        
        cell.lblNoDataFond.hidden  = NO;
        cell.lblNoDataFond.text = [GeneralUtil getLocalizedText:@"LBL_NO_DATA_FOUND_TITLE"];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (IBAction)btnInfoPress:(UIButton *)sender {
    
    NSIndexPath *indexPath = [tblSemesterList indexPathForCell:(marksTableViewCell *)sender.superview.superview.superview];
    
    NSArray *dataArray = [dicMarkDetail objectAtIndex:indexPath.section -1];
    
    NSArray *noExam = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"marks"];
    
    NSString *msg = [[noExam objectAtIndex:sender.tag - 100] valueForKey:@"comment"];
    [GeneralUtil alertInfo:msg];
}


- (IBAction)btnselecteYearPress:(UIButton *)sender {
    
    if(dropDown == nil) {
        
        CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
        
        fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(sender.frame.origin.x +10, originInSuperview.y, sender.frame.size.width, sender.frame.size.height)];
        [fakeButton addTarget:self action:@selector(btnselecteYearPress:) forControlEvents:UIControlEventTouchUpInside];
        fakeButton.tag = sender.tag;
        fakeButton.hidden = NO;
        
        [self.view addSubview:fakeButton];
        
        CGFloat f = arrYear.count * 40;
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:fakeButton :&f :(NSArray *)arrYear :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 11;
        scrollView.scrollEnabled = FALSE;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)btnCheckBoxPress:(UIButton *)sender {
    
    if ([selectedYear isEqualToString:@""] || selectedYear == nil) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_YEAR"]];
    }
    else {
        btnClicked = sender;
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
                
                if ([dicMarkDetail count] > inx) {
                    
                    [dicMarkDetail removeObjectAtIndex:inx];
                    
                    NSIndexSet *deleSet = [NSIndexSet indexSetWithIndex:inx + 1];
                    
                    [tblSemesterList deleteSections:deleSet withRowAnimation:UITableViewRowAnimationBottom];
                }
                
                [arrSelSemId removeObject:selcteSem];
                [[arrAllSemester objectAtIndex:sender.tag - 100] setValue:@"NO" forKey:@"selected"];
            }
        }
    }
}

- (void) niDropDownDelegateMethod: (TeacherNIDropDown *) sender {
    
    [fakeButton removeFromSuperview];
    dropDown = nil;
    scrollView.scrollEnabled = TRUE;
    
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
        [userObj getSubjectAndMarks:[dicStudantDetail valueForKey:@"class_id"] year:selectedYear semesterId:selectedSemId userId:[dicStudantDetail valueForKey:@"user_id"]  :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            if (resObj != nil) {
                
                if ([[resObj valueForKey:@"flag"] intValue] == 1) {
                    
                    dicMarkDetail = [resObj valueForKey:@"marks_details"];
                    
                    if ([[dicMarkDetail objectAtIndex:0] isKindOfClass:[NSArray class]]) {
                        
                        int rowcount = 0;
                        
                        for (NSArray *arr in dicMarkDetail) {
                            
                            if ([arr count] > 0) {
                                rowcount = rowcount + [arr count];
                            }
                            else {
                                rowcount = rowcount + 1;
                            }
                        }
                        
                        tableViewHeight.constant = 150 + (selectedSem * 70) + ((rowcount *50));
                        
                        [tblSemesterList reloadData];
                    }
                }
            }
            else {
                NSLog(@"Request Fail...");
                btnClicked.selected = false;
                selectedSem = selectedSem - 1;
                NSString *selcteSem =  [[arrAllSemester objectAtIndex:btnClicked.tag - 100] valueForKey:@"semester_id"];
                [arrSelSemId removeObject:selcteSem];
                [[arrAllSemester objectAtIndex:btnClicked.tag - 100] setValue:@"NO" forKey:@"selected"];
            }
        }];
    }
}
@end
