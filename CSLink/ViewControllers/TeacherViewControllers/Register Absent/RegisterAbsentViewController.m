//
//  RegisterAbsentViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/14/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "RegisterAbsentViewController.h"
#import "BaseViewController.h"
#import "TeacherUser.h"
#import "TeacherNIDropDown.h"
#import "AbsentDetailViewController.h"
#import "IQActionSheetPickerView.h"
#import "AbsentInfoViewController.h"
#import "AbsentTableViewCell.h"
#import "TeacherConstant.h"

@interface RegisterAbsentViewController ()<TeacherNIDropDownDelegate,IQActionSheetPickerViewDelegate>
{
    NSMutableArray *arrClass;
    NSMutableArray *arrStudant;
    NSMutableArray *arrResone;
    NSMutableArray *arrPeriod;
    NSMutableArray *arrAllPeriod;
    NSMutableDictionary *arrClassPeriod;
    NSMutableArray *arrAbsentStud;
    NSMutableArray *arrPnoticeStud;
    
    NSMutableArray *arrAbsentStudChange;
    NSMutableArray *arrPnoticeStudChange;
    
    NSMutableArray *arrReasonAbsentStud;
    NSMutableArray *arrReasonPnoticeStud;
    
    NSMutableArray *tempClass;
    
    TeacherUser *userObj;
    TeacherNIDropDown *dropDown;
    
    UIDatePicker *datePicker;
    UIToolbar *pickerToolbar;
    
    NSString *sdate;
    NSString *classId;
    
    NSIndexPath *currentIndexPath;
    
    BOOL isSaved;
    NSDate *cDate;
}
@end

@implementation RegisterAbsentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_REGISTER_ABSENT"] WithSel:@selector(btnBackClick)];
    
    [BaseViewController setBackGroud:self];
    
    self.navigationItem.rightBarButtonItem = [BaseViewController getRightButtonWithSel:@selector(infoBtnClick) addTarget:self icon:@"info"];
    
    cDate = [NSDate date];
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    
    [dformat setDateFormat:@"dd-MMM-yyyy"];
    
    ZDebug(@"%@", [dformat stringFromDate:cDate]);
    
    [BaseViewController getDropDownBtn:btnClass withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_CLASS"]];
    [BaseViewController getDropDownBtn:btnDate withString:[dformat stringFromDate:cDate]];
    
    [dformat setDateFormat:@"yyyy/MM/dd"];
    
    sdate = [dformat stringFromDate:cDate];
    
    [btnClass setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnDate setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    
    [BaseViewController formateButtonYellow:btnSave withColor:APP_BACKGROUD_COLOR title:[GeneralUtil getLocalizedText:@"BTN_SAVE_TITLE"]];
    [BaseViewController formateButtonYellow:btnSendAbsent withColor:APP_BACKGROUD_COLOR title:[GeneralUtil getLocalizedText:@"BTN_ABSENT_NOTICE_TITLE"]];
    
    lblStudName.textColor = TEXT_COLOR_LIGHT_YELLOW;
    lblStudName.font = FONT_18_BOLD;
    lblStudName.text = [GeneralUtil getLocalizedText:@"LBL_STUD_NAME_TITLE"];
    
    lblLectureRecords.textColor = TEXT_COLOR_LIGHT_YELLOW;
    lblLectureRecords.font = FONT_18_BOLD;
    lblLectureRecords.text = [GeneralUtil getLocalizedText:@"LBL_LECTURE_RECORD_TITLE"];
    
    userObj = [[TeacherUser alloc] init];
    arrStudant = [[NSMutableArray alloc] init];
    arrClass = [[NSMutableArray alloc] init];
    arrPnoticeStud = [[NSMutableArray alloc] init];
    arrResone = [[NSMutableArray alloc] init];
    arrAbsentStud = [[NSMutableArray alloc] init];
    arrPeriod = [[NSMutableArray alloc] init];
    tempClass = [[NSMutableArray alloc] init];
    
    arrPnoticeStudChange = [[NSMutableArray alloc] init];
    arrAbsentStudChange = [[NSMutableArray alloc] init];
    
    arrReasonPnoticeStud = [[NSMutableArray alloc] init];
    arrReasonAbsentStud = [[NSMutableArray alloc] init];
    
    tblStudantList.rowHeight = UITableViewAutomaticDimension;
    tblStudantList.estimatedRowHeight = 70.0;
    
    isSaved = true;
    [self getTeacherClass];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)btnBackClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)infoBtnClick {
    
    AbsentInfoViewController *custompopup = [[AbsentInfoViewController alloc] initWithNibName:@"AbsentInfoViewController" bundle:nil andData:nil];
    [self presentPopupViewController:custompopup animationType:MJPopupViewAnimationFade];
}

