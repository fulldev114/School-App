//
//  ReportViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/16/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ReportViewController.h"
#import "BaseViewController.h"
#import "TeacherNIDropDown.h"
#import "IQActionSheetPickerView.h"
#import "StatisticeViewController.h"
#import "EnterMarkViewController.h"
#import "EnterCharecterViewController.h"
#import "ReportCardViewController.h"
#import "TeacherCharacterReportViewController.h"
#import "ReportTableViewCell.h"
#import "ViewMarksViewController.h"
#import "TeacherViewCharecterViewController.h"
#import "TeacherUser.h"

#define LENG_CLASS_FIELD 12
#define LENG_STUDENT_FIELD 30
#define LENG_DAYS_FIELD 25
#define LENG_HOURS_FIELD 20

@interface ReportViewController ()<TeacherNIDropDownDelegate,IQActionSheetPickerViewDelegate>
{
    NSMutableArray *arrClass;
    NSMutableArray *arrFilterClass;
    NSMutableArray *arrGrade;
    NSMutableArray *arrStudant;
    NSMutableArray *arrFilterStudSearch;
    NSMutableArray *arrFilterStud;
    
    TeacherUser *userObj;
    TeacherNIDropDown *dropDown;
    NSString *selectedGrade;
    NSString *selectedClass;
    
    NSString *sdete;
    NSString *edete;
    
    CGSize pageSize;
    int contextX,contextY, contextWidth, margin;
    
    NSMutableDictionary *PDFReportData;
    NSString *PathOfReportGenerated;
    
    IBOutlet NSLayoutConstraint *heightOfBtnSend;
    
    NSMutableDictionary *dicABReportDatas;
    
