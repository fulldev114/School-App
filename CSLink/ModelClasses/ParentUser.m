//
//  User.m
//  Paytime2
//
//  Created by eTech Developer 8 on 01/01/16.
//  Copyright © 2016 etechmavens. All rights reserved.
//
#import "ParentUser.h"
#import "ParentConstant.h"

@interface ParentUser ()<ParentETechAsyncRequestDelegate> {
    RequestComplitionBlock complitionBlock;
    int resCode;
}
@end

@implementation ParentUser
- (id)init {
    self = [super init];
    
    if (self) {
        self.profileImg = [[UIImageView alloc] init];
    }
    return self;
}

-(void)login:(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:self.mobile forKey:@"phone"];
    [request.dictPermValues setObject:appDelegate.version forKey:@"app_version"];
    [request.dictPermValues setObject:@"ios" forKey:@"os"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_LOGIN :request];
    
    //   }
}

-(void)verifyCode:(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:self.mobile forKey:@"phone"];
    [request.dictPermValues setObject:self.verifyCode forKey:@"vericode"];
    
    // ZDebug(@"request.dictPermValues::%@", request.dictPermValues); parent_no
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_VERIFY_CODE :request];
    //   }
    
}

-(void)registerDevice:(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:self.mobile forKey:@"phone"];
    [request.dictPermValues setObject:self.verifyCode forKey:@"vericode"];
    [request.dictPermValues setObject:@"IPHONE" forKey:@"device"];
    [request.dictPermValues setObject:self.persentNo forKey:@"parent_no"];
    [request.dictPermValues setObject:self.userToken forKey:@"token"];
    [request.dictPermValues setObject:self.userId forKey:@"userid"];
    
    NSString *devicemodel = [[UIDevice currentDevice]model];
    NSString *deviceversion =[[UIDevice currentDevice]systemVersion];
    NSString *devicename=[[UIDevice currentDevice]name];
    NSString *appversion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //NSString *appidentifire=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"bundleIdentifier"];
    NSString *appidentifire=[[NSBundle mainBundle] bundleIdentifier];
    NSString *pushbadge = @"enabled";
    NSString *pushalert = @"enabled";
    NSString *pushsound = @"enabled";
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
        
        UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
        
        if (types == UIUserNotificationTypeNone) {
            pushbadge = @"disabled";
            pushalert = @"disabled";
            pushsound = @"disabled";
        }
        else {
            if (types & UIUserNotificationTypeAlert)
                pushalert = @"enabled";
            else
                pushalert = @"disabled";
            
            if (types & UIUserNotificationTypeBadge)
                pushbadge = @"enabled";
            else
                pushbadge = @"disabled";
            
            if (types & UIUserNotificationTypeSound)
                pushsound = @"enabled";
            else
                pushsound = @"disabled";
        }
    }
    else {
        NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        pushbadge = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
        pushalert = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
        pushsound = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";
    }
    
    [request.dictPermValues setObject:APPNAME forKey:@"appname"];
    [request.dictPermValues setObject:appversion forKey:@"appversion"];
    [request.dictPermValues setObject:devicename forKey:@"devicename"];
    [request.dictPermValues setObject:devicemodel forKey:@"devicemodel"];
    [request.dictPermValues setObject:deviceversion forKey:@"deviceversion"];
    [request.dictPermValues setObject:pushbadge forKey:@"pushbadge"];
    [request.dictPermValues setObject:pushalert forKey:@"pushalert"];
    [request.dictPermValues setObject:pushsound forKey:@"pushsound"];
    [request.dictPermValues setObject:appidentifire forKey:@"clientid"];
    
    
    NSString *Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [request.dictPermValues setObject:Identifier forKey:@"deviceuid"];
    
#ifdef DEBUG
    [request.dictPermValues setObject:@"sandbox" forKey:@"environment"];
#else
    [request.dictPermValues setObject:@"production" forKey:@"environment"];
#endif
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_REGISTER_DEVICE :request];
}

-(void)verifyPin:(NSString *)pincode :(RequestComplitionBlock)reqBlock {
    
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:self.mobile forKey:@"phone"];
    [request.dictPermValues setObject:self.persentNo forKey:@"parent_no"];
    [request.dictPermValues setObject:pincode forKey:@"pincode"];
    [request.dictPermValues setObject:appDelegate.version forKey:@"app_version"];
    [request.dictPermValues setObject:@"ios" forKey:@"os"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_VIRIFY_PINCODE :request];
}

-(void)forgotPin:(NSString *)phone andParentNo:(NSString *)no :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    if(phone == nil)
        phone = @"";
    [request.dictPermValues setObject:phone forKey:@"phone"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_FORGOT_PINCODE :request];
    
}

