//
//  GeneralUtil.h
//  Yappo
//
//  Created by Rahul on 14/04/14.
//  Copyright (c) 2014 kETAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "CustomIOS7AlertView.h"


@interface GeneralUtil : NSObject{
    
}
+(BOOL)isInternetConnection;
+(void)setUserPreference:(NSString *)key value:(NSString *)strValue;
+(void)setUserChildPreference:(NSString *)key value:(NSMutableArray *)arrValue;
+(void)setUserChildDetailPreference:(NSString *)key value:(NSDictionary *)dicValue;
+(void)removeUserPreference:(NSString *)key;
+ (NSString *)getUserPreference:(NSString *)key;
+ (id)getUserPreferenceChild:(NSString *)key;

+(BOOL) NSStringIsValidEmail:(NSString *)emailid;
+(NSString *)getLocalizedText:(NSString *)strValue;
+(void)showProgress;
+(void)hideProgress;

+(BOOL)isNotNullValue:(NSString*)strText;

+(CustomIOS7AlertView *)alertInfo:(NSString *)msg;
+(CustomIOS7AlertView *)alertInfo:(NSString *)msg withDelegate:(id)delegate;
+(CustomIOS7AlertView *)alertInfo:(NSString *)msg WithDelegate:(id)delegate;
+(CustomIOS7AlertView *)alertInfo:(NSString *)msg Delegate:(id)delegate;

+(BOOL)isRegularMobileNumber :(NSString*)number;
+(BOOL)checkValidMobile:(NSString *)strMsg;
+(BOOL)checkPinCode:(NSString *)strMsg;

+(NSString *)formateData:(NSString *)date;
+(NSString *)formateDataWithDate:(NSDate *)date;
+(NSString *)relativeDateStringForDate:(NSDate *)date;
+(NSString *)formateDataLocalize:(NSString *)date;

+(void)incrementBadge:(NSString *)userId :(NSDictionary *)other;
+(void)incrementBadge:(NSString *)userId badgeType:(NSString *)type badge:(int)badge;
+(void)clearBadge:(NSString *)userId badgeType:(NSString *)type;
+(int)getBadge:(NSString *)userId badgeType:(NSString *)type;
+(NSMutableArray *)getYear:(NSDate *)date;
+(NSDate *)getYearStartDate;
+(NSDate *)getYearEndDate;
+(NSDate *)getSemEndDate;
+(void)setAppDetailPreference:(NSString *)key value:(NSDictionary *)dicValue;
+(CGFloat)screenWidth;
+(NSArray*)getClassFromStudents:(NSMutableArray*)students;

@end
