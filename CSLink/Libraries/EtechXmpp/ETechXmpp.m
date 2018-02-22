//
//  ETechXmpp .m
//  ChatDemo
//
//  Created by etech-dev on 5/6/16.
//  Copyright © 2016 etech-dev. All rights reserved.
//

#import "ETechXmpp.h"

#import "XMPPRoomMemoryStorage.h"
#import "XMPPMessageDeliveryReceipts.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessage+XEP_0184.h"
#import "XMPPMessage+XEP_0085.h"
#import "XMPPMessage+XEP_0280.h"
#import "NSXMLElement+XEP_0203.h"
#import "NSXMLElement+XEP_0297.h"
#import "XMPPMessageCarbons.h"

#import "XMPPMessageArchiveManagement.h"

#import "ParentChatViewController.h"
#import "ParentChatListViewController.h"
#import "TeacherHomeViewController.h"
#import "TeacherSFOHomeViewController.h"
#import "GeneralUtil.h"
#import "ParentConstant.h"
#import "Helper.h"

#import "LNNotificationsUI.h"

#define SERVER      @"constore.no"

#define ARCHIVE_FETCH_NUMBER   10

#if DEBUG
#include <libgen.h>
#define Debug(fmt, args...)  NSLog(@"[%s:%d] %@\n", basename(__FILE__), __LINE__, [NSString stringWithFormat:fmt, ##args])
#define Error(fmt, args...)  NSLog(@"[%s:%d] %@\n", basename(__FILE__), __LINE__, [NSString stringWithFormat:fmt, ##args])
#else

#define Debug(fmt, args...)  NSLog(@"[%d] %@\n", __LINE__, [NSString stringWithFormat:fmt, ##args])
#define Error(fmt, args...)  NSLog(@"[%d] %@\n", __LINE__, [NSString stringWithFormat:fmt, ##args])
#endif

#define IS_CONNECTED [xmppStream isDisconnected]

#define CHAT_STATE_ACTIVE     @"active"
#define CHAT_STATE_COMPSING   @"composing"
#define CHAT_STATE_PAUSED     @"paused"
#define CHAT_STATE_INACTIVE   @"inactive"
#define CHAT_STATE_GONE       @"gone"

@interface ETechXmpp () {
    
    XMPPStream *xmppStream;
    XMPPRoster *xmppRoster;
    XMPPRosterMemoryStorage *xmppRosterMemStorage;
    
    XMPPMessageArchiveManagement *archiveManagement;
    
    NSMutableArray *allUsers;
    NSMutableArray *turnSockets;
    NSMutableArray *mArray;
    
    NSMutableArray *lastArchive;
    XMPPResultSet *lastResultSet;
    ArchiveHandler archiveHandler;
}

- (void)goOnline;
- (void)goOffline;

@end

@implementation ETechXmpp

@synthesize eTechXmppDelegate;

+(ETechXmpp *)sharedInstance
{
    static ETechXmpp *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ETechXmpp alloc] init];
    });
    
    return sharedInstance;
}

-(BOOL)isConnected {
    return xmppStream.isConnected;
}

-(void)connect:(NSString *)jabberId {
    
    [self setupStream];
    //[self setupRoster];
    
    allUsers = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    
    NSString *Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *jabberID = [jabberId stringByAppendingFormat:@"/%@", Identifier];
    
    if (!IS_CONNECTED) {
       [eTechXmppDelegate connectDidCompleted:NO error:error];
    }
    else if (jabberID != nil) {
        [xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
        
        if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
            [eTechXmppDelegate connectDidCompleted:NO error:error];
        }
    }
    else {
        [eTechXmppDelegate connectDidCompleted:NO error:error];
    }
}