-(void)getTeacherClass {
    
    if ( [GeneralUtil getUserPreference:key_teacherId] == nil )
        return;
    
    [userObj getTeacherClass:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
            
                arrClass = [[dicRes valueForKey:@"classes"] valueForKey:@"classes"];
                
                classId = [[arrClass objectAtIndex:0] valueForKey:@"class_id"];
                
                for (NSDictionary *dicvalue in arrClass) {
                    [tempClass addObject:[dicvalue valueForKey:@"class_name"]];
                }
                
                [self getAttendanc:classId date:sdate];
            }
            else {
                [GeneralUtil hideProgress];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)getAttendanc:(NSString *)clasId date:(NSString *)date {
    
    [userObj getAttendanceOfStud:clasId teacherId:[GeneralUtil getUserPreference:key_teacherId] date:date :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrReasonAbsentStud removeAllObjects];
            [arrReasonPnoticeStud removeAllObjects];
            [arrAbsentStud removeAllObjects];
            [arrStudant removeAllObjects];
            [arrPnoticeStud removeAllObjects];
            [arrResone removeAllObjects];
            [arrPeriod removeAllObjects];
            
            [arrAbsentStud addObjectsFromArray:[dicRes valueForKey:@"absentStudents"]];
            [arrStudant addObjectsFromArray:[dicRes valueForKey:@"allStudents"]];
            [arrPnoticeStud addObjectsFromArray:[dicRes valueForKey:@"pnoticeStudents"]];
            [arrResone addObjectsFromArray:[dicRes valueForKey:@"allReasons"]];
            [arrPeriod addObjectsFromArray:[dicRes valueForKey:@"allPeriods"]];
            
            [self getClassLactur];
            //arrAllPeriod = [arrPeriod copy];
            
//            [arrAbsentStudChange addObjectsFromArray:[dicRes valueForKey:@"absentStudents"]];
//            [arrPnoticeStudChange addObjectsFromArray:[dicRes valueForKey:@"pnoticeStudents"]];
            
            for (NSDictionary *dicAbStud in arrAbsentStud) {
                
                if (![[dicAbStud valueForKey:@"reason"] isEqualToString:@""]) {
                    
                    NSMutableDictionary *dicReasone = [[NSMutableDictionary alloc] init];
                    
                    [dicReasone setObject:[dicAbStud valueForKey:@"reason"] forKey:@"reason"];
                    [dicReasone setObject:[dicAbStud valueForKey:@"user_id"] forKey:@"user_id"];
                    
                    if (![arrReasonAbsentStud containsObject:dicReasone]) {
                        [arrReasonAbsentStud addObject:dicReasone];
                    }
                }
            }
            
            for (NSDictionary *dicPnStud in arrPnoticeStud) {
                
                if (![[dicPnStud valueForKey:@"reason"] isEqualToString:@""]) {
                   
                    NSMutableDictionary *dicReasone = [[NSMutableDictionary alloc] init];
                    
                    [dicReasone setObject:[dicPnStud valueForKey:@"reason"] forKey:@"reason"];
                    [dicReasone setObject:[dicPnStud valueForKey:@"user_id"] forKey:@"user_id"];
                    
                    if (![arrReasonPnoticeStud containsObject:dicReasone]) {
                        [arrReasonPnoticeStud addObject:dicReasone];
                    }
                }
            }
            
            [tblStudantList reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)getClassLactur {
    
    NSMutableDictionary *classPeriode = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *periode in arrPeriod) {
        NSMutableArray *lectures;
        if (![[classPeriode valueForKey:[periode valueForKey:@"class_id"]] isKindOfClass:[NSMutableArray class]]) {
            lectures = [[NSMutableArray alloc] init];
        }
        else {
            lectures = [classPeriode valueForKey:[periode valueForKey:@"class_id"]];
            
        }
        [lectures addObject:periode];
        [classPeriode setObject:lectures forKey:[periode valueForKey:@"class_id"]];
    }
    
    arrClassPeriod = [classPeriode copy];
    ZDebug(@"classPeriode :%@", classPeriode);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrStudant.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
//    
//    for (NSDictionary *dicReason in arrReasonAbsentStud) {
//        
//        if ([[dicReason valueForKey:@"user_id"] isEqualToString:[dicStudantDetail valueForKey:@"user_id"]]) {
//            return 100;
//        }
//        else {
//            return 70;
//        }
//    }
//    for (NSDictionary *dicReason in arrReasonPnoticeStud) {
//        
//        if ([[dicReason valueForKey:@"user_id"] isEqualToString:[dicStudantDetail valueForKey:@"user_id"]]) {
//            return 100;
//        }
//        else {
//            return 70;
//        }
//    }
//    
//    return 70;
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *simpleTableIdentifier = @"SimpleTableItem";
//    
//    UIImageView *imgProfile;
//    UILabel *lblStudantName,*lblNoLac,*lblReason;
//    UIView *seperator,*buttonView;
//    
//
    NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:indexPath.row];
    NSMutableArray *arrButton = [[NSMutableArray alloc] init];
    NSMutableArray *tempArrPeriod = [arrClassPeriod valueForKey:[dicStudantDetail valueForKey:@"class_id"]];
    
    //for (int i = 1 ; i <= [arrPeriod count]; i++) {
    for (int i = 1 ; i <= [tempArrPeriod count]; i++) {
        
        if (i <= 10) {
            UIButton *i = [[UIButton alloc] init];
            [arrButton addObject:i];
        }
    }
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
//        
//        cell.backgroundColor = [UIColor clearColor];
//        
//        imgProfile = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
//        imgProfile.tag = 100;
//        imgProfile.contentMode = UIViewContentModeScaleAspectFit;
//        // imgProfile.image = [UIImage imageNamed:@"profile.png"];
//        
//        [BaseViewController setRoudRectImage:imgProfile];
//        
//        lblStudantName = [BaseViewController getRowTitleLable:250 text:@""];
//        lblStudantName.frame = CGRectMake(60, 0, lblStudantName.frame.size.width, 30);
//        lblStudantName.textColor = TEXT_COLOR_CYNA;
//        lblStudantName.font = FONT_16_BOLD;
//        lblStudantName.tag = 200;
//        
//        lblStudantName.lineBreakMode = NSLineBreakByWordWrapping;
//        lblStudantName.numberOfLines = 0;
//        
//        lblReason = [BaseViewController getRowDetailLable:50 text:@""];
//        lblReason.frame = CGRectMake(60, 40, lblReason.frame.size.width, 30);
//        lblReason.textColor = TEXT_COLOR_WHITE;
//        lblReason.font = FONT_14_LIGHT;
//        lblReason.tag = 800;
//        
//        buttonView = [[UIView alloc] init];
//        buttonView.tag = 999999;
//        buttonView.frame = CGRectMake(ScreenWidth - ([arrButton count]*20) - 20, 35, [arrButton count]*20, 20);
//        
//        if ([arrButton count] > 0) {
//            int x = 0;
//            int pading = 3;
//            
//            int i = 0;
//            
//            for (UIButton *btn in arrButton) {
//                
//                btn.frame = CGRectMake(x, 0, 20, 20);
//                btn.tag = i+10;
//                btn.backgroundColor = TEXT_COLOR_GREEN ;
//                x = x + btn.frame.size.width + pading;
//                
//                btn.layer.cornerRadius = 10.0f;
//                btn.titleLabel.font = FONT_12_BOLD;
//                [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
//                [buttonView addSubview:btn];
//                
//                i++;
//            }
//        }
//        else {
//            
//            buttonView.frame = CGRectMake(ScreenWidth - 140, 35, 140, 20);
//            lblNoLac = [BaseViewController getRowTitleLable:250 text:@""];
//            lblNoLac.frame = CGRectMake(0, 0, lblNoLac.frame.size.width, 25);
//            lblNoLac.textColor = TEXT_COLOR_WHITE;
//            lblNoLac.font = FONT_14_BOLD;
//            lblNoLac.tag = 800;
//            lblNoLac.text = [GeneralUtil getLocalizedText:@"LBL_HOLIDAY_TITLE"];
//            [buttonView addSubview:lblNoLac];
//        }
//        
//        seperator = [[UIView alloc] initWithFrame:CGRectMake(60, 69 , cell.frame.size.width, 1)];
//        seperator.backgroundColor = SEPERATOR_COLOR;
//        
//        [cell.contentView addSubview:imgProfile];
//        [cell.contentView addSubview:lblStudantName];
//        [cell.contentView addSubview:lblReason];
//        [cell.contentView addSubview:seperator];
//        [cell.contentView addSubview:buttonView];
//    }
//    else {
//        
//        lblStudantName = (UILabel *)[cell.contentView viewWithTag:200];
//        lblReason = (UILabel *)[cell.contentView viewWithTag:800];
//        buttonView = (UIView *)[cell.contentView viewWithTag:999999];
//        imgProfile = (UIImageView *)[cell.contentView viewWithTag:100];
//        
//        if ([arrButton count] > 0) {
//            
//            [[buttonView subviews]
//             makeObjectsPerformSelector:@selector(removeFromSuperview)];
//            
//            int x = 0;
//            int pading = 3;
//            
//            int i = 0;
//            
//            for (UIButton *btn in arrButton) {
//                
//                btn.frame = CGRectMake(x, 0, 20, 20);
//                btn.tag = i+10;
//                btn.backgroundColor = TEXT_COLOR_GREEN ;
//                 btn.titleLabel.font = FONT_12_BOLD;
//                x = x + btn.frame.size.width + pading;
//                
//                btn.layer.cornerRadius = 10.0f;
//                [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
//                [buttonView addSubview:btn];
//                
//                i++;
//            }
//        }
//    }
    
    static NSString *simpleTableIdentifier = @"AbsentTableViewCell";
    
    AbsentTableViewCell *cell = (AbsentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"AbsentTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *tempButtonView = [[UIView alloc] init];
    
    int btnWidth,btnheight;
    
    if (IS_IPAD) {
        btnWidth = 40;
        btnheight = 40;
        cell.viewHeight.constant = 40;
    }
    else {
        btnWidth = 20;
        btnheight = 20;
    }
    
    tempButtonView.frame = CGRectMake(ScreenWidth - ([arrButton count]*btnWidth) - 80 , 0, [arrButton count]*btnWidth, btnheight);
    
    if ([arrButton count] > 0) {
        
        [[tempButtonView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

        int x = 0;
        int pading = 3;

        int i = 0;

        for (UIButton *btn in arrButton) {

            btn.frame = CGRectMake(x, 0, btnWidth, btnheight);
            btn.tag = i+10;
            btn.backgroundColor = TEXT_COLOR_GREEN ;
            btn.titleLabel.font = FONT_12_BOLD;
            x = x + btn.frame.size.width + pading;

            btn.layer.cornerRadius = btn.frame.size.height /2;
          //  [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [btn setTitle:[[tempArrPeriod objectAtIndex:i] valueForKey:@"lecture_no"] forState:UIControlStateNormal];
            
            [tempButtonView addSubview:btn];
            
            i++;
        }
    }
    
    [cell.buttonView addSubview:tempButtonView];
    
    cell.lblUserName.text = [dicStudantDetail valueForKey:@"name"];
    
     cell.lblReason.text = @"";
    
    [cell.profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    if ([arrButton count] > 0) {
        
        cell.lblNoLac.hidden = YES;
        
        for (int i = 0 ; i < [arrButton count]; i++ ) {
            
            UIButton *period = (UIButton *)[cell.buttonView viewWithTag:10+i];
            
            period.backgroundColor = TEXT_COLOR_GREEN ;
            
            for (NSDictionary *dic in arrAbsentStud) {
                if ([[dicStudantDetail valueForKey:@"user_id"] isEqualToString:[dic valueForKey:@"user_id"]] && [[dic valueForKey:@"lecture_no"] intValue] == [[[tempArrPeriod objectAtIndex:i] valueForKey:@"lecture_no"] intValue]) {
                    period.backgroundColor = [UIColor redColor];
                    
                   // cell.lblReason.text = [dic valueForKey:@"reason"];
                }
            }
            
            for (NSDictionary *dic in arrPnoticeStud) {
                if ([[dicStudantDetail valueForKey:@"user_id"] isEqualToString:[dic valueForKey:@"user_id"]] && [[dic valueForKey:@"lecture_no"] intValue] == [[[tempArrPeriod objectAtIndex:i] valueForKey:@"lecture_no"] intValue]) {
                    period.backgroundColor = TEXT_COLOR_LIGHT_YELLOW;
                    
                   // cell.lblReason.text = [dic valueForKey:@"reason"];
                }
            }
        }
    }
    else {
        
        cell.lblNoLac.hidden = NO;
    }
    for (NSDictionary *dicReason in arrReasonPnoticeStud) {
        
        if ([[dicReason valueForKey:@"user_id"] isEqualToString:[dicStudantDetail valueForKey:@"user_id"]]) {
            cell.lblReason.text = [dicReason valueForKey:@"reason"];
        }
    }
    for (NSDictionary *dicReason in arrReasonAbsentStud) {

        if ([[dicReason valueForKey:@"user_id"] isEqualToString:[dicStudantDetail valueForKey:@"user_id"]]) {
            
           // if ([cell.lblReason.text isEqualToString:@""]) {
                cell.lblReason.text = [dicReason valueForKey:@"reason"];
          //  }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *allDetail = [[NSMutableDictionary alloc] init];
    
    NSDictionary *DicDetail = [arrStudant objectAtIndex:indexPath.row];
    NSString *curReason;
    
    for (NSDictionary *dicReason in arrReasonAbsentStud) {
        
        if ([[dicReason valueForKey:@"user_id"] isEqualToString:[DicDetail valueForKey:@"user_id"]]) {
            curReason = [dicReason valueForKey:@"reason"];
        }
    }
    for (NSDictionary *dicReason in arrReasonPnoticeStud) {
        
        if ([[dicReason valueForKey:@"user_id"] isEqualToString:[DicDetail valueForKey:@"user_id"]]) {
            curReason = [dicReason valueForKey:@"reason"];
        }
    }
    
    if ([curReason isEqualToString:@""] || curReason == nil) {
        [allDetail setObject:@"" forKey:@"selectedReason"];
    }
    else {
        [allDetail setObject:curReason forKey:@"selectedReason"];
    }
    
    NSMutableArray *tempArrPeriod = [arrClassPeriod valueForKey:[[arrStudant objectAtIndex:indexPath.row] valueForKey:@"class_id"]];
    
    if ([tempArrPeriod count] > 0) {
        
        [allDetail setObject:[arrStudant objectAtIndex:indexPath.row] forKey:@"studants"];
        [allDetail setObject:arrPnoticeStud forKey:@"arrPnoticeStud"];
        [allDetail setObject:arrResone forKey:@"arrResone"];
        [allDetail setObject:arrAbsentStud forKey:@"arrAbsentStud"];
        // [allDetail setObject:arrPeriod forKey:@"allLacture"];
        [allDetail setObject:tempArrPeriod forKey:@"allLacture"];
        
        currentIndexPath = indexPath;
        AbsentDetailViewController *custompopup = [[AbsentDetailViewController alloc] initWithNibName:@"AbsentDetailViewController" bundle:nil andData:allDetail];
        custompopup.delegate = self;
        [self presentPopupViewController:custompopup animationType:MJPopupViewAnimationFade];
    }
    else {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"LBL_HOLIDAY_TITLE"]];
    }
}

-(NSString *)absentData {
    
    NSString *containStr = @"";
    
    NSMutableArray *arrAbs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicAbNotice in arrAbsentStud) {
        
        if (![containStr containsString:[NSString stringWithFormat:@"|%@|", [dicAbNotice valueForKey:@"lecture_no"]]]) {
            
            containStr = [containStr stringByAppendingFormat:@"|%@|", [dicAbNotice valueForKey:@"lecture_no"]];
            
            NSMutableArray *arrUid = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dicAbn in arrAbsentStud) {
                if ([[dicAbNotice valueForKey:@"lecture_no"] intValue] == [[dicAbn valueForKey:@"lecture_no"] intValue]) {
                    if (![arrUid containsObject:[dicAbn valueForKey:@"user_id"]]) {
                        [arrUid addObject:[dicAbn valueForKey:@"user_id"]];
                    }
                }
            }
            
            NSString *str = [arrUid componentsJoinedByString: @","];
            
            NSString *strtsemp = [NSString stringWithFormat:@"%@:::%@:::%@",[dicAbNotice valueForKey:@"lecture_no"],
                                  [dicAbNotice valueForKey:@"period_id"], str];
            
            [arrAbs addObject:strtsemp];
        }
    }
    
    NSString *str = [arrAbs componentsJoinedByString: @":=:"];
    
    return str;
}

-(NSString *)pNoticeData {
    
    NSString *containStr = @"";
    
    NSMutableArray *arrAbs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicAbNotice in arrPnoticeStud) {
        
        if (![containStr containsString:[NSString stringWithFormat:@"|%@|", [dicAbNotice valueForKey:@"lecture_no"]]]) {
            
            containStr = [containStr stringByAppendingFormat:@"|%@|", [dicAbNotice valueForKey:@"lecture_no"]];
            
            NSMutableArray *arrUid = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dicAbn in arrPnoticeStud) {
                if ([[dicAbNotice valueForKey:@"lecture_no"] intValue] == [[dicAbn valueForKey:@"lecture_no"] intValue]) {
                    if (![arrUid containsObject:[dicAbn valueForKey:@"user_id"]]) {
                        [arrUid addObject:[dicAbn valueForKey:@"user_id"]];
                    }
                }
            }
            
            NSString *str = [arrUid componentsJoinedByString: @","];
            
            NSString *strtsemp = [NSString stringWithFormat:@"%@:::%@:::%@",[dicAbNotice valueForKey:@"lecture_no"],
                                  [dicAbNotice valueForKey:@"period_id"], str];
            
            [arrAbs addObject:strtsemp];
        }
        
    }
    
    NSString *str = [arrAbs componentsJoinedByString: @":=:"];
    
    return str;
}

