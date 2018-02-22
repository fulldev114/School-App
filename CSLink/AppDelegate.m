//
//  AppDelegate.m
//  Onjyb
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "ParentLoginViewController.h"
#import "MainScreenViewController.h"
#import "ParentMenuViewController.h"
#import "TeacherMenuViewController.h"
#import "ParentPincodeViewController.h"
#import "IIViewDeckController.h"
#import "ParentHomeViewController.h"
#import "ParentSFOHomeViewController.h"
#import "TeacherHomeViewController.h"
#import "TeacherSFOHomeViewController.h"
#import "ParentGroupMessageViewController.h"
#import "ParentNIDropDown.h"

#import "ParentChatListViewController.h"
#import "emergancyMsg.h"
#import "ParentChatViewController.h"
#import "LocalizeLanguage.h"
#import "UpdateYappoViewController.h"
#import "LNNotificationsUI.h"
#import "IQKeyboardManager.h"
#import "Reachability.h"
#import "TeacherUser.h"

@interface AppDelegate () {
    UIView *emcymsgView;
    NSMutableDictionary *dicConnect;
    DatabaseHelper *dbUserHelper;
    
    CGSize pageSize;
    NSString *PathOfReportGenerated;
    
    int contextX,contextY, contextWidth, margin;
    
    ParentUser *userObj;
    Reachability* internetReachable;
}

@end

@implementation AppDelegate
@synthesize deckController,navigationController,isConnected,isPusharrive,statusViewHeight,version;

@synthesize xmppHelper;
@synthesize curJabberIdSel;
@synthesize curJabberId;
@synthesize curJIdwd;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    sleep(3);
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    
    version = infoDictionary[@"CFBundleShortVersionString"];
    
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    
    [[LNNotificationCenter defaultCenter] registerApplicationWithIdentifier:@"123" name:APPNAME icon:[UIImage imageNamed:@"Icon-Small"] defaultSettings:[LNNotificationAppSettings defaultNotificationAppSettings]];
    
    //curJabberId = @"nilesh@etechmavens.p1.im";
    //curJIdwd = @"a";
    
//#if TARGET_OS_SIMULATOR
//    
//    curJabberId = @"csadmin@constore.no";
//    curJIdwd = @"H764T844";
//    
//#else
//    
//    curJabberId = @"cs-5kpmmucc@constore.no";
//    curJIdwd = @"5KPMMUCC";
//    
//#endif
    
    dicConnect = [[NSMutableDictionary alloc] init];
    xmppHelper = [ETechXmpp sharedInstance];
    xmppHelper.eTechXmppDelegate = self;
    
    isPusharrive = false;
    
    [DatabaseHelper createDatabaseFromAssets:DATABASE_NAME];
    
    dbUserHelper = [[DatabaseHelper alloc] init:DATABASE_NAME];
    
    if (![GeneralUtil getUserPreference:key_selLang]) {
        [LocalizeLanguage setLocalizeLanguage:value_LangNorwegian];
        [GeneralUtil setUserPreference:key_selLang value:value_LangNorwegian];
    }
    else {
        [LocalizeLanguage setLocalizeLanguage:[GeneralUtil getUserPreference:key_selLang]];
    }
    
    NSString *login = [GeneralUtil getUserPreference:key_islogin];
    
    if ([[GeneralUtil getUserPreference:key_islogin] isEqualToString:@"YES"]) {
        if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
            NSDictionary *studentDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
            
            curJabberId = [studentDetail objectForKey:@"jid"];;
            curJIdwd = [studentDetail objectForKey:@"key"];
            
            [self connectXmpp:curJabberId];
        }
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    if ([[GeneralUtil getUserPreference:KEY_APP_VERSION] isEqualToString:version]) {
        
        NSDictionary *dict = [GeneralUtil getUserPreferenceChild:KEY_APP_DETAIL];
        
        if([[dict valueForKey:@"forceUpdateApp"] isEqualToString:@"Yes"]) {
           [self openUpgradeScreen:dict];
        }
        else {
            SplashViewController *splashViewController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
            navigationController = [[UINavigationController alloc]initWithRootViewController:splashViewController];
            
//            MyProfileViewControllerTemp *tvc = [[MyProfileViewControllerTemp alloc] initWithNibName:@"MyProfileViewControllerTemp" bundle:nil];
//            navigationController = [[UINavigationController alloc]initWithRootViewController:tvc];
            navigationController.navigationBarHidden = YES;
            self.window.rootViewController = navigationController;
        }
    }
    else {
        
        SplashViewController *splashViewController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
        navigationController = [[UINavigationController alloc]initWithRootViewController:splashViewController];
        
//        MyProfileViewControllerTemp *tvc = [[MyProfileViewControllerTemp alloc] initWithNibName:@"MyProfileViewControllerTemp" bundle:nil];
//        navigationController = [[UINavigationController alloc]initWithRootViewController:tvc];
        
        navigationController.navigationBarHidden = YES;
        self.window.rootViewController = navigationController;
    }
    
    [self.window makeKeyAndVisible];
    
    if ([[GeneralUtil getUserPreference:key_emg_msg_read] isEqualToString:@"Yes"]) {
        [self showEmergancyMsg:[GeneralUtil getLocalizedText:@"MSG_EMERGANCY_MSG_TITLE"] massage:[GeneralUtil getUserPreference:key_emergancy_msg]];
    }
    
    
    
