//
//  SMChatDelegate.h
//  jabberClient
//
//  Created by cesarerocchi on 7/16/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ETechXmppDelegate

-(void)connectDidCompleted:(BOOL)status error:(NSError *)error;
-(void)authenticatDidCompleted:(BOOL)status error:(NSError *)error;
-(void)newAvilableUser:(NSString *)user;
-(void)unAvilableUser:(NSString *)user;
-(void)newMessageReceived:(NSMutableDictionary *)messageContent;
-(void)typingStatus:(NSString *)typingStatus From:(NSString *)jId;
-(void)typingPaused:(NSString *)typingPaused From:(NSString *)jId;

@end
