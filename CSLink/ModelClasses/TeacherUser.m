//
//  User.m
//  Paytime2
//
//  Created by eTech Developer 8 on 01/01/16.
//  Copyright © 2016 etechmavens. All rights reserved.
//
#import "TeacherUser.h"
#import "TeacherConstant.h"

@interface TeacherUser ()<TeacherETechAsyncRequestDelegate> {
    RequestComplitionBlock complitionBlock;
    int resCode;
}
@end

@implementation TeacherUser
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
            
        [request.dictPermValues setObject:self.email forKey:@"email"];
        [request.dictPermValues setObject:appDelegate.version forKey:@"app_version"];
        [request.dictPermValues setObject:@"ios" forKey:@"os"];
    
        ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
        
        TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
        asyncRequest.delegate = self;
    
        [asyncRequest sendPostRequest:ACTION_TEACHER_LOGIN :request];
    
 //   }
}

-(void)verifyCode:(RequestComplitionBlock) reqBlock {

        [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:self.email forKey:@"email"];
    [request.dictPermValues setObject:self.verifyCode forKey:@"vericode"];
    
    // ZDebug(@"request.dictPermValues::%@", request.dictPermValues); parent_no
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_VERIFY_CODE :request];
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
    
    [request.dictPermValues setObject:@"IPHONE" forKey:@"device"];
    #if !TARGET_IPHONE_SIMULATOR
        [request.dictPermValues setObject:self.userToken forKey:@"token"];
    #endif
    [request.dictPermValues setObject:self.userId forKey:@"userid"];
    
    NSString *devicemodel = [[UIDevice currentDevice]model];
    NSString *deviceversion =[[UIDevice currentDevice]systemVersion];
    NSString *devicename=[[UIDevice currentDevice]name];
    NSString *appversion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
   // NSString *appidentifire=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"bundleIdentifier"];
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
    
    
    //[request.dictPermValues setObject:[self getUniqueDeviceIdentifierAsString] forKey:@"deviceuid"];
    
#ifdef DEBUG
    [request.dictPermValues setObject:@"sandbox" forKey:@"environment"];
#else
    [request.dictPermValues setObject:@"production" forKey:@"environment"];
#endif
    
     ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_REGISTER_DEVICE :request];
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
    
    [request.dictPermValues setObject:self.email forKey:@"email"];
    [request.dictPermValues setObject:pincode forKey:@"code"];
    [request.dictPermValues setObject:appDelegate.version forKey:@"app_version"];
    [request.dictPermValues setObject:@"ios" forKey:@"os"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_VIRIFY_PINCODE :request];
}

-(void)forgotPin:(NSString *)email :(RequestComplitionBlock) reqBlock {
    
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
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_FORGOT_PINCODE :request];
}


-(void)getStudantList:(NSString *)teacherId classId:(NSString *)cId :(RequestComplitionBlock)reqBlock {

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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:cId forKey:@"class_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_STUDANT_LIST :request];
}

-(void)checkInStudent:(NSString *)teacherId studentId:(NSString *)sId activityId:(NSString *)aId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:sId forKey:@"student_id"];
    [request.dictPermValues setObject:aId forKey:@"activity_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_SET_CHECKIN_BY_TEACHER :request];
}

-(void)getCheckedInStudentsList:(NSString *)teacherId classId:(NSString *)cId activityId:(NSString *)aId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:cId forKey:@"class_id"];
    [request.dictPermValues setObject:aId forKey:@"activity_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_CHECKEDIN_STUDENTS_LIST :request];
}


-(void)getCheckedOutStudentsList:(NSString *)teacherId classId:(NSString *)cId activityId:(NSString *)aId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:cId forKey:@"class_id"];
    [request.dictPermValues setObject:aId forKey:@"activity_id"];

    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_CHECKEDOUT_STUDENTS_LIST :request];
}

-(void)getStudentsList:(NSString *)teacherId classId:(NSString *)cId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:cId forKey:@"class_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_STUDENTS_LIST :request];
}

-(void)getStudentDetail:(NSString *)studentId Language:(NSString *)lang :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:studentId forKey:@"student_id"];
    [request.dictPermValues setObject:lang forKey:@"language"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_GET_STUDENT_DETAIL :request];
}

