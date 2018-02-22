//
//  ViewCharecterViewController.m
//  CSAdmin
//
//  Created by etech-dev on 10/19/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "TeacherViewCharecterViewController.h"
#import "TeacherBehaviyerTableViewCell.h"
#import "BaseViewController.h"
#import "IQActionSheetPickerView.h"
#import "TeacherUser.h"

@interface TeacherViewCharecterViewController ()<IQActionSheetPickerViewDelegate>
{
    NSMutableArray *arrAllBehaviyor;
    
    NSString *sDate;
    NSString *eDate;
    
    TeacherUser *userObj;
    
    CGSize pageSize;
    NSString *PathOfReportGenerated;
    
    int contextX,contextY, contextWidth, margin;
    NSString *type,*bId;
    
    NSMutableParagraphStyle *textStyle;
    
    NSIndexPath *selectedIndexPath;
}
@end

@implementation TeacherViewCharecterViewController
@synthesize dicStudantDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentLeft;
    
    [BaseViewController setBackGroud:self];
    //self.view.backgroundColor = [UIColor whiteColor];
    //[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_REPORT"] WithSel:@selector(btnBackClick)];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 50)];
    
    UILabel *lblStudName = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 180, 25)];
    [lblStudName setText:[dicStudantDetail valueForKey:@"name"]];
    [lblStudName setBackgroundColor:[UIColor clearColor]];
    [lblStudName setFont:FONT_NAVIGATION_TITLE];
    lblStudName.textColor = TEXT_COLOR_CYNA;
    [lblStudName setTextAlignment:NSTextAlignmentLeft];
    lblStudName.font = FONT_BTN_TITLE_18;
    
    UILabel *lblStudClass = [[UILabel alloc]initWithFrame:CGRectMake(35, 20, 180, 25)];
    [lblStudClass setText:[dicStudantDetail valueForKey:@"class_name"]];
    [lblStudClass setBackgroundColor:[UIColor clearColor]];
    [lblStudClass setFont:FONT_NAVIGATION_TITLE];
    lblStudClass.textColor = TEXT_COLOR_WHITE;
    [lblStudClass setTextAlignment:NSTextAlignmentLeft];
    lblStudClass.font = FONT_16_BOLD;
    
    [view addSubview:lblStudClass];
    [view addSubview:lblStudName];
    
    UIImageView *profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 30, 30)];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    profileImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [BaseViewController setRoudRectImage:profileImg];
    
    [view addSubview:profileImg];
    
    [self.navigationItem setTitleView:view];
    
    self.navigationItem.leftBarButtonItem = [BaseViewController getBackButtonWithSel:@selector(backButtonClick) addTarget:self];
    
    tblBehaviyor.rowHeight = UITableViewAutomaticDimension;
    tblBehaviyor.estimatedRowHeight = 60.0;
    
    lblFromDate.font = FONT_16_BOLD;
    lblFromDate.textColor = TEXT_COLOR_CYNA;
    
    
    lblTo.font = FONT_17_BOLD;
    lblTo.textColor = TEXT_COLOR_WHITE;
    lblTo.text = @"To";//[GeneralUtil getLocalizedText:@""];
    
    lblToDate.font = FONT_16_BOLD;
    lblToDate.textColor = TEXT_COLOR_CYNA;
    
    
