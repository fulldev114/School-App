//
//  ZoomPayAsyncRequest.m
//  ZoomPay
//
//  Created by Mayur on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TeacherETechAsyncRequest.h"
#import "Request.h"
#import "AFNetworking.h"
#import "TeacherConstant.h"

@interface TeacherETechAsyncRequest (){
    NSString *strAction;
}
@end


@implementation TeacherETechAsyncRequest

@synthesize delegate;

#pragma mark -
#pragma mark NSURLRequest


-(void)sendPostRequest :(NSString *)action :(Request *)requestData {
    
    strAction = action;
    
    NSString *strUrl;
    
    if([action isEqualToString:ACTION_TEACHER_GET_STUDENTS_LIST]
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
       )
    {
        strUrl=[NSString stringWithFormat:@"%@%@?", SFO_BASE_URL,action];

    }
    else if ([action isEqualToString:ACTION_DOWNLOAD_PDF]) {
        
        strUrl =[NSString stringWithFormat:@"%@%@",BASE_URL2,action];
    }
    else{
        strUrl=[NSString stringWithFormat:@"%@%@?",TEACHER_BASE_URL,action];
    }
    
    ZDebug(@"%@",strUrl);
    
//    __block ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strUrl]];
//    
//    for (int i = 0; i < [[requestData.dictPermValues allKeys] count]; i++) {
//        [request setPostValue:[requestData.dictPermValues valueForKey:[[requestData.dictPermValues allKeys] objectAtIndex:i]] forKey:[[requestData.dictPermValues allKeys] objectAtIndex:i]];
//    }
//	
//    [request setCompletionBlock:^{
//        
//        NSString *str = [[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",request.responseString]] stringByReplacingOccurrencesOfString: @"ï»¿" withString: @""];
//        
//        //ZDebug(@"RESPONSE RESULT: %@", str);
//        
//        NSMutableDictionary *dictResponse = [[NSMutableDictionary alloc] initWithDictionary:[str JSONValue]];
//        Response *response = [[Response alloc] init];
//        response.jsonData = dictResponse;
//        
//        if([delegate respondsToSelector:@selector(eTechAsyncRequestDelegate::)])
//            [delegate eTechAsyncRequestDelegate:strAction :response];
//        
//    }];
//    
//    [request setFailedBlock:^{
//        NSLog(@"API call Error");
//        [appDelegate hideProgress];
//        [AppUtility showPopupWithMsg:[AppUtility getLocalizedText:@"ALERT_MSG_CONNECTION_ERROR"]];
//        
//    }];
//    
//    [request startAsynchronous];
    
    AFHTTPRequestOperationManager *operationmanager = [AFHTTPRequestOperationManager manager];
    
    operationmanager.responseSerializer =
    [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
    
   // operationmanager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    operationmanager.responseSerializer.acceptableContentTypes = [operationmanager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [operationmanager POST:strUrl parameters:requestData.dictPermValues success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *responsedictionary = (NSDictionary *)responseObject;
         ZDebug(@"sendPostRequest > response: %@", responsedictionary);
         Response *response = [[Response alloc] init];
         response.jsonData = responsedictionary;
         
         if([delegate respondsToSelector:@selector(eTechAsyncRequestDelegate::)])
             [delegate eTechAsyncRequestDelegate:strAction :response];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"API call Error : - %@",error.description);
         [GeneralUtil hideProgress];
         [GeneralUtil alertInfo:error.localizedDescription];
         
         if ([strAction isEqualToString:ACTION_PARENT_GET_MARK_DEATIL]) {
             if([delegate respondsToSelector:@selector(eTechAsyncRequestDelegate::)])
                 [delegate eTechAsyncRequestDelegate:strAction :nil];
         }
     }];
}

