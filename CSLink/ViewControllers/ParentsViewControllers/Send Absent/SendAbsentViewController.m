//
//  SendAbsentViewController.m
//  CSLink
//
//  Created by etech-dev on 6/22/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "SendAbsentViewController.h"
#import "BaseViewController.h"
#import "IQActionSheetPickerView.h"
#import "ParentNIDropDown.h"


#define MIN_CELL_H  IS_IPAD ? 60 : 40

@interface SendAbsentViewController ()<IQActionSheetPickerViewDelegate,ParentNIDropDownDelegate>
{
    ParentUser *userObj;
    NSString *sdate,*selectResone;
    NSMutableArray *arrPeriods,*arrResone;
    ParentNIDropDown *dropDown;
}
@end

@implementation SendAbsentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BaseViewController setBackGroud:self];
    
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_SEND_ABSENT"] WithSel:@selector(btnBackClick)];
    
    [BaseViewController getDropDownBtn:btnResone withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_ANY_RESONE"]];
    [btnResone setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [BaseViewController formateButtonCyne:btnSend title:[GeneralUtil getLocalizedText:@"BTN_SEND_TITLE"] withIcon:@"send" withBgColor:TEXT_COLOR_CYNA];
    
    UIImageView *selectedStud = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    selectedStud.contentMode = UIViewContentModeScaleAspectFit;
    
    [BaseViewController setRoudRectImage:selectedStud];
    [selectedStud setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithCustomView:selectedStud];
    
    self.navigationItem.rightBarButtonItem = btnRight;
    
    userObj = [[ParentUser alloc] init];
    arrPeriods = [[NSMutableArray alloc] init];
    arrResone = [[NSMutableArray alloc] init];
    
    dateView.layer.borderWidth = 1.0f;
    dateView.layer.cornerRadius = 5.0f;
    dateView.layer.borderColor = [UIColor whiteColor].CGColor;
    dateView.backgroundColor = [UIColor clearColor];
    
    periodView.layer.borderWidth = 1.0f;
    periodView.layer.cornerRadius = 5.0f;
    periodView.layer.borderColor = [UIColor whiteColor].CGColor;
    periodView.backgroundColor = [UIColor clearColor];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    
    [dformat setDateFormat:@"dd-MMM-yyyy"];
    
    lblDate.font = FONT_18_REGULER;
    lblDate.textColor  = TEXT_COLOR_WHITE;
    lblDate.text = [dformat stringFromDate:date]; //[GeneralUtil getLocalizedText:@"LBL_SELECT_DATE_TITLE"];
    
    [dformat setDateFormat:@"yyyy-MM-dd"];
    sdate = [dformat stringFromDate:date];
    
    lblFullDay.font = FONT_18_REGULER;
    lblFullDay.textColor  = TEXT_COLOR_WHITE;
    lblFullDay.text = [GeneralUtil getLocalizedText:@"LBL_FULL_DAY_TITLE"];
    
    lblPeriode.font = FONT_18_REGULER;
    lblPeriode.textColor  = TEXT_COLOR_WHITE;
    lblPeriode.text = [GeneralUtil getLocalizedText:@"LBL_PERIODS_TITLE"];
    
    lblNoAnyLec.font = FONT_16_REGULER;
    lblNoAnyLec.textColor  = TEXT_COLOR_WHITE;
    lblNoAnyLec.text = [GeneralUtil getLocalizedText:@"LBL_HOLIDAY_TITLE"];
    lblNoAnyLec.hidden = YES;
    
    [btnCheckFullday setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [btnCheckFullday setBackgroundImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateSelected];
    
//    tblPeriode.layer.borderWidth = 1.0f;
//    tblPeriode.layer.cornerRadius = 5.0f;
//    tblPeriode.layer.borderColor = [UIColor whiteColor].CGColor;
//    tblPeriode.backgroundColor = [UIColor clearColor];
    
    heightOfTableview.constant = MIN_CELL_H;
    [self getPeriodesAndResone:sdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)btnBackClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getPeriodesAndResone:(NSString *)date {

    [userObj getPeriodsAndResone:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] currDate:date :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrPeriods removeAllObjects];
            [arrResone removeAllObjects];
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1)
            {
            
                NSArray *tempPeriods =(NSArray *)[dicRes valueForKey:@"allPeriods"];
                NSArray *tempResone =(NSArray *)[dicRes valueForKey:@"allReasons"];
                
                for (NSDictionary *dicPeriodValue in tempPeriods) {
                    
                    NSMutableDictionary *dicPeriod = [[NSMutableDictionary alloc] init];
                    
                    if ([dicPeriodValue valueForKey:@"reason"] != [NSNull null]) {
                        [dicPeriod setObject:@"1" forKey:@"selected"];
                    }
                    else {
                        [dicPeriod setObject:@"0" forKey:@"selected"];
                    }
                    
                    [dicPeriod setObject:[dicPeriodValue valueForKey:@"lecture_no"] forKey:@"lecture_no"];
                    [dicPeriod setObject:[dicPeriodValue valueForKey:@"time"] forKey:@"time"];
                    [dicPeriod setObject:[dicPeriodValue valueForKey:@"period_id"] forKey:@"period_id"];
                    
                    [arrPeriods addObject:dicPeriod];
                }
                
                for (NSDictionary *dicResone in tempResone) {
                    
                    [arrResone addObject:[dicResone valueForKey:@"template_title"]];
                }
                
                if ([arrPeriods count] > 0) {
                    lblNoAnyLec.hidden = YES;
                    tblPeriode.hidden = NO;
                    int height = MIN_CELL_H;
                    heightOfTableview.constant = height + ([arrPeriods count] * height);
                    [tblPeriode reloadData];
                }
            }
            else {
                int height = MIN_CELL_H;
                heightOfTableview.constant = height + 40;
                tblPeriode.hidden = YES;
                lblNoAnyLec.hidden = NO;
            }
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
    return arrPeriods.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%d",MIN_CELL_H);
    return MIN_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblSchName;
    UIButton *btnCheck;
    UIView *seperator;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblSchName = [BaseViewController getRowTitleLable:250 text:@""];
        lblSchName.frame = CGRectMake(10, 0, lblSchName.frame.size.width, 40);
        lblSchName.textColor = TEXT_COLOR_WHITE;
        lblSchName.font = FONT_18_REGULER;
        lblSchName.tag = 200;
        
        btnCheck = [[UIButton alloc] init];
        [btnCheck setImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateSelected];
        [btnCheck setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [btnCheck addTarget:self action:@selector(btncheckPress:) forControlEvents:UIControlEventTouchUpInside];
        btnCheck.tag = indexPath.row + 800 ;
        
        seperator = [[UIView alloc] init];
        seperator.backgroundColor = SEPERATOR_COLOR_WHITE;
        
        if (IS_IPAD) {
            lblSchName.frame = CGRectMake(10, 5, lblSchName.frame.size.width, 50);
            btnCheck.frame = CGRectMake(periodView.frame.size.width - 50, 10, 40, 40);
        }
        else {
            lblSchName.frame = CGRectMake(10, 0, lblSchName.frame.size.width, 40);
            btnCheck.frame = CGRectMake(periodView.frame.size.width - 35, 10, 20, 20);
        }
        seperator.frame = CGRectMake(0, MIN_CELL_H -1, periodView.frame.size.width, 1);
        
        [cell.contentView addSubview:seperator];
        [cell.contentView addSubview:btnCheck];
        [cell.contentView addSubview:lblSchName];
        
    }
    else {
        lblSchName = (UILabel *)[cell.contentView viewWithTag:200];
        btnCheck = (UIButton *)[cell.contentView viewWithTag:indexPath.row + 800];
    }
    
    NSDictionary *dicStudantDetail = [arrPeriods objectAtIndex:indexPath.row];
    
    lblSchName.text = [NSString stringWithFormat:@"%@ - %@",[dicStudantDetail valueForKey:@"lecture_no"],[dicStudantDetail valueForKey:@"time"]];
    
    if ([[dicStudantDetail valueForKey:@"selected"] isEqualToString:@"1"]) {
        [btnCheck setSelected:YES];
    }
    else {
        [btnCheck setSelected:NO];
    }
    
    return cell;
}
- (IBAction)btncheckPress:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    [btnCheckFullday setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [btnCheckFullday setSelected:NO];
    
    if ([[[arrPeriods objectAtIndex:(sender.tag - 800)] valueForKey:@"selected"] isEqualToString:@"1"]) {
        [[arrPeriods objectAtIndex:(sender.tag - 800) ] setObject:@"0" forKey:@"selected"];
    }
    else{
        [[arrPeriods objectAtIndex:(sender.tag - 800)] setObject:@"1" forKey:@"selected"];
    }
    [tblPeriode reloadData];
}

- (IBAction)btnDatePress:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
    [picker setMaximumDate:[GeneralUtil getYearEndDate]];
    [picker setMinimumDate:[GeneralUtil getYearStartDate]];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}