-(void)editStudentDetail:(NSString*) studentId Language:(NSString *)lang Data:(NSDictionary *)dic :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:studentId forKey:@"student_id"];
    [request.dictPermValues setObject:lang forKey:@"language"];
    [request.dictPermValues setObject:[dic valueForKey:@"first_name"] forKey:@"first_name"];
    [request.dictPermValues setObject:[dic valueForKey:@"last_name"] forKey:@"last_name"];
    [request.dictPermValues setObject:[dic valueForKey:@"email"] forKey:@"email"];
    [request.dictPermValues setObject:[dic valueForKey:@"mobile"] forKey:@"mobile"];
    [request.dictPermValues setObject:[dic valueForKey:@"telephone"] forKey:@"telephone"];
    [request.dictPermValues setObject:[dic valueForKey:@"class_name"] forKey:@"class_name"];
    [request.dictPermValues setObject:[dic valueForKey:@"contact_sfo"] forKey:@"contact_sfo"];
    [request.dictPermValues setObject:[dic valueForKey:@"doctor_name"] forKey:@"doctor_name"];
    [request.dictPermValues setObject:[dic valueForKey:@"doctor_contact"] forKey:@"doctor_contact"];
    [request.dictPermValues setObject:[dic valueForKey:@"check_out_rules"] forKey:@"check_out_rules"];

    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_SET_STUDENT_DETAIL :request];
}

-(void)deleteActivity:(NSString *)activityId :(RequestComplitionBlock) reqBlock
{
    [GeneralUtil showProgress];
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:activityId forKey:@"activity_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_DELETE_ACTIVITY :request];

}

-(void)sendCheckOutRule:(NSString *)studentId rules:(NSMutableArray *)rules :(RequestComplitionBlock) reqBlock {
    
    [GeneralUtil showProgress];
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:studentId forKey:@"student_id"];
    [request.dictPermValues setObject:rules forKey:@"check_out_rules"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_SET_STUDENT_DETAIL :request];
}

-(void)getStudentsListInActivity:(NSString *)teacherId activityId:(NSString*)aId classId:(NSString *)cId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:aId forKey:@"activity_id"];
    [request.dictPermValues setObject:cId forKey:@"class_id"];
    
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_STUDENTS_LIST :request];
}
-(void)getActivityDetails:(NSString *)activityID :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:activityID forKey:@"activity_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_ACTIVITY_DETAILS :request];
}
-(void)getActivities:(NSString *)teacherId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_ACTIVITIES :request];
}

-(void)getNotifications:(NSString *)teacherId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_NOTIFICATIONS :request];
}

-(void)getStudentsInActivity:(NSString *)teacherId :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_STUDENTS_IN_ACTIVITY :request];
}

-(void)getTeacherClass:(NSString *)teacherId :(RequestComplitionBlock) reqBlock {
    
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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_TEACHER_CLASS_LIST :request];

}

-(void)uploadPdf:(NSString *)teacherId pdfFile:(NSString *)pdf isSend:(NSString *)isSend :(RequestComplitionBlock)reqBlock {
    
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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:@"absentreport" forKey:@"report"];
    [request.dictPermValues setObject:isSend forKey:@"sendmail"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequestWithPdf:ACTION_UPLOAD_PDF uploadData:pdf requestData:request];
    
}
-(void)uploadPdfMarks:(NSString *)teacherId pdfFile:(NSString *)pdf isSend:(NSString *)isSend :(RequestComplitionBlock)reqBlock {
    
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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:@"marksreport" forKey:@"report"];
    [request.dictPermValues setObject:[isSend lowercaseString] forKey:@"sendmail"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequestWithPdf:ACTION_UPLOAD_MARKS_PDF uploadData:pdf requestData:request];
    
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
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_DOWNLOAD_PDF :request];
    
}


-(void)uploadPdfCharecter:(NSString *)teacherId pdfFile:(NSString *)pdf isSend:(NSString *)isSend :(RequestComplitionBlock)reqBlock {
    
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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:@"characterreport" forKey:@"report"];
    [request.dictPermValues setObject:[isSend lowercaseString] forKey:@"sendmail"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequestWithPdf:ACTION_UPLOAD_MARKS_PDF uploadData:pdf requestData:request];
    
}
-(void)getAllTeacherList:(NSString *)teacherId :(RequestComplitionBlock) reqBlock {

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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_TEACHER_LIST :request];
    
}
-(void)sendMessageToStudant:(NSString *)teacherId classId:(NSString *)classId studId:(NSString *)studId message:(NSString *)msg :(RequestComplitionBlock) reqBlock {
    
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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:classId forKey:@"class_ids"];
    [request.dictPermValues setObject:studId forKey:@"student_ids"];
    [request.dictPermValues setObject:msg forKey:@"message"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_SEND_MESSAGE_TO_STUD :request];
    
}


