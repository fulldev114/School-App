//
//  ETechXmpp .h
//  ChatDemo
//
//  Created by etech-dev on 5/6/16.
//  Copyright © 2016 etech-dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "ETechXmppDelegate.h"
#import "TURNSocket.h"
#import "XMPPRoster.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "EtechMassage.h"
#import "XMPPMUC.h"

typedef void (^ArchiveHandler)(BOOL, NSMutableArray*);

@interface ETechXmpp : NSObject

@property (nonatomic, strong) id  <ETechXmppDelegate, XMPPMUCDelegate> eTechXmppDelegate;

+(ETechXmpp *)sharedInstance;

- (void)setupStream;
- (void)setupRoster;
-(BOOL)isConnected;
-(void)connect:(NSString *)jabberId;
-(void)authenticat:(NSString *)password;
-(void)registerUser:(NSString *)password;
-(void)createSoket:(NSString *)jabberId;
-(void)sendRequest:(NSString *)jabberId;

-(void)createGroup:(NSString *)jabberId;

-(void)getAllRegisteredUsers;
-(NSString *)sendMassage:(EtechMassage *)msgObj ToJId:(NSString *)jabberId;

-(void)disConnect;
-(NSMutableArray<EtechMassage *> *)retriveHistory:(NSString *)jId from :(NSString *)from;
//-(NSMutableArray<EtechMassage *> *)retriveHistory:(NSString *)jId;
-(void)sendChatStateNotification:(NSString *)strState :(NSString *)jId;

-(int)getBadgeForJid:(NSString*)jid;
-(int)getBadgeForJid:(NSString*)jid :(BOOL)forTeacher;
-(void)clearBadgeForJid:(NSString*)jid;
-(int)getBadgeForUser:(NSString*)jid;
-(int)getBadgeForUser;
-(int)getBadgeForTeacher;

-(void)clearBadgeForUser;
-(void)clearBadgeForTeacher;

-(void)getMessageArchiveWith:(NSString *)jId :(ArchiveHandler) handler;
-(void)nextMessageArchiveWith:(NSString *)jId :(ArchiveHandler) handler;
@end