-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    
    lblDate.text = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    sdate = [formatter stringFromDate:date];
    
    [self getPeriodesAndResone:sdate];
}
- (IBAction)btnCheckFullDayPress:(UIButton *)sender {
    
    if (!sender.selected) {
        for (int i =0 ; i < [arrPeriods count]; i++) {
            [[arrPeriods objectAtIndex:i] setObject:@"1" forKey:@"selected"];
        }
        sender.selected = !sender.selected;
    }
    else {
        for (int i =0 ; i < [arrPeriods count]; i++) {
            [[arrPeriods objectAtIndex:i] setObject:@"0" forKey:@"selected"];
        }
        sender.selected = !sender.selected;
    }
    
    [tblPeriode reloadData];
}

- (IBAction)btnResonePress:(id)sender {
    
    CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
    
   // if(dropDown == nil) {
        CGFloat f;
        if (IS_IPAD) {
            f = arrResone.count * 50;
        }
        else {
            f = arrResone.count * 40;
        }
    
        if (f > ScreenHeight / 2) {
            f = ScreenHeight / 2;
        }
        
        NSString *direction = @"down";
        
        
        if (originInSuperview.y > ScreenHeight / 2) {
            direction = @"up";
        }
        
        dropDown = [[ParentNIDropDown alloc] showDropDown:sender :&f :(NSArray *)arrResone :nil :direction];
        dropDown.delegate = self;
//    }
//    else {
//        [dropDown hideDropDown:sender];
//        dropDown = nil;
//    }
}

