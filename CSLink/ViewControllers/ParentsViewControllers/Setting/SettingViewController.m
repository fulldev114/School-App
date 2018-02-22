//
//  SettingViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "SettingViewController.h"
#import "BaseViewController.h"
#import "ChangePinViewController.h"
#import "AboutUsViewController.h"
#import "LocalizeLanguage.h"
#import "IQKeyboardManager.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

-(void)localisView{
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_SETTING"] WithSel:@selector(menuClick)];
    [BaseViewController formateButtonCyne:btnAboutAs title:[GeneralUtil getLocalizedText:@"BTN_ABOUT_AS_TITLE"] withIcon:@"about-us" withBgColor:TEXT_COLOR_CYNA];
    [BaseViewController formateButtonCyne:btnChangePin title:[GeneralUtil getLocalizedText:@"BTN_CHANGE_PIN_TITLE"] withIcon:@"change-pincode" withBgColor:[UIColor clearColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    btnChangePin.layer.borderWidth = 1;
    btnChangePin.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangEglish]) {
        [BaseViewController formateButtonCyne:btnEnglish title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
        [BaseViewController formateButton:btnNorw withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    }else{
        [BaseViewController formateButtonCyne:btnNorw title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
        
        [BaseViewController formateButton:btnEnglish withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
    }
    
    [self localisView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)menuClick {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftView];
}

- (IBAction)btnEnglishPress:(id)sender {
    
    [LocalizeLanguage setLocalizeLanguage:value_LangEglish];
    [GeneralUtil setUserPreference:key_selLang value:value_LangEglish];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LANGUAGE_CHANGE object:nil];
    
    [self localisView];
    
    [BaseViewController formateButtonCyne:btnEnglish title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
    [BaseViewController formateButton:btnNorw withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:[GeneralUtil getLocalizedText:@"BTN_TTL_PICKER_DONE"]];
}

- (IBAction)btnNorwPress:(id)sender {
    [LocalizeLanguage setLocalizeLanguage:value_LangNorwegian];
    [GeneralUtil setUserPreference:key_selLang value:value_LangNorwegian];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LANGUAGE_CHANGE object:nil];
    
    [self localisView];
    
    [BaseViewController formateButtonCyne:btnNorw title:[GeneralUtil getLocalizedText:@"BTN_NORWEGIAN_TITLE"]];
    
    [BaseViewController formateButton:btnEnglish withColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_ENGLISH_TITLE"]];
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:[GeneralUtil getLocalizedText:@"BTN_TTL_PICKER_DONE"]];
}

- (IBAction)btnAboutAsPress:(id)sender {
    AboutUsViewController * vc = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnChangePinPress:(id)sender {
    
    ChangePinViewController * vc = [[ChangePinViewController alloc] initWithNibName:@"ChangePinViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