#if TARGET_OS_SIMULATOR
#else
    //IOS 8 push notification
    
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    //    {
    //        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    //        [[UIApplication sharedApplication] registerForRemoteNotifications];
    //    }
    //    else
    //    {
    //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
    //         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    //    }
    
    if([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
        
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]; [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
    }
    
    
    NSDictionary *pushInformation = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(pushInformation) {
        [self application:application didReceiveRemoteNotification:pushInformation];
    }
    
    
#endif
    
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:[GeneralUtil getLocalizedText:@"BTN_TTL_PICKER_DONE"]];
    
    return YES;
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame{
    
    ZDebug(@"didChangeStatusBarFrame %@", NSStringFromCGRect(newStatusBarFrame));
    
    statusViewHeight = newStatusBarFrame.size.height;
    
    [UIView animateWithDuration:0.35 animations:^{
        UIViewController *vc = [((UINavigationController *)deckController.centerController) topViewController];
        
        if (vc && [vc isKindOfClass:[ParentChatViewController class]]) {
            
            CGRect windowFrame = vc.view.frame;
            
            ZDebug(@"old fram%@", NSStringFromCGRect(windowFrame));
            
            if (newStatusBarFrame.size.height > 20) {
                // windowFrame.origin.y = newStatusBarFrame.size.height - 20 ;// old status bar frame is 20
                [(ParentChatViewController *)vc setNewFream:YES];
            }
            else{
                windowFrame.origin.y = 0.0;
                [(ParentChatViewController *)vc setNewFream:NO];
            }
            
            ZDebug(@"New fram%@", NSStringFromCGRect(windowFrame));
            
            vc.view.frame = windowFrame;
        }
    }];
}

