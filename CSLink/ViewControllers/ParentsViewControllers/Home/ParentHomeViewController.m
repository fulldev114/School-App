//
//  HomeViewController.m
//  Onjyb
//
//  Created by etech-dev on 5/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentHomeViewController.h"
#import "BaseViewController.h"
#import "ParentGroupMessageViewController.h"
#import "SendAbsentViewController.h"
#import "ParentChatListViewController.h"
#import "ParentChatViewController.h"
#import "ParentEmergancyMsgViewController.h"
#import "ParentSFOHomePageViewController.h"

@interface ParentHomeViewController ()
{
    ParentUser *userObj;
    NSMutableArray *arrStudant;
    int x,y,vy,Lpading,Rpading,bwidth,bheight,vwidth,vheight,count,totalStudent,lblHeight,viewWidth;
}
@end

@implementation ParentHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	btnSFO.layer.cornerRadius = 5.0f;
	
	//[btnSFO setBadgeBackgroundColor:[UIColor redColor]];
    userObj = [[ParentUser alloc] init];
    appDelegate.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    appDelegate.deckController.panningMode = IIViewDeckNoPanning;
    
    if (IS_IPAD) {
        [btnGroupMassage setBadgeEdgeInsets:UIEdgeInsetsMake(20, 0, 0, -80)];
        [btnMassage setBadgeEdgeInsets:UIEdgeInsetsMake(20, 0, 0, -80)];
    }
    else {
        [btnGroupMassage setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
        [btnMassage setBadgeEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
    }
    [self setNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setbadge];
}

-(void)setbadge {
    
    [self setStudantListView];
    
    [btnGroupMassage setBadgeBackgroundColor:[UIColor redColor]];
    [btnMassage setBadgeBackgroundColor:[UIColor redColor]];
    
    int badgeCnt = [appDelegate.xmppHelper getBadgeForUser:[appDelegate getCurrentChildId]];
    
    badgeCnt += [GeneralUtil getBadge:[appDelegate getCurrentChildId] badgeType:key_chat_badge];
    
    [btnMassage setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
    badgeCnt = [GeneralUtil getBadge:[appDelegate getCurrentChildId] badgeType:key_abi_badge];
    
    [btnGroupMassage setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
    
//    badgeCnt = [GeneralUtil getBadge:[appDelegate getCurrentChildId] badgeType:key_abn_badge];
//    
//    [btnAbsentNotice setBadgeString:[NSString stringWithFormat:@"%d", badgeCnt]];
}

-(void)setNavigation {
    
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
    
    [BaseViewController setNavigationMenu:self title:[GeneralUtil getLocalizedText:@"TITLE_HOME"] WithSel:@selector(menuClick)];
    [BaseViewController setBackGroud:self];
    
    massageView.layer.borderWidth = 2.0f;
    massageView.layer.borderColor = TEXT_COLOR_CYNA.CGColor;
    
    groupMassageView.layer.borderWidth = 2.0f;
    groupMassageView.layer.borderColor = TEXT_COLOR_LIGHT_GREEN.CGColor;
    
    absentNoticeView.layer.borderWidth = 2.0f;
    absentNoticeView.layer.borderColor = TEXT_COLOR_LIGHT_YELLOW.CGColor;
    
    [BaseViewController formateButtonCyne:btnMassage title:[GeneralUtil getLocalizedText:@"BTN_MESSAGE_TITLE"] withIcon:@"message" titleColor:TEXT_COLOR_CYNA];
    
    [BaseViewController formateButtonCyne:btnGroupMassage title:[GeneralUtil getLocalizedText:@"BTN_GROUP_MESSAGE_TITLE"] withIcon:@"group-message" titleColor:TEXT_COLOR_LIGHT_GREEN];
    // btnGroupMassage.titleLabel.font = FONT_16_BOLD;
    [BaseViewController formateButtonCyne:btnAbsentNotice title:[GeneralUtil getLocalizedText:@"BTN_SEND_ABSENT_TITLE"] withIcon:@"send-absent" titleColor:TEXT_COLOR_LIGHT_YELLOW];
    
    self.navigationItem.rightBarButtonItem = [BaseViewController getRightButtonWithSel:@selector(btnEmergancyMsg) addTarget:self icon:@"alert"];

     NSDictionary *def = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
    
    listScrollView.delegate = self;
}

-(void)menuClick {
    [self.viewDeckController toggleLeftView];
}

-(void)btnEmergancyMsg {
    
    ParentEmergancyMsgViewController *evc = [[ParentEmergancyMsgViewController alloc] initWithNibName:@"ParentEmergancyMsgViewController" bundle:nil];
    [self.navigationController pushViewController:evc animated:YES];
}


-(void)setStudantListView {
    
    [[listScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (IS_IPHONE_5) {
        heightOfScrollView.constant = 75;
    }
    else {
        heightOfScrollView.constant = 85;
    }
    
    arrStudant = [[NSMutableArray alloc] init];
    
    arrStudant = (NSMutableArray *)[GeneralUtil getUserPreference:key_saveChild];
    
    totalStudent = [arrStudant count];
    
    x = 0;
    y = 0;
    vy = 10;
    count = 0;
    
    if (IS_IPAD) {
        bwidth = 90;
        bheight = 90;
        Lpading = 30;
        Rpading = 30;
        vwidth = 1;
        vheight = 80;
        lblHeight = 50;
    }
    else if (IS_IPHONE_5) {
        bwidth = 47;
        bheight = 47;
        Lpading = 17;
        Rpading = 17;
        vwidth = 1;
        vheight = 40;
        lblHeight = 30;
    }
    else {
        bwidth = 52;
        bheight = 51;
        Lpading = 25;
        Rpading = 25;
        vwidth = 1;
        vheight = 40;
        lblHeight = 30;
    }
    
    int sfo_count = 0;
    
    for (int i = 0; i < totalStudent; i++) {
        
        if (i == 0) {
            Lpading = 0;
        }
        else {
            
            if (IS_IPAD) {
                Lpading = 30;
            }
            else if (IS_IPHONE_5) {
                Lpading = 17;
            }
            else {
                Lpading = 25;
            }
        }
        
        if (i != totalStudent - 1) {
            if (IS_IPAD) {
                Rpading = 30;
            }
            else if (IS_IPHONE_5) {
                Rpading = 17;
            }
            else {
                Rpading = 25;
            }
        }
        else {
            Rpading = 0;
        }
        
        viewWidth = bwidth + Lpading+Rpading;
        UIView *studview = [[UIView alloc] initWithFrame:CGRectMake(x, y, viewWidth, bheight + lblHeight)];
        studview.tag = i + 333;
        
        UIImageView *profImg = [[UIImageView alloc] initWithFrame:CGRectMake(Lpading, 0, bwidth, bheight)];
        profImg.tag = i + 200;
        profImg.layer.borderWidth = 2.0f;
        profImg.layer.borderColor = TEXT_COLOR_WHITE.CGColor;
        
        profImg.layer.cornerRadius = profImg.frame.size.height/2;
        profImg.layer.masksToBounds = YES;
        
        profImg.layer.borderWidth = 2.0f;
        profImg.layer.borderColor = TEXT_COLOR_WHITE.CGColor;
        
        [profImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[arrStudant objectAtIndex:i] valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
        
        MIBadgeButton *btn = [[MIBadgeButton alloc] init];
        
        btn.frame = CGRectMake(Lpading, 2, bwidth, bheight);
        
        [btn addTarget:self action:@selector(btnSelectStudPress:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 100;
        
        UILabel *lblStudName = [[UILabel alloc] initWithFrame:CGRectMake(Lpading, btn.frame.size.height, bwidth, lblHeight)];
        
        lblStudName.textAlignment = NSTextAlignmentCenter;
        
        lblStudName.font = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? FONT_20_SEMIBOLD : FONT_10_REGULER;
        lblStudName.textColor = TEXT_COLOR_WHITE;
        lblStudName.text = [[arrStudant objectAtIndex:i] valueForKey:@"child_name"];
        lblStudName.lineBreakMode = NSLineBreakByWordWrapping;
        lblStudName.numberOfLines = 0;
        lblStudName.tag = i + 300;
        
        int total = [[[arrStudant objectAtIndex:i] valueForKey:@"abi_badge"] intValue] +
                        [[[arrStudant objectAtIndex:i] valueForKey:@"abn_badge"] intValue] +
                        [[[arrStudant objectAtIndex:i] valueForKey:@"chat_badge"] intValue] + [appDelegate.xmppHelper getBadgeForUser:[[arrStudant objectAtIndex:i] valueForKey:@"user_id"]];
        NSDictionary *dicStudantDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
        
        if ([[dicStudantDetail valueForKey:@"user_id"] isEqualToString:[[arrStudant objectAtIndex:i] valueForKey:@"user_id"]]) {
        
            profImg.layer.borderColor = TEXT_COLOR_LIGHT_YELLOW.CGColor;
            lblStudName.textColor = TEXT_COLOR_LIGHT_YELLOW;
        }
        
        [btn setBadgeBackgroundColor:[UIColor redColor]];
        
        if (IS_IPAD) {
            [btn setBadgeEdgeInsets:UIEdgeInsetsMake(-2, 0, 0, -50)];
        }
        else {
            [btn setBadgeEdgeInsets:UIEdgeInsetsMake(-2, 0, 0, -30)];
        }
        
        if(total < 0)
            total = 0;
        
        [btn setBadgeString:[NSString stringWithFormat:@"%d", total]];
        
        x = x + bwidth + Lpading;
        
        if (i != totalStudent - 1) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x + bwidth + Rpading, 0, vwidth, vheight)];
            view.backgroundColor = SEPERATOR_COLOR;
            [studview addSubview:view];
            x = x + Rpading + vwidth;
        }
        
//        if(i%2 == 0)
//            studview.backgroundColor = [UIColor purpleColor];
//        else
//            studview.backgroundColor = [UIColor brownColor];
        
        [studview addSubview:profImg];
        [studview addSubview:btn];
        [studview addSubview:lblStudName];
        
        [listScrollView addSubview:studview];
        
        NSDictionary *one = [arrStudant objectAtIndex:i];
        if ( [one valueForKey:@"sfo_type"] == [NSNull null] )
            continue;
        
        if ([[one valueForKey:@"sfo_type"] isEqualToString:@"1"])
            sfo_count++;
    }
    
    if (sfo_count > 0)
        btnSFO.hidden = NO;
    else
        btnSFO.hidden = YES;
    
    listScrollView.contentSize = CGSizeMake(x, 60) ;
}

- (IBAction)btnNextPress:(id)sender {
    
    if (IS_IPAD) {
        if (count <= totalStudent - 4) {
            int width =  bwidth+vwidth+(Lpading*2);
            count++;
            [listScrollView setContentOffset:CGPointMake(width * count, 0) animated:YES];
            [btnPrevious setBackgroundImage:[UIImage imageNamed:@"back-blue.png"] forState:UIControlStateNormal];
        }
        if (count < totalStudent - 3 ) {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-blue.png"] forState:UIControlStateNormal];
        }
        else {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-white.png"] forState:UIControlStateNormal];
            
        }
    }
    else {
        
        if (count <= totalStudent - 3) {
            int width =  bwidth+vwidth+(Lpading*2);
            count++;
            [listScrollView setContentOffset:CGPointMake(width * count, 0) animated:YES];
            [btnPrevious setBackgroundImage:[UIImage imageNamed:@"back-blue.png"] forState:UIControlStateNormal];
        }
        
        if (count < totalStudent - 2 ) {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-blue.png"] forState:UIControlStateNormal];
        }
        else {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-white.png"] forState:UIControlStateNormal];
        }
    }
    
//    if(count == 0)
//        [btnPrevious setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    else
//        [btnPrevious setBackgroundImage:[UIImage imageNamed:@"back-blue.png"] forState:UIControlStateNormal];
}

- (IBAction)btnPreviousPress:(id)sender {
    
    if (count >= 1) {
        int width =  bwidth+vwidth+(Lpading*2);
        count--;
        [listScrollView setContentOffset:CGPointMake(width * count, 0) animated:YES];
    }
    
    if(count == 0)
        [btnPrevious setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    else
        [btnPrevious setBackgroundImage:[UIImage imageNamed:@"back-blue.png"] forState:UIControlStateNormal];
    
    if (IS_IPAD) {
        if (count < totalStudent - 3) {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-blue.png"] forState:UIControlStateNormal];
        }
        else {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-white.png"] forState:UIControlStateNormal];
        }
    }
    else{
        if (count <= totalStudent - 2) {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-blue.png"] forState:UIControlStateNormal];
        }
        else {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-white.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView { }

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //ZDebug(@"scrollViewWillBeginDragging: %@", NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    ZDebug(@"scrollViewDidEndDragging: %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    [self reSetStudantViewOnScrollChange:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //ZDebug(@"scrollViewDidEndScrollingAnimation: %@", NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //ZDebug(@"scrollViewDidEndDecelerating: %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    [self reSetStudantViewOnScrollChange:scrollView];
}

- (void)reSetStudantViewOnScrollChange:(UIScrollView *)scrollView {
    
    float x1 = scrollView.contentOffset.x;
    
    int width =  bwidth + vwidth + (Lpading * 2);
    count = (((int)x1) / width);
    
    for (int i = 0; i < totalStudent; i++) {
        UIView *view = [scrollView viewWithTag:i+333];
        if(x1 > view.frame.origin.x && x1 < (view.frame.origin.x + view.frame.size.width)) {
            if(view.tag == 333)
                [scrollView setContentOffset:CGPointMake(view.frame.origin.x, 0) animated:YES];
            else
                [scrollView setContentOffset:CGPointMake(view.frame.origin.x + Lpading, 0) animated:YES];
            
            break;
        }
    }
    
    if(count == 0)
        [btnPrevious setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    else
        [btnPrevious setBackgroundImage:[UIImage imageNamed:@"back-blue.png"] forState:UIControlStateNormal];
    
    if (IS_IPAD) {
        if (count <= totalStudent - 5) {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-blue.png"] forState:UIControlStateNormal];
        }
        else {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-white.png"] forState:UIControlStateNormal];
        }
    }
    else{
        if (count <= totalStudent - 3) {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-blue.png"] forState:UIControlStateNormal];
        }
        else {
            [btnNext setBackgroundImage:[UIImage imageNamed:@"next-white.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)btnSelectStudPress:(UIButton *)sender {
    
    NSDictionary *dicStudantDetail = [arrStudant objectAtIndex:sender.tag - 100];
    
    if ([[dicStudantDetail valueForKey:@"parentname"] isEqualToString:@""] || [dicStudantDetail valueForKey:@"parentname"] == nil) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_STUDANT_IS_NOT_ACTIVE"]];
    }
    else {
        
        int i = sender.tag - 100;
        
        UIImageView *btnSele = (UIImageView *) [listScrollView viewWithTag: i + 200];
        btnSele.layer.borderColor = TEXT_COLOR_LIGHT_YELLOW.CGColor;
        
        UILabel *lblSle = (UILabel *) [listScrollView viewWithTag:i + 300];
        lblSle.textColor = TEXT_COLOR_LIGHT_YELLOW;
        
        NSDictionary *dicStudantDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
        
        if (![[dicStudantDetail valueForKey:@"user_id"] isEqualToString:[[arrStudant objectAtIndex:sender.tag - 100] valueForKey:@"user_id"]]) {
            
            int i = [arrStudant indexOfObject:dicStudantDetail];
            
            UIImageView *btnSele = (UIImageView *) [listScrollView viewWithTag: i + 200];
            btnSele.layer.borderColor = TEXT_COLOR_WHITE.CGColor;
            
            UILabel *lblSle = (UILabel *) [listScrollView viewWithTag:i + 300];
            lblSle.textColor = TEXT_COLOR_WHITE;
            
            [GeneralUtil setUserChildDetailPreference:key_selectedStudant value:[arrStudant objectAtIndex:sender.tag - 100]];
            [appDelegate.xmppHelper disConnect];
            
//            NSDictionary *dicStudantDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
//            
//            [GeneralUtil setUserPreference:key_abi_badge value:[dicStudantDetail valueForKey:@"abi_badge"]];
//            [GeneralUtil setUserPreference:key_abn_badge value:[dicStudantDetail valueForKey:@"abn_badge"]];
//            
//            int total = [[dicStudantDetail valueForKey:@"abi_badge"] intValue] + [[dicStudantDetail valueForKey:@"abn_badge"] intValue];
//            
//            [GeneralUtil setUserPreference:key_total_badge value:[NSString stringWithFormat:@"%d",total]];
            
            [self setbadge];
            
            NSDictionary *dicStudantDetail = [GeneralUtil getUserPreferenceChild:key_selectedStudant];
            
            ZDebug(@"jid: %@ Name: %@", [dicStudantDetail objectForKey:@"jid"],[dicStudantDetail objectForKey:@"child_name"]);
            
            appDelegate.curJabberId = [dicStudantDetail objectForKey:@"jid"];
            appDelegate.curJIdwd = [dicStudantDetail objectForKey:@"key"];
            [appDelegate connectXmpp:appDelegate.curJabberId];
        }
    }
}

- (IBAction)btnGroupMessagePress:(UIButton *)sender {
    ParentGroupMessageViewController * pvc = [[ParentGroupMessageViewController alloc] initWithNibName:@"ParentGroupMessageViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
    
    [GeneralUtil clearBadge:[appDelegate getCurrentChildId] badgeType:key_abi_badge];
    
//    NSString *abi = [GeneralUtil getUserPreference:key_abi_badge];
//    NSString *bTotal = [GeneralUtil getUserPreference:key_total_badge];
//    
//    int total = [bTotal intValue] - [abi intValue];
//    
//    [GeneralUtil setUserPreference:key_total_badge value:[NSString stringWithFormat:@"%d",total]];
//    [GeneralUtil setUserPreference:key_abi_badge value:[NSString stringWithFormat:@"%d",([abi intValue] - [abi intValue])]];
}

- (IBAction)btnMessagePress:(id)sender {
    
    ParentChatListViewController * pvc = [[ParentChatListViewController alloc] initWithNibName:@"ParentChatListViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
    
    [GeneralUtil clearBadge:[appDelegate getCurrentChildId] badgeType:key_chat_badge];
    
//    ChatViewController * vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
//    //vc.teacherDetail = [arrTeacher objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnSendAbsent:(id)sender {
    
    SendAbsentViewController * pvc = [[SendAbsentViewController alloc] initWithNibName:@"SendAbsentViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction)btnSFO:(id)sender {

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
