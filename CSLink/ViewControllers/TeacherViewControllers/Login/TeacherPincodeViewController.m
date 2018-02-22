//
//  PincodeViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "TeacherPincodeViewController.h"
#import "TeacherConstant.h"
#import "BaseViewController.h"
#import "THPinViewController.h"

@interface TeacherPincodeViewController () <THPinViewControllerDelegate>
{
    TeacherUser *userObj;
}

@property (nonatomic, strong) UIImageView *secretContentView;
@property (nonatomic, strong) UIButton *loginLogoutButton;
@property (nonatomic, copy) NSString *correctPin;
@property (nonatomic, assign) NSUInteger remainingPinEntries;
@property (nonatomic, assign) BOOL locked;

@end

@implementation TeacherPincodeViewController
@synthesize isForVerification;
static const NSUInteger THNumberOfPinEntries = 6;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    txtPinCode.text = @"1111";
    userObj = [[TeacherUser alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    
    [BaseViewController setBackGroud:self];
    
    [BaseViewController formateButtonCyne:btnLogin title:[GeneralUtil getLocalizedText:@"BTN_LOGIN_TITLE"]];
    [BaseViewController setCynaColorDefultFontBtn:btnForgotPin];
    
    
 //   self.view.backgroundColor = [UIColor colorWithRed:0.361f green:0.404f blue:0.671f alpha:1.0f];
    
    self.correctPin = @"1234";
    
    //    self.secretContentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confidential"]];
    //    self.secretContentView.translatesAutoresizingMaskIntoConstraints = NO;
    //    self.secretContentView.contentMode = UIViewContentModeScaleAspectFit;
    //    [self.view addSubview:self.secretContentView];
    //
    ////    self.loginLogoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ////    self.loginLogoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    ////    [self.loginLogoutButton setTitle:@"Enter PIN" forState:UIControlStateNormal];
    ////    self.loginLogoutButton.tintColor = [UIColor whiteColor];
    ////    [self.view addSubview:self.loginLogoutButton];
    //
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginLogoutButton attribute:NSLayoutAttributeCenterX
    //                                                          relatedBy:NSLayoutRelationEqual
    //                                                             toItem:self.view attribute:NSLayoutAttributeCenterX
    //                                                         multiplier:1.0f constant:0.0f]];
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginLogoutButton attribute:NSLayoutAttributeCenterY
    //                                                          relatedBy:NSLayoutRelationEqual
    //                                                             toItem:self.view attribute:NSLayoutAttributeTop
    //                                                         multiplier:1.0f constant:60.0f]];
    //    NSDictionary *views = @{ @"secretContentView" : self.secretContentView };
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[secretContentView]-(20)-|"
    //                                                                      options:0 metrics:nil views:views]];
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(120)-[secretContentView]-(20)-|"
    //                                                                      options:0 metrics:nil views:views]];
    self.locked = YES;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    [self performSelector:@selector(showPinView) withObject:nil afterDelay:1.0];
    
    
    // [self showPinViewAnimated:NO];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if (! self.locked) {
        [self showPinViewAnimated:NO];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Properties

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    
    if (self.locked) {
        self.remainingPinEntries = THNumberOfPinEntries;
        [self.loginLogoutButton removeTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginLogoutButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        self.secretContentView.hidden = YES;
    } else {
        [self.loginLogoutButton removeTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginLogoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        self.secretContentView.hidden = NO;
    }
}

#pragma mark - UI


- (void)showPinView
{
    [self showPinViewAnimated:NO];
}

- (void)showPinViewAnimated:(BOOL)animated
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.promptTitle = [GeneralUtil getLocalizedText:@"LBL_ENTER_PIN_TITLE"];
    [pinViewController setPromptColor:[UIColor whiteColor]];
    //UIColor *darkBlueColor = [UIColor colorWithRed:0.012f green:0.071f blue:0.365f alpha:1.0f];
    // pinViewController.promptColor = ;
    pinViewController.view.tintColor = [UIColor whiteColor];
    
    // for a solid background color, use this:
    pinViewController.backgroundColor = [UIColor clearColor];
    
    // for a translucent background, use this:
    //    self.view.tag = THPinViewControllerContentViewTag;
    //    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //    pinViewController.translucentBackground = YES;
    
    [BaseViewController setBackGroud:pinViewController];
    
    [self presentViewController:pinViewController animated:animated completion:nil];
}

#pragma mark - THPinViewControllerDelegate

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    //if ([pin isEqualToString:self.correctPin]) {
        //
        userObj.email = [GeneralUtil getUserPreference:key_My_Email];
        
        [userObj verifyPin:pin :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                int numFlag =[[dicRes valueForKey:key_flag] intValue];
                //int numFlag =[[dicRes valueForKey:@"errcode"] intValue];
                
                if (numFlag == 1) {
                    
                    NSString *parentStatus = [dicRes valueForKey:key_ParentStatus];
                    
                    if ([parentStatus isEqualToString:@"0"]) //blocked parent, 1:active, 2:inactive
                    {
                        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_PARENT_IS_BLOCK"]];
                    }
                    else {
                        
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                            if (!isForVerification) {
                                
                                [GeneralUtil setUserPreference:key_UserName value:[dicRes valueForKey:@"teachername"]];
                                [GeneralUtil setUserPreference:key_UserImage value:[dicRes valueForKey:@"image"]];
                                
                                [GeneralUtil setUserPreference:key_studant_req_badge value:[dicRes valueForKey:@"psb"]];
                                [GeneralUtil setUserPreference:key_teacher_badge value:[dicRes valueForKey:@"inb"]];
                                [GeneralUtil setUserPreference:key_chat_badge value:[dicRes valueForKey:@"chb"]];
                                [GeneralUtil setUserPreference:key_register_badge value:[dicRes valueForKey:@"rgb"]];
                                [GeneralUtil setUserPreference:key_charge_type value:[dicRes valueForKey:key_charge_type]];
                                
                                [GeneralUtil setUserPreference:@"RealPinCode" value:txtPinCode.text];
                                [appDelegate setTeacherHomeAsRootView];
                                
                            }
                            else{
                                
                                [((UINavigationController *)appDelegate.deckController.centerController) popViewControllerAnimated:YES];
                                self.navigationController.navigationBarHidden = NO;
                                [GeneralUtil setUserPreference:key_studant_req_badge value:[dicRes valueForKey:@"psb"]];
                                [GeneralUtil setUserPreference:key_teacher_badge value:[dicRes valueForKey:@"inb"]];
                                [GeneralUtil setUserPreference:key_chat_badge value:[dicRes valueForKey:@"chb"]];
                                [GeneralUtil setUserPreference:key_register_badge value:[dicRes valueForKey:@"rgb"]];
                                [GeneralUtil setUserPreference:key_charge_type value:[dicRes valueForKey:key_charge_type]];

                            }
                            
                            [appDelegate checkUpdateVersone:[dicRes valueForKey:@"update_info"]];
                        }];
                    }
                    
                    NSString *userToken = [GeneralUtil getUserPreference:key_device_tokan];
                    
                    #if !TARGET_IPHONE_SIMULATOR
                    if (userToken != nil && userToken.length > 0) {
                        [self deviceRegister];
                    }
                    #endif
                }
                
                if (numFlag == 0) {
                    
                    [GeneralUtil hideProgress];
                    
                    [pinViewController resetView];
                    //[GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_WRONG_PIN"]];
                    
                    if ([dicRes valueForKey:@"msg"])
                        [GeneralUtil alertInfo:[dicRes valueForKey:@"msg"]];
                    else
                        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_WRONG_PIN"]];
                }
            }
            else {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_WRONG_PIN"]];
                NSLog(@"Request Fail...");
            }
        }];
        
        return YES;
