//
//  EtechMassage.h
//  ChatDemo
//
//  Created by etech-dev on 5/7/16.
//  Copyright © 2016 etech-dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EtechMassage : NSObject

@property (nonatomic , strong) NSString *messageId;
@property (nonatomic , strong) NSString *text;
@property (nonatomic , strong) NSString *from;
@property (nonatomic , strong) NSString *to;
@property (nonatomic , strong) NSString *type;
@property (nonatomic , strong) NSString *forwarded;
@property (nonatomic , strong) NSNumber *deliveryState;
@property (nonatomic , strong) NSDate *timestamp;
@property (nonatomic , strong) NSString *parent;
@end
