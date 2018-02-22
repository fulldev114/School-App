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


@protocol ParentETechAsyncRequestDelegate <NSObject>

-(void)eTechAsyncRequestDelegate :(NSString *)action :(Response *)responseData;
@end

@interface ParentETechAsyncRequest : NSObject {
	id<ParentETechAsyncRequestDelegate> delegate;
}

@property (nonatomic, retain) id<ParentETechAsyncRequestDelegate> delegate;

-(void)sendPostRequest :(NSString *)action :(Request *)requestData;
-(void)sendPostRequestWithUpload :(NSString *)action :(Request *)requestData;
-(void)sendPostRequestWithPdf:(NSString *)action uploadData:(id)uploadData  requestData:(Request *)requestData;
@end

