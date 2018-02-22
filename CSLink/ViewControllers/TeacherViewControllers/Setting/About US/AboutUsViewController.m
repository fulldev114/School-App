//
//  AboutUsViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/24/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "AboutUsViewController.h"
#import "BaseViewController.h"

#import <MessageUI/MessageUI.h>

@interface AboutUsViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_ABOUT_US"] WithSel:@selector(backButtonClick)];
    
    lblAboutUs.font = FONT_17_BOLD;
    lblAboutUs.textColor = TEXT_COLOR_WHITE;
    lblAboutUs.text = [GeneralUtil getLocalizedText:@"LBL_ABOUT_US_TITLE"];
    
    lblTitilrInfo.font = FONT_18_BOLD;
    lblTitilrInfo.textColor = TEXT_COLOR_CYNA;
    lblTitilrInfo.text = [GeneralUtil getLocalizedText:@"LBL_LINK_INFO_TITLE"];
    
    lblSupport.font = FONT_17_BOLD;
    lblSupport.textColor = TEXT_COLOR_WHITE;
    lblSupport.text = SUPPORT_URL;
    
    lbllink.font = FONT_17_BOLD;
    lbllink.textColor = TEXT_COLOR_WHITE;
    lbllink.text = LINK_URL;
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTappedSupport)];
    tapGestureRecognizer1.numberOfTapsRequired = 1;
    [lblSupport addGestureRecognizer:tapGestureRecognizer1];
    lblSupport.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTappedlink)];
    tapGestureRecognizer2.numberOfTapsRequired = 1;
    [lbllink addGestureRecognizer:tapGestureRecognizer2];
    lbllink.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)labelTappedSupport {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * emailController = [[MFMailComposeViewController alloc] init];
        emailController.mailComposeDelegate = self;
        
        //  [emailController setSubject:subject];
        //  [emailController setMessageBody:mailBody isHTML:YES];
        //  [emailController setToRecipients:recipients];
        
        [self presentViewController:emailController animated:YES completion:nil];
    }
    
  //  NSString * url = [NSString stringWithFormat:@"http://%@",SUPPORT_URL];
  //  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    
}

-(void)labelTappedlink {
    
    NSString * url = [NSString stringWithFormat:@"http://%@",LINK_URL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
