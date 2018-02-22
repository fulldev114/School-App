//
//  StatisticViewController.m
//  CSLink
//
//  Created by etech-dev on 6/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "StatisticViewController.h"
#import "BaseViewController.h"
#import "ParentConstant.h"
#import "IQActionSheetPickerView.h"

#define kBorderInset            20.0
#define kBorderWidth            1.0
#define kMarginInset            12.0
#define kLineWidth              1.0

@interface StatisticViewController ()<IQActionSheetPickerViewDelegate>
{
    NSString *sDate,*eDate;
    ParentUser *userObj;
    NSData *pdfData;
    BOOL isPDFGenerated;
    NSString* PathOfReportGenerated;
    CGSize pageSize;
    NSMutableDictionary *PDFReportData;
    NSString * pdf_totalDays;
    NSString * pdf_totalHours;
    NSString * pdf_totalReportHours;
    NSString * pdf_totalReportDays;
    NSArray * pdf_absentInfo;
    NSMutableArray * pdf_absentInfoReal;
    NSMutableArray * pdf_assist;
    NSMutableArray * pdf_dates;
    NSMutableDictionary * pdf_dicFlag;
    NSMutableDictionary *resultDict;
}
@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_STATISTICS"] WithSel:@selector(menuClick)];
    [BaseViewController formateButtonCyne:btnDownload title:[GeneralUtil getLocalizedText:@"BTN_DOWNLOAD_TITLE"] withIcon:@"pdf-icon" withBgColor:TEXT_COLOR_CYNA];
    // Progress Bar Customization
    
    [_dayProcess setStartAngle:270.0f];
    
    [_dayProcess setProgressBarWidth:5.0f];
    [_dayProcess setProgressBarProgressColor:TEXT_COLOR_LIGHT_YELLOW];
    [_dayProcess setProgressBarTrackColor:[UIColor whiteColor]];
    
    // Hint View Customization
    [_dayProcess setHintViewSpacing:1.0f];
    [_dayProcess setHintViewBackgroundColor:APP_BACKGROUD_COLOR];
    [_dayProcess setHintTextFont:FONT_18_BOLD];
    [_dayProcess setHintTextColor:TEXT_COLOR_LIGHT_YELLOW];
    [_dayProcess setHintTextGenerationBlock:^NSString *(CGFloat progress) {
        return [NSString stringWithFormat:@"%d", (int) progress * 365];
    }];
    
    [_hourProcess setStartAngle:270.0f];
    
    [_hourProcess setProgressBarWidth:5.0f];
    [_hourProcess setProgressBarProgressColor:TEXT_COLOR_LIGHT_GREEN];
    [_hourProcess setProgressBarTrackColor:[UIColor whiteColor]];
    
    // Hint View Customization
    [_hourProcess setHintViewSpacing:1.0f];
    [_hourProcess setHintViewBackgroundColor:APP_BACKGROUD_COLOR];
    [_hourProcess setHintTextFont:FONT_18_BOLD];
    [_hourProcess setHintTextColor:TEXT_COLOR_LIGHT_GREEN];
    [_hourProcess setHintTextGenerationBlock:^NSString *(CGFloat progress) {
        return [NSString stringWithFormat:@"%d", (int) progress * 365];
    }];
    
    lblEndDate.textColor = TEXT_COLOR_CYNA;
    lblEndDate.font = FONT_16_BOLD;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    
    [dformat setDateFormat:@"dd-MMM-yyyy"];
    
    lblEndDate.text = [dformat stringFromDate:date];
    
    lblStartDate.textColor = TEXT_COLOR_CYNA;
    lblStartDate.font = FONT_16_BOLD;
    
    NSDate *stDate = [GeneralUtil getYearStartDate];
    
    lblStartDate.text = [dformat stringFromDate:stDate];
    
    [dformat setDateFormat:@"yyyy-MM-dd"];
    
    eDate = [dformat stringFromDate:date];
    sDate = [dformat stringFromDate:stDate];
    
    lblTo.textColor = TEXT_COLOR_WHITE;
    lblTo.font = FONT_16_BOLD;
   // lblTo.text = [GeneralUtil getLocalizedText:@"LBL_TO_TITLE"];
    
    lblDays.textColor = TEXT_COLOR_LIGHT_YELLOW;
    lblDays.font = FONT_16_BOLD;
    lblDays.text = [GeneralUtil getLocalizedText:@"LBL_DAYS_TITLE"];
    
    lblHours.textColor = TEXT_COLOR_LIGHT_GREEN;
    lblHours.font = FONT_16_BOLD;
    lblHours.text = [GeneralUtil getLocalizedText:@"LBL_HOURS_TITLE"];
    
    userObj = [[ParentUser alloc] init];
    
    lblUserName.font = FONT_16_BOLD;
    lblUserName.textColor = TEXT_COLOR_WHITE;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    [BaseViewController setRoudRectImage:profileImg];
    
    [self getStudantStatistic:sDate endDate:eDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)menuClick {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}