-(NSString *)changeAbData {
    
    NSString *containStr = @"";
    
    NSMutableArray *arrAbs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicAbNotice in arrAbsentStudChange) {
        
        if (![containStr containsString:[NSString stringWithFormat:@"|%@|", [dicAbNotice valueForKey:@"lecture_no"]]]) {
            
            containStr = [containStr stringByAppendingFormat:@"|%@|", [dicAbNotice valueForKey:@"lecture_no"]];
            
            NSMutableArray *arrUid = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dicAbn in arrAbsentStudChange) {
                if ([[dicAbNotice valueForKey:@"lecture_no"] intValue] == [[dicAbn valueForKey:@"lecture_no"] intValue]) {
                    [arrUid addObject:[dicAbn valueForKey:@"user_id"]];
                }
            }
            
            NSString *str = [arrUid componentsJoinedByString: @","];
            
            NSString *strtsemp = [NSString stringWithFormat:@"%@:::%@:::%@",[dicAbNotice valueForKey:@"lecture_no"],
                                  [dicAbNotice valueForKey:@"period_id"], str];
            
            [arrAbs addObject:strtsemp];
        }
        
    }
    
    NSString *str = [arrAbs componentsJoinedByString: @":=:"];
    
    return str;
}

-(NSString *)changePnData {
    
    NSString *containStr = @"";
    
    NSMutableArray *arrAbs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicAbNotice in arrPnoticeStudChange) {
        
        if (![containStr containsString:[NSString stringWithFormat:@"|%@|", [dicAbNotice valueForKey:@"lecture_no"]]]) {
            
            containStr = [containStr stringByAppendingFormat:@"|%@|", [dicAbNotice valueForKey:@"lecture_no"]];
            
            NSMutableArray *arrUid = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dicAbn in arrPnoticeStudChange) {
                if ([[dicAbNotice valueForKey:@"lecture_no"] intValue] == [[dicAbn valueForKey:@"lecture_no"] intValue]) {
                    
                    if (![arrUid containsObject:[dicAbn valueForKey:@"user_id"]]) {
                        [arrUid addObject:[dicAbn valueForKey:@"user_id"]];
                    }
                }
            }
            
            NSString *str = [arrUid componentsJoinedByString: @","];
            
            NSString *strtsemp = [NSString stringWithFormat:@"%@:::%@:::%@",[dicAbNotice valueForKey:@"lecture_no"],
                                  [dicAbNotice valueForKey:@"period_id"], str];
            
            [arrAbs addObject:strtsemp];
        }
        
    }
    
    NSString *str = [arrAbs componentsJoinedByString: @":=:"];
    
    return str;
}

