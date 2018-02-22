//
//  PincodeViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentPincodeViewController.h"
#import "ParentStudantListViewController.h"
#import "BaseViewController.h"
#import "ParentConstant.h"
#import "THPinViewController.h"

@interface ParentPincodeViewController () <THPinViewControllerDelegate>
{
    ParentUser *userObj;
    
}

@property (nonatomic, strong) UIImageView *secretContentView;
@property (nonatomic, strong) UIButton *loginLogoutButton;
@property (nonatomic, copy) NSString *correctPin;
@property (nonatomic, assign) NSUInteger remainingPinEntries;
@property (nonatomic, assign) BOOL locked;

@end

@implementation ParentPincodeViewController

@synthesize isForVerification;

static const NSUInteger THNumberOfPinEntries = 6;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userObj = [[ParentUser alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    
    [BaseViewController setBackGroud:self];
    
    [BaseViewController formateButtonCyne:btnLogin title:@"Login"];
    [BaseViewController setCynaColorDefultFontBtn:btnForgotPin];
    
    
    
   // self.view.backgroundColor = [UIColor colorWithRed:0.361f green:0.404f blue:0.671f alpha:1.0f];
    
    self.correctPin = @"1111";
    
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
   // UIColor *darkBlueColor = [UIColor colorWithRed:0.012f green:0.071f blue:0.365f alpha:1.0f];
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
        userObj.mobile = [GeneralUtil getUserPreference:key_myParentPhone];
        userObj.persentNo = [GeneralUtil getUserPreference:key_myParentNo];
        
        [userObj verifyPin:pin :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                int numFlag =[[dicRes valueForKey:key_flag] intValue];
                
                if (numFlag == 1) {
                    
                    NSString *parentStatus = [dicRes valueForKey:key_ParentStatus];
                    
                    [GeneralUtil setUserPreference:key_myParentName value:[dicRes valueForKey:@"parent name"]];
                    [GeneralUtil setUserPreference:key_ParentEmail value:[dicRes valueForKey:@"parent email"]];
                    
                    if ([parentStatus isEqualToString:@"0"]) //blocked parent, 1:active, 2:inactive
                    {
                        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_PERENT_IS_BLOCK"]];
                    }
                    else {
                        
                        [self setStudantDetaile:dicRes];
                        
                        if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
                            
                            [self dismissViewControllerAnimated:YES completion:^{
                                
                                if (!isForVerification) {
                                    [appDelegate setParentHomeAsRootView];
                                }
                                else {
                                    [((UINavigationController *)appDelegate.deckController.centerController) popViewControllerAnimated:YES];
                                    self.navigationController.navigationBarHidden = NO;
                                }
                                
                                [appDelegate checkUpdateVersone:[dicRes valueForKey:@"update_info"]];
                            }];
                        }
                        else {
                            
                            [self dismissViewControllerAnimated:YES completion:^{
                                if (!isForVerification) {
                                    ParentStudantListViewController *pvc = [[ParentStudantListViewController alloc] initWithNibName:@"ParentStudantListViewController" bundle:nil];
                                    [self.navigationController pushViewController:pvc animated:YES];
                                }
                                else {
                                    [appDelegate.navigationController popViewControllerAnimated:YES];
                                    self.navigationController.navigationBarHidden = NO;
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
                }
                
                if (numFlag == 0) {
                    [pinViewController resetView];
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_WRONG_PIN"]];
                }
            }
            else {
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
    userObj.mobile = [GeneralUtil getUserPreference:key_myParentPhone];
    userObj.persentNo = [GeneralUtil getUserPreference:key_myParentNo];
    userObj.userId = [GeneralUtil getUserPreference:key_UserId];
    userObj.verifyCode = [GeneralUtil getUserPreference:key_verifyCode];
    
    [userObj registerDevice:^(NSObject *resObj){
        
        NSLog(@"Device Register :%@",@"test");
    }];
}

-(void)setStudantDetaile:(NSDictionary *)studant {
    
    NSArray *ChildDataArray = [[studant valueForKey:key_allchilds] valueForKey:key_childs];
    
    NSMutableArray *arrStudtemp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *stud in ChildDataArray) {
        
        if ([stud valueForKey:@"sfo_type"] == [NSNull null])
            [stud setValue:@"0" forKey:@"sfo_type"];
        
        [arrStudtemp addObject:stud];
    }
 //   NSMutableArray *arrStud = [[NSMutableArray alloc] initWithArray:arrStudtemp];
    
    [GeneralUtil setUserChildPreference:key_saveChild value:arrStudtemp];
    
    [GeneralUtil setUserPreference:key_parentIdSave value:[studant valueForKey:key_parentid]];
    [GeneralUtil setUserPreference:key_ParentEmail value:[studant valueForKey:key_parentemail]];
    [GeneralUtil setUserPreference:key_saveParentName value:[studant valueForKey:key_parentname]];
    [GeneralUtil setUserPreference:key_myParentNo value:[studant valueForKey:@"parent_no"]];
    [GeneralUtil setUserPreference:key_myParentPhone value:[studant valueForKey:@"phone"]];
    [GeneralUtil setUserPreference:key_myParentNo2 value:[studant valueForKey:@"parent_no2"]];
    [GeneralUtil setUserPreference:key_myParentPhone2 value:[studant valueForKey:@"parent_mobile2"]];
    [GeneralUtil setUserPreference:key_myParentName2 value:[studant valueForKey:@"parent_name2"]];
    [GeneralUtil setUserPreference:key_myParentNo3 value:[studant valueForKey:@"parent_no3"]];
    
    if ([studant valueForKey:@"parent_mobile3"] == [NSNull null]) {
        [GeneralUtil setUserPreference:key_myParentPhone3 value:@""];
    }
    else
        [GeneralUtil setUserPreference:key_myParentPhone3 value:[studant valueForKey:@"parent_mobile3"]];
    
    if ([studant valueForKey:@"parent_name3"] == [NSNull null]) {
        [GeneralUtil setUserPreference:key_myParentName3 value:@""];
    }
    else
        [GeneralUtil setUserPreference:key_myParentName3 value:[studant valueForKey:@"parent_name3"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[studant valueForKey:key_ParentStatus] forKey:key_ParentStatus];
    
    [GeneralUtil setUserPreference:@"RealPinCode" value:txtPinCode.text];
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
    txtPinCode.text = @"1111";
    userObj = [[User alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    
    [BaseViewController setBackGroud:self];
    
    [BaseViewController formateButtonCyne:btnLogin title:@"Login"];
    [BaseViewController setCynaColorDefultFontBtn:btnForgotPin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)btnLoginPress:(id)sender {
    
    userObj.mobile = [GeneralUtil getUserPreference:key_myParentPhone];
    userObj.persentNo = [GeneralUtil getUserPreference:key_myParentNo];
    
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
                    
                    [self setStudantDetaile:dicRes];
                    
                    if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
                        [appDelegate setHomeAsRootView];
                    }
                    else {
                        StudantListViewController * pvc = [[StudantListViewController alloc] initWithNibName:@"StudantListViewController" bundle:nil];
                        [self.navigationController pushViewController:pvc animated:YES];
                    }
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

- (IBAction)btnForgotPin:(id)sender {
    
    [userObj forgotPin:[[NSUserDefaults standardUserDefaults] objectForKey:key_myParentPhone] :^(NSObject *resObj){
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            [GeneralUtil alertInfo:@"Pincode had been sent to your SMS."];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)setStudantDetaile:(NSDictionary *)studant {
    
    NSArray * ChildDataArray = [[studant valueForKey:key_allchilds] valueForKey:key_childs];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([ChildDataArray isEqual:[NSNull null]] || ChildDataArray == nil || ChildDataArray.count == 0) {
//        NSMutableArray * ary = [[NSMutableArray alloc] init];
//        [defaults setObject:ary forKey:key_saveChild];
//        
//    }
//    else {
//        
//        NSMutableArray *arrayChild = [ChildDataArray mutableCopy]; // set value
//        NSLog(@"%@", arrayChild);
//        
//        [defaults setObject:arrayChild forKey:key_saveChild];
//    }
    
    [GeneralUtil setUserChildPreference:key_saveChild value:ChildDataArray];
    
    [GeneralUtil setUserPreference:key_parentIdSave value:[studant valueForKey:key_parentid]];
    [GeneralUtil setUserPreference:key_saveParentEmail value:[studant valueForKey:key_parentemail]];
    [GeneralUtil setUserPreference:key_saveParentName value:[studant valueForKey:key_parentname]];

    [[NSUserDefaults standardUserDefaults] setObject:[studant valueForKey:key_ParentStatus] forKey:key_ParentStatus];
    
    [GeneralUtil setUserPreference:@"RealPinCode" value:txtPinCode.text];
    
    //        [self register_device:[[NSUserDefaults standardUserDefaults] objectForKey:key_parentIdSave]];
    
//    NSString * strPin = [[NSUserDefaults standardUserDefaults]  objectForKey:@"ParepareforPincode"];
//    [[NSUserDefaults standardUserDefaults] setObject:strPin forKey:@""];
}

@end
*/
