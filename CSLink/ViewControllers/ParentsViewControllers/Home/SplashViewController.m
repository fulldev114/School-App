//
//  SplashViewController.m
//  Construction
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "SplashViewController.h"
#import "ParentLoginViewController.h"
#import "ParentPincodeViewController.h"
#import "TeacherPincodeViewController.h"
#import "ParentConstant.h"
#import "BaseViewController.h"
#import "ParentMyProfileViewController.h"
#import "MainScreenViewController.h"

@interface SplashViewController ()
{
        NSUserDefaults *appUserDefult;
}
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    NSLog(@"key_islogin = %@", [GeneralUtil getUserPreference:key_islogin]);
    if ([[GeneralUtil getUserPreference:key_islogin] isEqualToString:@"YES"]) {
        ParentPincodeViewController *pvc = [[ParentPincodeViewController alloc] initWithNibName:@"ParentPincodeViewController" bundle:nil];
        [self.navigationController pushViewController:pvc animated:YES];
    }
    else if([[GeneralUtil getUserPreference:key_islogin] isEqualToString:@"Yes"])
    {
        TeacherPincodeViewController *pvc = [[TeacherPincodeViewController alloc] initWithNibName:@"TeacherPincodeViewController" bundle:nil];
        [self.navigationController pushViewController:pvc animated:YES];
    }
    else {
//        LoginViewController * pvc = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:pvc animated:YES];
        MainScreenViewController * pvc = [[MainScreenViewController alloc] init];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}
@end