-(NSString *)reasoneAbStud {
    
    NSMutableArray *arrAbs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicAbNotice in arrReasonAbsentStud) {
            
            NSString *strtsemp = [NSString stringWithFormat:@"%@:::%@",[dicAbNotice valueForKey:@"user_id"],[dicAbNotice valueForKey:@"reason"]];
        
        if (![arrAbs containsObject:strtsemp]) {
            [arrAbs addObject:strtsemp];
        }
        
    }
    
    NSString *str = [arrAbs componentsJoinedByString: @":=:"];
    
    return str;
}

-(NSString *)reasonePnoticebStud {
    
    NSMutableArray *arrAbs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicAbNotice in arrReasonPnoticeStud) {
        
            NSString *strtsemp = [NSString stringWithFormat:@"%@:::%@",[dicAbNotice valueForKey:@"user_id"],[dicAbNotice valueForKey:@"reason"]];
            
        if (![arrAbs containsObject:strtsemp]) {
            [arrAbs addObject:strtsemp];
        }
    }
    
    NSString *str = [arrAbs componentsJoinedByString: @":=:"];
    
    return str;
}

- (IBAction)btnSavePress:(id)sender {
    
    NSString *data = [self absentData];
    NSString *changenotices = [self changePnData];
    NSString *addNotice = [self changeAbData];
    NSString *notices = [self pNoticeData];
    NSString *reasonPNotice = [self reasonePnoticebStud];
    NSString *reasonAbData = [self reasoneAbStud];

    ZDebug(@"data %@", data);
    ZDebug(@"%@", changenotices);
    ZDebug(@"%@", addNotice);
    ZDebug(@"notices%@", notices);
    ZDebug(@"reasonPNotice %@", reasonPNotice);
    ZDebug(@"reasonAbData %@", reasonAbData);
    
    if (classId != nil && [classId isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_CLASS"]];
    }
    else {
        isSaved = true;
        [userObj saveAbsentReport:[GeneralUtil getUserPreference:key_teacherId] classId:classId date:sdate data:data changenotices:changenotices addnotices:addNotice notices:notices absentReason:reasonAbData noticesReason:reasonPNotice :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SETTING_CHECK_SUCCESS"] WithDelegate:self];
                }
                else {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INTERNAL_SERVER_ERROR"]];
                }
            }
            else {
                NSLog(@"Request Fail...");
            }
        }];
    }
}

