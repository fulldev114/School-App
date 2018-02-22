//
//  Helper.m
//  Collab
//
//  Created by eTech Developer on 30/11/15.
//  Copyright © 2015 eTech Developer. All rights reserved.
//

#import "Helper.h"


@implementation Helper

- (id)init {
    self = [super init];
    if (self) {
        databaseHelper = [[DatabaseHelper alloc] init:DATABASE_NAME];
    }
    return self;
}
-(BOOL)checkNullValue:(id)value{
    
    if (value == nil || value == (id)[NSNull null] || !value || [value isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    return NO;
}

//-(void)insertOrReplaceMessageStatus:(NSMutableDictionary *)subDetail {
//    [databaseHelper insertIntoTable:TBL_MESSAGE_DELIVERY_STATUS Values:subDetail];
//}

-(void)insertLetestMessage:(NSMutableDictionary *)subDetail {
    [databaseHelper insertOrReplaceIntoTable:TBL_RECEIVE_MESSAGE Values:subDetail];
}

-(void)insertMessageStatus:(NSMutableDictionary *)subDetail {
    [databaseHelper insertIntoTable:TBL_MESSAGE_DELIVERY_STATUS Values:subDetail];
}

-(void)updateMessageStatus:(NSMutableDictionary *)subDetail :(NSString *)msgId {
    [databaseHelper updateTable:TBL_MESSAGE_DELIVERY_STATUS Values:subDetail
                    WhereClause:[NSString stringWithFormat:@" message_id LIKE '%@'", msgId]];
}

-(NSMutableArray *)getReceiveStudant {
    
    NSMutableArray *allLetestStatus = [[NSMutableArray alloc] init];
    
    NSString *query =[NSString stringWithFormat:@"SELECT * FROM tbl_receive_msg ORDER BY last_msg_date DESC"];
    
    allLetestStatus = [databaseHelper executeSelectQuery:query];
    
    return allLetestStatus;
}

-(NSMutableArray *)getMessageStatus:(NSString *)msgId {
    
    NSMutableArray *allDeliveryStatus = [[NSMutableArray alloc] init];
    
    NSString *query =[NSString stringWithFormat:@"SELECT * FROM tbl_delivery_status where message_id LIKE '%@'", msgId];
    
    allDeliveryStatus = [databaseHelper executeSelectQuery:query];
    
    return allDeliveryStatus;
}

-(NSMutableArray *)getAllMessageDeliveryStatus {
    
    NSMutableArray *allDeliveryStatus = [[NSMutableArray alloc] init];
    
    NSString *query =[NSString stringWithFormat:@"SELECT * FROM tbl_delivery_status"];
    
    allDeliveryStatus = [databaseHelper executeSelectQuery:query];
    
    return allDeliveryStatus;
}
@end
