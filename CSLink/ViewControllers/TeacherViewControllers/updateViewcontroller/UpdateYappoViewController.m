//
//  UpdateYappoViewController.m
//  Yappo
//
//  Created by Susheel on 28/07/14.
//  Copyright (c) 2014 kETAN. All rights reserved.
//

#import "UpdateYappoViewController.h"
#import "TeacherConstant.h"
#import "GeneralUtil.h"

@interface UpdateYappoViewController ()

@end

@implementation UpdateYappoViewController
@synthesize dictUpdateApp;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self setLocalizedText];
    
    [BaseViewController setBackGroud:self];
    
    if([[dictUpdateApp  valueForKey:@"forceUpdateApp"]isEqualToString:@"No"]) {
        //FORCEFULLY UPDATE = NO
      //  btnUpgrade.frame = CGRectMake(10, 426, 145, 44);
     //   btnSkip.frame = CGRectMake(165, 426, 145, 44);
    }
    else {
        //FORECEFULLY UPDATE = YES
      //  btnUpgrade.frame = CGRectMake(10, 426, 300, 44);
        [btnSkip setHidden:YES];
        bottomspace.constant = 10;
    }
}

-(void)setLocalizedText {
    
//    [btnUpgrade.titleLabel setTextColor:[AppUtility setNavTitleColor]];
//    [btnUpgrade.titleLabel setFont:[AppUtility setTableHelveticaMedium:17]];
//    btnUpgrade = [AppUtility adjustBtnFontSize:btnUpgrade];
//    [btnUpgrade setTitle:[AppUtility getLocalizedText:@"BTN_LBL_UPGRADE"] forState:UIControlStateNormal];
//    
//    [btnSkip.titleLabel setTextColor:[AppUtility setNavTitleColor]];
//    [btnSkip.titleLabel setFont:[AppUtility setTableHelveticaMedium:17]];
//    btnSkip = [AppUtility adjustBtnFontSize:btnSkip];
//    [btnSkip setTitle:[AppUtility getLocalizedText:@"BTN_LBL_SKIP"] forState:UIControlStateNormal];
//    
//    //LOC
//    [lblMsg setTextColor:[AppUtility setTableTitleColor]];
//    [lblMsg setFont:[AppUtility setTableHelveticaMedium:17]];
//    [lblMsg setText:[[dictUpdateApp valueForKey:@"upgrade"] valueForKey:@"MessageType"]];
//    [lblMsg setNumberOfLines:7];
    
//    [btnUpgrade.titleLabel setTextColor:TEXT_COLOR_CYNA];
//    [btnUpgrade.titleLabel setFont:FONT_17_BOLD];
//   // btnUpgrade = [AppUtility adjustBtnFontSize:btnUpgrade];
//    [btnUpgrade setTitle:[dictUpdateApp  valueForKey:@"updatebuttontitle"] forState:UIControlStateNormal];
    
    [BaseViewController formateButtonCyne:btnUpgrade title:[dictUpdateApp  valueForKey:@"updatebuttontitle"]];
    [BaseViewController formateButtonCyne:btnSkip title:[dictUpdateApp  valueForKey:@"skipbuttontitle"]];
    
    //[btnSkip.titleLabel setTextColor:TEXT_COLOR_CYNA];
   // [btnSkip.titleLabel setFont:FONT_17_BOLD];
    // btnUpgrade = [AppUtility adjustBtnFontSize:btnUpgrade];
    //[btnSkip setTitle:[dictUpdateApp  valueForKey:@"skipbuttontitle"] forState:UIControlStateNormal];
    
    //LOC
    [lblMsg setTextColor:TEXT_COLOR_WHITE];
    [lblMsg setFont:FONT_17_REGULER];
    [lblMsg setText:[dictUpdateApp  valueForKey:@"MessageType"]];
    [lblMsg setNumberOfLines:7];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(IBAction)btnSkipPress:(id)sender {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnPressUpgrade:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dictUpdateApp valueForKey:@"URL"]]];
}

@end