    NSMutableParagraphStyle *textStyle;
}
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentLeft;
    
    if ([self.reportOrAdd isEqualToString:@"ADD_MARK"]){
        [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_MARK"] WithSel:@selector(menuClick)];
        btnSend.hidden = YES;
        heightOfBtnSend.constant = 0;
    }
    else if([self.reportOrAdd isEqualToString:@"ADD_CHAR"]) {
        [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_CHARECTER"] WithSel:@selector(menuClick)];
        btnSend.hidden = YES;
        heightOfBtnSend.constant = 0;
    }
    else if([self.reportOrAdd isEqualToString:@"VIEW_ABSENT"]) {
        [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_SCREEN_REPORT"] WithSel:@selector(menuClick)];
        self.navigationItem.rightBarButtonItem = [BaseViewController getRightButtonWithSel:@selector(editBtnClick) addTarget:self icon:@"info"];
    }
    else if([self.reportOrAdd isEqualToString:@"VIEW_MARK"]) {
        [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_MENU_MARK_REPORT"] WithSel:@selector(menuClick)];
      //  self.navigationItem.rightBarButtonItem = [BaseViewController getRightButtonWithSel:@selector(editBtnClick) addTarget:self icon:@"info"];
        btnSend.hidden = YES;
        heightOfBtnSend.constant = 0;
    }
    else if([self.reportOrAdd isEqualToString:@"VIEW_CHAR"]) {
        [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_CHARECTER"] WithSel:@selector(menuClick)];
       // self.navigationItem.rightBarButtonItem = [BaseViewController getRightButtonWithSel:@selector(editBtnClick) addTarget:self icon:@"info"];
        btnSend.hidden = YES;
        heightOfBtnSend.constant = 0;
    }
    else {
        [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_SCREEN_REPORT"] WithSel:@selector(menuClick)];
        btnSend.hidden = YES;
        heightOfBtnSend.constant = 0;
    }
    
    [BaseViewController setBackGroud:self];
    
    if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
   //     btnGrade.tag = 10;
    }
    
    [BaseViewController getDropDownBtn:btnGrade withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_CLASS"]];
  //  [BaseViewController getDropDownBtn:btnClass withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_GRADE"]];
  //  [BaseViewController getDropDownBtn:btnClass withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_CLASS"]];
    
    [BaseViewController formateButtonYellow:btnSend withColor:APP_BACKGROUD_COLOR title:[GeneralUtil getLocalizedText:@"BTN_SEND_TITLE"]];
    
    txtSearchStud.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_SEARCH"];
    [BaseViewController getRoundRectTextField:txtSearchStud withIcon:@"search"];
    
    
    txtSearchStud.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtSearchStud.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [txtSearchStud addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    txtSearchStud.delegate = self;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    
    [dformat setDateFormat:@"dd-MMM-yyyy"];
    
    lblEndDate.textColor = TEXT_COLOR_WHITE;
    lblEndDate.font = FONT_16_BOLD;
    
    lblEndDate.text = [dformat stringFromDate:date];
    
    NSDate *stDate = [GeneralUtil getYearStartDate];
    
    
    lblStartDate.textColor = TEXT_COLOR_WHITE;
    lblStartDate.font = FONT_16_BOLD;
    
    lblStartDate.text = [dformat stringFromDate:stDate];
    
    [dformat setDateFormat:@"yyyy-MM-dd"];
    edete = [dformat stringFromDate:date];
    
    [dformat setDateFormat:@"yyyy-MM-dd"];
    sdete = [dformat stringFromDate:stDate];
    
    celenderView.layer.cornerRadius = 8.0f;
    celenderView.backgroundColor = [UIColor clearColor];
    celenderView.layer.borderWidth = 1.0f;
    celenderView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    userObj = [[TeacherUser alloc] init];
    arrStudant = [[NSMutableArray alloc] init];
    arrClass = [[NSMutableArray alloc] init];
    arrGrade = [[NSMutableArray alloc] init];
    arrFilterStud = [[NSMutableArray alloc] init];
    arrFilterClass = [[NSMutableArray alloc] init];
    arrFilterStudSearch = [[NSMutableArray alloc] init];
    dicABReportDatas = [[NSMutableDictionary alloc] init];
    
    tblStudentList.rowHeight = UITableViewAutomaticDimension;
    tblStudentList.estimatedRowHeight = 60.0;
    
  //  [self getStudantList];
    
    [self getTeacherClass];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // txtSearchStud.text = @"";
}

-(void)menuClick {
    
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}

-(void)editBtnClick {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
/*
-(void)getStudantList {
    
    [userObj getStudantList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrFilterStud removeAllObjects];
            [arrFilterStudSearch removeAllObjects];
            [arrClass removeAllObjects];
            
            arrStudant = (NSMutableArray *)[dicRes valueForKey:@"result"];
            
            for (NSDictionary *dicCls in [dicRes valueForKey:@"classes"]) {
                [arrClass addObject:[dicCls valueForKey:@"class_name"]];
            }
            
            arrFilterStud = [arrStudant mutableCopy];
            
            for (NSDictionary *dicStudant in arrFilterStud) {
                [arrFilterStudSearch addObject:dicStudant];
            }
            
            
            [tblStudentList  reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}
*/

-(void)getTeacherClass {
    
    [userObj getTeacherClass:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrFilterClass removeAllObjects];
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                arrGrade = [[dicRes valueForKey:@"grades"] valueForKey:@"grades"];
                arrClass = [[dicRes valueForKey:@"classes"] valueForKey:@"classes"];
                
                selectedGrade = @"";//[arrGrade objectAtIndex:0];
                selectedClass = @"";
                
                for (NSDictionary *dicValue in arrClass) {
                    
//                    NSString *gid = [dicValue valueForKey:@"grade"];
//                    
//                    if ([gid isEqualToString:selectedGrade]) {
//                        [arrFilterClass addObject:[dicValue valueForKey:@"class_name"]];
//                    }
                    
                    [arrFilterClass addObject:[dicValue valueForKey:@"class_name"]];
                    
                }
                
                if ([self.reportOrAdd isEqualToString:@"ADD_MARK"]){
                    [self getAdminStudantlist];
                }
                else if([self.reportOrAdd isEqualToString:@"ADD_CHAR"]) {
                    [self getAdminStudantlist];
                }
                else {
                    [self getReportStudantlist];
                }
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

-(void)getAdminStudantlist {
    
    [userObj getRequestStudantList:[GeneralUtil getUserPreference:key_schoolId] teacherId:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            //  [arrFilterStud removeAllObjects];
            
            arrStudant = (NSMutableArray *)[dicRes valueForKey:@"allStudents"];
            arrFilterStud = [arrStudant mutableCopy];
            arrFilterStudSearch = [arrFilterStud mutableCopy];
            [tblStudentList  reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)getReportStudantlist {
    
    [userObj getReposrtStudantList:[GeneralUtil getUserPreference:key_teacherId] gradeId:selectedGrade classId:selectedClass :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
          //  [arrFilterStud removeAllObjects];
            
            arrStudant = (NSMutableArray *)[dicRes valueForKey:@"allStudents"];
            arrFilterStud = [arrStudant mutableCopy];
            arrFilterStudSearch = [arrFilterStud mutableCopy];
            [tblStudentList  reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrFilterStud.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    CGFloat height = 0;
//    NSDictionary *dicStudantDetail = [arrFilterStud objectAtIndex:indexPath.row];
//    
//    height = [BaseViewController getHeightForText:[dicStudantDetail valueForKey:@"name"] withFont:FONT_16_SEMIBOLD andWidth:230];
//    
//    if (height < 65) {
//         return 65;
//    }
//    else {
//         return height;
//    }
   return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *simpleTableIdentifier = @"ReportTableViewCell";
    
    ReportTableViewCell *cell = (ReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ReportTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    
//    static NSString *simpleTableIdentifier = @"SimpleTableItem";
//    
//    UIImageView *imgProfile;
//    UILabel *lblStudantName;
//    
//    UIButton *btnAddMark,*btnAddChar;
//    UIView *seperator,*verticalsep;
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
//        
//        cell.backgroundColor = [UIColor clearColor];
//        
//        imgProfile = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 40, 40)];
//        imgProfile.tag = 100;
//        imgProfile.contentMode = UIViewContentModeScaleAspectFit;
//        
//        
//        [BaseViewController setRoudRectImage:imgProfile];
//        
//        lblStudantName = [BaseViewController getRowTitleLable:230 text:@""];
//        lblStudantName.textColor = TEXT_COLOR_CYNA;
//        lblStudantName.font = FONT_16_SEMIBOLD;
//        lblStudantName.tag = 200;
//        lblStudantName.lineBreakMode = NSLineBreakByWordWrapping;
//        lblStudantName.numberOfLines = 0;
//        
//        btnAddMark = [[UIButton alloc] init];
//        btnAddMark.frame = CGRectMake(70, 40, 180, 15);
//        btnAddMark.tag = indexPath.row + 2000;
//        btnAddMark.titleLabel.font = FONT_BTN_TITLE_15;
//        [btnAddMark setTitle:[GeneralUtil getLocalizedText:@"BTN_ADD_MARK_TITLE"] forState:UIControlStateNormal];
//        [btnAddMark setImage:[UIImage imageNamed:@"add-yellow"] forState:UIControlStateNormal];
//        [btnAddMark setTitleColor:TEXT_COLOR_LIGHT_YELLOW forState:UIControlStateNormal];
//        btnAddMark.userInteractionEnabled = NO;
//        btnAddMark.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//        verticalsep = [[UIView alloc] initWithFrame:CGRectMake(170, 40, 2, 15)];
//        verticalsep.backgroundColor = TEXT_COLOR_WHITE;
//        
//        btnAddChar = [[UIButton alloc] init];
//        btnAddChar.frame = CGRectMake(180, 40, 120, 15);
//        btnAddChar.titleLabel.font = FONT_BTN_TITLE_15;
//        [btnAddChar setTitle:[GeneralUtil getLocalizedText:@"BTN_ADD_CHARACTER_TITLE"] forState:UIControlStateNormal];
//        [btnAddChar setImage:[UIImage imageNamed:@"add-green"] forState:UIControlStateNormal];
//        [btnAddChar setTitleColor:TEXT_COLOR_LIGHT_GREEN forState:UIControlStateNormal];
//        btnAddChar.tag = indexPath .row + 400;
//    
//        
//        seperator = [[UIView alloc] initWithFrame:CGRectMake(75, 69, cell.frame.size.width, 1)];
//        seperator.backgroundColor = SEPERATOR_COLOR;
//        
//        [cell.contentView addSubview:imgProfile];
//        [cell.contentView addSubview:lblStudantName];
//        [cell.contentView addSubview:btnAddMark];
//        [cell.contentView addSubview:btnAddChar];
//        [cell.contentView addSubview:verticalsep];
//        [cell.contentView addSubview:seperator];
//        
//    }
//    else {
//        lblStudantName = (UILabel *)[cell.contentView viewWithTag:200];
//        imgProfile = (UIImageView *)[cell.contentView viewWithTag:100];
//        btnAddMark = (UIButton *)[cell.contentView viewWithTag:indexPath .row + 2000];
//        btnAddChar = (UIButton *)[cell.contentView viewWithTag:indexPath .row + 400];
//    }
//    
//    NSDictionary *dicStudantDetail = [arrFilterStud objectAtIndex:indexPath.row];
//    
//    CGFloat height = 0;
//    height = [BaseViewController getHeightForText:[dicStudantDetail valueForKey:@"name"] withFont:FONT_16_SEMIBOLD andWidth:230];
//    
//    if (height < 40) {
//        height = 40;
//    }
//    
//    lblStudantName.frame = CGRectMake(75, 10, 230, height);
//    
//    lblStudantName.backgroundColor = [UIColor redColor];
//    CGRect frame = lblStudantName.frame;
//    
//    int yPos = frame.origin.y + height + 5;
//    
//    btnAddMark.frame = CGRectMake(btnAddMark.frame.origin.x, yPos, btnAddMark.frame.size.width, btnAddMark.frame.size.height);
//    
//    btnAddChar.frame = CGRectMake(btnAddChar.frame.origin.x, yPos, btnAddChar.frame.size.width, btnAddChar.frame.size.height);
//    
//    seperator.frame = CGRectMake(seperator.frame.origin.x, yPos + btnAddMark.frame.size.height, seperator.frame.size.width, seperator.frame.size.height);
//    
//    verticalsep.frame = CGRectMake(verticalsep.frame.origin.x, yPos, verticalsep.frame.size.width, verticalsep.frame.size.height);
//    
//    lblStudantName.text = [dicStudantDetail valueForKey:@"name"];
    
    NSDictionary *dicStudantDetail = [arrFilterStud objectAtIndex:indexPath.row];
    
    if ([self.reportOrAdd isEqualToString:@"VIEW_MARK"]) {
        [cell.btnViewReport setTitle:[GeneralUtil getLocalizedText:@"BTN_TTL_VIEW_MARKS"] forState:UIControlStateNormal];
        [cell.btnViewReport setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell.btnViewReport setTitleColor:TEXT_COLOR_LIGHT_YELLOW forState:UIControlStateNormal];
//        btnAddChar.hidden = YES;
//        verticalsep.hidden = YES;
    }
    else if ([self.reportOrAdd isEqualToString:@"VIEW_CHAR"]) {
        
        [cell.btnViewReport setTitle:[GeneralUtil getLocalizedText:@"BTN_TTL_VIEW_CHAR"] forState:UIControlStateNormal];
        [cell.btnViewReport setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell.btnViewReport setTitleColor:TEXT_COLOR_LIGHT_GREEN forState:UIControlStateNormal];
//        btnAddChar.hidden = YES;
//        verticalsep.hidden = YES;
    }
    else if ([self.reportOrAdd isEqualToString:@"VIEW_ABSENT"]) {
       
        [cell.btnViewReport setTitle:[GeneralUtil getLocalizedText:@"BTN_TTL_VIEW_ABSENT"] forState:UIControlStateNormal];
        [cell.btnViewReport setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell.btnViewReport setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
//        btnAddChar.hidden = YES;
//        verticalsep.hidden = YES;
    }
    else if ([self.reportOrAdd isEqualToString:@"ADD_MARK"]){
        [cell.btnViewReport setTitle:[GeneralUtil getLocalizedText:@"BTN_ADD_MARK_TITLE"] forState:UIControlStateNormal];
        [cell.btnViewReport setImage:[UIImage imageNamed:@"add-yellow"] forState:UIControlStateNormal];
        [cell.btnViewReport setTitleColor:TEXT_COLOR_LIGHT_YELLOW forState:UIControlStateNormal];
//        btnAddChar.hidden = YES;
//        verticalsep.hidden = YES;
    }
    else {
        [cell.btnViewReport setTitle:[GeneralUtil getLocalizedText:@"BTN_ADD_CHARACTER_TITLE"] forState:UIControlStateNormal];
        [cell.btnViewReport setImage:[UIImage imageNamed:@"add-green"] forState:UIControlStateNormal];
        [cell.btnViewReport setTitleColor:TEXT_COLOR_LIGHT_GREEN forState:UIControlStateNormal];
//        verticalsep.hidden = YES;
//        btnAddChar.hidden = YES;
    }
    
    cell.lblStudantName.text = [dicStudantDetail valueForKey:@"name"];
    
    
    [cell.profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dicStudantDetail = [arrFilterStud objectAtIndex:indexPath.row];
    
    if ([self.reportOrAdd isEqualToString:@"VIEW_MARK"]) {
        
        ViewMarksViewController * vc = [[ViewMarksViewController alloc] initWithNibName:@"ViewMarksViewController" bundle:nil];
        vc.dicStudantDetail = dicStudantDetail;
        [self.navigationController pushViewController:vc animated:YES];
        
//        ReportCardViewController * vc = [[ReportCardViewController alloc] initWithNibName:@"ReportCardViewController" bundle:nil];
//        vc.dicStudantDetail = dicStudantDetail;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.reportOrAdd isEqualToString:@"VIEW_CHAR"]) {
//        CharacterReportViewController * vc = [[CharacterReportViewController alloc] initWithNibName:@"CharacterReportViewController" bundle:nil];
//        vc.dicStudantDetail = dicStudantDetail;
//        [self.navigationController pushViewController:vc animated:YES];
        
        TeacherViewCharecterViewController * vc = [[TeacherViewCharecterViewController alloc] initWithNibName:@"TeacherViewCharecterViewController" bundle:nil];
        vc.dicStudantDetail = dicStudantDetail;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.reportOrAdd isEqualToString:@"VIEW_ABSENT"]) {
        
        [userObj getAbsentStatestic:[dicStudantDetail valueForKey:@"user_id"] startdate:sdete endDate:edete :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                dicABReportDatas = (NSMutableDictionary *)resObj;
                
                NSString *days = (NSString *)[dicRes valueForKey:@"tdays"];
                NSString *hours = (NSString *)[dicRes valueForKey:@"thours"];
                
                NSMutableDictionary *stasticdetail = [[NSMutableDictionary alloc] init];
                [stasticdetail setObject:days forKey:@"day"];
                [stasticdetail setObject:hours forKey:@"hour"];
                [stasticdetail setObject:lblStartDate.text forKey:@"sdate"];
                [stasticdetail setObject:lblEndDate.text forKey:@"edate"];
                [stasticdetail setObject:[dicStudantDetail valueForKey:@"name"] forKey:@"userName"];
                
                StatisticeViewController *custompopup = [[StatisticeViewController alloc] initWithNibName:@"StatisticeViewController" bundle:nil andDate:stasticdetail];
                [self presentPopupViewController:custompopup animationType:MJPopupViewAnimationFade];
                
            }
            else {
                NSLog(@"Request Fail...");
            }
        }];
    }
    else if ([self.reportOrAdd isEqualToString:@"ADD_MARK"]){
        EnterMarkViewController * vc = [[EnterMarkViewController alloc] initWithNibName:@"EnterMarkViewController" bundle:nil];
        vc.dicStud = dicStudantDetail;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        EnterCharecterViewController * vc = [[EnterCharecterViewController alloc] initWithNibName:@"EnterCharecterViewController" bundle:nil];
        vc.dicStud = dicStudantDetail;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)btnSendPress:(id)sender {
    
    [dropDown hideDropDown:btnClass];
    
    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_IS_SEND_MAIL_PDF"] Delegate:self];
}

-(void)sendStatastice:(NSString *)isSend {
    
    [userObj sendStatisticeOfClass:[GeneralUtil getUserPreference:key_teacherId]  schoolId:[GeneralUtil getUserPreference:key_schoolId] gradeId:selectedGrade classId:selectedClass sdate:sdete edate:edete :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1)
            {
                dicABReportDatas = (NSMutableDictionary *)resObj;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self generatePDF];
                    NSFileManager* fileMgr = [NSFileManager defaultManager];
                    BOOL fileExists = [fileMgr fileExistsAtPath:PathOfReportGenerated];
                    NSData *pdfData = [NSData dataWithContentsOfFile:PathOfReportGenerated];
                    
                    if(fileExists==YES)
                    {
                        [pdfData writeToFile:nil atomically:YES];
                    }
                    else
                    {
                        [pdfData writeToFile:PathOfReportGenerated atomically:YES];
                    }
                    
                    [self generatePDF];
                    
                    NSMutableDictionary *dicHeaderInfo = [[NSMutableDictionary alloc] init];
                    
                    NSString *schName = [[[dicABReportDatas objectForKey:@"school_info"] objectAtIndex:0] valueForKey:@"school_name"];
                    NSString *tchName = [[[dicABReportDatas objectForKey:@"teacher_info"] objectAtIndex:0]valueForKey:@"teacher_name"];
                    
                    [dicHeaderInfo setValue:schName forKey:@"school_name"];
                    [dicHeaderInfo setValue:tchName forKey:@"teacher_name"];

                    [self drawHeader:dicHeaderInfo];
                    
                  //  [self drawLine];
                    
                    
                    [self drawSubjectAndMarks:[dicABReportDatas valueForKey:@"absent_student_info"]];
                    
                    [self uploadPdf:isSend];
                });
                
            }
            else if ([[dicRes valueForKey:@"flag"] intValue] == 0)
            {
                dicABReportDatas = nil;
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALIDE_PERAMETER_ERROR"]];
            }
            else {
                dicABReportDatas = nil;
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_OTHER_ERROR"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (IBAction)btnStartDatePress:(id)sender {
    
    [dropDown hideDropDown:btnClass];
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
    picker.tag = 1;
    [picker setMaximumDate:[GeneralUtil getYearEndDate]];
    [picker setMinimumDate:[GeneralUtil getYearStartDate]];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
    
}

- (IBAction)btnEndDatePress:(id)sender {
    
    [dropDown hideDropDown:btnClass];
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
    
    picker.tag = 2;
    [picker setMaximumDate:[GeneralUtil getYearEndDate]];
    [picker setMinimumDate:[GeneralUtil getYearStartDate]];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (pickerView.tag == 1) {
        
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        sdete = [formatter stringFromDate:date];
    }
    
    if (pickerView.tag == 2) {
        
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        edete = [formatter stringFromDate:date];
    }
    
    NSDate *eDate = [formatter dateFromString:edete];
    NSDate *sDate = [formatter dateFromString:sdete];
    
    if ([eDate compare:sDate] == NSOrderedDescending || [eDate compare:sDate] == NSOrderedSame) {
       // [GeneralUtil alertInfo:@"valide"];
        
        [formatter setDateFormat:@"dd-MMM-yyyy"];
        
        lblStartDate.text = [formatter stringFromDate:sDate];
        lblEndDate.text = [formatter stringFromDate:eDate];
    }
    else {
        [GeneralUtil alertInfo:@"MSG_INVALIDE_DATE"];
    }
}

- (IBAction)btnClassPress:(id)sender {
    
    if ([selectedGrade isEqualToString:@""] || selectedGrade == nil) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_GRADE"]];
    }
    else {
        if(dropDown == nil) {
            CGFloat f;
            if (IS_IPAD) {
                f = [arrFilterClass count] * 50;
            }
            else {
                f = [arrFilterClass count] * 40;
            }
            
            if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
                f = [[UIScreen mainScreen] bounds].size.height / 2;
            }
            
            dropDown = [[TeacherNIDropDown alloc]showDropDown:sender :&f :(NSArray *)arrFilterClass :nil :@"down"];
            dropDown.delegate = self;
            dropDown.tag  = 2;
        }
        else {
            [dropDown hideDropDown:sender];
            dropDown = nil;
        }
    }
}

- (IBAction)btnGradePress:(id)sender {
    
    if(dropDown == nil) {
        
        CGFloat f;
        if (IS_IPAD) {
            f = [arrFilterClass count] * 50;
        }
        else {
            f = [arrFilterClass count] * 40;
        }
        
        if (f > [[UIScreen mainScreen] bounds].size.height / 2) {
            f = [[UIScreen mainScreen] bounds].size.height / 2;
        }
        
        dropDown = [[TeacherNIDropDown alloc]showDropDown:sender :&f :(NSArray *)arrFilterClass :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 1;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void)niDropDownDelegateMethod: (TeacherNIDropDown *) sender {
    
    dropDown = nil;
    txtSearchStud.text = @"";
    selectedClass = [arrFilterClass objectAtIndex:sender.index];
    [arrFilterStud removeAllObjects];
    [arrFilterStudSearch removeAllObjects];
    
    for (NSDictionary *dicValue in arrStudant) {
        
        NSString *cid = [dicValue valueForKey:@"class_name"];
        
        if ([cid isEqualToString:selectedClass]) {
            [arrFilterStud addObject:dicValue];
            [arrFilterStudSearch addObject:dicValue];
        }
    }
    [tblStudentList reloadData];
    
//    dropDown = nil;
//    
//    if (sender.tag == 1) {
//        
//        selectedGrade = [arrGrade objectAtIndex:sender.index];
//        [arrFilterClass removeAllObjects];
//        for (NSDictionary *dicValue in arrClass) {
//            
//            NSString *gid = [dicValue valueForKey:@"grade"];
//            
//            if ([gid isEqualToString:selectedGrade]) {
//                [arrFilterClass addObject:[dicValue valueForKey:@"class_name"]];
//            }
//        }
//        [BaseViewController getDropDownBtn:btnClass withString:[GeneralUtil getLocalizedText:@"BTN_SELECT_CLASS"]];
//        selectedClass = @"";
//        [self getRequestStudList];
//    }
//    
//    if (sender.tag == 2) {
//        
//        NSString *scname = [arrFilterClass objectAtIndex:sender.index];
//        
//        for (NSDictionary *dicValue in arrClass) {
//            
//            NSString *cname = [dicValue valueForKey:@"class_name"];
//            
//            if ([cname isEqualToString:scname]) {
//                
//                selectedClass = [dicValue valueForKey:@"class_id"];
//                
//                [self getRequestStudList];
//            }
//        }
//    }
}

-(void)uploadPdf:(NSString *)isSend {

    [userObj uploadPdf:[GeneralUtil getUserPreference:key_teacherId] pdfFile:PathOfReportGenerated isSend:isSend :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1)
            {
                NSString * url = [dicRes valueForKey:@"url"];
              //  NSString *url = [NSString stringWithFormat:@"%@%@",UPLOAD_URL,strUrl];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
            }
            else if ([[dicRes valueForKey:@"flag"] intValue] == 0)
            {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALIDE_PERAMETER_ERROR"]];
            }
            else {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_OTHER_ERROR"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

#pragma mark Gnerate PDf

#define kBorderInset            20.0
#define kBorderWidth            1.0
#define kMarginInset            12.0
#define kLineWidth              1.0

-(void) generatePDF

{
    /*** This is the method called by your "PDF generating" Button. Just give initial PDF page frame, Name for your PDF file to be saved as, and the path for storing it to documnets directory ***/
    pageSize = CGSizeMake(612, 792);
    
    NSString *fileName = @"AbsentReport.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"pdfpath %@",pdfFilePath);
    
    PathOfReportGenerated=pdfFilePath;
    
    [self generatePdfWithFilePath:pdfFilePath];
}


- (void) generatePdfWithFilePath: (NSString *)thefilePath

{
    /*** Now generating the pdf  and storing it to the documents directory of device on selected path. Customize do-while loop to meet your pdf requirements like number of page, Size of NSstrings/texts you want to fit. Basically just call all the above methods depending on your requirements from do-while loop or you can recustomize it. ****/
    
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
}

-(CGSize)getSizeOfContent:(NSString *)text font:(UIFont *)font {
    
    CGSize maximumSize = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:maximumSize
                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:context].size;
    
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size;
}

-(CGSize)getSizeOfColumn:(NSString *)text font:(UIFont *)font width:(int)width {
    
    CGSize maximumSize = CGSizeMake(width, pageSize.height - 2*kBorderInset - 2*kMarginInset);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:maximumSize
                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:context].size;
    
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size;
}

-(void)drawHeader:(NSMutableDictionary *)studantDetail {
    
    NSString *reportTitle = [NSString stringWithFormat:@"%@",[GeneralUtil getLocalizedText:@"PGF_HEDER_TITLE"]];
    NSString *date = [NSString stringWithFormat:@"%@ - %@\n",sdete,edete];
    
    NSString *schName = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_SCHOOL_NAME_TITLE"],[studantDetail  valueForKey:@"school_name"]];
    
    NSString *studName = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_TEACHER_NAME_TITLE"],[studantDetail valueForKey:@"teacher_name"]];
    
   // NSString *className = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_CLASS_TITLE"],[[studantDetail valueForKey:@"school_name"] valueForKey:@"school_name"]];
    
    contextX = kBorderInset + kMarginInset;
    contextY = kBorderInset + kMarginInset;
    
    contextWidth = pageSize.width - ((kBorderInset + kMarginInset) * 2);
    
    
    CGSize stringSize = [self getSizeOfContent:reportTitle font:FONT_16_REGULER];
    CGRect renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    
    [reportTitle drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_REGULER, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    stringSize = [self getSizeOfContent:date font:FONT_16_REGULER];
    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    
    [date drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_REGULER, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    stringSize = [self getSizeOfContent:schName font:FONT_16_REGULER];
    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    
    [schName drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_REGULER, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    
    stringSize = [self getSizeOfContent:studName font:FONT_16_BOLD];
    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [studName drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_BOLD, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    
//    stringSize = [self getSizeOfContent:className font:FONT_16_BOLD];
//    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
//    
//    [className drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_BOLD, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
   // contextY = contextY + 10; // 50 = space btwn header text and line
}

-(void)drawLine {
    
    if (contextY > (pageSize.height - (kBorderInset + kMarginInset))) {
        contextY = kBorderInset + kMarginInset;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    }
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, kLineWidth);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blackColor].CGColor);
    
    CGPoint startPoint = CGPointMake(contextX, contextY);
    CGPoint endPoint = CGPointMake(contextWidth, contextY);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
}

- (void) drawSubjectAndMarks:(NSMutableArray *)arrSubjectDetail
{
    margin = 15;
    
   // contextY = contextY + 20;
    
    int wAbsent = 120, wPnotice = 120, wTotal = 50;
    
    
    int xAbsent = contextX + 230;
    int xPnotice = xAbsent + wAbsent;
    int xTotal = xPnotice + wPnotice;
    
    CGRect rect1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_ABSENT_NOTICE_TITLE"] Font:FONT_16_BOLD Width:wAbsent X:xAbsent Y:contextY];
    rect1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_PERENT_NOTICE_TITLE"] Font:FONT_16_BOLD Width:wPnotice X:xPnotice Y:contextY];
    rect1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_TOTAL_TITLE"] Font:FONT_16_BOLD Width:wTotal X:xTotal Y:contextY];
    
    contextY = contextY + rect1.size.height + 3;
    
    int wClass = 50, wStudantName = 170, wADay = 45,wAHours = 45,wNDay = 45,wNHours = 45,wTDay = 45, wTHours = 45;
    
    int xClass = contextX;
    int xStudantName = xClass + wClass + 10;
    int xADays = xStudantName + wStudantName;
    int xAHours = xADays + wADay + 10;
    int xNDay = xAHours + wAHours + 20;
    int xNHours = xNDay + wNDay + 10;
    int xTDay = xNHours + wNHours + 15;
    int xTHours = xTDay + wTDay + 10;
    
    CGRect rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_CLASS_NAME_TITLE"] Font:FONT_16_BOLD Width:wClass X:xClass Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_STUDENT_NAME_TITLE"] Font:FONT_16_BOLD Width:wStudantName X:xStudantName Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_DAY_TITLE"] Font:FONT_16_BOLD Width:wADay X:xADays Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_HOUR_TITLE"] Font:FONT_16_BOLD Width:wAHours X:xAHours Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_DAY_TITLE"] Font:FONT_16_BOLD Width:wNDay X:xNDay Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_HOUR_TITLE"] Font:FONT_16_BOLD Width:wNHours X:xNHours Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_DAY_TITLE"] Font:FONT_16_BOLD Width:wTDay X:xTDay Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_HOUR_TITLE"] Font:FONT_16_BOLD Width:wTHours X:xTHours Y:contextY];
    
    contextY = contextY + rec1.size.height + 5;
    
    for (NSDictionary *dicBehaviour in arrSubjectDetail) {
        
        if (contextY > (((pageSize.height - (kBorderInset + kMarginInset))) - 100)) {
            contextY = kBorderInset + kMarginInset;
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        }
        
        CGRect rec1 = [self drawText:[dicBehaviour valueForKey:@"class_name"] Font:FONT_16_REGULER Width:wClass X:xClass Y:contextY];
        CGRect rec2 = [self drawText:[dicBehaviour valueForKey:@"user_name"] Font:FONT_16_REGULER Width:wStudantName X:xStudantName Y:contextY];
        CGRect rec3 = [self drawText:[NSString stringWithFormat:@"%d",[[dicBehaviour valueForKey:@"adays"] intValue]] Font:FONT_16_REGULER Width:wADay X:xADays Y:contextY];
        CGRect rec4 = [self drawText:[NSString stringWithFormat:@"%d",[[dicBehaviour valueForKey:@"ahours"] intValue]] Font:FONT_16_REGULER Width:wAHours X:xAHours Y:contextY];
        CGRect rec5 = [self drawText:[NSString stringWithFormat:@"%d",[[dicBehaviour valueForKey:@"ndays"] intValue]] Font:FONT_16_REGULER Width:wNDay X:xNDay Y:contextY];
        CGRect rec6 = [self drawText:[NSString stringWithFormat:@"%d",[[dicBehaviour valueForKey:@"nhours"] intValue]] Font:FONT_16_REGULER Width:wNHours X:xNHours Y:contextY];
        CGRect rec7 = [self drawText:[NSString stringWithFormat:@"%d",[[dicBehaviour valueForKey:@"tdays"] intValue]] Font:FONT_16_REGULER Width:wTDay X:xTDay Y:contextY];
        CGRect rec8 = [self drawText:[NSString stringWithFormat:@"%d",[[dicBehaviour valueForKey:@"thours"] intValue]] Font:FONT_16_REGULER Width:wTHours X:xTHours Y:contextY];
        
        int h = rec1.size.height;
        
        if (h < rec2.size.height ) {
            h = rec2.size.height;
        }
        
        if (h < rec3.size.height ) {
            h = rec3.size.height;
        }
        
        if (h < rec4.size.height ) {
            h = rec4.size.height;
        }
        
        if (h < rec5.size.height ) {
            h = rec5.size.height;
        }
        
        if (h < rec6.size.height ) {
            h = rec6.size.height;
        }
        
        if (h < rec7.size.height ) {
            h = rec7.size.height;
        }
        
        if (h < rec8.size.height ) {
            h = rec8.size.height;
        }
        
        contextY = contextY + h + 5;
    }
    
    UIGraphicsEndPDFContext();
}

-(CGRect)drawText:(NSString *)text :(UIFont *)font {
    
    CGSize stringSize = [self getSizeOfContent:text font:font];
    CGRect renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [self drawText:text Font:font Width:contextWidth X:contextX Y:contextY];
    
    contextY = contextY + 5;
    
    return renderingRect;
}

-(CGRect)drawText:(NSString *)text Font:(UIFont *)font Width:(int)width X:(int)x Y:(int)y{
    
    if (contextY > (pageSize.height - (kBorderInset + kMarginInset))) {
        contextY = kBorderInset + kMarginInset;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    }
    
    CGSize stringSize = [self getSizeOfColumn:text font:font width:width];
    CGRect renderingRect = CGRectMake(x, y, width, stringSize.height);
    
    [text drawInRect:renderingRect withAttributes:@{NSFontAttributeName:font,
                                                    NSParagraphStyleAttributeName:textStyle}];
    
    
    return renderingRect;
}


//- (void) drawText
//
//{
//    //mReportDatas
//    /***calculate the size of the NSString/Texts we need to draw ***/
//    
//    
//    
//    
//    NSLog(@"%@",dicABReportDatas);
//    
//    if (dicABReportDatas !=nil)
//    {
//        
//        CGContextRef    currentContext = UIGraphicsGetCurrentContext();
//        CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
//        NSDictionary *teacher = [[dicABReportDatas valueForKey:@"teacher_info"] objectAtIndex:0];
//        NSDictionary *school = [[dicABReportDatas valueForKey:@"school_info"] objectAtIndex:0];
//        
//        NSString * schoolName=[NSString stringWithFormat:@"%@\t%@", [GeneralUtil getLocalizedText:@"PGF_SCHOOL_NAME_TITLE"], [school objectForKey:@"school_name"]];
//        
//        
//        NSString * teacherName =[NSString stringWithFormat:@"%@\t%@", [GeneralUtil getLocalizedText:@"PGF_TEACHER_NAME_TITLE"], [teacher objectForKey:@"teacher_name"]];
//        
//        NSString * ClassName = @"";//[NSString stringWithFormat:@"Klasse : %@",[[PDFReportData objectForKey:@"user_info"] objectForKey:@"class_name"]];
//        
//        
//        NSString *LabelHeads=[NSString stringWithFormat:@"%@%@%@%@",[self getStringForPDFAlign:[GeneralUtil getLocalizedText:@"PGF_CLASS_NAME_TITLE"] field:0],
//                              [self getStringForPDFAlign:[GeneralUtil getLocalizedText:@"PGF_STUDENT_NAME_TITLE"] field:1],
//                              [self getStringForPDFAlign:[GeneralUtil getLocalizedText:@"PGF_DAY_(NOTICE)_TITLE"] field:2] ,
//                              [GeneralUtil getLocalizedText:@"PGF_HOURS_(NOTICE)_TITLE"]];
//        
//        NSString *FinalReport;
//        
//        NSArray *LeaveDetails=[dicABReportDatas valueForKey:@"absent_student_info"];
//        NSMutableArray *ArrLeaves=[[NSMutableArray alloc]init];
//        if ([LeaveDetails count]>0)
//        {
//            for (int i=0; i<[LeaveDetails count]; i++)
//            {
//                NSDictionary *oneStudent = [LeaveDetails objectAtIndex:i] ;
//                NSString *clsName=[oneStudent valueForKey:@"class_name"];
//                NSString *oneName = [oneStudent valueForKey:@"user_name"];
//                NSString *Days= [NSString stringWithFormat:@"%@(%@)", [oneStudent valueForKey:@"tdays"], [oneStudent valueForKey:@"ndays"]];
//                NSString *Hours= [NSString stringWithFormat:@"%@(%@)", [oneStudent valueForKey:@"thours"], [oneStudent valueForKey:@"nhours"]];
//                
//                
////                NSString * realClsName = [NSString stringWithFormat:@"%-10@", clsName];
////                NSString * realOneName = [NSString stringWithFormat:@"%-150@", oneName];
////                NSString * realDays = [NSString stringWithFormat:@"%-10@", Days];
////                NSString * realHours = [NSString stringWithFormat:@"%-10@", Hours];
////
////                NSString *FinalStr=[NSString stringWithFormat:@"%@%@%@%@", realClsName, realOneName , realDays , realHours];
//                
//                //NSString *FinalStr=[NSString stringWithFormat:@"%-10@%-200@%-20@%-20@", clsName, oneName , Days , Hours];
//                
//                NSString * realClsName = [self getStringForPDFAlign:clsName field:0];
//                NSString * realOneName = [self getStringForPDFAlign:oneName field:1];
//                NSString * realDays = [self getStringForPDFAlign:Days field:2];
//                NSString * realHours = [self getStringForPDFAlign:Hours field:3];
//                
//                NSString *FinalStr=[NSString stringWithFormat:@"%@%@%@%@", realClsName, realOneName , realDays , realHours];
//                
//                [ArrLeaves addObject:FinalStr];
//            }
//            
//            
//            NSMutableString * strMut = [[NSMutableString alloc] init];
//            for (int k = 0; k < ArrLeaves.count ; k++) {
//                NSString * strele = [ArrLeaves objectAtIndex:k];
//                NSString *one = [NSString stringWithFormat:@"%@\n",strele];
//                [strMut appendString:one];
//            }
//            
//            NSString *sentence = [NSString stringWithString:strMut];
//            
//            NSLog(@"sentence: %@", sentence);
//            NSString *TotalDaysandHours=[NSString stringWithFormat:@"%@:\n%@: %@(%@)\t%@: %@(%@)",[GeneralUtil getLocalizedText:@"PGF_TOTAL_TITLE"],[GeneralUtil getLocalizedText:@"PGF_DAY_TITLE"],[dicABReportDatas valueForKey:@"tdays"],[dicABReportDatas valueForKey:@"ndays"],[GeneralUtil getLocalizedText:@"PGF_HOUR_TITLE"],[dicABReportDatas valueForKey:@"thours"],[dicABReportDatas valueForKey:@"nhours"]];
//            
//            FinalReport = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@\n\n%@\n\n\n%@",schoolName,teacherName,ClassName,LabelHeads,sentence,TotalDaysandHours];
//        }
//        else
//        {
//            NSString *sentence = @"";
//            NSString *TotalDaysandHours=[NSString stringWithFormat:@"Total                          %@                     %@Time(r)",[PDFReportData objectForKey:@"total_days"],[PDFReportData objectForKey:@"total_hours"]];
//            
//            FinalReport = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@\n\n%@\n\n\n%@",schoolName,teacherName,ClassName,LabelHeads,sentence,TotalDaysandHours];
//        }
//        
//        UIFont *font = [UIFont fontWithName:@"Consolas" size:11.0];
//        CGSize stringSize = [FinalReport sizeWithFont:font   constrainedToSize:CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset) lineBreakMode:NSLineBreakByWordWrapping];
//        
//        
//        CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset + 50.0, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height);
//        [FinalReport drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
//    }
//}

//-(NSString *) getStringForPDFAlign:(NSString *) strOrg field:(int) field {
//    NSString * retStr;
//    int count;
//    if (field == 0) {
//        if (strOrg.length + 3 > LENG_CLASS_FIELD) {
//            NSRange rng;
//            rng.length = LENG_CLASS_FIELD - 5;
//            rng.location = 0;
//            NSString * strSub = [strOrg substringWithRange:rng];
//            retStr = [NSString stringWithFormat:@"%@..   ",strSub];
//        }
//        else {
//            count = LENG_CLASS_FIELD - (int)strOrg.length;
//            NSString * strSpace = [self getSpaceString:count];
//            retStr = [NSString stringWithFormat:@"%@%@",strOrg,strSpace];
//        }
//    }
//    if (field == 1) {
//        if (strOrg.length + 3 > LENG_STUDENT_FIELD) {
//            NSRange rng;
//            rng.length = LENG_STUDENT_FIELD - 5;
//            rng.location = 0;
//            NSString * strSub = [strOrg substringWithRange:rng];
//            retStr = [NSString stringWithFormat:@"%@..   ",strSub];
//        }
//        else {
//            count = LENG_STUDENT_FIELD - (int)strOrg.length;
//            NSString * strSpace = [self getSpaceString:count];
//            retStr = [NSString stringWithFormat:@"%@%@",strOrg,strSpace];
//        }
//    }
//    if (field == 2) {
//        if (strOrg.length + 3 > LENG_DAYS_FIELD) {
//            NSRange rng;
//            rng.length = LENG_DAYS_FIELD - 5;
//            rng.location = 0;
//            NSString * strSub = [strOrg substringWithRange:rng];
//            retStr = [NSString stringWithFormat:@"%@..   ",strSub];
//        }
//        else {
//            count = LENG_DAYS_FIELD - (int)strOrg.length;
//            NSString * strSpace = [self getSpaceString:count];
//            retStr = [NSString stringWithFormat:@"%@%@",strOrg,strSpace];
//        }
//    }
//    if (field == 3) {
//        if (strOrg.length + 3 > LENG_HOURS_FIELD) {
//            NSRange rng;
//            rng.length = LENG_HOURS_FIELD - 5;
//            rng.location = 0;
//            NSString * strSub = [strOrg substringWithRange:rng];
//            retStr = [NSString stringWithFormat:@"%@..   ",strSub];
//        }
//        else {
//            count = LENG_HOURS_FIELD - (int)strOrg.length;
//            NSString * strSpace = [self getSpaceString:count];
//            retStr = [NSString stringWithFormat:@"%@%@",strOrg,strSpace];
//        }
//    }
//    NSLog(@"%@____%d",retStr,(int)retStr.length);
//    return retStr;
//}

//-(NSString *) getSpaceString:(int) count {
//    NSMutableString * str = [[NSMutableString alloc] init];
//    if (count == 0) return @"";
//    for (int i = 0; i < count; i++)
//        [str appendString:@" "];
//    NSString * strret = [NSString stringWithString:str];
//    return strret;
//}
- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *isSend;
    
    if (buttonIndex == 1) {
        isSend = @"No";
    }
    else {
        isSend = @"Yes";
    }
    
    [self sendStatastice:isSend];
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
            if ([[[item objectForKey:@"name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
                [arrFilterStud addObject:item];
            }
        }
    }else{
        arrFilterStud = [arrFilterStudSearch mutableCopy];
    }
    
    [tblStudentList reloadData];
}

@end