- (NSString *)getCurrentChildId {
    
    NSDictionary *studentDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
    NSString *curChlId = [studentDetail objectForKey:@"user_id"];
    
    return curChlId;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    //register to receive notifications
    
    [application registerForRemoteNotifications];
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler

{
    
    //handle the actions
    
    if ([identifier isEqualToString:@"declineAction"]) { }
    
    else if ([identifier isEqualToString:@"answerAction"]) { }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
#if TARGET_IPHONE_SIMULATOR
#else
    
    NSString *deviceToken = [[[[devToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"deviceToken:-------- %@",deviceToken);
    
    [GeneralUtil setUserPreference:key_device_tokan value:deviceToken];
   
#endif
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError > error: %@", error);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"++++++++++++++++++++didReceiveRemoteNotification+++++++++++++++++++++++++++++");
#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"userInfo: %@",userInfo);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSDictionary *data = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [data objectForKey:@"alert"];
    NSNumber *badnum = [data valueForKey:@"badge"];
    
    NSDictionary *others = [userInfo objectForKey:@"others"];
    NSString *msg_type = [others valueForKey:@"type"];
    
    if ([msg_type isEqualToString:@"emg_msg"]) {
        
        [GeneralUtil setUserPreference:key_emergancy_msg value:alert];
        [GeneralUtil setUserPreference:key_emg_msg_read value:@"Yes"];
        
        [self showEmergancyMsg:[GeneralUtil getLocalizedText:@"MSG_EMERGANCY_MSG_TITLE"] massage:[GeneralUtil getUserPreference:key_emergancy_msg]];
    }
    else {
        
        NSString *kidid = [others valueForKey:@"kidid"];
        
        [GeneralUtil incrementBadge:kidid :others];
        
        UIViewController *vc = [((UINavigationController *)deckController.centerController) topViewController];
        
        if ([vc isKindOfClass:[ParentHomeViewController class]]) {
            
            [(ParentHomeViewController *)vc setbadge];
        }
        else {
            
            if (![msg_type isEqualToString:@"chat_msg"])
                AudioServicesPlaySystemSound (1054);
        }
    }
    
//    if ([msg_type isEqualToString:@"emg_msg"]) {
//        
//        [GeneralUtil setUserPreference:key_emergancy_msg value:alert];
//        [GeneralUtil setUserPreference:key_emg_msg_read value:@"Yes"];
//        
//         [self showEmergancyMsg:[GeneralUtil getLocalizedText:@"MSG_EMERGANCY_MSG_TITLE"] massage:[GeneralUtil getUserPreference:key_emergancy_msg]];
//    }
//    else if ([msg_type isEqualToString:@"abi"] ||
//             [msg_type isEqualToString:@"abn"]||
//             [msg_type isEqualToString:@"chat_msg"] ) {
//    
//        NSString *kidid = [others valueForKey:@"kid_id"];
//        
//        if ([msg_type isEqualToString:@"abi"]) {
//        
//            if ([kidid isEqualToString:[appDelegate getCurrentChildId]]) {
//                
//                UIViewController *vc = [((UINavigationController *)deckController.centerController) topViewController];
//                
//                if ([vc isKindOfClass:[GroupMessageViewController class]]) {
//                    
//                    [(GroupMessageViewController *)vc getMessageOfTeacher];
//                }
//                else {
//                    [GeneralUtil incrementBadge:kidid badgeType:key_abi_badge];
//                }
//            }
//            else {
//                [GeneralUtil incrementBadge:kidid badgeType:key_abi_badge];
//            }
//        }
//        else if ([msg_type isEqualToString:@"abn"]) {
//            [GeneralUtil incrementBadge:kidid badgeType:key_abn_badge];
//        }
//        
//        else if ([msg_type isEqualToString:@"chat_msg"])
//            [GeneralUtil incrementBadge:kidid badgeType:key_chat_badge];
//        
//        UIViewController *vc = [((UINavigationController *)deckController.centerController) topViewController];
//        
//        if ([vc isKindOfClass:[HomeViewController class]]) {
//            
//            [(HomeViewController *)vc setbadge];
//        }
//        else {
//            if (![msg_type isEqualToString:@"chat_msg"])
//                AudioServicesPlaySystemSound (1054);
//        }
//    }
    
#else
     NSLog(@"userInfo: %@",userInfo);
    
#endif
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIView *dropdownView = [appDelegate.window viewWithTag:NIDROPDOWN_VIEW_TAG];
    [dropdownView removeFromSuperview];
    
    isPusharrive = false;
    
    if ([[GeneralUtil getUserPreference:key_islogin] isEqualToString:@"YES"]) {
        if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
            [self disConnectXmpp];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if ([[GeneralUtil getUserPreference:key_emg_msg_read] isEqualToString:@"Yes"]) {
        [self showEmergancyMsg:[GeneralUtil getLocalizedText:@"MSG_EMERGANCY_MSG_TITLE"] massage:[GeneralUtil getUserPreference:key_emergancy_msg]];
    }
    
    if ([[GeneralUtil getUserPreference:key_islogin] isEqualToString:@"YES"]) {
        
        
        if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
            [self connectXmpp:curJabberId];
            
            ZDebug(@"Xmpp Connection start...");
        }
        
        ParentPincodeViewController * pvc = [[ParentPincodeViewController alloc] initWithNibName:@"ParentPincodeViewController" bundle:nil];
        pvc.isForVerification = true;
        
        if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
            
            UIViewController *vc = [((UINavigationController *)deckController.centerController) topViewController];
            
            if (![vc isKindOfClass:[ParentPincodeViewController class]]) {
                
            
            [((UINavigationController *)deckController.centerController) pushViewController:pvc animated:YES];
            }
        }
        else {
            UIViewController *vc = [navigationController topViewController];
            
            if (![vc isKindOfClass:[ParentPincodeViewController class]]) {
            [navigationController pushViewController:pvc animated:YES];
            }
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (IIViewDeckController*)generateTeacherControllerStack {
    
    TeacherMenuViewController* leftController = [[TeacherMenuViewController alloc] initWithNibName:@"TeacherMenuViewController" bundle:nil];
//    UIViewController *centerController = [[TeacherHomeViewController alloc] initWithNibName:@"TeacherHomeViewController" bundle:nil];
    UIViewController *centerController = [[TeacherSFOHomeViewController alloc] initWithNibName:@"TeacherSFOHomeViewController" bundle:nil];
    centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
    deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController leftViewController:leftController rightViewController:nil];
    deckController.leftSize = 60;
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    
    return deckController;
}

- (IIViewDeckController*)generateParentControllerStack {
    
    ParentMenuViewController* leftController = [[ParentMenuViewController alloc] initWithNibName:@"ParentMenuViewController" bundle:nil];
    UIViewController *centerController = [[ParentHomeViewController alloc] initWithNibName:@"ParentHomeViewController" bundle:nil];
//	UIViewController *centerController = [[ParentSFOHomeViewController alloc] initWithNibName:@"ParentSFOHomeViewController" bundle:nil];
    centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
    deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController leftViewController:leftController rightViewController:nil];
    deckController.leftSize = 60;
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    
    return deckController;
}

-(void)setTeacherHomeAsRootView {
    IIViewDeckController *deck = [self generateTeacherControllerStack];
    
    /* To adjust speed of open/close animations, set either of these two properties. */
    // deckController.openSlideAnimationDuration = 0.15f;
    // deckController.closeSlideAnimationDuration = 0.5f;
    self.window.rootViewController = deck;
}

-(void)setParentHomeAsRootView {
    IIViewDeckController *deck = [self generateParentControllerStack];
    
    /* To adjust speed of open/close animations, set either of these two properties. */
    // deckController.openSlideAnimationDuration = 0.15f;
    // deckController.closeSlideAnimationDuration = 0.5f;
    self.window.rootViewController = deck;
}

-(void)setFlagvalue {
    isPusharrive = true;
}
-(void)Logout {
    
//    ParentLoginViewController *loginViewController= [[ParentLoginViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginViewController];
    MainScreenViewController *mainViewController= [[MainScreenViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
}

-(void)connectXmpp:(NSString *)jabberId {
    curJabberId = jabberId;
    [xmppHelper connect:jabberId];
}

-(void)disConnectXmpp {
    
    isConnected = false;
    [dicConnect setObject:[NSNumber numberWithBool:NO]
                   forKey:@"is_Connected"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectingStatus" object:dicConnect];
    
    [xmppHelper disConnect];
}

-(void)connectDidCompleted:(BOOL)status error:(NSError *)error {
    
    if (status) {
        NSLog(@"Connection successfully...");
        [xmppHelper authenticat:curJIdwd];
    }
    else {
        NSLog(@"connectDidCompleted > Error: %@",error);
    }
}

-(void)authenticatDidCompleted:(BOOL)status error:(NSError *)error {
    
    if (status) {
        NSLog(@"Authenticate successfully...");
        
        [dicConnect setObject:[NSNumber numberWithBool:YES]
                       forKey:@"is_Connected"];
        isConnected = true;
        [self performSelector:@selector(setFlagvalue) withObject:self afterDelay:2.0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectingStatus" object:dicConnect];
    }
    else {
        NSLog(@"authenticatDidCompleted > Error: %@",error);
    }
}

-(void)newMessageReceived:(NSMutableDictionary *)messageContent {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageReceived" object:messageContent];
}

-(void)typingStatus:(NSString *)typingStatus From:(NSString *)jId {
    
    NSDictionary *dicStatus = @{@"status":typingStatus,@"from" : jId};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TypingStatus" object:dicStatus];
}

-(void)typingPaused:(NSString *)typingPaused From:(NSString *)jId {
    
    NSDictionary *dicStatus = @{@"status":typingPaused,@"from" : jId};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TypingPaused" object:dicStatus];
}

-(void)newAvilableUser:(NSString *)user {
    
}

-(void)unAvilableUser:(NSString *)user {
    
}

-(CGSize)getSizeOfContent:(NSString *)text {
    
    CGSize maximumSize = CGSizeMake(220, CGFLOAT_MAX);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:maximumSize
                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_16_REGULER} context:context].size;
    
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size;
}

-(void)showEmergancyMsg:(NSString *)title massage:(NSString *)msg {
    
    
    AudioServicesPlaySystemSound (1021);
    
//    AudioServicesPlaySystemSound (1054);
//    AudioServicesPlaySystemSound (1054);
//    AudioServicesPlaySystemSound (1054);
    
    emcymsgView = [self.window viewWithTag:128856];
    
    if (emcymsgView ) {
        [emcymsgView removeFromSuperview];
    }
    
    emcymsgView = [[UIView alloc]  initWithFrame:[[UIScreen mainScreen] bounds]];
    emcymsgView.tag = 128856;
    emcymsgView.backgroundColor = TEXT_COLOR_DARK_BLUE;
    
    CGSize contentHeight = [self getSizeOfContent:msg];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2, SCREEN_HEIGHT / 2, SCREEN_WIDTH - 70, contentHeight.height + 190)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    contentView.layer.cornerRadius = 10;
    
    [emcymsgView addSubview:contentView];
    contentView.center = emcymsgView.center;
    
    UIView *titelView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, contentView.frame.size.width ,80)];
    titelView.backgroundColor = [UIColor redColor];
    [contentView addSubview:titelView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titelView.bounds byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight ) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titelView.bounds;
    maskLayer.path  = maskPath.CGPath;
    titelView.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.frame =  titelView.bounds;
    borderLayer.path  = maskPath.CGPath;
    borderLayer.lineWidth   = 1.0f;
    borderLayer.strokeColor = [UIColor clearColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [titelView.layer addSublayer:borderLayer];
    
    UIImageView *alertIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    alertIcon.image = [UIImage imageNamed: @"alert"];
    [titelView addSubview:alertIcon];
    alertIcon.center = titelView.center;
    
    UILabel *alertTitel = [[UILabel alloc] initWithFrame:CGRectMake(0, titelView.frame.size.height, titelView.frame.size.width - 20, 40)];
    alertTitel.textAlignment = NSTextAlignmentCenter;
    alertTitel.textColor = [UIColor redColor];
    alertTitel.font = FONT_16_BOLD;
    alertTitel.text = title;
    [contentView addSubview:alertTitel];
    
    CGPoint centerTitle = alertTitel.center;
    centerTitle.x = contentView.frame.size.width / 2;
    [alertTitel setCenter:centerTitle];
    
    UILabel *alertMassage = [[UILabel alloc] initWithFrame:CGRectMake(0,alertTitel.frame.origin.y  + alertTitel.frame.size.height, titelView.frame.size.width - 20, contentHeight.height)];
    alertMassage.textAlignment = NSTextAlignmentCenter;
    alertMassage.textColor = [UIColor blackColor];
    alertMassage.font = FONT_16_REGULER;
    alertMassage.lineBreakMode = NSLineBreakByWordWrapping;
    alertMassage.numberOfLines = 0;
    alertMassage.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    alertMassage.text = msg;

    [contentView addSubview:alertMassage];
    
    CGPoint centerMassage = alertMassage.center;
    centerMassage.x = contentView.frame.size.width / 2;
    [alertMassage setCenter:centerMassage];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height - 50, 100, 35)];
    btnClose.layer.cornerRadius = 5;
    btnClose.backgroundColor = [UIColor redColor];
    [btnClose setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnClose setTitle:[GeneralUtil getLocalizedText:@"BTN_CLOSE_TITLE"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnClosePress) forControlEvents:UIControlEventTouchUpInside];
    
    CGPoint btnCenter = btnClose.center;
    btnCenter.x = contentView.frame.size.width / 2;
    [btnClose setCenter:btnCenter];
    [contentView addSubview:btnClose];
    
    [self.window addSubview:emcymsgView];
    [self.window bringSubviewToFront:emcymsgView];
}

-(void)btnClosePress {
    [emcymsgView removeFromSuperview];
    [GeneralUtil setUserPreference:key_emg_msg_read value:@"NO"];
}

-(void)checkUpdateVersone:(NSDictionary *)responsedictionary  {
    
    if ([[[responsedictionary  objectForKey:@"iOS"] valueForKey:@"isVersionDifferent"] isEqualToString:@"Yes"]) {
        [GeneralUtil setUserPreference:KEY_APP_VERSION value:version];
       // [[NSUserDefaults standardUserDefaults] setObject:[responsedictionary valueForKey:@"upgrade"] forKey:@"DicKey"];
        [GeneralUtil setAppDetailPreference:KEY_APP_DETAIL value:[responsedictionary  objectForKey:@"iOS"]];
        [appDelegate openUpgradeScreen:[responsedictionary  objectForKey:@"iOS"]];
    }
}

-(void)openUpgradeScreen:(NSDictionary *)dict {
    
    if([[dict valueForKey:@"forceUpdateApp"] isEqualToString:@"No"]) {
        //WITH SKIP OPTION
        
        UpdateYappoViewController *updateViewController = [[UpdateYappoViewController alloc]init];
        updateViewController.dictUpdateApp = dict;
        
        if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
            
            if (![[(UINavigationController *)appDelegate.deckController.centerController topViewController] isKindOfClass:[UpdateYappoViewController class]]) {
                
        
            [(UINavigationController *)appDelegate.deckController.centerController pushViewController:updateViewController animated:NO];
            }
        }
        else {
            if (![[self.navigationController topViewController] isKindOfClass:[UpdateYappoViewController class]]) {
                [self.navigationController pushViewController:updateViewController animated:NO];
            }
        }
    }
    else {
        //WITHOUT SKIP OPTION
        UpdateYappoViewController *updateViewController = [[UpdateYappoViewController alloc]init];
        updateViewController.dictUpdateApp = dict;
        [self.window setRootViewController:updateViewController];
    }
}

-(void)generateAndUploadPdf:(NSDictionary *)studantDetail andSubjectDetail:(NSMutableArray *)arrSubjectDetail withImg:(NSString *)isWithImg isIndividual:(BOOL)isIndividul {
    
    //    [self generatePDF];
    //
    //    [self drawHeader:studantDetail];
    //
    //    [self drawLine];
    //
    //    [self drawSubjectAndMarks:arrSubjectDetail];
    //
    //    [self uploadPdf:isSend];
    
    NSMutableDictionary *dicPara = [[NSMutableDictionary alloc] init];
    
    [dicPara setObject:@"" forKey:@"teacher_id"];
    [dicPara setObject:@"no" forKey:@"send_email"];
    [dicPara setObject:[studantDetail valueForKey:@"user_id"] forKey:@"student_id"];
    [dicPara setObject:[studantDetail valueForKey:@"school_class_id"] forKey:@"class_id"];
    
    
    [dicPara setObject:isWithImg forKey:@"include_image"];
    
    
    if (isIndividul) {
        
        NSString *subjectIds = @"";
        NSString *testId = @"";
        
        for (NSDictionary *dicValue in arrSubjectDetail) {
            
            subjectIds = [dicValue valueForKey:@"subject_id"];
            testId = [[[dicValue valueForKey:@"marks"] objectAtIndex:0] valueForKey:@"exam_no"];
        }
        
        [dicPara setObject:subjectIds forKey:@"subject_id"];
        [dicPara setObject:testId forKey:@"test_id"];
        [dicPara setObject:[[arrSubjectDetail objectAtIndex:0] valueForKey:@"semester_id"] forKey:@"semester_id"];
        
        ZDebug(@"subjectIds : == %@", subjectIds);
        ZDebug(@"testId : == %@", testId);
    }
    else {
        
        NSString *subjectIds = @"";
        
        
        for (NSDictionary *dicValue in arrSubjectDetail) {
            
            subjectIds = [subjectIds stringByAppendingFormat:@"%@,",[dicValue valueForKey:@"subject_id"]];
            
        }
        
        [dicPara setObject:[[arrSubjectDetail objectAtIndex:0] valueForKey:@"semester_id"] forKey:@"semester_id"];
        ZDebug(@"subjectIds : == %@", subjectIds);
        
        [dicPara setObject:subjectIds forKey:@"selected_subjects_id"];
    }
    
    ZDebug(@"%@", dicPara);
    
    userObj = [[ParentUser alloc] init];
    
    [userObj downloadPdf:dicPara isindividual:isIndividul :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1)
            {
                NSString * url = [dicRes valueForKey:@"url"];
                //  NSString *url = [NSString stringWithFormat:@"%@%@",UPLOAD_URL,strUrl];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
            }
            else if ([[dicRes valueForKey:@"flag"] intValue] == 0)
            {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALIDE_PERAMETER_ERROR"]];
            }
            else {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_OTHER_ERROR"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)generateAndUploadPdf:(NSDictionary *)studantDetail andSubjectDetail:(NSMutableArray *)arrSubjectDetail isMmailSend:(NSString *)isSend withImg:(NSString *)isWithImg isIndividual:(BOOL)isIndividul {
    
    //    [self generatePDF];
    //
    //    [self drawHeader:studantDetail];
    //
    //    [self drawLine];
    //
    //    [self drawSubjectAndMarks:arrSubjectDetail];
    //
    //    [self uploadPdf:isSend];
    
    NSMutableDictionary *dicPara = [[NSMutableDictionary alloc] init];
    
    [dicPara setObject:[GeneralUtil getUserPreference:key_teacherId] forKey:@"teacher_id"];
    [dicPara setObject:isSend forKey:@"send_email"];
    [dicPara setObject:[studantDetail valueForKey:@"user_id"] forKey:@"student_id"];
    [dicPara setObject:[studantDetail valueForKey:@"class_id"] forKey:@"class_id"];
    
    
    [dicPara setObject:isWithImg forKey:@"include_image"];
    
    
    if (isIndividul) {
        
        NSString *subjectIds = @"";
        NSString *testId = @"";
        
        for (NSDictionary *dicValue in arrSubjectDetail) {
            
            subjectIds = [dicValue valueForKey:@"subject_id"];
            testId = [[[dicValue valueForKey:@"marks"] objectAtIndex:0] valueForKey:@"exam_no"];
        }
        
        [dicPara setObject:subjectIds forKey:@"subject_id"];
        [dicPara setObject:testId forKey:@"test_id"];
        [dicPara setObject:[[arrSubjectDetail objectAtIndex:0] valueForKey:@"semester_id"] forKey:@"semester_id"];
        
        ZDebug(@"subjectIds : == %@", subjectIds);
        ZDebug(@"testId : == %@", testId);
    }
    else {
        
        NSString *subjectIds = @"";
        
        
        for (NSDictionary *dicValue in arrSubjectDetail) {
            
            subjectIds = [subjectIds stringByAppendingFormat:@"%@,",[dicValue valueForKey:@"subject_id"]];
            
        }
        
        [dicPara setObject:[[arrSubjectDetail objectAtIndex:0] valueForKey:@"semester_id"] forKey:@"semester_id"];
        ZDebug(@"subjectIds : == %@", subjectIds);
        
        [dicPara setObject:subjectIds forKey:@"selected_subjects_id"];
    }
    
    ZDebug(@"%@", dicPara);
    
    userObj = [[ParentUser alloc] init];
    
    [userObj downloadPdf:dicPara isindividual:isIndividul :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1)
            {
                NSString * url = [dicRes valueForKey:@"url"];
                //  NSString *url = [NSString stringWithFormat:@"%@%@",UPLOAD_URL,strUrl];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
            }
            else if ([[dicRes valueForKey:@"flag"] intValue] == 0)
            {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALIDE_PERAMETER_ERROR"]];
            }
            else {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_OTHER_ERROR"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)uploadPdf {
    
    userObj = [[ParentUser alloc] init];
    
    [userObj uploadPdfMarks:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] pdfFile:PathOfReportGenerated :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1)
            {
                NSString * url = [dicRes valueForKey:@"url"];
                //  NSString *url = [NSString stringWithFormat:@"%@%@",UPLOAD_URL,strUrl];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
            }
            else if ([[dicRes valueForKey:@"flag"] intValue] == 0)
            {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALIDE_PERAMETER_ERROR"]];
            }
            else {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_OTHER_ERROR"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}


-(void) generatePDF

{
    /*** This is the method called by your "PDF generating" Button. Just give initial PDF page frame, Name for your PDF file to be saved as, and the path for storing it to documnets directory ***/
    pageSize = CGSizeMake(612, 792);
    
    NSString *fileName = @"StuantMarks.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"pdfpath %@",pdfFilePath);
    
    PathOfReportGenerated=pdfFilePath;
    
    [self generatePdfWithFilePath:pdfFilePath];
}

#pragma mark Gnerate PDf

#define kBorderInset            20.0
#define kBorderWidth            1.0
#define kMarginInset            12.0
#define kLineWidth              1.0

- (void) generatePdfWithFilePath: (NSString *)thefilePath

{
    /*** Now generating the pdf  and storing it to the documents directory of device on selected path. Customize do-while loop to meet your pdf requirements like number of page, Size of NSstrings/texts you want to fit. Basically just call all the above methods depending on your requirements from do-while loop or you can recustomize it. ****/
    
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
}

-(CGSize)getSizeOfContent:(NSString *)text font:(UIFont *)font {
    
    CGSize maximumSize = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:maximumSize
                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:context].size;
    
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size;
}

-(void)drawHeader:(NSDictionary *)studantDetail {
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentLeft;
    
    
    NSString *schName = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_SCHOOL_NAME_TITLE"],[studantDetail valueForKey:@"school_name"]];
    
    NSString *studName = [NSString stringWithFormat:@"%@: %@\n",[GeneralUtil getLocalizedText:@"PGF_STUDENT_NAME_TITLE"],[studantDetail valueForKey:@"child_name"]];
    
    NSString *className = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_CLASS_TITLE"],[studantDetail valueForKey:@"class_name"]];
    
    contextX = kBorderInset + kMarginInset;
    contextY = kBorderInset + kMarginInset;
    
    contextWidth = pageSize.width - ((kBorderInset + kMarginInset) * 2);
    
    
    CGSize stringSize = [self getSizeOfContent:schName font:FONT_16_REGULER];
    CGRect renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    
    [schName drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_REGULER, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    
    
    stringSize = [self getSizeOfContent:studName font:FONT_16_BOLD];
    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [studName drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_BOLD, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    
    stringSize = [self getSizeOfContent:className font:FONT_16_BOLD];
    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [className drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_BOLD, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    contextY = contextY + 30; // 50 = space btwn header text and line
}

-(void)drawLine {
    
    if (contextY > (pageSize.height - (kBorderInset + kMarginInset))) {
        contextY = kBorderInset + kMarginInset;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    }
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, kLineWidth);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blackColor].CGColor);
    
    CGPoint startPoint = CGPointMake(contextX, contextY);
    CGPoint endPoint = CGPointMake(contextWidth, contextY);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}


- (void) drawSubjectAndMarks:(NSMutableArray *)arrSubjectDetail
{
    margin = 15;
    
    contextY = contextY + 10;
    
    NSString *preSubject;
    
    for (NSDictionary *dicSuject in arrSubjectDetail) {
        
        if (!preSubject) {
            preSubject = [dicSuject valueForKey:@"subject_name"];
        }
        
        NSArray *arrMarks = [dicSuject valueForKey:@"marks"];
        
        NSString *teacherName = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_TEACHER_NAME_TITLE"],[dicSuject valueForKey:@"teacher_name"]];
        
        NSString *subjectName = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_SUBJECT_NAME_TITLE"],[dicSuject valueForKey:@"subject_name"]];
        
        
        if (![preSubject isEqualToString:[dicSuject valueForKey:@"subject_name"]]) {
            preSubject = [dicSuject valueForKey:@"subject_name"];
            
            contextY = kBorderInset + kMarginInset;
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        }
        
        for (NSDictionary *dicTest in arrMarks) {
            
            contextWidth = contextWidth / 2;
            
            if (contextY > ((pageSize.height - (kBorderInset + kMarginInset))) / 2) {
                contextY = kBorderInset + kMarginInset;
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
            }
            
            NSString *testNumber = [NSString stringWithFormat:@"%@: %d",[GeneralUtil getLocalizedText:@"PGF_TEST_NUMBER_TITLE"],[[dicTest valueForKey:@"exam_no"] intValue]];
            
            CGRect renderingRect = [self drawText:testNumber :FONT_16_BOLD];
            
            
            NSString *dateOfTest = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"PGF_DATE_OF_TEST_TITLE"],[GeneralUtil formateDataLocalize:[dicTest valueForKey:@"exam_date"]]];
            
            contextY = contextY - 5;
            contextX = contextX + contextWidth + 110;
            
            renderingRect = [self drawText:dateOfTest :FONT_16_BOLD];
            
            contextY = contextY + renderingRect.size.height;
            
            contextX = contextX - contextWidth - 110;
            contextWidth = contextWidth * 2;
            
            
            renderingRect = [self drawText:teacherName :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            
            renderingRect = [self drawText:subjectName :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            contextY = contextY + margin;
            
            NSString *ExamAbout = [NSString stringWithFormat:@"%@:",[GeneralUtil getLocalizedText:@"PGF_EXAM_ABOUT_TITLE"]];
            renderingRect = [self drawText:ExamAbout :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            
            ExamAbout = [dicTest valueForKey:@"exam_about"];
            renderingRect = [self drawText:ExamAbout :FONT_16_REGULER];
            contextY = contextY + renderingRect.size.height;
            
            contextY = contextY + margin;
            
            NSString *comment = [NSString stringWithFormat:@"%@:",[GeneralUtil getLocalizedText:@"PGF_COMMENT_TITLE"]];
            renderingRect = [self drawText:comment :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            comment = [dicTest valueForKey:@"comment"];
            
            if ([comment isEqualToString:@""]) {
                comment = [GeneralUtil getLocalizedText:@"LBL_NO_COMMENT_TITLE"];
            }
            else {
                comment = [dicTest valueForKey:@"comment"];
            }
            
            renderingRect = [self drawText:comment :FONT_16_REGULER];
            contextY = contextY + renderingRect.size.height;
            
            contextY = contextY + margin;
            
            NSString *marks = [NSString stringWithFormat:@"%@:",[GeneralUtil getLocalizedText:@"PGF_MARKS_TITLE"]];
            renderingRect = [self drawText:marks :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            marks = [dicTest valueForKey:@"marks"];
            
            if ([marks isEqualToString:@""]) {
                marks = [GeneralUtil getLocalizedText:@"LBL_NO_MARKS_TITLE"];
            }
            else {
                comment = [dicTest valueForKey:@"marks"];
            }
            
            renderingRect = [self drawText:marks :FONT_16_REGULER];
            contextY = contextY + renderingRect.size.height;
            
            contextY = contextY + 25;
            
            [self drawLine];
            
            contextY = contextY + 25;
        }
    }
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

-(CGRect)drawText:(NSString *)text :(UIFont *)font {
    
    if (contextY > (pageSize.height - (kBorderInset + kMarginInset))) {
        contextY = kBorderInset + kMarginInset;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    }
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentLeft;
    
    CGSize stringSize = [self getSizeOfContent:text font:font];
    CGRect renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [text drawInRect:renderingRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + 5;
    
    return renderingRect;
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            [self disConnectXmpp];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            if (![xmppHelper isConnected]) {
                if ([[GeneralUtil getUserPreference:key_islogin] isEqualToString:@"YES"]) {
                    if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
                        NSDictionary *studentDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
                        curJabberId = [studentDetail objectForKey:@"jid"];;
                        curJIdwd = [studentDetail objectForKey:@"key"];
                        
                        [self connectXmpp:curJabberId];
                    }
                }
            }
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            
            if (![xmppHelper isConnected]) {
                if ([[GeneralUtil getUserPreference:key_islogin] isEqualToString:@"YES"]) {
                    if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
                        NSDictionary *studentDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];                       
                        curJabberId = [studentDetail objectForKey:@"jid"];;
                        curJIdwd = [studentDetail objectForKey:@"key"];
                        
                        [self connectXmpp:curJabberId];
                    }
                }
            }
            
            
            break;
        }
    }
}


@end