-(void)getAttendanceOfStud:(NSString *)classId teacherId:(NSString *)teacherid date:(NSString *)Date :(RequestComplitionBlock) reqBlock {
    
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
    [request.dictPermValues setObject:Date forKey:@"date"];
    [request.dictPermValues setObject:teacherid forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_ATTENDANC_OF_STUD :request];
    
}

-(void)getRequestStudantList:(NSString *)schId teacherId:(NSString *)teacherId :(RequestComplitionBlock) reqBlock {

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
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_REQUEST_STUDANT_LIST :request];
}

-(void)getReposrtStudantList:(NSString *)schId gradeId:(NSString *)gradeId classId:(NSString *)classsId :(RequestComplitionBlock) reqBlock {

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
    
   // [request.dictPermValues setObject:schId forKey:@"school_id"];
    [request.dictPermValues setObject:gradeId forKey:@"grade_id"];
    [request.dictPermValues setObject:classsId forKey:@"class_id"];
    [request.dictPermValues setObject:schId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_REPOSRT_STUDANT_LIST :request];
}

-(void)checkOutStudent:(NSString *)teacherId studentId:(NSString *)sId activityId:(NSString *)aId checkOutType:checkType :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:sId forKey:@"student_id"];
    [request.dictPermValues setObject:aId forKey:@"activity_id"];
    [request.dictPermValues setObject:checkType forKey:@"check_out_type"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_SET_CHECKOUT_BY_TEACHER :request];
}

-(void)sendStatisticeOfClass:(NSString *)teacherId schoolId:(NSString *)schId gradeId:(NSString *)gradeId classId:(NSString *)classsId sdate:(NSString *)sdate edate:(NSString *)edate :(RequestComplitionBlock) reqBlock{
    
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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:gradeId forKey:@"grade_id"];
    [request.dictPermValues setObject:classsId forKey:@"class_id"];
    [request.dictPermValues setObject:sdate forKey:@"from_date"];
    [request.dictPermValues setObject:edate forKey:@"to_date"];
    [request.dictPermValues setObject:schId forKey:@"school_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_STATISTICS_BY_TECHER_OF_CLASS :request];
}

-(void)getAbsentStatestic:(NSString *)childId startdate:(NSString *)sdate endDate:(NSString *)edate :(RequestComplitionBlock) reqBlock {
    
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
    
    [request.dictPermValues setObject:childId forKey:@"child_id"];
    [request.dictPermValues setObject:sdate forKey:@"from_date"];
    [request.dictPermValues setObject:edate forKey:@"to_date"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_STATISTICS_BY_TECHER :request];

}
-(void)saveAbsentReport:(NSString *)teacherId classId:(NSString *)classsId date:(NSString *)date data:(NSString *)data changenotices:(NSString *)changenotices addnotices:(NSString *)addnotices notices:(NSString *)notices absentReason:(NSString *)absentreason noticesReason:(NSString *)noticereason :(RequestComplitionBlock) reqBlock {
    
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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:classsId forKey:@"class_id"];
    [request.dictPermValues setObject:date forKey:@"date"];
    [request.dictPermValues setObject:data forKey:@"datas"];
   // [request.dictPermValues setObject:changenotices forKey:@"changenotices"];
   // [request.dictPermValues setObject:addnotices forKey:@"addnotices"];
    [request.dictPermValues setObject:notices forKey:@"notices"];
    [request.dictPermValues setObject:absentreason forKey:@"absentreason"];
    [request.dictPermValues setObject:noticereason forKey:@"noticereason"];
    
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_SAVE_ABSENT_REPORT_TECHER :request];
}
-(void)sendAbsentReport:(NSString *)teacherId date:(NSString *)date classId:(NSString *)classsId :(RequestComplitionBlock) reqBlock {

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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:date forKey:@"date"];
    [request.dictPermValues setObject:classsId forKey:@"class_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_SEND_ABSENT_NOTICE_TEACHER :request];
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
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_REGISTER_PERENT :request];
}

