//
//  AppDelegate.h
//  Onjyb
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "MBProgressHUD.h"
#import "ETech.h"

@interface AppDelegate : UIResponder <ETechXmppDelegate, UIApplicationDelegate> {
    ETechXmpp *xmppHelper;
    NSString *curJabberId, *curJIdwd, *curJabberIdSel;
}

@property (strong, nonatomic) ETechXmpp *xmppHelper;
@property (strong, nonatomic) NSString *curJabberIdSel;
@property (strong, nonatomic) NSString *curJabberId;
@property (strong, nonatomic) NSString *curJIdwd;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic , strong) UINavigationController *navigationController;
@property (strong, nonatomic) IIViewDeckController* deckController;
@property (nonatomic,retain)  MBProgressHUD *progressHUD;
@property (assign, nonatomic) BOOL isConnected;
@property (assign, nonatomic) BOOL isPusharrive;
@property (assign, nonatomic) int statusViewHeight;
@property (strong , nonatomic)  NSString *version;
@property (assign, nonatomic) BOOL internetActive;

- (NSString *)getCurrentChildId;
-(void)setParentHomeAsRootView;
-(void)setTeacherHomeAsRootView;
-(void)Logout;

-(void)connectXmpp:(NSString *)jabberId;
-(void)disConnectXmpp;
-(void)checkUpdateVersone:(NSDictionary *)responsedictionary;

-(void)generateAndUploadPdf:(NSDictionary *)studantDetail andSubjectDetail:(NSMutableArray *)arrSubjectDetail withImg:(NSString *)isWithImg isIndividual:(BOOL)isIndividul;
-(void)generateAndUploadPdf:(NSDictionary *)studantDetail andSubjectDetail:(NSMutableArray *)arrSubjectDetail isMmailSend:(NSString *)isSend withImg:(NSString *)isWithImg isIndividual:(BOOL)isIndividul;

@end