-(void)getSchoolList:(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    // [request.dictPermValues setObject:@"" forKey:@"phone"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_SCHOOL_LIST :request];
}
-(void)getPerentList:(NSString *)userId :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"userid"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_PERENT_LIST :request];
    
}

-(void)getPeriodsAndResone:(NSString *)userId currDate:(NSString *)currdate :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"child_id"];
    [request.dictPermValues setObject:currdate forKey:@"curdate"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_PERIODS_LIST :request];
    
}

-(void)sendAbsent:(NSString *)userId periodIds:(NSString *)periodeIds resone:(NSString *)resone date:(NSString *)date :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"child_id"];
    [request.dictPermValues setObject:periodeIds forKey:@"period_ids"];
    [request.dictPermValues setObject:resone forKey:@"reason"];
    [request.dictPermValues setObject:date forKey:@"date"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_SEND_ABSENT :request];
}

-(void)getStudStatistics:(NSString *)userId startDate:(NSString *)startdate endDate:(NSString *)endate :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"child_id"];
    [request.dictPermValues setObject:startdate forKey:@"from_date"];
    [request.dictPermValues setObject:endate forKey:@"to_date"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_STATISTICS_OF_STUD :request];
}

-(void)getSelectedStudList:(NSString *)parentId :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:parentId forKey:@"parent_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_ALL_CHIELD :request];
}
-(void)getAbsentNoticeList:(NSString *)userId isAbFlag:(NSString *)isAb :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"userid"];
    [request.dictPermValues setObject:isAb forKey:@"isab"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_ABSENT_NOITCE_LIST :request];
}

-(void)getTeacherList:(NSString *)classId userid:(NSString *)userId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:classId forKey:@"classid"];
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_TEACHER_LIST :request];
}

-(void)getUserProfile:(NSString *)userId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"userid"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_CHIELD_DETAIL :request];
    
}

-(void)updateUserProfile:(NSString *)sId userName:(NSString *)uname :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:self.userId forKey:@"userid"];
    [request.dictPermValues setObject:sId forKey:@"schoolid"];
    [request.dictPermValues setObject:uname forKey:@"childname"];
    [request.dictPermValues setObject:self.persen1Name forKey:@"parent1name"];
    [request.dictPermValues setObject:self.persen1Phone forKey:@"parent1phone"];
    [request.dictPermValues setObject:self.persen2Name forKey:@"parent2name"];
    [request.dictPermValues setObject:self.persen2Phone forKey:@"parent2phone"];
    [request.dictPermValues setObject:self.persen3Name forKey:@"parent3name"];
    [request.dictPermValues setObject:self.persen3Phone forKey:@"parent3phone"];
    [request.dictPermValues setObject:self.persen1Phone forKey:@"mobile"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequestWithPdf:ACTION_PARENT_UPDATE_CHIELD_DETAIL uploadData:self.profileImg.image requestData:request];
}

-(void)getStudantList:(NSString *)schId graId:(NSString *)gid classId:(NSString *)cId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:schId forKey:@"school_id"];
    [request.dictPermValues setObject:gid forKey:@"grade_id"];
    [request.dictPermValues setObject:cId forKey:@"class_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_STUDANT_LIST :request];
}

-(void)addStudant:(NSString *)parentId studantId:(NSString *)sId :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:parentId forKey:@"parent_id"];
    [request.dictPermValues setObject:sId forKey:@"child_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_ADD_STUDANT :request];
}

-(void)sendFeedback:(NSString *)name email:(NSString *)email message:(NSString *)message :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:email forKey:@"email"];
    [request.dictPermValues setObject:message forKey:@"message"];
    [request.dictPermValues setObject:name forKey:@"name"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_CONTECT_US :request];
}
-(void)changePincode:(NSString *)parentNo phoneNo:(NSString *)phoneno oldPin:(NSString *)oldpin newPin:(NSString *)newpin :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:phoneno forKey:@"phone"];
    [request.dictPermValues setObject:newpin forKey:@"newcode"];
    [request.dictPermValues setObject:oldpin forKey:@"oldcode"];
    [request.dictPermValues setObject:parentNo forKey:@"parent_no"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_CAHNGE_PINCODE :request];
    
}
-(void)registerPerent:(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:self.persen1Name forKey:@"parent1"];
    [request.dictPermValues setObject:self.persen1Email forKey:@"email1"];
    [request.dictPermValues setObject:self.persen1Phone forKey:@"phone1"];
    
    [request.dictPermValues setObject:self.persen2Name forKey:@"parent2"];
    [request.dictPermValues setObject:self.persen2Email forKey:@"email2"];
    [request.dictPermValues setObject:self.persen2Phone forKey:@"phone2"];
    
    [request.dictPermValues setObject:self.persentPin forKey:@"pincode"];
    
    [request.dictPermValues setObject:appDelegate.version forKey:@"app_version"];
    [request.dictPermValues setObject:@"ios" forKey:@"os"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_REGISTER_PERENT :request];
}