-(void)studRequestApproveOrReject:(NSString *)teacherId userId:(NSString *)userId parentId:(NSString *)parentId  value:(NSString *)value :(RequestComplitionBlock) reqBlock {

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
    [request.dictPermValues setObject:parentId forKey:@"nc_parent_id"];
    [request.dictPermValues setObject:value forKey:@"approve"];
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_REQUEST_APPROVE_OR_REJECT :request];
}

-(void)getTeacherDetail:(NSString *)teacherId :(RequestComplitionBlock) reqBlock{
    
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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_TEACHER_DETAIL :request];
}

-(void)updateTeacherDetail:(NSString *)name :(RequestComplitionBlock) reqBlock {

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
    [request.dictPermValues setObject:self.email forKey:@"email"];
    [request.dictPermValues setObject:self.mobile forKey:@"mobile"];
    [request.dictPermValues setObject:name forKey:@"name"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequestWithPdf:ACTION_TEACHER_UPDATE_TEACHER_DETAIL uploadData:self.profileImg.image requestData:request];
}

-(void)getTeacherMsgHistory:(NSString *)teacherId :(RequestComplitionBlock) reqBlock {

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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_MSG_HISTORY :request];
}

-(void)changePincode:(NSString *)teacherId oldPin:(NSString *)oldpin newPin:(NSString *)newpin :(RequestComplitionBlock) reqBlock {
    
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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:newpin forKey:@"newcode"];
    [request.dictPermValues setObject:oldpin forKey:@"oldcode"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_CAHNGE_PINCODE :request];
}

-(void)sendFeedback:(NSString *)teacherId email:(NSString *)email message:(NSString *)message :(RequestComplitionBlock) reqBlock {

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
    
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:email forKey:@"email"];
    [request.dictPermValues setObject:message forKey:@"message"];
    [request.dictPermValues setObject:@"winj" forKey:@"name"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_CONTECT_US :request];
}

-(void)studCheckedDetail:(NSString *)teacherId childid:(NSString *)childId checkeddetail:(NSMutableDictionary *)checkedDetail :(RequestComplitionBlock) reqBlock {
    
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
    
    [request.dictPermValues setObject:[checkedDetail valueForKey:@"checked1"] forKey:@"checked1"];
    [request.dictPermValues setObject:[checkedDetail valueForKey:@"checked2"] forKey:@"checked2"];
    [request.dictPermValues setObject:[checkedDetail valueForKey:@"bothchecked"] forKey:@"bothchecked"];
    [request.dictPermValues setObject:[checkedDetail valueForKey:@"contactchecked"] forKey:@"contactchecked"];
    [request.dictPermValues setObject:[checkedDetail valueForKey:@"contact_name"] forKey:@"contact_name"];
    [request.dictPermValues setObject:[checkedDetail valueForKey:@"contact_mobile"] forKey:@"contact_mobile"];
    
    [request.dictPermValues setObject:childId forKey:@"child_id"];
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_UPDATE_STUD_CHECKED_DETAIL :request];
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
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_ALL_SEM_SUBJ :request];
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
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_DESCIPINE_AND_BEHAV :request];
}

