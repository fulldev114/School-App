//
//  AbsentInfoViewController.m
//  CSAdmin
//
//  Created by etech-dev on 7/20/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "AbsentInfoViewController.h"
#import "TeacherConstant.h"

@interface AbsentInfoViewController ()

@end

@implementation AbsentInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(id)obj {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPAD) {
        
        if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
            heightOfPopup.constant = 480;
        }
        else {
            heightOfPopup.constant = 410;
        }
    }
    else if (IS_IPHONE_5) {
        
        if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
            heightOfPopup.constant = 460;
        }
        else {
            heightOfPopup.constant = 380;
        }
    }
    else {
        
        if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
            heightOfPopup.constant = 400;
        }
        else {
            heightOfPopup.constant = 360;
        }
    }
    [self setUpUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setUpUi {
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    popupView.layer.cornerRadius = 5;
    
    presentView.layer.cornerRadius = presentView.frame.size.width /2;
    teacheNoticeView.layer.cornerRadius = teacheNoticeView.frame.size.width / 2;
    parentNoticeView.layer.cornerRadius = parentNoticeView.frame.size.width / 2;
    
    presentView.backgroundColor = TEXT_COLOR_GREEN;
    parentNoticeView.backgroundColor = TEXT_COLOR_LIGHT_YELLOW;
    teacheNoticeView.backgroundColor = [UIColor redColor];
    
    lblScreenInfo.font = FONT_16_REGULER;
    lblPresent.font = FONT_16_REGULER;
    lblParentNotice.font = FONT_16_REGULER;
    lblTeacherNotice.font = FONT_16_REGULER;
    lblslectionInfo.font = FONT_16_REGULER;
    lblNameAndPeriodInfo.font = FONT_16_REGULER;
    
    lblScreenInfo.textColor = APP_BACKGROUD_COLOR;
    lblPresent.textColor = APP_BACKGROUD_COLOR;
    lblParentNotice.textColor = APP_BACKGROUD_COLOR;
    lblTeacherNotice.textColor = APP_BACKGROUD_COLOR;
    lblslectionInfo.textColor = APP_BACKGROUD_COLOR;
    lblNameAndPeriodInfo.textColor = APP_BACKGROUD_COLOR;
    
    lblScreenInfo.text = [GeneralUtil getLocalizedText:@"LBL_SCREEN_INFO_TITLE"];
    lblPresent.text = [GeneralUtil getLocalizedText:@"LBL_INFO_PRESENT_TITLE"];
    lblParentNotice.text = [GeneralUtil getLocalizedText:@"LBL_PERENT_NOTICE_TITLE"];
    lblTeacherNotice.text = [GeneralUtil getLocalizedText:@"LBL_TEACHER_NOTICE_TITLE"];
    lblslectionInfo.text = [GeneralUtil getLocalizedText:@"LBL_SELECTION_INFO_TITLE"];
    lblNameAndPeriodInfo.text = [GeneralUtil getLocalizedText:@"LBL_NUMBER_AND_NAME_TITLE"];
}

- (IBAction)btnClosePress:(id)sender {
    [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
@end
