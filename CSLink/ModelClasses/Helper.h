//
//  Helper.h
//  Collab
//
//  Created by eTech Developer on 30/11/15.
//  Copyright © 2015 eTech Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentConstant.h"

@interface Helper : NSObject
{
    DatabaseHelper *databaseHelper;
}

//-(void)insertOrReplaceMessageStatus:(NSMutableDictionary *)subDetail;
-(void)insertLetestMessage:(NSMutableDictionary *)subDetail;
-(void)insertMessageStatus:(NSMutableDictionary *)subDetail;
-(void)updateMessageStatus:(NSMutableDictionary *)subDetail :(NSString *)msgId;
-(NSMutableArray *)getAllMessageDeliveryStatus;
-(NSMutableArray *)getMessageStatus:(NSString *)msgId;
-(NSMutableArray *)getReceiveStudant;
@end