-(void)deleteStudantBehaviour:(NSString *)BehaviourId :(RequestComplitionBlock) reqBlock {
    
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
    
    [request.dictPermValues setObject:BehaviourId forKey:@"desc_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_DELETE_DESCIPINE_AND_BEHAV :request];
}

-(void)addStudantMark:(NSString *)classId year:(NSString *)year subjectId:(NSString *)subjectId userId:(NSString *)userId semId:(NSString *)semId examNo:(NSString *)exno marks:(NSString *)marks comments:(NSString *)comments image:(UIImage *)img removeimage:(NSString *)removeimage examDate:(NSString *)exDate examAbout:(NSString *)exabout teacherId:(NSString *)techerId:(RequestComplitionBlock) reqBlock {
    
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
    [request.dictPermValues setObject:subjectId forKey:@"subject_id"];
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    [request.dictPermValues setObject:semId forKey:@"semester_id"];
    [request.dictPermValues setObject:exno forKey:@"exam_no"];
    [request.dictPermValues setObject:marks forKey:@"marks"];
    [request.dictPermValues setObject:comments forKey:@"comment"];
    [request.dictPermValues setObject:exDate forKey:@"exDate"];
    [request.dictPermValues setObject:removeimage forKey:@"removeimage"];
    [request.dictPermValues setObject:exabout forKey:@"exam_about"];
    [request.dictPermValues setObject:techerId forKey:@"teacher_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    if (img == nil) {
        [asyncRequest sendPostRequest:ACTION_TEACHER_ADD_MARKS_STUD :request];
    }
    else {
        [asyncRequest sendPostRequestWithPdf:ACTION_TEACHER_ADD_MARKS_STUD uploadData:img requestData:request];
    }
}

-(void)addStudantCharecter:(NSString *)classId year:(NSString *)year gradeId:(NSString *)gradeId userId:(NSString *)userId semId:(NSString *)semId comments:(NSString *)comments :(RequestComplitionBlock) reqBlock {
    
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
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    [request.dictPermValues setObject:comments forKey:@"comment"];
    [request.dictPermValues setObject:year forKey:@"year"];
    [request.dictPermValues setObject:gradeId forKey:@"character_id"];
    [request.dictPermValues setObject:semId forKey:@"semester_id"];
    
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_ADD_CHARECTER_STUD :request];
}

-(void)addStudantBehaviyore:(NSString *)classId date:(NSString *)date desciplineId:(NSString *)desciplineId userId:(NSString *)userId teacherId:(NSString *)teacherId remarksId:(NSString *)remarksId comments:(NSString *)comments type:(NSString *)type :(RequestComplitionBlock) reqBlock {
    
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
    [request.dictPermValues setObject:userId forKey:@"user_id"];
    [request.dictPermValues setObject:teacherId forKey:@"teacher_id"];
    [request.dictPermValues setObject:comments forKey:@"comment"];
    [request.dictPermValues setObject:date forKey:@"date"];
    [request.dictPermValues setObject:desciplineId forKey:@"descipline_id"];
    [request.dictPermValues setObject:remarksId forKey:@"remarks_id"];
    [request.dictPermValues setObject:type forKey:@"type"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_ADD_CHARECTER_STUD :request];
}

-(void)getSubjectAndMarks:(NSString *)classId year:(NSString *)year semesterId:(NSString *)semesterId userId:(NSString *)userId :(RequestComplitionBlock) reqBlock {
    
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
    
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_MARK_DEATIL :request];
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
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_CHERACTER_DEATIL :request];
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
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_EMG_MESSAGE :request];
}

-(void)getAllGroupOfSchool:(NSString *)schoolId :(RequestComplitionBlock) reqBlock {
    
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
    
    [request.dictPermValues setObject:schoolId forKey:@"school_id"];
    
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_GET_ALL_GROUP :request];
}

-(void)sendEmgMessage:(NSString *)userId groupid:(NSString *)groupId memberid:(NSString *)memberId message:(NSString *)message :(RequestComplitionBlock) reqBlock {
    
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
    
    [request.dictPermValues setObject:userId forKey:@"sender_id"];
    [request.dictPermValues setObject:message forKey:@"message"];
    [request.dictPermValues setObject:groupId forKey:@"group_id"];
    [request.dictPermValues setObject:memberId forKey:@"member_id"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_TEACHER_SEND_EMG_MESSAGE :request];
}

//-(void)sendEmgMessage:(NSString *)userId  schoolId:(NSString *)schoolId  message:(NSString *)message :(RequestComplitionBlock) reqBlock {
//    
//    [GeneralUtil showProgress];
//    
//    
//    //    if(![AppUtil isInternetConnection]) {
//    //        [AppUtil showAlertWithMsg:[AppUtil getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
//    //        [AppUtil hideProgress];
//    //    }
//    //    else {
//    
//    //        NSMutableDictionary *dictRes = [[NSMutableDictionary alloc] init];
//    //        [dictRes setObject:@"1002" forKey:@"ErrorMessageNumber"];
//    //        complitionBlock(dictRes);
//    
//    Request *request = [[Request alloc]init];
//    
//    complitionBlock = reqBlock;
//    
//    [request.dictPermValues setObject:userId forKey:@"sender_id"];
//    [request.dictPermValues setObject:schoolId forKey:@"school_id"];
//    [request.dictPermValues setObject:message forKey:@"message"];
//    
//    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
//    
//    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
//    asyncRequest.delegate = self;
//    
//    [asyncRequest sendPostRequest:ACTION_SEND_EMG_MESSAGE :request];
//}