-(void)sendPostRequestWithPdf:(NSString *)action uploadData:(id)uploadData  requestData:(Request *)requestData
{
    strAction = action;
    
    ZDebug(@"sendPostRequest > action: %@", action);
    ZDebug(@"sendPostRequest > request: %@", requestData);
    
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",TEACHER_BASE_URL,action];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:strUrl parameters:requestData.dictPermValues constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSData *upData ;
         
         if ([action isEqualToString:ACTION_PARENT_UPDATE_CHIELD_DETAIL]) {
             
             upData = UIImageJPEGRepresentation(uploadData, 0.5);
             [formData appendPartWithFileData:upData name:@"image" fileName:@"proPic.jpg" mimeType:@"image/jpeg"];
         }
         
         if ([action isEqualToString:ACTION_UPLOAD_PDF]) {
             
             upData = [[NSFileManager defaultManager] contentsAtPath:uploadData];
             [formData appendPartWithFileData:upData name:@"pdf" fileName:@"AbsentReport.pdf" mimeType:@"application/pdf"];
         }
         if ([action isEqualToString:ACTION_UPLOAD_MARKS_PDF]) {
             
             upData = [[NSFileManager defaultManager] contentsAtPath:uploadData];
             [formData appendPartWithFileData:upData name:@"pdf" fileName:@"StuantMarks.pdf" mimeType:@"application/pdf"];
         }
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ZDebug(@"Success: %@", responseObject);
         NSDictionary *responsedictionary = (NSDictionary *)responseObject;
         
         Response *response = [[Response alloc] init];
         response.jsonData = responsedictionary;
         
         if([delegate respondsToSelector:@selector(eTechAsyncRequestDelegate::)])
             [delegate eTechAsyncRequestDelegate:strAction :response];
     }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [GeneralUtil hideProgress];
         ZDebug(@" +++++>> in post api Failer %@   \n     Response String======>>>>%@",error.localizedDescription , [operation responseString]);
         [GeneralUtil alertInfo:error.localizedDescription];
         
         Response *response = [[Response alloc] init];
         [delegate eTechAsyncRequestDelegate:strAction :response];
     }];
}

//-(void)sendPostRequestWithUpload :(NSString *)action :(Request *)requestData {
//    
//    strAction = action;
//    NSString *strUrl=[NSString stringWithFormat:@"%@%@?",URL_BASEURL,action];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:strUrl parameters:requestData.dictPermValues constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
//        
//        User *user = [[User alloc]init];
//        NSString *dirPath = [user fetchCacheDirectoryPath];
//        NSString *ImagePath = [NSString stringWithFormat:@"%@/test.jpg",dirPath];
//        NSData *imageData = [NSData dataWithContentsOfFile:ImagePath ];
//        if(imageData)
//            [formData appendPartWithFileData:imageData name:@"user_photo" fileName:@"user_photo.jpg" mimeType:@"image/jpeg"];
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"Success: %@", responseObject);
//         NSDictionary *responsedictionary = (NSDictionary *)responseObject;
//         
//         Response *response = [[Response alloc] init];
//         response.jsonData = responsedictionary;
//         
//         if([delegate respondsToSelector:@selector(eTechAsyncRequestDelegate::)])
//             
//             [delegate eTechAsyncRequestDelegate:strAction :response];
//     }
//     
//          failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         NSLog(@"Internal Error");
//         //[appDelegate.progressHUD hide:YES];
//         
//     }];
//}

//- (void)uploadFailed:(ASIHTTPRequest *)theRequest {
//    [appDelegate.progressHUD hide:YES];
//    ZDebug(@"%@",[NSString stringWithFormat:@"Fail uploading %@ bytes of data",[[theRequest error] localizedDescription]]);
//}
//
//-(void)uploadFinished:(ASIHTTPRequest *)theRequest {
//    [appDelegate.progressHUD hide:YES];
//    ZDebug(@"%@",[NSString stringWithFormat:@"Finished uploading %llu bytes of data",[theRequest postLength]]);
//}

@end