- (void)setupStream {
    if (!xmppStream) {
        xmppStream = [[XMPPStream alloc] init];
        [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        XMPPMessageDeliveryReceipts* xmppMessageDeliveryReceipts = [[XMPPMessageDeliveryReceipts alloc] initWithDispatchQueue:dispatch_get_main_queue()];
        xmppMessageDeliveryReceipts.autoSendMessageDeliveryReceipts = YES;
        xmppMessageDeliveryReceipts.autoSendMessageDeliveryRequests = YES;
        [xmppMessageDeliveryReceipts activate:xmppStream];
        
//        XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
//        XMPPMessageArchiving *xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingStorage];
//        [xmppMessageArchivingModule activate:xmppStream];
//        [xmppMessageArchivingModule  addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        archiveManagement = [[XMPPMessageArchiveManagement alloc] init];
        [archiveManagement activate:xmppStream];
        [archiveManagement  addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
}

- (void)setupRoster {
    if (!xmppRoster) {
        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        xmppRosterMemStorage = [[XMPPRosterMemoryStorage alloc] init];
        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterMemStorage dispatchQueue:dispatch_get_main_queue()];
        [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [xmppRoster activate:xmppStream];
    }
}

-(void)authenticat:(NSString *)password {
    
    NSError *error = nil;
    if (![xmppStream authenticateWithPassword:password error:&error])
    {
        Error(@"Error authenticating: %@", error);
        [eTechXmppDelegate authenticatDidCompleted:NO error:error];
    }
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [xmppStream sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}

-(void)disConnect {
    
    appDelegate.isPusharrive = false;
    [self goOffline];
    [xmppStream disconnect];
}

-(void)registerUser:(NSString *)password {
    
    NSError *error = nil;
    
    Debug(@"Attempting registration for username %@", xmppStream.myJID.bare);
    
   if (xmppStream.supportsInBandRegistration) {
        
        if (![xmppStream registerWithPassword:password error:&error]) {
            Error(@"Oops, I forgot something: %@", error);
        }
   }
   else {
       Error(@"ERROR: in-band registartion is not supported");
   }
}

-(void)sendRequest:(NSString *)jabberId {
    
    //[self setupRoster];
    
    XMPPJID *jid = [XMPPJID jidWithString:jabberId];
    
    NSString *str1=jabberId;
    NSRange range = [str1 rangeOfString:@"@"];
    
    NSString *niceName = [str1 substringWithRange:NSMakeRange(0, range.location)];
    
    [xmppRoster addUser:jid withNickname:niceName];
}

-(NSString *)sendMassage:(EtechMassage *)msgObj ToJId:(NSString *)jabberId {
    
    NSString *msgId = [xmppStream generateUUID];
    NSString *messageStr = msgObj.text;
    if([messageStr length] > 0) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@", jabberId]];
        [message addAttributeWithName:@"id" stringValue:msgId];
        
        [message addChild:body];
        
        NSXMLElement *thread = [NSXMLElement elementWithName:@"thread" stringValue:@"CSApp"];
        [message addChild:thread];
        
        NSXMLElement *xmlExtraInfo = [NSXMLElement elementWithName:@"extra" xmlns:@"urn:xmpp:extra"];
        
        NSXMLElement *xmlParent = [NSXMLElement elementWithName:@"parent" stringValue:[NSString stringWithFormat:@"%d",[[GeneralUtil getUserPreference:key_myParentNo] intValue]]];
        [xmlExtraInfo addChild:xmlParent];
        
        NSXMLElement *xmlParentName = [NSXMLElement elementWithName:@"parentname" stringValue:[GeneralUtil getUserPreference:key_myParentName]];
        
        [xmlExtraInfo addChild:xmlParentName];
        
        NSDateFormatter *dformat = [[NSDateFormatter alloc] init];
        
        [dformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSXMLElement *xmlDate = [NSXMLElement elementWithName:@"date" stringValue:[dformat stringFromDate:[NSDate date]]];
        
        [xmlExtraInfo addChild:xmlDate];
        
        [message addChild:xmlExtraInfo];
        
        Debug(@"sendMassage > message %@", message);
        
        [xmppStream sendElement:message];
        
        [self insertDeliveryStatus:msgId];
    }
    
    return msgId;
}

-(void)sendChatStateNotification:(NSString *)strState :(NSString *)jId
{
    XMPPJID *toID = [XMPPJID jidWithString:jId];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:toID];
    
    if([CHAT_STATE_ACTIVE isEqualToString:strState])
        [message addActiveChatState];
    else if([CHAT_STATE_COMPSING isEqualToString:strState])
        [message addComposingChatState];
    else if([CHAT_STATE_PAUSED isEqualToString:strState])
        [message addPausedChatState];
    else if([CHAT_STATE_INACTIVE isEqualToString:strState])
        [message addInactiveChatState];
    else if([CHAT_STATE_GONE isEqualToString:strState])
        [message addGoneChatState];
    
    Debug(@"sendChatStateNotification > State:%@, message %@", strState, message);
    
    [xmppStream sendElement:message];
}

-(NSMutableArray<EtechMassage *> *)retriveHistory:(NSString *)jId from:(NSString *)from {
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr LIKE %@ AND streamBareJidStr LIKE %@", [jId lowercaseString],[from lowercaseString]];
    
    [request setEntity:entityDescription];
    NSError *error;
    
    NSArray *messages_arc = [moc executeFetchRequest:request error:&error];
    
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    if(!error) {
        
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messages_arc) {
            
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            //Debug(@"retriveHistory > message %@", message);
            
            //NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
            //[m setObject:message.body forKey:@"msg"];
            //
            //if ([[element attributeStringValueForName:@"to"] isEqualToString:jId]) {
            //    [m setObject:@"you" forKey:@"sender"];
            //}
            //else {
            //    [m setObject:jId forKey:@"sender"];
            //}
            //
            //[messages addObject:m];
            
            //NSLog(@"bareJid: %@",message.bareJid);
            //NSLog(@"bareJidStr: %@",message.bareJidStr);
            //NSLog(@"streamBareJidStr: %@",message.streamBareJidStr);
            //NSLog(@"Body: %@",message.body);
            //NSLog(@"Timestamp: %@",message.timestamp);
            //NSLog(@"outgoing: %d",[message.outgoing intValue]);
            
            EtechMassage *objMsg = [[EtechMassage alloc] init];
            objMsg.text = message.body;
            objMsg.from = [element attributeStringValueForName:@"from"];
            objMsg.to = [element attributeStringValueForName:@"to"];
            objMsg.timestamp = message.timestamp;
            objMsg.deliveryState = message.deliveriState;
            
            [messages addObject:objMsg];
        }
        
    }
    
    return messages;
}


-(void)getMessageArchiveWith:(NSString *)jId :(ArchiveHandler) handler {
    archiveHandler = handler;
    lastResultSet = nil;
    lastArchive = [[NSMutableArray alloc] init];
    
    NSXMLElement *field = [XMPPMessageArchiveManagement fieldWithVar:@"with" type:nil andValue:[jId lowercaseString]];
    
    NSArray *fields = @[field];
    
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    lastResultSet = [XMPPResultSet resultSetWithMax:ARCHIVE_FETCH_NUMBER before:timestamp];
    
    [archiveManagement retrieveMessageArchiveWithFields:fields withResultSet:lastResultSet];
}

-(void)nextMessageArchiveWith:(NSString *)jId :(ArchiveHandler) handler {
    archiveHandler = handler;
    lastArchive = [[NSMutableArray alloc] init];
    
    NSXMLElement *field = [XMPPMessageArchiveManagement fieldWithVar:@"with" type:nil andValue:[jId lowercaseString]];
    
    NSArray *fields = @[field];
    
    lastResultSet = [XMPPResultSet resultSetWithMax:ARCHIVE_FETCH_NUMBER before:lastResultSet.first];
    
    [archiveManagement retrieveMessageArchiveWithFields:fields withResultSet:lastResultSet];
}

- (void)xmppMessageArchiveManagement:(XMPPMessageArchiveManagement *)xmppMessageArchiveManagement didFinishReceivingMessagesWithSet:(XMPPResultSet *)resultSet {
    Debug(@"xmppMessageArchiveManagement ===> didFinishReceivingMessagesWithSet: %@", resultSet);
    
    lastResultSet = resultSet;
    
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    for (int i = 0; i < lastArchive.count; i++) {
        
        XMPPMessage *msg = [lastArchive objectAtIndex:i];
        
        NSXMLElement *result = [msg elementForName:@"result"];
        BOOL forwarded = [result hasForwardedStanza];
        
        if (forwarded) {
            msg = [XMPPMessage messageFromElement:[[result elementForName:@"forwarded"] elementForName:@"message"]];
            
            NSString *strTime = [[[XMPPMessage messageFromElement:[[result elementForName:@"forwarded"] elementForName:@"delay"]] attributeForName:@"stamp"] stringValue];
            
            EtechMassage *objMsg = [[EtechMassage alloc] init];
            objMsg.text = msg.body;
            objMsg.from = [msg.from bare];
            objMsg.to = [msg.to bare];
            objMsg.timestamp = [formater dateFromString:strTime];
            
            Helper *obj = [[Helper alloc] init];
            
            NSMutableArray *allDeliveryStatus = [obj getMessageStatus:[msg attributeStringValueForName:@"id"]];
            
            if(allDeliveryStatus.count == 0)
                objMsg.deliveryState = [NSNumber numberWithInteger:-1];
            else {
                objMsg.deliveryState = [NSNumber numberWithInteger:[[[allDeliveryStatus objectAtIndex:0] valueForKey:@"delivery_status"] intValue]];
            }
            
            if ([msg elementForName:@"extra"] && [[msg elementForName:@"extra"] elementForName:@"parent"]) {
                NSXMLElement *element = [[msg elementForName:@"extra"] elementForName:@"parent"];
                objMsg.parent = [element stringValue];
            }
            else {
                objMsg.parent = @"-1";
            }
            
            [messages addObject:objMsg];
        }
    }
    
    if(archiveHandler)
        archiveHandler(true, messages);
}

- (void)xmppMessageArchiveManagement:(XMPPMessageArchiveManagement *)xmppMessageArchiveManagement didReceiveMAMMessage:(XMPPMessage *)message {
    Debug(@"xmppMessageArchiveManagement ===> didReceiveMAMMessage: %@", message);
    
    [lastArchive addObject:message];
}

- (void)xmppMessageArchiveManagement:(XMPPMessageArchiveManagement *)xmppMessageArchiveManagement didFailToReceiveMessages:(XMPPIQ *)error {
    Debug(@"xmppMessageArchiveManagement ===> didFailToReceiveMessages: %@", error);
    archiveHandler(false, nil);
}

- (void)xmppMessageArchiveManagement:(XMPPMessageArchiveManagement *)xmppMessageArchiveManagement didReceiveFormFields:(XMPPIQ *)iq {
    Debug(@"xmppMessageArchiveManagement ===> didReceiveFormFields: %@", iq);
}

- (void)xmppMessageArchiveManagement:(XMPPMessageArchiveManagement *)xmppMessageArchiveManagement didFailToReceiveFormFields:(XMPPIQ *)iq {
    Debug(@"xmppMessageArchiveManagement ===> didFailToReceiveFormFields: %@", iq);
}


-(void)createSoket:(NSString *)jabberId {
    
    XMPPJID *jid = [XMPPJID jidWithString:jabberId];
    
    Debug(@"Attempting TURN connection to %@ - %@", jid, xmppStream.tag);
    
    TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:xmppStream toJID:jid];
    
    [turnSockets addObject:turnSocket];
    
    [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
    
    Debug(@"TURN Connection succeeded!");
    Debug(@"You now have a socket that you can use to send/receive data to/from the other person.");
    
    [turnSockets removeObject:sender];
}

- (void)turnSocketDidFail:(TURNSocket *)sender {
    
    Debug(@"TURN Connection failed!");
    [turnSockets removeObject:sender];
}

-(void)sendInvitation:(NSString *)groupId userJId:(NSString *)jabberId {
    
    XMPPRoomMemoryStorage *roomStorage = [[XMPPRoomMemoryStorage alloc] init];
    
    /**
     * Remember to add 'conference' in your JID like this:
     * e.g. uniqueRoomJID@conference.yourserverdomain
     */
    
    XMPPJID *roomJID = [XMPPJID jidWithString:groupId];
    XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomStorage jid:roomJID dispatchQueue:dispatch_get_main_queue()];
    
    [xmppRoom activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [xmppRoom inviteUser:[XMPPJID jidWithString:jabberId] withMessage:@"invitetion test!"];
}

-(void)getGroupList {
    
    NSString* server = @"conference.192.168.1.128"; //or whatever the server address for muc is
    XMPPJID *servrJID = [XMPPJID jidWithString:server];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:servrJID];
    
    [iq addAttributeWithName:@"from" stringValue:[xmppStream myJID].full];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#items"];
    
   // [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/muc#admin"];
    
    [iq addChild:query];
    [xmppStream sendElement:iq];
}

-(void)createGroup:(NSString *)jabberId {
    
    //////////////////////////////////////////////////////

    XMPPRoomMemoryStorage *roomStorage = [[XMPPRoomMemoryStorage alloc] init];
    
    /**
     * Remember to add 'conference' in your JID like this:
     * e.g. uniqueRoomJID@conference.yourserverdomain
     */
    
    XMPPJID *roomJID = [XMPPJID jidWithString:@"ChitChatGroup@conference.192.168.1.128"];
    XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomStorage jid:roomJID dispatchQueue:dispatch_get_main_queue()];
    
    [xmppRoom activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [xmppRoom fetchMembersList];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items {
    Debug(@"didFetchMembersList :%@", items);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError {

    Debug(@"didNotFetchMembersList :%@", iqError);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    Debug(@"didReceiveIQ: %@", [iq description]);
    
    NSXMLElement *queryElement = [iq elementForName: @"query" xmlns: @"jabber:iq:roster"];
    
    NSXMLElement *queryElementGroup = [iq elementForName: @"query" xmlns: @"http://jabber.org/protocol/disco#items"];
    
    if (queryElement) {
        
        NSArray *itemElements = [queryElement elementsForName: @"item"];
        
        for (int i=0; i < [itemElements count]; i++) {
            
            NSString *jid=[[[itemElements objectAtIndex:i] attributeForName:@"jid"] stringValue];
            [mArray addObject:jid];
        }
    }
    else if (queryElementGroup) {
        NSArray *itemElements = [queryElementGroup elementsForName: @"item"];
        
        for (int i=0; i<[itemElements count]; i++) {
            
            NSString *jid=[[[itemElements objectAtIndex:i] attributeForName:@"jid"] stringValue];
            [mArray addObject:jid];
        }
    }
    
    return NO;
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender {
    Debug(@"created successfully...");
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
    Debug(@"join successfully...");
    [sender fetchConfigurationForm];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    NSXMLElement *newConfig = [configForm copy];
    NSArray *fields = [newConfig elementsForName:@"field"];
    
    for (NSXMLElement *field in fields)
    {
        NSString *var = [field attributeStringValueForName:@"var"];
        // Make Room Persistent
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"] ||
             [var isEqualToString:@"muc#roomconfig_membersonly"] || [var isEqualToString:@"muc#roomconfig_allowinvites"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
        
        else if ([var isEqualToString:@"muc#roomconfig_publicroom"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"0"]];
        }
    }
    
    [sender configureRoomUsingOptions:newConfig];
}

- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult {
    
}

- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult {

}

#pragma mark XMPP delegates

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    // connection to the server successful
    [eTechXmppDelegate connectDidCompleted:YES error:nil];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    [eTechXmppDelegate authenticatDidCompleted:YES error:nil];
    [self goOnline];
    //[self getGroupList];
    
//    XMPPJID *servrJID = [XMPPJID jidWithString:SERVER];
//    
//    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
//    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:servrJID elementID:@"info1" child:query ];
//    [iq addAttributeWithName:@"xmlns" stringValue:@"jabber:client"];
//    [iq addAttributeWithName:@"from" stringValue:xmppStream.myJID.full];
//    
//    [xmppStream sendElement:iq];
    
    
    XMPPMessageCarbons *xmppMessageCarbon  = [[XMPPMessageCarbons alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    [xmppMessageCarbon activate:xmppStream];
    [xmppMessageCarbon enableMessageCarbons];
    
    
//    NSXMLElement *iq1 = [NSXMLElement elementWithName:@"iq"];
//    [iq1 addAttributeWithName:@"type" stringValue:@"get"];
//    [iq1 addAttributeWithName:@"id" stringValue:@"pk1"];
//    
//    NSXMLElement *retrieve = [NSXMLElement elementWithName:@"retrieve" xmlns:@"urn:xmpp:archive"];
//    
//    [retrieve addAttributeWithName:@"with" stringValue:@"CS-M6S4A5TT@constore.no"];
//    NSXMLElement *set = [NSXMLElement elementWithName:@"set" xmlns:@"http://jabber.org/protocol/rsm"];
//    NSXMLElement *max = [NSXMLElement elementWithName:@"max" stringValue:@"100"];
//    
//    [iq1 addChild:retrieve];
//    [retrieve addChild:set];
//    [set addChild:max];
//    [xmppStream sendElement:iq1];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    
    Debug(@"Error authenticating: %@", error);
    [eTechXmppDelegate authenticatDidCompleted:NO error:nil];
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration" message:@"Registration with XMPP Successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [eTechXmppDelegate authenticatDidCompleted:YES error:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
    DDXMLElement *errorXML = [error elementForName:@"error"];
    NSString *errorCode  = [[errorXML attributeForName:@"code"] stringValue];
    
    NSString *regError = [NSString stringWithFormat:@"ERROR :- %@",error.description];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration with XMPP   Failed!" message:regError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    if([errorCode isEqualToString:@"409"]){
        
        [alert setMessage:@"Username Already Exists!"];
    }
    [alert show];
    
    [eTechXmppDelegate authenticatDidCompleted:NO error:nil];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
   
    NSString *presenceType = [presence type];
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    Debug(@"presenceFromUser :%@, presenceType: %@", presenceFromUser, presenceType);
    
    if (![presenceFromUser isEqualToString:myUsername]) {
    
        if ([presenceType isEqualToString:@"available"]) {
            
            [eTechXmppDelegate newAvilableUser:presenceFromUser];
        }
        else if ([presenceType isEqualToString:@"unavailable"]) {
            
            [eTechXmppDelegate unAvilableUser:presenceFromUser];
        }
        else if  ([presenceType isEqualToString:@"subscribe"]) {
            [eTechXmppDelegate newAvilableUser:presenceFromUser];
        }
        
        [allUsers addObject:presenceFromUser];
    }
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    [xmppRoster acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    Debug(@"didReceiveMessage: %@", message);
    
    if([message hasReceiptResponse]) {
        
        Debug(@"hasReceiptResponse > receiptResponseID: %@", [message receiptResponseID]);
        
        NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
        [msg setObject:[message receiptResponseID] != nil? [message receiptResponseID] : @"" forKey:@"message_id"];
        [msg setObject:[NSNumber numberWithInt:1] forKey:@"state"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeliveryState" object:msg];
        
        [self updateDeliveryStatus:[message receiptResponseID]];
        
        //        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        //        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        //
        //        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:moc];
        //        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        //
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageStr contains[cd] %@", [message receiptResponseID]];
        //        request.predicate = predicate;
        //
        //        [request setEntity:entityDescription];
        //        NSError *error;
        //        NSArray *messages_arc = [moc executeFetchRequest:request error:&error];
        //
        //        if(!error && [messages_arc count] > 0) {
        //            XMPPMessageArchiving_Message_CoreDataObject *message = [messages_arc objectAtIndex:0];
        //            message.deliveriState = [NSNumber numberWithInt:1];
        //            
        //            error = nil;
        //            [moc save:&error];
        //        }
    
    }
    else if([message isChatMessage] && [message body]) {
        
        NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
        [msg setObject:[message body] forKey:@"msg"];
        [msg setObject:[message fromStr] forKey:@"sender"];
        
        XMPPJID *userJID = [XMPPJID jidWithString:[message fromStr]];
        
        NSString *bareJid = [userJID bare];
        
        LNNotification* notification = [LNNotification notificationWithMessage:[message body]];
        
        UIViewController *vc = [((UINavigationController *)appDelegate.deckController.centerController) topViewController];
        
        if ([message elementForName:@"extra"] && [[message elementForName:@"extra"] elementForName:@"username"]) {
            NSXMLElement *element = [[message elementForName:@"extra"] elementForName:@"username"];
            
            NSString *teacher = [element stringValue];
            
            notification.title = teacher;
            notification.defaultAction = [LNNotificationAction actionWithTitle:@"View" handler:^(LNNotificationAction *action) {
            }];
        }
        
        if (appDelegate.isPusharrive) {
            
            if ([vc isKindOfClass:[ParentChatViewController class]]) {
                
                if (![appDelegate.curJabberIdSel isEqualToString:bareJid]) {
                    
                    AudioServicesPlaySystemSound (1054);
                    [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"123"];
                }
            }
            else {
                
                AudioServicesPlaySystemSound (1054);
                [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"123"];
            }
        }
        
        if(!appDelegate.curJabberIdSel || ![bareJid hasPrefix:appDelegate.curJabberIdSel]) {
            
            NSString *strKey = [NSString stringWithFormat:@"%@_%@", [appDelegate getCurrentChildId], bareJid];
            
            int curBadge = [[GeneralUtil getUserPreference:strKey] intValue];
            
            curBadge++;
            
            [GeneralUtil setUserPreference:strKey value:[NSString stringWithFormat:@"%d", curBadge]];
            
            [self insertNewMessage:bareJid];
            
            if (appDelegate.isPusharrive) {
                NSString *strAllKey = [NSString stringWithFormat:@"%@", [appDelegate getCurrentChildId]];
                
                int curBadge = [[GeneralUtil getUserPreference:strAllKey] intValue];
                
                curBadge++;
                
                [GeneralUtil setUserPreference:strAllKey value:[NSString stringWithFormat:@"%d", curBadge]];
            }
        }
        
        if ([vc isKindOfClass:[TeacherHomeViewController class]]) {
            
            [(TeacherHomeViewController *)vc setBadge];
        }
        
        if ([vc isKindOfClass:[TeacherSFOHomeViewController class]]) {
            
            [(TeacherSFOHomeViewController *)vc setBadge];
        }
        
        [eTechXmppDelegate newMessageReceived:msg];
    }
    else if([message hasComposingChatState]) {
        [eTechXmppDelegate typingStatus:[message chatState] From:[message fromStr]];
    }
    else if([message hasPausedChatState]) {
        [eTechXmppDelegate typingPaused:[message chatState] From:[message fromStr]];

    }
    else {
        NSXMLElement *element = [[message elementForName:@"sent"] elementForName:@"forwarded"];
        
        element = [element elementForName:@"message"];
        
        if (element ) {
            
            XMPPMessage *messageFromElement = [XMPPMessage messageFromElement:element];
            if ([element elementForName:@"body"]) {
                NSString *msgStr = [[element elementForName:@"body"] stringValue];
                NSString *from = [[element attributeForName:@"from"] stringValue];
                
                NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
                [msg setObject:msgStr forKey:@"msg"];
                [msg setObject:from forKey:@"sender"];
                [msg setObject:@"Yes" forKey:@"Forwarded"];
                
                if ([element elementForName:@"extra"] && [[element elementForName:@"extra"] elementForName:@"parent"]) {
                    NSXMLElement *ele = [[element elementForName:@"extra"] elementForName:@"parent"];
                    
                    NSString *parent = [ele stringValue];
                    
                    [msg setObject:parent forKey:@"parent"];
                }
                
                [eTechXmppDelegate newMessageReceived:msg];
                
                XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
                
                [xmppMessageArchivingStorage archiveMessage:messageFromElement outgoing:YES xmppStream:sender];
            }
        }
    }
}

-(void)insertNewMessage:(NSString *)jid {
    
    NSMutableDictionary *dictUnit = [[NSMutableDictionary alloc] init];
    
    [dictUnit setObject:jid forKey:@"jid"];
    [dictUnit setObject:[GeneralUtil formateDataWithDate:[NSDate date]] forKey:@"last_msg_date"];
    
    Helper *obj = [[Helper alloc] init];
    [obj insertLetestMessage:dictUnit];
}

-(void)insertDeliveryStatus:(NSString *)msgId
{
    NSMutableDictionary *dictUnit = [[NSMutableDictionary alloc] init];
    
    [dictUnit setObject:msgId forKey:@"message_id"];
    [dictUnit setObject:@"0" forKey:@"delivery_status"];
    
    Helper *obj = [[Helper alloc] init];
    [obj insertMessageStatus:dictUnit];
}

-(void)updateDeliveryStatus:(NSString *)msgId
{
    NSMutableDictionary *dictUnit = [[NSMutableDictionary alloc] init];
    [dictUnit setObject:@"1" forKey:@"delivery_status"];
    
    Helper *obj = [[Helper alloc] init];
    [obj updateMessageStatus:dictUnit :msgId];
}

-(int)getBadgeForJid:(NSString*)jid {
    
    NSString *strKey = [NSString stringWithFormat:@"%@_%@", [appDelegate getCurrentChildId], [jid lowercaseString]];
    
    int curBadge = [[GeneralUtil getUserPreference:strKey] intValue];
    
    NSString *strAllKey = [NSString stringWithFormat:@"%@", [appDelegate getCurrentChildId]];
    
    int allCnt = [[GeneralUtil getUserPreference:strAllKey] intValue];
    
    allCnt = allCnt - curBadge;
    
    if (allCnt < 0) {
        allCnt = 0;
    }
    
    [GeneralUtil setUserPreference:strAllKey value:[NSString stringWithFormat:@"%d", allCnt]];
    
    return curBadge;
}


-(int)getBadgeForJid:(NSString*)jid :(BOOL)forTeacher{
    
    NSString *strKey = [NSString stringWithFormat:@"%@_%@", [GeneralUtil getUserPreference:key_teacherId], [jid lowercaseString]];
    
    int curBadge = [[GeneralUtil getUserPreference:strKey] intValue];
    
    
    //    NSString *strAllKey;
    //
    //
    //    if (forTeacher) {
    //        strAllKey = [NSString stringWithFormat:@"internal_%@", [GeneralUtil getUserPreference:key_teacherId]];
    //    }
    //    else{
    //        strAllKey = [NSString stringWithFormat:@"parent_%@", [GeneralUtil getUserPreference:key_teacherId]];
    //    }
    //
    //
    //    int allCnt = [[GeneralUtil getUserPreference:strAllKey] intValue];
    //
    //    allCnt = allCnt - curBadge;
    //
    //    if (allCnt < 0) {
    //        allCnt = 0;
    //    }
    //
    //    [GeneralUtil setUserPreference:strAllKey value:[NSString stringWithFormat:@"%d", allCnt]];
    
    return curBadge;
}

-(int)getBadgeForUser:(NSString*)userId {
    
    NSString *strKey = [NSString stringWithFormat:@"%@", userId];
    
    int curBadge = [[GeneralUtil getUserPreference:strKey] intValue];
    
    return curBadge;
}

-(int)getBadgeForUser {
    
    NSString *strKey = [NSString stringWithFormat:@"parent_%@", [GeneralUtil getUserPreference:key_teacherId]];
    
    int curBadge = [[GeneralUtil getUserPreference:strKey] intValue];
    
    return curBadge;
}

-(void)clearBadgeForUser {
    
    NSString *strKey = [NSString stringWithFormat:@"parent_%@", [GeneralUtil getUserPreference:key_teacherId]];
    
    [GeneralUtil setUserPreference:strKey value:[NSString stringWithFormat:@"%d", 0]];
}

-(void)clearBadgeForTeacher {
    
    NSString *strKey = [NSString stringWithFormat:@"internal_%@", [GeneralUtil getUserPreference:key_teacherId]];
    
    [GeneralUtil setUserPreference:strKey value:[NSString stringWithFormat:@"%d", 0]];
}

-(int)getBadgeForTeacher {
    
    NSString *strKey = [NSString stringWithFormat:@"internal_%@", [GeneralUtil getUserPreference:key_teacherId]];
    
    int curBadge = [[GeneralUtil getUserPreference:strKey] intValue];
    
    //[GeneralUtil setUserPreference:strKey value:[NSString stringWithFormat:@"%d", 0]];
    
    return curBadge;
}

-(void)clearBadgeForJid:(NSString*)jid {
    NSString *strKey = [NSString stringWithFormat:@"%@_%@", [appDelegate getCurrentChildId], [jid lowercaseString]];
    [GeneralUtil setUserPreference:strKey value:@""];
}

- (void)willInsertMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message
{
    Debug(@"willInsertMessage :%@",message);
}

- (void)didUpdateMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message
{
    Debug(@"didUpdateMessage :%@",message);
}

- (void)willDeleteMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message
{
    Debug(@"willDeleteMessage :%@",message);
}

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *) roomJID didReceiveInvitation:(XMPPMessage *)message{
    
    Debug(@"room id : %@ massage :%@",roomJID,message);
    
    NSXMLElement * x = [message elementForName:@"x" xmlns:XMPPMUCUserNamespace];
    NSXMLElement * invite  = [x elementForName:@"invite"];
    if (invite != nil)
    {
        NSString * conferenceRoomJID = [[message attributeForName:@"from"] stringValue];
        [self joinMultiUserChatRoom:conferenceRoomJID];
    }
}

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *) roomJID didReceiveInvitationDecline:(XMPPMessage *)message{

}

#pragma mark XMPP XMPPMessageCarbonsDelegate

- (void)xmppMessageCarbons:(XMPPMessageCarbons *)xmppMessageCarbons willReceiveMessage:(XMPPMessage *)message outgoing:(BOOL)isOutgoing {
    Debug(@"xmppMessageCarbons > willReceiveMessage: %@", message);
}

- (void)xmppMessageCarbons:(XMPPMessageCarbons *)xmppMessageCarbons didReceiveMessage:(XMPPMessage *)message outgoing:(BOOL)isOutgoing {
    Debug(@"xmppMessageCarbons > didReceiveMessage: %@", message);
}

- (void) joinMultiUserChatRoom:(NSString *) newRoomName
{
    XMPPJID *roomJID = [XMPPJID jidWithString:newRoomName];
    XMPPRoomMemoryStorage *roomMemoryStorage = [[XMPPRoomMemoryStorage alloc] init];
    XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomMemoryStorage jid:roomJID dispatchQueue:dispatch_get_main_queue()];
    
    [xmppRoom activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoom joinRoomUsingNickname:@"etech" history:nil];
}

@end
