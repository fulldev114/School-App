//
//  Teacher.h
//  CSLink
//
//  Created by etech-dev on 6/27/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"
#import "NSUserDefaults+DemoSettings.h"

@interface Teacher : NSObject

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *users;

@end