//    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelFromDate)];
//    tapGestureRecognizer1.numberOfTapsRequired = 1;
//    [lblFromDate addGestureRecognizer:tapGestureRecognizer1];
//    lblFromDate.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelToDate)];
//    tapGestureRecognizer2.numberOfTapsRequired = 1;
//    [lblToDate addGestureRecognizer:tapGestureRecognizer2];
//    lblToDate.userInteractionEnabled = YES;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    //  [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    lblFromDate.text = [formatter stringFromDate:[GeneralUtil getYearStartDate]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    sDate = [formatter stringFromDate:[GeneralUtil getYearStartDate]];
    
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    //  [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    lblToDate.text = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    eDate = [formatter stringFromDate:[NSDate date]];
    
    userObj = [[TeacherUser alloc] init];
    arrAllBehaviyor = [[NSMutableArray alloc] init];
    
    celanderView.layer.cornerRadius = 8.0f;
    celanderView.backgroundColor = [UIColor clearColor];
    celanderView.layer.borderWidth = 1.0f;
    celanderView.layer.borderColor = [UIColor whiteColor].CGColor;
    
   // [tblBehaviyor setContentInset:UIEdgeInsetsMake(-120,0,0,0)];
    
    [BaseViewController formateButtonCyne:btnDownload title:[GeneralUtil getLocalizedText:@"BTN_DOWNLOAD_PDF_TITLE"]];
    
    lblNoDataFond.font = FONT_18_BOLD;
    lblNoDataFond.textColor = TEXT_COLOR_LIGHT_GREEN;
    lblNoDataFond.text = [GeneralUtil getLocalizedText:@"LBL_NO_DATA_FOUND_TITLE"];
    lblNoDataFond.hidden = YES;
    
    leftTopView.hidden = NO;
    rightTopView.hidden = YES;
    leftBottomView.hidden = YES;
    rightBottomView.hidden = NO;
    
    btnDescipline.titleLabel.font = FONT_16_BOLD;
    btnBehaviour.titleLabel.font = FONT_16_BOLD;
    
    btnDescipline.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnBehaviour.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [btnDescipline setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    [btnBehaviour setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    
    [btnDescipline setTitle:[GeneralUtil getLocalizedText:@"BTN_DESCIPLINE_TITLE"] forState:UIControlStateNormal];
    [btnBehaviour setTitle:[GeneralUtil getLocalizedText:@"BTN_BEHAVIOUR_TITLE"] forState:UIControlStateNormal];
    
    leftTopView.backgroundColor = TEXT_COLOR_CYNA;
    rightTopView.backgroundColor = TEXT_COLOR_CYNA;
    bId = @"2";
    [self getBehaviuore:bId];
    type = [GeneralUtil getLocalizedText:@"BTN_BEHAVIOUR_TITLE"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)labelFromDate {
//    
//    
//    
//}
//-(void)labelToDate {
//    
//    
//    
//}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (pickerView.tag == 10) {
        
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        sDate = [formatter stringFromDate:date];
    }
    
    if (pickerView.tag == 20) {
        
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        eDate = [formatter stringFromDate:date];
    }
    
    NSDate *edate = [formatter dateFromString:eDate];
    NSDate *sdate = [formatter dateFromString:sDate];
    
    if ([edate compare:sdate] == NSOrderedDescending || [edate compare:sdate] == NSOrderedSame) {
        // [GeneralUtil alertInfo:@"valide"];
        
        [formatter setDateFormat:@"dd-MMM-yyyy"];
        
        lblFromDate.text = [formatter stringFromDate:sdate];
        lblToDate.text = [formatter stringFromDate:edate];
        
        [self getBehaviuore:bId];
    }
    else {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALIDE_DATE"]];
    }
}

-(void)getBehaviuore:(NSString *)decId {
    
    [userObj getStudantBehaviour:[dicStudantDetail valueForKey:@"class_id"] schoolId:[GeneralUtil getUserPreference:key_schoolId] userId:[dicStudantDetail valueForKey:@"user_id"] sDate:sDate eDate:eDate desceplineId:decId :^(NSObject *resObj)
     {
         
         [GeneralUtil hideProgress];
         
         NSMutableDictionary *dicRes = (NSMutableDictionary *)resObj;
         [arrAllBehaviyor removeAllObjects];
         if (dicRes != nil) {
             
             if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                 
                 arrAllBehaviyor = (NSMutableArray *)[dicRes valueForKey:@"descipline_details"];
                 
                 if (arrAllBehaviyor && [arrAllBehaviyor isKindOfClass:[NSArray class]] && [arrAllBehaviyor count] > 0) {
                     lblNoDataFond.hidden = YES;
                     btnDownload.hidden = NO;
                 }
                 else {
                     lblNoDataFond.hidden = NO;
                     btnDownload.hidden = YES;
                 }
             }
             else {
                 lblNoDataFond.hidden = NO;
                 btnDownload.hidden = YES;
             }
             [tblBehaviyor reloadData];
         }
         else {
             NSLog(@"Request Fail...");
         }
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAllBehaviyor.count;
   // return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *simpleTableIdentifier = @"TeacherBehaviyerTableViewCell";
    
    TeacherBehaviyerTableViewCell *cell = (TeacherBehaviyerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TeacherBehaviyerTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.btnDelete addTarget:self action:@selector(btnDeletePress:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSDictionary *dicBehaviour = [arrAllBehaviyor objectAtIndex:indexPath.row];
    
    
    
    if ([[dicBehaviour valueForKey:@"descipline_id"] isEqualToString:@"1"]) {
        UIImage *image = [UIImage imageNamed:@"behaviyorBlue"];
        UIEdgeInsets edgeInsets;
        edgeInsets.left = 40.0f;
        edgeInsets.top = 20.0f;
        edgeInsets.right = 20.0f;
        edgeInsets.bottom = 20.0f;
        
        cell.bubbleView.image = [image resizableImageWithCapInsets:edgeInsets];
    }
    if ([[dicBehaviour valueForKey:@"descipline_id"] isEqualToString:@"2"]) {
        UIImage *image = [UIImage imageNamed:@"send_bg"];
        UIEdgeInsets edgeInsets;
        edgeInsets.left = 40.0f;
        edgeInsets.top = 20.0f;
        edgeInsets.right = 20.0f;
        edgeInsets.bottom = 20.0f;
        
        cell.bubbleView.image = [image resizableImageWithCapInsets:edgeInsets];
    }
    
    if ([[dicBehaviour valueForKey:@"comment"] isEqualToString:@""]) {
        cell.separetorView.hidden = YES;
    }
    else {
        cell.separetorView.hidden = NO;
    }
    
    [cell.profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicBehaviour valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.lblBehaviyor.text = [NSString stringWithFormat:@"%@: %@",type,[dicBehaviour valueForKey:@"remarks_name"]];
    cell.lblComment.text = [dicBehaviour valueForKey:@"comment"];
    
    if ([[dicBehaviour valueForKey:@"teacher_id"] isEqualToString:[GeneralUtil getUserPreference:key_teacherId]]){
        cell.btnDelete.hidden = NO;
    }
    else {
        cell.btnDelete.hidden = YES;
    }
    
//    cell.lblBehaviyor.text = @"type,[dicBehaviour valueForKey: emarks_name";
//    cell.lblComment.text = @"type,[dicBehaviour valueForKey: emarks_name";
    
    cell.lblUserName.text = [dicBehaviour valueForKey:@"name"];
    cell.lblDate.text = [GeneralUtil formateDataLocalize:[dicBehaviour valueForKey:@"char_date"]];
    
    return cell;
}

-(void)btnDeletePress:(UIButton *)sender {

    NSIndexPath *indexPath = [tblBehaviyor indexPathForCell:(TeacherBehaviyerTableViewCell *)sender.superview.superview];
    
    selectedIndexPath = indexPath;
    
    NSString *msg = [NSString stringWithFormat:@"%@",[GeneralUtil getLocalizedText:@"MSG_DELETE_BEHAVIOUR"]];
    
    CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:msg Delegate:self];
    alertView.tag = 10;
    [alertView show];
}

-(void)deleteBehaviour:(NSIndexPath *)indexPath {

    NSDictionary *deleteValue = [arrAllBehaviyor objectAtIndex:indexPath.row];
    
    ZDebug(@"%@", [GeneralUtil getUserPreference:key_teacherId]);
    
    if ([[deleteValue valueForKey:@"teacher_id"] isEqualToString:[GeneralUtil getUserPreference:key_teacherId]]) {
        
        [userObj deleteStudantBehaviour:[deleteValue valueForKey:@"desc_id"] :^(NSObject *resObj)
         {
             [GeneralUtil hideProgress];
             
             NSMutableDictionary *dicRes = (NSMutableDictionary *)resObj;
             
             if (dicRes != nil) {
                 
                 if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                     
                     [arrAllBehaviyor removeObjectAtIndex:indexPath.row];
                     
                     [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CHARECTER_DELETE_SUCCESS"]];
                     
                     [tblBehaviyor reloadData];
                 }
                 else {
                     [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:[dicRes valueForKey:@"msg"]]];
                 }
             }
             else {
                 NSLog(@"Request Fail...");
             }
         }];
    }
}

- (IBAction)btnFromDate:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
    picker.tag = 10;
    [picker setMaximumDate:[GeneralUtil getYearEndDate]];
    
    [picker setMinimumDate:[GeneralUtil getYearStartDate]];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

- (IBAction)btnToDate:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
    picker.tag = 20;
    [picker setMaximumDate:[GeneralUtil getYearEndDate]];
    [picker setMinimumDate:[GeneralUtil getYearStartDate]];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

- (IBAction)btnDescplinePress:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    //  [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    lblFromDate.text = [formatter stringFromDate:[GeneralUtil getYearStartDate]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    sDate = [formatter stringFromDate:[GeneralUtil getYearStartDate]];
    
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    //  [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    lblToDate.text = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    eDate = [formatter stringFromDate:[NSDate date]];
    
    [arrAllBehaviyor removeAllObjects];
    bId =@"1";
    [self getBehaviuore:bId];
    
    type = [GeneralUtil getLocalizedText:@"BTN_DESCIPLINE_TITLE"];
    
    
    leftTopView.hidden = YES;
    rightTopView.hidden = NO;
    leftBottomView.hidden = NO;
    rightBottomView.hidden = YES;
    
    [btnDescipline setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnBehaviour setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    
}

- (IBAction)btnBehaviourPress:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    //  [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    lblFromDate.text = [formatter stringFromDate:[GeneralUtil getYearStartDate]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    sDate = [formatter stringFromDate:[GeneralUtil getYearStartDate]];
    
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    //  [btnDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
    lblToDate.text = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    eDate = [formatter stringFromDate:[NSDate date]];
    
    [arrAllBehaviyor removeAllObjects];
    
    bId =@"2";
    
    [self getBehaviuore:bId];
    
    type = [GeneralUtil getLocalizedText:@"BTN_BEHAVIOUR_TITLE"];
    
    leftTopView.hidden = NO;
    rightTopView.hidden = YES;
    leftBottomView.hidden = YES;
    rightBottomView.hidden = NO;
    
    [btnDescipline setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    [btnBehaviour setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
}

- (IBAction)btnDownloadPress:(id)sender {
    
    [self generatePDF];
    
    [self drawHeader:dicStudantDetail];
    
    [self drawLine];
    
    [self drawSubjectAndMarks:arrAllBehaviyor type:type];
    
    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_IS_SEND_MAIL_PDF"] Delegate:self];
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (customAlertView.tag == 10) {
        if (buttonIndex == 1) {
            
        }
        else {
            [self deleteBehaviour:selectedIndexPath];
        }
    }
    else {
        NSString *isSend;
        
        if (buttonIndex == 1) {
            isSend = @"No";
        }
        else {
            isSend = @"Yes";
        }
        
        [self uploadPdf:isSend];
    }
}


-(void)uploadPdf:(NSString *)isSend {
    
    userObj = [[TeacherUser alloc] init];
    
    [userObj uploadPdfCharecter:[GeneralUtil getUserPreference:key_teacherId] pdfFile:PathOfReportGenerated isSend:isSend :^(NSObject *resObj) {
        
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

-(void) generatePDF

{
    /*** This is the method called by your "PDF generating" Button. Just give initial PDF page frame, Name for your PDF file to be saved as, and the path for storing it to documnets directory ***/
    pageSize = CGSizeMake(612, 792);
    
    NSString *fileName = @"characterreport.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"pdfpath %@",pdfFilePath);
    
    PathOfReportGenerated=pdfFilePath;
    
    [self generatePdfWithFilePath:pdfFilePath];
}

#pragma mark Gnerate PDf

#define kBorderInset            20.0
#define kBorderWidth            1.0
#define kMarginInset            12.0
#define kLineWidth              1.0

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

-(void)drawHeader:(NSDictionary *)studantDetail {
    
    
    NSString *schName = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_SCHOOL_NAME_TITLE"],[studantDetail valueForKey:@"school_name"]];
    
    NSString *studName = [NSString stringWithFormat:@"%@: %@\n",[GeneralUtil getLocalizedText:@"PGF_STUDENT_NAME_TITLE"],[studantDetail valueForKey:@"name"]];
    
    NSString *className = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_CLASS_TITLE"],[studantDetail valueForKey:@"class_name"]];
    
    contextX = kBorderInset + kMarginInset;
    contextY = kBorderInset + kMarginInset;
    
    contextWidth = pageSize.width - ((kBorderInset + kMarginInset) * 2);
    
    
    CGSize stringSize = [self getSizeOfContent:schName font:FONT_16_REGULER];
    CGRect renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    
    [schName drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_REGULER, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    
    stringSize = [self getSizeOfContent:studName font:FONT_16_BOLD];
    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [studName drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_BOLD, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    
    stringSize = [self getSizeOfContent:className font:FONT_16_BOLD];
    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [className drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_BOLD, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    contextY = contextY + 30; // 50 = space btwn header text and line
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

- (void) drawSubjectAndMarks:(NSMutableArray *)arrSubjectDetail type:(NSString *)ctype
{
    margin = 15;
    
    contextY = contextY + 20;
    
    NSString *testNumber = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_CATAGORY_TITLE"],ctype];
    
    CGRect renderingRect = [self drawText:testNumber :FONT_16_BOLD];
    
    contextY = contextY + renderingRect.size.height + 10;
    
   // NSString *headerTitle = [NSString stringWithFormat:@"%@ %@  %@ %@",[GeneralUtil getLocalizedText:@"PGF_DATE_TITLE"],[GeneralUtil getLocalizedText:@"PGF_REMARK_TITLE"],[GeneralUtil getLocalizedText:@"PGF_COMMENT_TITLE"],[GeneralUtil getLocalizedText:@"PGF_TEACHER_TITLE"]];
    
    
    
    
//    NSString *dateCol = [self getColum:[GeneralUtil getLocalizedText:@"PGF_DATE_TITLE"] font:FONT_16_BOLD width:30];
//    NSString *remarkCol = [self getColum:[GeneralUtil getLocalizedText:@"PGF_REMARK_TITLE"] font:FONT_16_BOLD width:40];
//    NSString *commentCol = [self getColum:[GeneralUtil getLocalizedText:@"PGF_COMMENT_TITLE"] font:FONT_16_BOLD width:60];
//    NSString *teacherCol = [self getColum:[GeneralUtil getLocalizedText:@"PGF_TEACHER_TITLE"] font:FONT_16_BOLD width:30];
//    
//    NSString *headerTitle = [NSString stringWithFormat:@"%@%@%@%@",dateCol,remarkCol,commentCol,teacherCol];
//    
//    renderingRect = [self drawText:headerTitle :FONT_16_BOLD];
//    
//    contextY = contextY + renderingRect.size.height;
    
    
    int wDate = 85, wRemark = 110, wComment = 223, wTeach = 145;
    
    int xDate = contextX;
    int xRemark = xDate + wDate;
    int xComment = xRemark + wRemark + 4;
    int xTeach = xComment + wComment + 5;
    
    CGRect rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_DATE_TITLE"] Font:FONT_16_BOLD Width:wDate X:xDate Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_REMARK_TITLE"] Font:FONT_16_BOLD Width:wRemark X:xRemark Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_COMMENT_TITLE"] Font:FONT_16_BOLD Width:wComment X:xComment Y:contextY];
    rec1 = [self drawText:[GeneralUtil getLocalizedText:@"PGF_TEACHER_TITLE"] Font:FONT_16_BOLD Width:wTeach X:xTeach Y:contextY];
    
    contextY = contextY + rec1.size.height + 5;
    
    for (NSDictionary *dicBehaviour in arrAllBehaviyor) {
        
        if (contextY > (((pageSize.height - (kBorderInset + kMarginInset))) - 100)) {
            contextY = kBorderInset + kMarginInset;
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        }
        
       CGRect rec1 = [self drawText:[GeneralUtil formateDataLocalize:[dicBehaviour valueForKey:@"char_date"]] Font:FONT_14_REGULER Width:wDate X:xDate Y:contextY];
       CGRect rec2 = [self drawText:[dicBehaviour valueForKey:@"remarks_name"] Font:FONT_14_REGULER Width:wRemark X:xRemark Y:contextY];
       CGRect rec3 = [self drawText:[dicBehaviour valueForKey:@"comment"] Font:FONT_14_REGULER Width:wComment X:xComment Y:contextY];
       CGRect rec4 = [self drawText:[dicBehaviour valueForKey:@"name"] Font:FONT_14_REGULER Width:wTeach X:xTeach Y:contextY];
        
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

@end
