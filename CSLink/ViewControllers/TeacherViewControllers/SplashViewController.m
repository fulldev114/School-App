//
//  SplashViewController.m
//  Construction
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "SplashViewController.h"
#import "LoginViewController.h"
#import "PincodeViewController.h"
#import "TeacherConstant.h"
#import "BaseViewController.h"

@interface SplashViewController ()
{
        NSUserDefaults *appUserDefult;
}
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setNeedsStatusBarAppearanceUpdate];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 0.0
                                                  target: self
                                                selector:@selector(onTick:)
                                                userInfo: nil repeats:NO];
    appUserDefult = [NSUserDefaults standardUserDefaults];
    
    [BaseViewController setBackGroud:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)onTick:(NSTimer *)timer {
    
    ZDebug(@"%@", [GeneralUtil getUserPreference:@"AppleLanguages"]);
    
    NSBundle *languageBundle = nil;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"fr" ofType:@"lproj"];
    
    languageBundle = [NSBundle bundleWithPath:path];
    
    ZDebug(@"language path : %@", languageBundle);
    
    if ([[GeneralUtil getUserPreference:key_islogin] isEqualToString:@"Yes"]) {
        
        PincodeViewController * pvc = [[PincodeViewController alloc] initWithNibName:@"PincodeViewController" bundle:nil];
        [self.navigationController pushViewController:pvc animated:YES];
    }
    else {
        LoginViewController * pvc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end