-(void)uploadPdf:(NSString *)userId pdfFile:(NSString *)pdf :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    [request.dictPermValues setObject:@"absentreport" forKey:@"report"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequestWithPdf:ACTION_UPLOAD_PDF uploadData:pdf requestData:request];
    
}

-(void)downloadPdf:(NSMutableDictionary *)parameter isindividual:(BOOL)isindividual :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    if (isindividual) {
        
        [request.dictPermValues setObject:[parameter valueForKey:@"teacher_id"] forKey:@"teacher_id"];
        [request.dictPermValues setObject:[parameter valueForKey:@"send_email"] forKey:@"send_email"];
        [request.dictPermValues setObject:[parameter valueForKey:@"student_id"] forKey:@"student_id"];
        [request.dictPermValues setObject:[parameter valueForKey:@"class_id"] forKey:@"class_id"];
        [request.dictPermValues setObject:[parameter valueForKey:@"subject_id"] forKey:@"subject_id"];
        [request.dictPermValues setObject:[parameter valueForKey:@"test_id"] forKey:@"test_id"];
        [request.dictPermValues setObject:[parameter valueForKey:@"include_image"] forKey:@"include_image"];
        [request.dictPermValues setObject:[parameter valueForKey:@"semester_id"] forKey:@"semester_id"];
        [request.dictPermValues setObject:@"" forKey:@"selected_subjects_id"];
        
    }
    else {
        
        [request.dictPermValues setObject:[parameter valueForKey:@"teacher_id"] forKey:@"teacher_id"];
        [request.dictPermValues setObject:[parameter valueForKey:@"send_email"] forKey:@"send_email"];
        [request.dictPermValues setObject:[parameter valueForKey:@"student_id"] forKey:@"student_id"];
        [request.dictPermValues setObject:[parameter valueForKey:@"class_id"] forKey:@"class_id"];
        [request.dictPermValues setObject:@"" forKey:@"subject_id"];
        [request.dictPermValues setObject:@"" forKey:@"test_id"];
        [request.dictPermValues setObject:[parameter valueForKey:@"include_image"] forKey:@"include_image"];
        [request.dictPermValues setObject:[parameter valueForKey:@"semester_id"] forKey:@"semester_id"];
        [request.dictPermValues setObject:[parameter valueForKey:@"selected_subjects_id"] forKey:@"selected_subjects_id"];
    }
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_DOWNLOAD_PDF :request];
    
}

-(void)uploadPdfMarks:(NSString *)userId pdfFile:(NSString *)pdf :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    [request.dictPermValues setObject:@"marksreport" forKey:@"report"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequestWithPdf:ACTION_UPLOAD_MARKS_PDF uploadData:pdf requestData:request];
    
}

-(void)uploadPdfCharecter:(NSString *)userId pdfFile:(NSString *)pdf :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    [request.dictPermValues setObject:@"	" forKey:@"report"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequestWithPdf:ACTION_UPLOAD_MARKS_PDF uploadData:pdf requestData:request];
    
}

-(void)getSemseterAndSubj:(NSString *)classId schoolId:(NSString *)schoolId userId:(NSString *)userId :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:classId forKey:@"class_id"];
    [request.dictPermValues setObject:schoolId forKey:@"school_id"];
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_ALL_SEM_SUBJ :request];
}

-(void)getStudantBehaviour:(NSString *)classId schoolId:(NSString *)schoolId userId:(NSString *)userId sDate:(NSString *)sDate eDate:(NSString *)eDate desceplineId:(NSString *)descID :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:classId forKey:@"class_id"];
    [request.dictPermValues setObject:schoolId forKey:@"school_id"];
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    [request.dictPermValues setObject:sDate forKey:@"from_date"];
    [request.dictPermValues setObject:eDate forKey:@"to_date"];
    [request.dictPermValues setObject:descID forKey:@"descipline_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_DESCIPINE_AND_BEHAV :request];
}

-(void)getSubjectAndMarks:(NSString *)classId year:(NSString *)year semesterId:(NSString *)semesterId userId:(NSString *)userId :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    
    //    if(![GeneralUtil isInternetConnection]) {
    //        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [GeneralUtil hideProgress];
    //    }
    //    else {
    //
    //            NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //            [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //            complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:classId forKey:@"class_id"];
    [request.dictPermValues setObject:year forKey:@"year"];
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    [request.dictPermValues setObject:semesterId forKey:@"semester_ids"];
    
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_MARK_DEATIL :request];
}