- (IBAction)btnSendAbsendPress:(id)sender {

    NSString *data = [self absentData];
    
    if (data == nil || [data isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_NO_ABSENT_DATA"]];
    }
    else if (!isSaved) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_DATA_NOT_SAVE"]];
    }
    else if (classId != nil && [classId isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_CLASS_TO_SEND"]];
    }
    else {
        [userObj sendAbsentReport:[GeneralUtil getUserPreference:key_teacherId] date:sdate classId:classId :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1 && [[dicRes valueForKey:@"errcode" ] intValue] == 1) {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_NO_ABSEND_NOTICE"]];
                }
                else if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_REMIENDER_SEND_SUCCESS"]];
                }
                else if ([[dicRes valueForKey:@"flag"] intValue] == 0) {
                    [GeneralUtil alertInfo:[dicRes valueForKey:@"msg"]];
                }
                else {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INTERNAL_SERVER_ERROR"]];
                }
            }
            else {
                NSLog(@"Request Fail...");
            }
        }];
    }
}

- (IBAction)btnClassPress:(id)sender {
    
    if(dropDown == nil) {
        
        CGFloat f;
        if (IS_IPAD) {
            f = [tempClass count] * 50;
        }
        else {
            f = [tempClass count] * 40;
        }
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:sender :&f :(NSArray *)tempClass :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 2;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void)niDropDownDelegateMethod: (TeacherNIDropDown *) sender {
    
    dropDown = nil;
    
    NSString *selectedClass = [tempClass objectAtIndex:sender.index];
    
    for (NSDictionary *dicValue   in  arrClass) {
        if ([[dicValue valueForKey:@"class_name"] isEqualToString:selectedClass]) {
            classId = [dicValue valueForKey:@"class_id"];
            [self getAttendanc:classId date:sdate];
        }
    }
}

- (IBAction)btnDatePress:(UIButton *)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
   
    [picker setMaximumDate:[GeneralUtil getYearEndDate]];
    [picker setMinimumDate:[GeneralUtil getYearStartDate]];
    
    [picker setDate:cDate];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    cDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    sdate = [formatter stringFromDate:date];
    
    [self getAttendanc:classId date:sdate];
}