-(void)updateStudantProfile:(NSString *)userId  image:(UIImageView *)img :(RequestComplitionBlock) reqBlock {
    
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
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    
    [asyncRequest sendPostRequestWithPdf:ACTION_TEACHER_UPLOAD_STUDENT_PROFILE uploadData:img.image requestData:request];
}

-(void)getCalendarData:(NSString *)fromDate toDate:(NSString *)toDate :(RequestComplitionBlock)reqBlock {
    
    [GeneralUtil showProgress];
    
    Request *request = [[Request alloc]init];
    
    complitionBlock = reqBlock;
    
    [request.dictPermValues setObject:fromDate forKey:@"from_date"];
    [request.dictPermValues setObject:toDate forKey:@"to_date"];
    
    ZDebug(@"request.dictPermValues::%@", request.dictPermValues);
    
    TeacherETechAsyncRequest *asyncRequest = [[TeacherETechAsyncRequest alloc]init];
    asyncRequest.delegate = self;
    
    [asyncRequest sendPostRequest:ACTION_CALENDAR_DATA :request];
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
    
        if([action isEqualToString:ACTION_TEACHER_LOGIN]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_VERIFY_CODE]) {
         
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_REGISTER_DEVICE]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_VIRIFY_PINCODE]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_FORGOT_PINCODE]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_REGISTER_PERENT]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_STUDANT_LIST]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_REQUEST_STUDANT_LIST]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_TEACHER_CLASS_LIST]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_REQUEST_APPROVE_OR_REJECT]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_TEACHER_DETAIL]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_UPDATE_TEACHER_DETAIL]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_UPDATE_STUD_CHECKED_DETAIL]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_MSG_HISTORY]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_ATTENDANC_OF_STUD]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_SEND_MESSAGE_TO_STUD]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_REPOSRT_STUDANT_LIST]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_STATISTICS_BY_TECHER]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_STATISTICS_BY_TECHER_OF_CLASS]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_UPLOAD_PDF]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_SAVE_ABSENT_REPORT_TECHER]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_SEND_ABSENT_NOTICE_TEACHER]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_CAHNGE_PINCODE]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_CONTECT_US]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_TEACHER_LIST]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_ALL_SEM_SUBJ]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_ADD_MARKS_STUD]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_ADD_CHARECTER_STUD]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_CHERACTER_DEATIL]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_MARK_DEATIL]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_EMG_MESSAGE]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_SEND_EMG_MESSAGE]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_UPLOAD_STUDENT_PROFILE]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_DESCIPINE_AND_BEHAV]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_DELETE_DESCIPINE_AND_BEHAV]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_DOWNLOAD_PDF]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_ALL_GROUP]) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
        else if([action isEqualToString:ACTION_TEACHER_GET_STUDENTS_LIST]
                 || [action isEqualToString:ACTION_TEACHER_GET_STUDENTS_IN_ACTIVITY]
                 || [action isEqualToString:ACTION_TEACHER_GET_ACTIVITIES]
                 || [action isEqualToString:ACTION_TEACHER_GET_ACTIVITY_DETAILS]
                 || [action isEqualToString:ACTION_TEACHER_GET_CHECKEDIN_STUDENTS_LIST]
                 || [action isEqualToString:ACTION_TEACHER_GET_CHECKEDOUT_STUDENTS_LIST]
                 || [action isEqualToString:ACTION_TEACHER_SET_CHECKIN_BY_TEACHER]
                 || [action isEqualToString:ACTION_TEACHER_SET_CHECKOUT_BY_TEACHER]
                 || [action isEqualToString:ACTION_TEACHER_GET_NOTIFICATIONS]
                 || [action isEqualToString:ACTION_CALENDAR_DATA]
                 || [action isEqualToString:ACTION_GET_STUDENT_DETAIL]
                 || [action isEqualToString:ACTION_SET_STUDENT_DETAIL]
                 || [action isEqualToString:ACTION_DELETE_ACTIVITY]
                ) {
            
            NSMutableDictionary *dictRes = responseData.jsonData;
            
            complitionBlock(dictRes);
        }
}

@end