-(void)getCharecterAndGrade:(NSString *)classId year:(NSString *)year semesterId:(NSString *)semesterId userId:(NSString *)userId schoolId:(NSString *)schoolId :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:classId forKey:@"class_id"];
    [request.dictPermValues setObject:year forKey:@"year"];
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    [request.dictPermValues setObject:semesterId forKey:@"semester_ids"];
    [request.dictPermValues setObject:schoolId forKey:@"school_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_CHERACTER_DEATIL :request];
}
-(void)getAllEmgMessage:(NSString *)userId :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    //
    //    if(![AppUtil isInternetConnection]) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
    //        [AppUtil hideProgress];
    //    }
    //    else {
    
    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
    //        complitionBlock(dictRes);
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_EMG_MESSAGE :request];
}

-(void)getStudentsListByParent:(NSString *)parentId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:parentId forKey:@"parent_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_STUDENTS_LIST :request];
}

-(void)checkInStudent:(NSString *)parentId studentId:(NSString *)sId activityId:(NSString *)aId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:parentId forKey:@"parent_id"];
    [request.dictPermValues setObject:sId forKey:@"student_id"];
    [request.dictPermValues setObject:aId forKey:@"activity_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_CHECK_IN :request];
}

-(void)checkOutStudent:(NSString *)parentId studentId:(NSString *)sId activityId:(NSString *)aId checkOutType:checkType :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:parentId forKey:@"parent_id"];
    [request.dictPermValues setObject:sId forKey:@"student_id"];
    [request.dictPermValues setObject:aId forKey:@"activity_id"];
    [request.dictPermValues setObject:checkType forKey:@"check_out_type"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_CHECK_OUT :request];
}


-(void)getActivities:(NSString *)parentId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:parentId forKey:@"parent_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    ParentETechAsyncRequest *asyncRequest = [[ParentETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_PARENT_GET_ACTIVITIES :request];
}

-(void)eTechAsyncRequestDelegate :(NSString *)action :(Response *)responseData {
    
    //    resCode = [AppUtil validateResponse:responseData];
    //
    //    if(resCode == RES_CODE_INVALID_FORMAT) {
    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_INTERNAL_SERVER_ERROR"]];
    //        complitionBlock(nil);
    //    }
    //    else{
    //
    //        if([action isEqualToString:ACTION_LOGIN]) {
    //
    //            if(resCode == RES_CODE_00) {
    //                NSMutableDictionary *dictRes = responseData.jsonData;
    //
    //                complitionBlock([dictRes objectForKey:@"res_object"]);
    //            }
    //            else {
    //
    //                [AppUtil hideProgress];
    //
    //                                if(resCode == RES_CODE_03) {
    //
    //                                    complitionBlock([NSString stringWithFormat:@"%i",RES_CODE_03]);
    //                                }
    //                                else {
    //                [AppUtil showAlertWithMsg:[responseData.jsonData valueForKey:TXT_REQ_MSG]];
    //               complitionBlock(nil);
    //                 }
    //          }
    //        }
    //    }
    
    if([action isEqualToString:ACTION_PARENT_LOGIN]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_VERIFY_CODE]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_REGISTER_DEVICE]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_VIRIFY_PINCODE]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_FORGOT_PINCODE]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_SCHOOL_LIST]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_STUDANT_LIST]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_ADD_STUDANT]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_REGISTER_PERENT]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_ALL_CHIELD]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_CHIELD_DETAIL]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_UPDATE_CHIELD_DETAIL]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_TEACHER_LIST]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_ABSENT_NOITCE_LIST]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_CAHNGE_PINCODE]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_CONTECT_US]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_PERENT_LIST]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_PERIODS_LIST]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_SEND_ABSENT]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_STATISTICS_OF_STUD]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_UPLOAD_PDF]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_ALL_SEM_SUBJ]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_MARK_DEATIL]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_CHERACTER_DEATIL]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_EMG_MESSAGE]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_PARENT_GET_DESCIPINE_AND_BEHAV]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if([action isEqualToString:ACTION_DOWNLOAD_PDF]) {
        
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if ([action isEqualToString:ACTION_PARENT_GET_ACTIVITIES]) {
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if ([action isEqualToString:ACTION_PARENT_GET_STUDENTS_LIST]) {
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if ([action isEqualToString:ACTION_PARENT_CHECK_IN]) {
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
    else if ([action isEqualToString:ACTION_PARENT_CHECK_OUT]) {
        NSMutableDictionary *dictRes = responseData.jsonData;
        
        complitionBlock(dictRes);
    }
}

@end