-(void)getStudantStatistic:(NSString *)startDate endDate:(NSString *)endDate {

    [userObj getStudStatistics:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] startDate:startDate endDate:endDate :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        resultDict = [[NSMutableDictionary alloc] init];
        resultDict = (NSMutableDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                NSDateFormatter *f = [[NSDateFormatter alloc] init];
                [f setDateFormat:@"yyyy-MM-dd"];
                NSDate *stDate = [f dateFromString:startDate];
                NSDate *enDate = [f dateFromString:endDate];
                
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                    fromDate:stDate
                                                                      toDate:enDate
                                                                     options:NSCalendarWrapComponents];
                
                float totaleDay = ([[dicRes valueForKey:@"tdays"] floatValue]/[components day]);
                float totaleHour = ([[dicRes valueForKey:@"thours"] floatValue]/24);
                
                
                lblUserName.text = [[[dicRes valueForKey:@"user_info"] objectAtIndex:0]valueForKey:@"student_name"];
                
                [_dayProcess setProgress:totaleDay animated:YES];
                [_hourProcess setProgress:totaleHour animated:YES];
                
                
                [_dayProcess setHintTextGenerationBlock:^NSString *(CGFloat progress) {
                    return [NSString stringWithFormat:@"%d",[[dicRes valueForKey:@"tdays"] intValue]];
                }];
                
                [_hourProcess setHintTextGenerationBlock:^NSString *(CGFloat progress) {
                    return [NSString stringWithFormat:@"%d",[[dicRes valueForKey:@"thours"] intValue]];
                }];
                
                pdf_assist = [[NSMutableArray alloc] init];
                NSArray * totalAbsents = [resultDict valueForKey:@"absent_student_info"];
                NSNumber *tHours1 = [resultDict valueForKey:@"thours"];
                NSNumber *tDays1 = [resultDict valueForKey:@"tdays"];
                int tHours = [tHours1 intValue];
                int tDays = [tDays1 intValue];
                
                pdf_absentInfo = [resultDict valueForKey:@"absent_student_info"];
                int i;
                int sTotalhours = 0, sTotalReporthours = 0, sTotalReportdays = 0;
                NSMutableDictionary* m_dictionary = [[NSMutableDictionary alloc] init];
                pdf_absentInfoReal = [[NSMutableArray alloc] init];
                NSMutableArray * m_assit = [[NSMutableArray alloc] init];
                NSMutableDictionary * flagReportDay = [[NSMutableDictionary alloc] init];
                pdf_dicFlag = [[NSMutableDictionary alloc] init];
                pdf_dates = [[NSMutableArray alloc] init];
                NSString * strDate;
                for (i = 0; i < pdf_absentInfo.count; i++) {
                    NSArray * aryOne = [pdf_absentInfo objectAtIndex:i];
                    NSNumber * hourCounts = [aryOne valueForKey:@"hours"];
                    NSString * strReason = [aryOne valueForKey:@"reason"];
                    strDate = [aryOne valueForKey:@"date"];
                    NSString * strLectures = [aryOne valueForKey:@"lectures"];
                    NSString *cntHours = [aryOne valueForKey:@"cnt_hours"];
                    NSString *cnt      = [aryOne valueForKey:@"cnt"];
                    if ([cntHours isEqualToString:cnt]) {
                        strLectures = [NSString stringWithFormat:@"1 %@", [GeneralUtil getLocalizedText:@"PGF_DAY_TITLE"]];
                    }
                    NSString * str = [pdf_dicFlag valueForKey:strDate];
                    
                    sTotalhours += hourCounts.intValue;
                    if (![strReason isEqualToString:@"-"]) {
                        sTotalReporthours += hourCounts.intValue;
                        NSString * strFlag = [flagReportDay valueForKey:strDate];
                        if (!strFlag) {
                            
                            [flagReportDay setValue:@"YES" forKey:strDate];
                            sTotalReportdays ++;
                        }
                    }
                    
                    if (!str && i!= 0) {
                        [pdf_absentInfoReal addObject:m_dictionary];
                        [pdf_assist addObject:m_assit];
                        m_dictionary = [[NSMutableDictionary alloc] init];
                        m_assit = [[NSMutableArray alloc] init];
                        [m_assit addObject:strReason];
                        
                        [m_dictionary setValue:strLectures forKey:strReason];
                        
                    }
                    else{
                        [m_assit addObject:strReason];
                        [m_dictionary setValue:strLectures forKey:strReason];
                    }
                    if (!str) [pdf_dates addObject:strDate];
                    [pdf_dicFlag setValue:@"YES" forKey:strDate];
                }
                [pdf_absentInfoReal addObject:m_dictionary];
                [pdf_assist addObject:m_assit];
                
                
                pdf_totalDays = [NSString stringWithFormat:@"%d", (int)pdf_absentInfoReal.count];
                pdf_totalHours = [NSString stringWithFormat:@"%d",sTotalhours];
                pdf_totalReportDays = [NSString stringWithFormat:@"%d",sTotalReportdays];
                pdf_totalReportHours = [NSString stringWithFormat:@"%d",sTotalReporthours];
                pdf_totalDays = [NSString stringWithFormat:@"%d", tDays];
                pdf_totalHours = [NSString stringWithFormat:@"%d",tHours];
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
- (IBAction)btnSetProgress:(id)sender {

    
}

- (void) generatePdfWithFilePath: (NSString *)thefilePath

{
    /*** Now generating the pdf  and storing it to the documents directory of device on selected path. Customize do-while loop to meet your pdf requirements like number of page, Size of NSstrings/texts you want to fit. Basically just call all the above methods depending on your requirements from do-while loop or you can recustomize it. ****/
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    NSInteger currentPage = 0;
    BOOL done = NO;
    do
    {
        //Start a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        //Draw a page number at the bottom of each page.
        currentPage++;
        //Draw a border for each page.
        //Draw text fo your header.
        [self drawHeader];
        
        [self drawSubHeader];
        //Draw a line below the header.
        //Draw some text for the page.
        [self drawText];
        //Draw an image
        done = YES;
    }
    while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    [self showPDFFileFromServer];
    //    [[[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Success", @"Success") message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}
-(void)showPDFFileFromServer {
    
        [userObj uploadPdf:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] pdfFile:PathOfReportGenerated :^(NSObject *resObj) {
            
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
- (void) drawHeader
{
    /*** drawing header format for PDF  *****/
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    NSString *textToDraw = @"Fraværsrapport";
    UIFont *font = [UIFont systemFontOfSize:16.0];
    
    CGSize stringSize = [textToDraw sizeWithFont:font constrainedToSize:CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height);
    [textToDraw drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
}

- (void) drawSubHeader
{
    /*** drawing header format for PDF  *****/
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    NSString * strFrom = [GeneralUtil formateDataLocalize:sDate];
    NSString * strTo = [GeneralUtil formateDataLocalize:eDate];
    
    NSString *textToDraw = [NSString stringWithFormat:@"%@ To %@",strFrom ,strTo];
    
    UIFont *font = [UIFont systemFontOfSize:14.0];
    
    CGSize stringSize = [textToDraw sizeWithFont:font constrainedToSize:CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset+20, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height);
    [textToDraw drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
}

- (void) drawText
{
    
    /***calculate the size of the NSString/Texts we need to draw ***/
    
    ZDebug(@"%@", resultDict);
    
    if (resultDict != nil)
    {
        CGContextRef    currentContext = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
        NSString * studentInfo = [NSString stringWithFormat:@"%@\n\t%@: %@\n\t%@: %@\n\t%@: %@\n\t%@: %@",[GeneralUtil getLocalizedText:@"PGF_STUDENT_INFO_TITLE"],[GeneralUtil getLocalizedText:@"PGF_STUDENT_NAME_TITLE"], [[[resultDict valueForKey:@"user_info"] objectAtIndex:0] valueForKey:@"student_name"],[GeneralUtil getLocalizedText:@"PGF_SCHOOL_NAME_TITLE"],[[[resultDict valueForKey:@"user_info"] objectAtIndex:0] valueForKey:@"school_name"],[GeneralUtil getLocalizedText:@"PGF_CLASS_NAME_TITLE"],[[[resultDict valueForKey:@"user_info"] objectAtIndex:0] valueForKey:@"class_name"],[GeneralUtil getLocalizedText:@"PGF_PERANT_NAME_TITLE"],[[resultDict valueForKey:@"parent_info"] valueForKey:@"parent_name"]];
        
        NSString * teacherInfo = [NSString stringWithFormat:@"%@\n\t%@: %@\n\t%@: %@\n\t%@: %@",[GeneralUtil getLocalizedText:@"PGF_TEACHER_INFO_TITLE"],[GeneralUtil getLocalizedText:@"PGF_TEACHER_NAME_TITLE"], [[[resultDict valueForKey:@"user_info"] objectAtIndex:0] valueForKey:@"teacher_name"],[GeneralUtil getLocalizedText:@"PGF_TEACHER_EMAIL_TITLE"],[[[resultDict valueForKey:@"user_info"] objectAtIndex:0] valueForKey:@"school_email"], [GeneralUtil getLocalizedText:@"PGF_TEACHER_MOBILE_TITLE"],[[[resultDict valueForKey:@"user_info"] objectAtIndex:0] valueForKey:@"school_phone"]];
        
        NSString * strStaticsTotal = [NSString stringWithFormat:@"%@\n\t %@: %@\n\t%@: %@",[GeneralUtil getLocalizedText:@"PGF_HEDER_TITLE"],[GeneralUtil getLocalizedText:@"PGF_TOTAL_DAY_TITLE"],pdf_totalDays,[GeneralUtil getLocalizedText:@"PGF_TOTAL_HOUR_TITLE"],pdf_totalHours];
        
        int i,j;
        NSMutableString * strDatesAll = [[NSMutableString alloc] init];
        for (i = 0; i < pdf_absentInfoReal.count ; i++) {
            NSString * strOneCell;
            NSArray * aryDic = [pdf_absentInfoReal objectAtIndex:i];
            NSArray * aryElement = [pdf_assist objectAtIndex:i];
            NSMutableString * strMut = [[NSMutableString alloc] init];
            [strMut appendString:@"\t"];
            
            if ([pdf_dates count] > 0) {
                
                NSString *currDate = [pdf_dates objectAtIndex:i];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dateFromString = [[NSDate alloc] init];
                // voila!
                dateFromString = [dateFormatter dateFromString:currDate];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd MMM yyyy"];
                NSString *dateStr = [df stringFromDate:dateFromString];
                
                [strMut appendString:dateStr];
                
                for (j = 0; j < aryElement.count ; j++) {
                    NSString * strele = [aryElement objectAtIndex:j];
                    strOneCell = [NSString stringWithFormat:@"\t\t%@: %@\t\t\n\t\t\t\t\t%@: %@", [GeneralUtil getLocalizedText:@"PGF_LECTURE_TITLE"], [aryDic valueForKey:strele], [GeneralUtil getLocalizedText:@"PGF_REASONE_TITLE"], strele];
                    [strMut appendString:strOneCell];
                    [strMut appendString:@"\n\t\t\t"];
                }
                [strMut appendString:@"\n"];
                NSString * realOneDate = [NSString stringWithString:strMut];
                [strDatesAll appendString:realOneDate];
            }
        }
        NSString * strLines = [NSString stringWithString:strDatesAll];
        
        NSString * strTotalPDF = [NSString stringWithFormat:@"%@\n\n\n%@\n\n\n%@\n\n%@",studentInfo,teacherInfo,strStaticsTotal,strLines];
        
        UIFont *font = [UIFont systemFontOfSize:14.0];
        CGSize stringSize = [strTotalPDF sizeWithFont:font   constrainedToSize:CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset + 50.0, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height);
        [strTotalPDF drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    }
}

- (IBAction)btnEndDatePress:(id)sender {
    
   IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
    picker.tag = 2;
    [picker setMaximumDate:[GeneralUtil getYearEndDate]];
    [picker setMinimumDate:[GeneralUtil getYearStartDate]];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

- (IBAction)startDatePress:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:[GeneralUtil getLocalizedText:@"LBL_DATE_TIME_TITLE"] delegate:self];
    picker.tag = 1;
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
        
        sDate = [formatter stringFromDate:date];
        
    }
    
    if (pickerView.tag == 2) {
        
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        eDate = [formatter stringFromDate:date];
    }
    
    NSDate *etDate = [formatter dateFromString:eDate];
    NSDate *stDate = [formatter dateFromString:sDate];
    
    if ([etDate compare:stDate] == NSOrderedDescending || [etDate compare:stDate] == NSOrderedSame) {
        // [GeneralUtil alertInfo:@"valide"];
        
        [formatter setDateFormat:@"dd-MMM-yyyy"];
        
        lblStartDate.text = [formatter stringFromDate:stDate];
        lblEndDate.text = [formatter stringFromDate:etDate];
        
        [self getStudantStatistic:sDate endDate:eDate];
    }
    else {
        [GeneralUtil alertInfo:@"invalide date"];
    }
}

- (IBAction)btnDownload:(id)sender {
    
    /*** This is the method called by your "PDF generating" Button. Just give initial PDF page frame, Name for your PDF file to be saved as, and the path for storing it to documnets directory ***/
    pageSize = CGSizeMake(612, 792);
    
    NSString *fileName = @"AbsentReport.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"pdfpath %@",pdfFilePath);
    
    PathOfReportGenerated=pdfFilePath;
    
    [self generatePdfWithFilePath:pdfFilePath];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    BOOL fileExists = [fileMgr fileExistsAtPath:PathOfReportGenerated];
    
    if(fileExists==YES)
    {
        [pdfData writeToFile:nil atomically:YES];
    }
    else
    {
        [pdfData writeToFile:PathOfReportGenerated atomically:YES];
    }
}
@end