- (void)Done:(NSMutableDictionary *)dicValue {
    
    NSMutableArray *lecturedetail = [dicValue valueForKey:@"changeValue"];
    
    [lecturedetail removeObjectAtIndex:0];
    
    NSMutableArray *arrRemoveAbnotice = [[NSMutableArray alloc] init];
    NSMutableArray *arrRemovePnotice = [[NSMutableArray alloc] init];
    NSMutableArray *arrReasonAbnotice = [[NSMutableArray alloc] init];
    NSMutableArray *arrReasonPnotice = [[NSMutableArray alloc] init];
    
    if ([[dicValue valueForKey:@"reason"] isEqualToString:@""]) {
    
    }
    else {
        
        for (NSDictionary *absentDict in lecturedetail) {
            
            NSMutableDictionary *dicReasone = [[NSMutableDictionary alloc] init];
            
            if ([[absentDict valueForKey:@"selected"] intValue] == 1){
                [dicReasone setObject:[dicValue valueForKey:@"reason"] forKey:@"reason"];
                [dicReasone setObject:[absentDict valueForKey:@"user_id"] forKey:@"user_id"];
                
                if (![arrReasonAbsentStud containsObject:dicReasone]) {
                    
                    for (NSDictionary *absentDict in arrReasonAbsentStud) {
                        
                        if ([[[lecturedetail objectAtIndex:0] valueForKey:@"user_id"] isEqualToString:[absentDict valueForKey:@"user_id"]]) {
                            [arrReasonAbnotice addObject:absentDict];
                            break;
                        }
                    }
                    
                    [arrReasonAbsentStud addObject:dicReasone];
                    break;
                }
            }
            
            if ([[absentDict valueForKey:@"selected"] intValue] == 2) {
                [dicReasone setObject:[dicValue valueForKey:@"reason"] forKey:@"reason"];
                [dicReasone setObject:[absentDict valueForKey:@"user_id"] forKey:@"user_id"];
                
                if (![arrReasonPnoticeStud containsObject:dicReasone]) {
                    
                    for (NSDictionary *absentDict in arrReasonPnoticeStud) {
                        
                        if ([[[lecturedetail objectAtIndex:0] valueForKey:@"user_id"] isEqualToString:[absentDict valueForKey:@"user_id"]]) {
                            [arrReasonPnotice addObject:absentDict];
                        }
                    }
                    
                    [arrReasonPnoticeStud addObject:dicReasone];
                    break;
                }
            }
        }
        
        //        for (NSDictionary *absentDict in lecturedetail) {
        //
        //            NSMutableDictionary *dicReasone = [[NSMutableDictionary alloc] init];
        //
        //            
        //        }
    }
    
    BOOL isNotAbsent = true;
    
    for (NSDictionary *absentDict in lecturedetail) {
        if ([[absentDict valueForKey:@"selected"] intValue] != 0) {
            isNotAbsent = false;
        }
    }
    
    if (isNotAbsent) {
        
        for (NSDictionary *absentDict in arrReasonAbsentStud) {
            
            if ([[[lecturedetail objectAtIndex:0] valueForKey:@"user_id"] isEqualToString:[absentDict valueForKey:@"user_id"]]) {
                [arrReasonAbnotice addObject:absentDict];
            }
        }
        
        for (NSDictionary *absentDict in arrReasonPnoticeStud) {
            
            if ([[[lecturedetail objectAtIndex:0] valueForKey:@"user_id"] isEqualToString:[absentDict valueForKey:@"user_id"]]) {
                [arrReasonPnotice addObject:absentDict];
            }
        }
    }
    
    for (NSMutableDictionary *absentDict in lecturedetail ) { // int i = 0 ; i < [lecturedetail count]; i++ ) {
        
       // NSMutableDictionary *absentDict = [lecturedetail objectAtIndex:i];
        
        
         for (int j = 0 ; j < [arrAbsentStud count]; j++ ) {
             
             NSMutableDictionary *dic = [arrAbsentStud objectAtIndex:j];
             
             
             int selV = [[absentDict valueForKey:@"selected"] intValue];
             
           
                if (([[absentDict valueForKey:@"user_id"] isEqualToString:[dic valueForKey:@"user_id"]] &&
                    [[absentDict valueForKey:@"lecture_no"] isEqualToString:[dic valueForKey:@"lecture_no"]]) &&
                    (selV == 0 || selV == 2)) {
                    
                    [arrRemoveAbnotice addObject:dic];
                    break;
                }
             
//                 if ([[absentDict valueForKey:@"user_id"] isEqualToString:[dic valueForKey:@"user_id"]] &&
//                     [[absentDict valueForKey:@"lecture_no"] isEqualToString:[dic valueForKey:@"lecture_no"]]&&
//                     [[absentDict valueForKey:@"selected"] intValue] == 2) {
//                     
//                     [arrRemoveAbnotice addObject:dic];
//                 }
             
            }
       
        
        for (int j = 0 ; j < [arrPnoticeStud count]; j++ ) {
            
            int selV = [[absentDict valueForKey:@"selected"] intValue];
            
            NSMutableDictionary *dic = [arrPnoticeStud objectAtIndex:j];
            if (([[absentDict valueForKey:@"user_id"] isEqualToString:[dic valueForKey:@"user_id"]] &&
                 [[absentDict valueForKey:@"lecture_no"] isEqualToString:[dic valueForKey:@"lecture_no"]]) &&
                (selV == 0 || selV == 1)) {
                
                [arrRemovePnotice addObject:dic];
                break;
            }
//            if ([[absentDict valueForKey:@"user_id"] isEqualToString:[dic valueForKey:@"user_id"]] &&
//                [[absentDict valueForKey:@"lecture_no"] isEqualToString:[dic valueForKey:@"lecture_no"]]&&
//                [[absentDict valueForKey:@"selected"] intValue] == 1) {
//                
//                [arrRemovePnotice addObject:dic];
//            }
        }
        
        if (//[[absentDict valueForKey:@"lecture_no"] intValue] == i+1 &&
            [[absentDict valueForKey:@"selected"] intValue] == 1) {
            [arrAbsentStud addObject:absentDict];
            isSaved = false;
        }
        
        else if (//[[absentDict valueForKey:@"lecture_no"] intValue] == i+1 &&
            [[absentDict valueForKey:@"selected"] intValue] == 2) {
            [arrPnoticeStud addObject:absentDict];
        }
    }
    
    for (int i = 0; i < [arrRemoveAbnotice count]; i++) {
        
        NSMutableDictionary *dic = [arrRemoveAbnotice objectAtIndex:i];
        
        [arrAbsentStud removeObject:dic];
        isSaved = false;
    }
    
    for (int i = 0; i < [arrRemovePnotice count]; i++) {
        
        NSMutableDictionary *dic = [arrRemovePnotice objectAtIndex:i];
        
        [arrPnoticeStud removeObject:dic];
    }
    
    for (int i = 0; i < [arrReasonPnotice count]; i++) {
        
        NSMutableDictionary *dic = [arrReasonPnotice objectAtIndex:i];
        
        [arrReasonPnoticeStud removeObject:dic];
    }
    
    for (int i = 0; i < [arrReasonAbnotice count]; i++) {
        
        NSMutableDictionary *dic = [arrReasonAbnotice objectAtIndex:i];
        
        [arrReasonAbsentStud removeObject:dic];
    }
    
    [tblStudantList reloadData];
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
  //  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