//    }
//    else {
//        return NO;
//    }
}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return YES;
}

- (void)incorrectPinEnteredInPinViewController:(THPinViewController *)pinViewController
{
    
    
}

- (void)pinViewControllerWillDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController
{
    self.locked = NO;
}

- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController
{
    
}

- (void)pinViewControllerWillDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController
{
    
}

-(void)deviceRegister {
    
    userObj.userToken = [GeneralUtil getUserPreference:key_device_tokan];
    userObj.userId = [GeneralUtil getUserPreference:key_teacherId];
    [userObj registerDevice:^(NSObject *resObj) {
        NSLog(@"Device Register :%@",@"test");
    }];
}

@end

/*
@interface PincodeViewController ()
{
    TeacherUser *userObj;
}
@end

@implementation PincodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    txtPinCode.text = @"1234";
    userObj = [[User alloc] init];
    
    [BaseViewController setBackGroud:self];
    
    [BaseViewController formateButtonCyne:btnLogin title:@"Login"];
    [BaseViewController setCynaColorDefultFontBtn:btnForgotPin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)btnLoginPress:(id)sender {
    
    userObj.email = [GeneralUtil getUserPreference:key_My_Email];
    
    [userObj verifyPin:txtPinCode.text :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
             int numFlag =[[dicRes valueForKey:key_flag] intValue];
            
            if (numFlag == 1) {
                
                NSString *parentStatus = [dicRes valueForKey:key_ParentStatus];
                
                if ([parentStatus isEqualToString:@"0"]) //blocked parent, 1:active, 2:inactive
                {
                    [GeneralUtil alertInfo:@"The connection is blocked, please contact your school."];
                }
                else {
                    
                    [GeneralUtil setUserPreference:@"RealPinCode" value:txtPinCode.text];
                    [appDelegate setHomeAsRootView];
                }
            }
            
            if (numFlag == 0) {
                
                [GeneralUtil alertInfo:@"Wrong pincode"];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];    
}

- (IBAction)btnForgotPinPrees:(id)sender {
    
    [userObj forgotPin:[[NSUserDefaults standardUserDefaults] objectForKey:key_My_Email] :^(NSObject *resObj){
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            [GeneralUtil alertInfo:@"Pincode had been sent to your email."];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)setStudantDetaile:(NSDictionary *)studant {
    
}
@end
*/
