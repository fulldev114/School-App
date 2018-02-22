//
//  PerentRegisterViewController.m
//  CSLink
//
//  Created by etech-dev on 5/31/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "PerentRegisterViewController.h"
#import "BaseViewController.h"
#import "Page1.h"
#import "Page2.h"
#import "ParentUser.h"
#import "ParentLoginViewController.h"

@interface PerentRegisterViewController ()
{
    WalkThroughViewController *walkthrough;
    Page1 *page_one;
    Page2 *page_two;
    ParentUser *userObj;
}
@end

@implementation PerentRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    //[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_REGISTER"] WithSel:@selector(backButtonClick)];
    [self showWalkthrough:nil];
    
    userObj = [[ParentUser alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showWalkthrough:(id)sender {
    
    walkthrough = [[WalkThroughViewController alloc]init];
    
    page_one = [[Page1 alloc] initWithNibName:@"Page1" bundle:nil];
    page_one.delegate = self;
    page_two = [[Page2 alloc] initWithNibName:@"Page2" bundle:nil];
    page_two.delegate = self;
    
    // Attach the pages to the master
    walkthrough.delegate = self;
    
    [walkthrough addViewController:page_one];
    [walkthrough addViewController:page_two];
    
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:walkthrough];
    
    
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"]
                                                        forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.shadowImage = [UIImage new];
    nav.navigationBar.translucent = YES;
    
    [self presentViewController:nav animated:NO completion:nil];
}

#pragma - DELEGATE
- (void)walkthroughCloseButtonPressed
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)walkthroughNextButtonPressed
{
    NSLog(@"Next");
}

- (void)walkthroughPrevButtonPressed
{
    NSLog(@"Prev");
}

- (void)walkthroughPageDidChange:(NSInteger)pageNumber
{
    NSLog(@"%ld",(long)pageNumber);
}

- (void)btnNextButtonPressed{
    [walkthrough nextPage:nil];
}

- (void)btnRegisterButtonPressed {
    
    userObj.persen1Name = page_one.txtNameP1.text;
    userObj.persen1Email = page_one.txtEmailP1.text;
    userObj.persen1Phone = page_one.txtPhoneP1.text;
    userObj.persentPin = page_one.txtPinCode.text;
    userObj.persen2Name = page_two.txtNameP2.text;
    userObj.persen2Email = page_two.txtEmailP2.text;
    userObj.persen2Phone = page_two.txtPhoneP2.text;
    
    if ([page_one.txtNameP1.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_FULLNAME"]];
    }
    else if([page_one.txtPhoneP1.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_PHONE"]];
    }
    else if(![GeneralUtil checkValidMobile:page_one.txtPhoneP1.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INVALID_PHONE"]];
    }
    else if([page_one.txtPinCode.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_PIN_CODE"]];
    }
    else if([page_one.txtConformPin.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CONFIRM_PIN_CODE"]];
    }
    else if(![page_one.txtConformPin.text isEqualToString:page_one.txtPinCode.text]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CONFIRM_PIN_CODE_MISSMATCH"]];
    }
    else if([page_two.txtNameP2.text isEqualToString:@""]){
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_USER_REGISTER"] Delegate:self];
    }
    else {
        [self registerParent];
    }
}

-(void)registerParent {
    
    [userObj registerPerent:^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:key_flag]isEqualToNumber:[NSNumber numberWithInt:1]])
                
            {
                
                //Record has been successfullly inserted .
                //        Takk for registrering, login med mobilnummeret ditt.
                //        Takk for registrering, medlemskapet ditt aktiveres i løpet av 24 timer.":@"Thanks for registration, the CSlink team will activate your membership within 24 hours.
                //                if ([txtSecondParentname.text isEqualToString:@""] || [txtSecondParentmobile.text isEqualToString:@""]) {
                //                    UIAlertView * al = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Great", @"Great") message:AMLocalizedString(@"You can register the second parent info later by selecting there profile in the app, please use registered number to login and add a student.", @"You can register the second parent info later by selecting there profile in the app, please use registered number to login and add a student.") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //                    al.tag = 3000;
                //                    [al show];
                //                    return;
                //                }
                //                else {
                //                    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"Great" message:@"Welcome! As a new member, please login with your registered mobile number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //                    al.tag = 1000;
                //                    [al show];
                //                }
                
                CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SUCCESSFULL_REGISTER"] withDelegate:self];
                
                alertView.tag = 2;
                
                
            }
            
            else if ([[dicRes valueForKey:key_flag]isEqualToNumber:[NSNumber numberWithInt:0]])
                
            {
                if ([[dicRes valueForKey:@"errcode"] isEqualToString:@"3"]) {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_UNSUCCESSFULL_REGISTER"]];
                }
                else
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_MOBILE_ALLREADY_REGISTER"]];
            }
        }
    }];
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (customAlertView.tag == 2) {
        ParentLoginViewController * pvc = [[ParentLoginViewController alloc] init];
        
        
        appDelegate.navigationController = [[UINavigationController alloc]initWithRootViewController:pvc];
        appDelegate.navigationController.navigationBarHidden = YES;
        appDelegate.window.rootViewController = appDelegate.navigationController;
    }
    else {
    if (buttonIndex == 1) {
        
    }
    else {
        [self registerParent];
    }
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self dismissViewControllerAnimated:NO completion:^{
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//}
@end
