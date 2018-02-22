//
//  HomeViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentSFOHomeViewController.h"
#import "BaseViewController.h"
#import "BundleEx.h"
#import "ParentGroupMessageViewController.h"
#import "SendAbsentViewController.h"
#import "StudantListViewController.h"
#import "TeacherMessageViewController.h"
#import "ParentChatListViewController.h"
#import "EmergancyMsgViewController.h"
#import "TeacherConstant.h"
#import "ParentSFOHomePageViewController.h"

@interface ParentSFOHomeViewController ()
{
    ParentUser *userObj;

}
@end

@implementation ParentSFOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userObj = [[ParentUser alloc] init];

    appDelegate.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    appDelegate.deckController.panningMode = IIViewDeckNoPanning;
    [self setNavigation];
    [self setUpUi];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setBadge];
}

-(void)setBadge {
    
    int badgeCnt = [appDelegate.xmppHelper getBadgeForUser];
    
    badgeCnt +=[[GeneralUtil getUserPreference:key_chat_badge] intValue];
    
    [btnMassage setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
    badgeCnt = [appDelegate.xmppHelper getBadgeForTeacher];
    
    badgeCnt +=[[GeneralUtil getUserPreference:key_teacher_badge] intValue];
    
    [btnInternalBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
//    int badgeCnt = [[GeneralUtil getUserPreference:key_chat_badge] intValue];
//    
//    [btnMassage setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
//    
//    badgeCnt = [[GeneralUtil getUserPreference:key_teacher_badge] intValue];
//    
//    [btnInternalBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
    badgeCnt = [[GeneralUtil getUserPreference:key_studant_req_badge] intValue];
    
    [btnStudentBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
    [btnSFOBadge setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
    badgeCnt = [[GeneralUtil getUserPreference:key_register_badge] intValue];
    
    [btnAbsentNotice setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
}

-(void)setNavigation {
    
    [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_HOME"] WithSel:@selector(menuClick)];
    [BaseViewController setBackGroud:self];
    
    self.navigationItem.rightBarButtonItem = [BaseViewController getRightButtonWithSel:@selector(btnEmergancyMsg) addTarget:self icon:@"alert"];
    
    massageView.layer.borderWidth = 2.0f;
    massageView.layer.borderColor = TEXT_COLOR_CYNA.CGColor;
    
    groupMassageView.layer.borderWidth = 2.0f;
    groupMassageView.layer.borderColor = TEXT_COLOR_LIGHT_GREEN.CGColor;
    
    absentNoticeView.layer.borderWidth = 2.0f;
    absentNoticeView.layer.borderColor = TEXT_COLOR_LIGHT_YELLOW.CGColor;
    
    [BaseViewController formateButtonCyne:btnMassage title:[GeneralUtil getLocalizedText:@"BTN_MESSAGE_TITLE"] withIcon:@"message" titleColor:TEXT_COLOR_CYNA];
    [BaseViewController formateButtonCyne:btnGroupMassage title:[GeneralUtil getLocalizedText:@"BTN_GROUP_MESSAGE_TITLE"] withIcon:@"group-message" titleColor:TEXT_COLOR_LIGHT_GREEN];
    [BaseViewController formateButtonCyne:btnAbsentNotice title:[GeneralUtil getLocalizedText:@"BTN_SEND_ABSENT_TITLE"] withIcon:@"send-absent" titleColor:TEXT_COLOR_LIGHT_YELLOW];
}

-(void)setUpUi
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    if (IS_IPAD) {
        btnInteralMsg.layer.cornerRadius    = 50.5;
        btnStudant.layer.cornerRadius       = 50.5;
        btnSFO.layer.cornerRadius           = 50.5;
    }
    else if (IS_IPHONE_5) {
        btnInteralMsg.layer.cornerRadius    = 27.5;
        btnStudant.layer.cornerRadius       = 27.5;
        btnSFO.layer.cornerRadius           = 27.5;
    }
    else{
        btnInteralMsg.layer.cornerRadius    = 36;
        btnStudant.layer.cornerRadius       = 36;
        btnSFO.layer.cornerRadius           = 36;
    }

    [btnInteralMsg setImage:[UIImage imageNamed:@"internal-message"] forState:UIControlStateNormal];
    [btnStudant setImage:[UIImage imageNamed:@"students"] forState:UIControlStateNormal];
    [btnSFO setImage:[UIImage imageNamed:@"sfo"] forState:UIControlStateNormal];

    [btnInternalBadge setBadgeBackgroundColor:[UIColor redColor]];
    [btnSFOBadge setBadgeBackgroundColor:[UIColor redColor]];
    [btnStudentBadge setBadgeBackgroundColor:[UIColor redColor]];
    [btnMassage setBadgeBackgroundColor:[UIColor redColor]];
    [btnAbsentNotice setBadgeBackgroundColor:[UIColor redColor]];
    
    if (IS_IPAD) {
        [btnStudentBadge setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
        [btnInternalBadge setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
        [btnSFOBadge setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
        [btnMassage setBadgeEdgeInsets:UIEdgeInsetsMake(5, 0, 0, -80)];
        [btnAbsentNotice setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
    }
    else {
        [btnStudentBadge setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
        [btnInternalBadge setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
        [btnSFOBadge setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
        [btnMassage setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
        [btnAbsentNotice setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
    }
    
    btnInteralMsg.contentMode = UIViewContentModeCenter;
    btnStudant.contentMode = UIViewContentModeCenter;
    btnSFO.contentMode = UIViewContentModeCenter;
    
    btnInteralMsg.layer.borderWidth = 2.0f;
    btnInteralMsg.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnStudant.layer.borderWidth = 2.0f;
    btnStudant.layer.borderColor = [UIColor whiteColor].CGColor;

    btnSFO.layer.borderWidth = 2.0f;
    btnSFO.layer.borderColor = [UIColor whiteColor].CGColor;

    lblInternal.textColor = [UIColor whiteColor];
    lblStudant.textColor = [UIColor whiteColor];
    lblSFO.textColor = [UIColor whiteColor];
    
    lblInternal.font = FONT_16_SEMIBOLD;
    lblStudant.font = FONT_16_SEMIBOLD;
    lblSFO.font = FONT_16_SEMIBOLD;
    
    lblInternal.text    = [GeneralUtil getLocalizedText:@"LBL_INTERNALMSG_TITLE"];
    lblStudant.text     = [GeneralUtil getLocalizedText:@"LBL_STUDANT_TITLE"];
    lblSFO.text         = [GeneralUtil getLocalizedText:@"LBL_SFO_TITLE"];
}

-(void)menuClick {
    [self.viewDeckController toggleLeftView];
}

-(void)btnEmergancyMsg {
    
    EmergancyMsgViewController *evc = [[EmergancyMsgViewController alloc] initWithNibName:@"EmergancyMsgViewController" bundle:nil];
    [self.navigationController pushViewController:evc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnMessagePress:(id)sender {
    
	ParentChatListViewController * pvc = [[ParentChatListViewController alloc] initWithNibName:@"ParentChatListViewController" bundle:nil];
	[self.navigationController pushViewController:pvc animated:YES];
	
	[GeneralUtil clearBadge:[appDelegate getCurrentChildId] badgeType:key_chat_badge];
	
   // [NSBundle setLanguage:@"fr"];
    
    //CustomIOS7AlertView *alertView = [BaseViewController customAlertDisplay:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, "];
    //[alertView show];
    
  //  [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_REQUEST_REJECT_SUCCESS"] Delegate:self];
    
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ZDebug(@"clickedButtonAtIndex: %d", buttonIndex);
}

- (IBAction)btnGroupMessagePress:(id)sender {
    
	ParentGroupMessageViewController * pvc = [[ParentGroupMessageViewController alloc] initWithNibName:@"ParentGroupMessageViewController" bundle:nil];
	[self.navigationController pushViewController:pvc animated:YES];
	
	[GeneralUtil clearBadge:[appDelegate getCurrentChildId] badgeType:key_abi_badge];
}

- (IBAction)btnAbsentNoticePress:(id)sender {
    
    SendAbsentViewController * vc = [[SendAbsentViewController alloc] initWithNibName:@"SendAbsentViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    [GeneralUtil setUserPreference:key_register_badge value:@"0"];
}

- (IBAction)btnStudentPress:(id)sender {
    StudantListViewController * vc = [[StudantListViewController alloc] initWithNibName:@"StudantListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)teacherMsgPress:(id)sender {
    TeacherMessageViewController * vc = [[TeacherMessageViewController alloc] initWithNibName:@"TeacherMessageViewController" bundle:nil];
    vc.bTeacherMode = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
    [GeneralUtil setUserPreference:key_teacher_badge value:@"0"];
    
    [appDelegate.xmppHelper clearBadgeForTeacher];
}

- (IBAction)sfoPress:(id)sender {
    [userObj getStudentsListByParent:[GeneralUtil getUserPreference:key_parentIdSave] :^(NSObject *resObj) {
//    [userObj getStudentsList:@"1095" :^(NSObject *resObj) {
    
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            if ([dicRes objectForKey:@"flag"] == [NSNull null])
                return;
            
            if ([[dicRes objectForKey:@"flag"] intValue] != 1)
                return;
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[dicRes objectForKey:@"students"]];
            if (array.count == 0)
                return;
            
            ParentSFOHomePageViewController *vc = [[ParentSFOHomePageViewController alloc] initWithNibName:@"ParentSFOHomePageViewController" bundle:nil];
            vc.studentsData = [NSMutableArray arrayWithArray:[dicRes objectForKey:@"students"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}
@end
