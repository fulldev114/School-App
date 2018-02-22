//
//  ZoomPayAsyncRequest.h
//  ZoomPay
//
//  Created by Mayur on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
#import "Request.h"


@protocol TeacherETechAsyncRequestDelegate <NSObject>

-(void)eTechAsyncRequestDelegate :(NSString *)action :(Response *)responseData;
@end

@interface TeacherETechAsyncRequest : NSObject {
	id<TeacherETechAsyncRequestDelegate> delegate;
}

@property (nonatomic, retain) id<TeacherETechAsyncRequestDelegate> delegate;

-(void)sendPostRequest :(NSString *)action :(Request *)requestData;
-(void)sendPostRequestWithUpload :(NSString *)action :(Request *)requestData;
-(void)sendPostRequestWithPdf:(NSString *)action uploadData:(id)uploadData  requestData:(Request *)requestData;
@end

