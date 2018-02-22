//
//  GeneralUtil.m
//  Yappo
//
//  Created by Rahul on 14/04/14.
//  Copyright (c) 2014 kETAN. All rights reserved.
//

#import "GeneralUtil.h"
#import "LocalizeLanguage.h"
#import "Reachability.h"
#import "TeacherConstant.h"

@implementation GeneralUtil


#pragma mark - TO VALIDATE EMAILID

+(BOOL)isInternetConnection {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if(networkStatus == NotReachable) {
        return NO;
    }
    else{
        return YES;
    }
}

+(BOOL) NSStringIsValidEmail:(NSString *)emailid
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailid];
}

#pragma mark - For Storing user prefernce to NSUSERDEFAULT

+(void)setUserPreference:(NSString *)key value:(NSString *)strValue {
    
    [[NSUserDefaults standardUserDefaults] setObject:strValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setUserChildPreference:(NSString *)key value:(NSMutableArray *)arrValue {
    
    [[NSUserDefaults standardUserDefaults] setObject:arrValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setUserChildDetailPreference:(NSString *)key value:(NSDictionary *)dicValue {
    
    [[NSUserDefaults standardUserDefaults] setObject:dicValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setAppDetailPreference:(NSString *)key value:(NSDictionary *)dicValue {
    
    [[NSUserDefaults standardUserDefaults] setObject:dicValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)removeUserPreference:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getLocalizedText:(NSString *)strValue {
    //return NSLocalizedString(strValue, @"");
    return [LocalizeLanguage get:strValue alter:@""];
}

+ (NSString *)getUserPreference:(NSString *)key {
    
    NSString *strUserDetail = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //strUserDetail = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if(![self isNotNullValue:strUserDetail]) {
        return @"";
    }
    
    return strUserDetail;
}

+ (id)getUserPreferenceChild:(NSString *)key {
    
    id strUserDetail = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    strUserDetail = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if(![self isNotNullValue:strUserDetail]) {
        return @"";
    }
    
    return strUserDetail;
}

+(BOOL)isNotNullValue:(NSString*)strText {
    
    if([strText class] != [NSNull class] || strText != NULL) {
        return YES;
    }
    else {
        return NO;
    }
}
+(void)showProgress {
    
    if(!appDelegate.progressHUD) {
        appDelegate.progressHUD = [[MBProgressHUD alloc]init];
        
        appDelegate.progressHUD.dimBackground = YES;
        
        appDelegate.progressHUD.labelText = [GeneralUtil getLocalizedText:@"LBL_LOADING_STATUS_TITLE"];
        [appDelegate.window addSubview:appDelegate.progressHUD];
    }
    
    if(appDelegate.progressHUD) {
        appDelegate.progressHUD.labelText = [GeneralUtil getLocalizedText:@"LBL_LOADING_STATUS_TITLE"];
        [appDelegate.window bringSubviewToFront:appDelegate.progressHUD];
        [appDelegate.progressHUD show:YES];
    }
}

+(void)hideProgress {
    
    if(appDelegate.progressHUD) {
        [appDelegate.progressHUD hide:YES];
    }
}



+(NSDate *)getYearEndDate {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    ZDebug(@"getYearStartDate :%d, %d, %d", components.year, components.month, components.day);
    
    NSDateComponents *componentsPost = [[NSDateComponents alloc] init];
    
    if (components.month < APP_START_DATE_MONTH) {
        [componentsPost setYear:[components year]];
    }
    else if (components.month == APP_START_DATE_MONTH) {
        
        if (components.day < APP_END_DATE_DAY)
            [componentsPost setYear:[components year]];
        else
            [componentsPost setYear:[components year] + 1];
    }
    else {
        [componentsPost setYear:[components year] + 1];
    }
    
    [componentsPost setMonth:APP_START_DATE_MONTH];
    [componentsPost setDay:APP_END_DATE_DAY];
    
    
    NSCalendar *calendarPre = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *stDate = [calendarPre dateFromComponents:componentsPost];
    
    ZDebug(@"getYearStartDate: %@", stDate);
    
    return stDate;
}

+(NSDate *)getYearStartDate {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    ZDebug(@"getYearStartDate :%d, %d, %d", components.year, components.month, components.day);
    
    NSDateComponents *componentsPre = [[NSDateComponents alloc] init];
    
    if (components.month > APP_START_DATE_MONTH) {
        [componentsPre setYear:[components year]];
    }
    else if (components.month == APP_START_DATE_MONTH) {
        
        if (components.day > APP_START_DATE_DAY)
            [componentsPre setYear:[components year]];
        else
            [componentsPre setYear:[components year] - 1];
    }
    else {
        [componentsPre setYear:[components year] - 1];
    }
    
    [componentsPre setMonth:APP_START_DATE_MONTH];
    [componentsPre setDay:APP_START_DATE_DAY];
    
    
    NSCalendar *calendarPre = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *stDate = [calendarPre dateFromComponents:componentsPre];
    
    ZDebug(@"getYearStartDate: %@", stDate);
    
    return stDate;
}

+(NSDate *)getSemEndDate {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    ZDebug(@"CurrentDate :%d, %d, %d", components.year, components.month, components.day);
    
    NSDateComponents *componentsPre = [[NSDateComponents alloc] init];
    
    if (components.month < APP_START_DATE_MONTH) {
        [componentsPre setYear:[components year]];
    }
    else if (components.month == APP_SEM_END_DATE_MONTH) {
        
        [componentsPre setYear:[components year]];
    }
    else if (components.month == APP_START_DATE_MONTH) {
        
        if (components.day < APP_START_DATE_DAY)
            [componentsPre setYear:[components year]];
        else
            [componentsPre setYear:[components year] + 1];
    }
    else {
        [componentsPre setYear:[components year] + 1];
    }
    
    [componentsPre setMonth:APP_SEM_END_DATE_MONTH];
    [componentsPre setDay:APP_START_DATE_DAY];
    
    
    NSCalendar *calendarPre = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *stDate = [calendarPre dateFromComponents:componentsPre];
    
    ZDebug(@"getSemEndDate: %@", stDate);
    
    return stDate;
}

+(NSMutableArray *)getYear:(NSDate *)date {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    int curant = [components year];
    
    NSMutableArray *arrYear = [[NSMutableArray alloc] init];
    
    for (int i = curant; i > curant - 20; i--) {
        NSString *str = [NSString stringWithFormat:@"%d-%d",i,i+1];
        [arrYear addObject:str];
    }
    
    return arrYear;
}

+(CustomIOS7AlertView *)alertInfo:(NSString *)msg {
    
    CustomIOS7AlertView *alertView = [BaseViewController customAlertDisplay:msg Btns:[NSMutableArray arrayWithObjects:[GeneralUtil getLocalizedText:@"BTN_OK_TITLE"], nil]];
    [alertView show];
    
    return alertView;
}

+(CustomIOS7AlertView *)alertInfo:(NSString *)msg withDelegate:(id)delegate {
    
    CustomIOS7AlertView *alertView = [BaseViewController customAlertDisplay:msg Btns:[NSMutableArray arrayWithObjects:[GeneralUtil getLocalizedText:@"BTN_OK_TITLE"], nil]];
    alertView.delegate = delegate;
    [alertView show];
    
    return alertView;
}

+(CustomIOS7AlertView *)alertInfo:(NSString *)msg WithDelegate:(id)delegate {
    
    CustomIOS7AlertView *alertView = [BaseViewController customAlertDisplay:msg Btns:[NSMutableArray arrayWithObjects:[GeneralUtil getLocalizedText:@"BTN_OK_TITLE"], nil]];
    if (delegate) {
        alertView.delegate = delegate;
    }
    
    [alertView show];
    
    return alertView;
}

+(CustomIOS7AlertView *)alertInfo:(NSString *)msg Delegate:(id)delegate {
    
    CustomIOS7AlertView *alertView = [BaseViewController customAlertDisplay:msg Btns:[NSMutableArray arrayWithObjects:[GeneralUtil getLocalizedText:@"BTN_YES_TITLE"],[GeneralUtil getLocalizedText:@"BTN_NO_TITLE"], nil] ];
    alertView.delegate = delegate;
    [alertView show];
    
    return alertView;
}

+(BOOL)checkValidMobile:(NSString *)strMsg {
    
    
    if([strMsg isEqualToString:@""]){
        return FALSE;
    }
    else {
        if ([self isRegularMobileNumber:strMsg]) {
            return TRUE;
        }
        else {
            return FALSE;
        }
    }
}

+(BOOL)isRegularMobileNumber :(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{8}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

+(BOOL)checkPinCode:(NSString *)strMsg {
    
    
    if([strMsg isEqualToString:@""]){
        return FALSE;
    }
    else {
        if ([self isRegularPinnum:strMsg]) {
            return TRUE;
        }
        else {
            return FALSE;
        }
    }
}

+(BOOL)isRegularPinnum :(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{4}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

+(NSString *)formateData:(NSString *)date {
    
    NSDate *edate = [[NSDate alloc] init];
    
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    
    [dformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    edate = [dformat dateFromString:date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];

    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:edate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:edate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:edate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    //[formatter setDateFormat:@"dd-MMM-yyyy, HH:mm"];
    
   // [formatter setDateStyle:NSDateFormatterFullStyle];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *ed=[formatter stringFromDate:destinationDate];
    
    return ed;
}

+(NSString *)formateDataLocalize:(NSString *)date {
    
    NSDate *edate = [[NSDate alloc] init];
    
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    
    [dformat setDateFormat:@"yyyy-MM-dd"];
    
    edate = [dformat dateFromString:date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"dd-MMM-yyyy, HH:mm"];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    // [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *ed=[formatter stringFromDate:edate];
    
    return ed;
}

+(NSString *)formateDataWithDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *ed=[formatter stringFromDate:date];
    
    return ed;
}

+(NSString *)relativeDateStringForDate:(NSDate *)date
{
    
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitMinute | NSCalendarUnitHour;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    
    NSDate *today = [cal dateFromComponents:components1];
    
    components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute ) fromDate:date];
    
    NSDate *thatdate = [cal dateFromComponents:components1];
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units fromDate:today toDate:thatdate options:0];
    
    NSDate *prevDate = date;
    
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    
    [dformat setDateFormat:@"dd-MMM-yyyy"];
    
    NSString *strPrevDate=[dformat stringFromDate:prevDate];
    
    // return strPrevDate;
    
    if (components.day <= 0) {
       // return [NSString stringWithFormat:@"%ld:%ld", (long)components.hour,(long)components.minute];
        
        int h = (int)(+components.hour);
        int m = (int)(+components.minute);
        
        return [NSString stringWithFormat:@"%d:%d", h,m];
    }
    else {
        return strPrevDate;
    }
    
//    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitMinute | NSCalendarUnitHour;
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
//    NSDate *today = [cal dateFromComponents:components1];
//    
//    components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
//    NSDate *thatdate = [cal dateFromComponents:components1];
//    
//    // if `date` is before "now" (i.e. in the past) then the components will be positive
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:units fromDate:today toDate:thatdate options:0];
//    
//    NSDate *prevDate = date;
//    
//    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
//    
//    [dformat setDateFormat:@"dd-MMM-yyyy"];
//    
//    NSString *strPrevDate=[dformat stringFromDate:prevDate];
//    
//    if (components.day <= 0) {
//        return [NSString stringWithFormat:@"%ld:%ld", (long)components.hour,(long)components.minute];
//    }
//    else {
//        return strPrevDate;
//    }
//    
//    return strPrevDate;
    
//    if (components.year > 0) {
//        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
//    } else if (components.month > 0) {
//        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
//    } else if (components.weekOfYear > 0) {
//        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
//    } else if (components.day > 0) {
//        if (components.day > 1) {
//            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
//        } else {
//            return @"Yesterday";
//        }
//    } else {
//        return @"Today";
//    }
}

//+(void)incrementBadge:(NSString *)userId badgeType:(NSString *)type badge:(int)badge

+(void)incrementBadge:(NSString *)userId :(NSDictionary *)other{
    
    NSMutableArray *arrStudant = (NSMutableArray *)[GeneralUtil getUserPreference:key_saveChild];
    
    NSMutableArray *arrStudtemp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tempStud in arrStudant) {
        [arrStudtemp addObject:tempStud];
    }
    
    for (NSDictionary *stud in arrStudtemp) {
    
        if ([[stud valueForKey:@"user_id"] isEqualToString:userId]) {
            
            //int badge = [[stud valueForKey:type] intValue] + 1;
            
            NSMutableDictionary *dicNew = [stud mutableCopy];
            
            [dicNew setValue:[NSString stringWithFormat:@"%d",[[other valueForKey:@"abi"] intValue]] forKey:key_abi_badge];
            [dicNew setValue:[NSString stringWithFormat:@"%d",[[other valueForKey:@"abn"] intValue]] forKey:key_abn_badge];
            [dicNew setValue:[NSString stringWithFormat:@"%d",[[other valueForKey:@"chat_msg"] intValue]] forKey:key_chat_badge];
            
            //NSMutableArray *arrStud = [[NSMutableArray alloc] initWithArray:arrStudant];
            
            [arrStudtemp replaceObjectAtIndex:[arrStudtemp indexOfObject:stud] withObject:dicNew];
            
            [GeneralUtil setUserChildPreference:key_saveChild value:arrStudtemp];
            
            break;
        }
    }
}

+(void)clearBadge:(NSString *)userId badgeType:(NSString *)type {
    
    NSMutableArray *arrStudant = (NSMutableArray *)[GeneralUtil getUserPreference:key_saveChild];
    
    NSMutableArray *arrStudtemp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *stud in arrStudant) {
        
        if ([stud valueForKey:@"sfo_type"] == [NSNull null])
            [stud setValue:@"0" forKey:@"sfo_type"];

        [arrStudtemp addObject:stud];
    }
    
    for (NSDictionary *stud in arrStudtemp) {
        
        if ([[stud valueForKey:@"user_id"] isEqualToString:userId]) {
            
            NSMutableDictionary *dicNew = [stud mutableCopy];
            
            [dicNew setValue:@"0" forKey:type];
            
            [arrStudtemp replaceObjectAtIndex:[arrStudtemp indexOfObject:stud] withObject:dicNew];
            
            [GeneralUtil setUserChildPreference:key_saveChild value:arrStudtemp];
            
            break;
        }
    }
}

+(int)getBadge:(NSString *)userId badgeType:(NSString *)type {
    
    NSMutableArray *arrStudant = (NSMutableArray *)[GeneralUtil getUserPreference:key_saveChild];
    
    for (NSDictionary *stud in arrStudant) {
        
        if ([[stud valueForKey:@"user_id"] isEqualToString:userId]) {
            
            int badge = [[stud valueForKey:type] intValue];
            
            return badge;
        }
    }
    
    return 0;
}

+(CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+(NSArray*)getClassFromStudents:(NSMutableArray*)students
{
    NSMutableArray *aryClass = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < students.count; i++)
    {
        NSString *class = [[students objectAtIndex:i] valueForKey:@"class_name"];
        
        BOOL bExist = NO;
        for ( int j = 0; j < aryClass.count; j++)
        {
            if ([class isEqualToString:[aryClass objectAtIndex:j]])
                bExist = YES;
        }
        
        if (!bExist)
        {
            [aryClass addObject:class];
        }
    }
    
    NSArray *finalRows = [aryClass sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *letter1 = [obj1 substringToIndex:1];
        NSString *letter2 = [obj2 substringToIndex:1];
        return [letter1 compare:letter2];
    }];
    
    return finalRows;
}

@end