- (void) niDropDownDelegateMethod: (ParentNIDropDown *) sender {
    selectResone = [arrResone objectAtIndex:sender.index];
    
    if ([selectResone length] > 10) {
        
        if (IS_IPAD) {
            btnResone.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -390);
        }
        else {
            btnResone.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -300);
        }
    }
    else {
        btnResone.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -260);
    }
    
    btnResone.titleEdgeInsets = UIEdgeInsetsMake(0, -70, 0, 0);
}

- (IBAction)btnSendPress:(id)sender {
    
    NSString *periodeIds = @"";
    
    for (NSDictionary *dicPeriodValue in arrPeriods) {
        if ([[dicPeriodValue valueForKey:@"selected"] isEqualToString:@"1"]) {
            periodeIds = [periodeIds stringByAppendingFormat:@"%@,",[dicPeriodValue valueForKey:@"period_id"]];
        }
    }
    
    if ([sdate isEqualToString:@""] || sdate == nil){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_DATE"]];
    }
    else if ([periodeIds isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_PERIOD"]];
    }
    else if ([selectResone isEqualToString:@""] || selectResone == nil){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_RESONE"]];
    }
    else {
        
        [userObj sendAbsent:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] periodIds:periodeIds resone:selectResone date:sdate :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_MESSAGE_SEND_SUCCESS"]];
                    
                    for (int i =0 ; i < [arrPeriods count]; i++) {
                        [[arrPeriods objectAtIndex:i] setObject:@"0" forKey:@"selected"];
                    }
                    [BaseViewController getDropDownBtn:btnResone withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_ANY_RESONE"]];
                    [tblPeriode reloadData];
                    selectResone = @"";
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
@end
