//
//  EmergancyMsgViewController.m
//  CSAdmin
//
//  Created by etech-dev on 7/13/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "EmergancyMsgViewController.h"
#import "BaseViewController.h"
#import "TeacherUser.h"
#import "SelecteGroupForEmgViewController.h"

@interface EmergancyMsgViewController ()
{
    NSMutableArray *arrEmgMsg;
    TeacherUser *userObj;
    NSString  *isMesageList;
    NSString  *MesageText;
    
    int viewType;
    int curSelInx;
    
    UIButton *btnPre;
}
@end

@implementation EmergancyMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tblSysMsg.delegate = nil;
    tblSysMsg.dataSource = nil;
    txvMessage.delegate = self;
    
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_EMERGANCY_MESSAGE"] WithSel:@selector(backButtonClick)];
    
    [BaseViewController formateButtonCyne:btnSend title:[GeneralUtil getLocalizedText:@"BTN_SEND_MESSAGE_TITLE"]];
    
    [BaseViewController formateButtonCyne:btnNext title:[GeneralUtil getLocalizedText:@"BTN_NEXT_TITLE"]];
    
    btnCancel.titleLabel.font = FONT_16_BOLD;
    [btnCancel setTitleColor:TEXT_COLOR_LIGHT_GREEN forState:UIControlStateNormal];
    [btnCancel setTitle:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"] forState:UIControlStateNormal];
    
    [BaseViewController formateButtonCyne:btnESend title:[GeneralUtil getLocalizedText:@"BTN_SEND_MESSAGE_TITLE"]];
    [BaseViewController formateButton:btnEcancel withColor:TEXT_COLOR_CYNA title:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]];
    
    isMesageList = @"SMSG";
    
    lblNoDataFond.font = FONT_18_SEMIBOLD;
    lblNoDataFond.textColor = TEXT_COLOR_WHITE;
    lblNoDataFond.text = [GeneralUtil getLocalizedText:@"LBL_NO_MASSAGE_TITLE"];
    
    btnSend.hidden = YES;
    btnCancel.hidden = YES;
    lblNoDataFond.hidden = YES;
    viewCustMsg.hidden = YES;
    viewMessage.hidden = YES;
    viewSysMsg.backgroundColor = TEXT_COLOR_CYNA;
    viewCustMsg.backgroundColor = TEXT_COLOR_CYNA;
    viewMessage.backgroundColor = TEXT_COLOR_CYNA;
    
    msgView.hidden = YES;
    viewSeperator.backgroundColor = SEPERATOR_COLOR;
    
    btnSystemMsg.titleLabel.font = FONT_18_BOLD;
    btnCustomMsg.titleLabel.font = FONT_18_BOLD;
    btnMessage.titleLabel.font = FONT_18_BOLD;
    
    btnSystemMsg.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnCustomMsg.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [btnSystemMsg setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    [btnCustomMsg setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnCustomMsg setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    
    [btnSystemMsg setTitle:[GeneralUtil getLocalizedText:@"BTN_TEMPLATE_TITLE"] forState:UIControlStateNormal];
    [btnCustomMsg setTitle:[GeneralUtil getLocalizedText:@"BTN_CUSTOM_MESSAGE_TITLE"] forState:UIControlStateNormal];
    [btnMessage setTitle:[GeneralUtil getLocalizedText:@"BTN_HISTORY_TITLE"] forState:UIControlStateNormal];
    
    lblMessage.font = FONT_18_REGULER;
    lblMessage.text = [GeneralUtil getLocalizedText:@"LBL_EMESSAGE_TITLE"];
    lblMessage.textColor = TEXT_COLOR_WHITE;
    
    txvMessage.textColor = TEXT_COLOR_WHITE;
    txvMessage.backgroundColor = [UIColor clearColor];
    containtView.backgroundColor = [UIColor clearColor];
    msgView.backgroundColor = [UIColor clearColor];
    
    msgView.layer.cornerRadius = 5;
    msgView.layer.borderWidth = 1;
    msgView.layer.borderColor = TEXT_COLOR_WHITE.CGColor;
    
    viewType = 1;
    curSelInx = -1;
    userObj = [[TeacherUser alloc] init];
    arrEmgMsg = [[NSMutableArray alloc] init];
    arrEmgMsg = [self getSystemMessage];
    
    tblSysMsg.delegate = self;
    tblSysMsg.dataSource = self;
    [tblSysMsg reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)getSystemMessage {

    NSMutableArray *tempMsg = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
    
    [msg setObject:@"fire" forKey:@"icon"];
    [msg setObject:[GeneralUtil getLocalizedText:@"EMSG_MESSAGE_FIRE"] forKey:@"message"];
    [msg setObject:@"0" forKey:@"selected"];
    [tempMsg addObject:[NSDictionary dictionaryWithDictionary:msg]];
    [msg removeAllObjects];
    
    [msg setObject:@"water-flood" forKey:@"icon"];
    [msg setObject:[GeneralUtil getLocalizedText:@"EMSG_MESSAGE_WATER"] forKey:@"message"];
    [msg setObject:@"0" forKey:@"selected"];
    [tempMsg addObject:[NSDictionary dictionaryWithDictionary:msg]];
    [msg removeAllObjects];
    
    [msg setObject:@"alert" forKey:@"icon"];
    [msg setObject:[GeneralUtil getLocalizedText:@"EMSG_MESSAGE_ATTACK"] forKey:@"message"];
    [msg setObject:@"0" forKey:@"selected"];
    [tempMsg addObject:[NSDictionary dictionaryWithDictionary:msg]];
    [msg removeAllObjects];
    
    return tempMsg;
}

- (IBAction)btnSysMsgPress:(id)sender {
    
 //   btnESend.hidden = NO;
 //   btnEcancel.hidden = NO;
    txvMessage.text = @"";
    lblNoDataFond.hidden = YES;
    viewCustMsg.hidden = YES;
    msgView.hidden = YES;
    viewMessage.hidden = YES;
    viewSysMsg.hidden = NO;
    tblSysMsg.hidden = NO;
    heightOfContentView.constant = 330;
    btnSend.hidden = YES;
    btnCancel.hidden = YES;
    [btnCustomMsg setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnMessage setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnSystemMsg setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    
    viewType = 1;
    
    isMesageList = @"SMSG";
    
    arrEmgMsg = [self getSystemMessage];
    
    tblSysMsg.delegate = self;
    tblSysMsg.dataSource = self;
    [tblSysMsg reloadData];
}

- (IBAction)btnCustMsgPress:(id)sender {
    
 //   [arrEmgMsg removeAllObjects];
    
//    btnESend.hidden = YES;
 //   btnEcancel.hidden = YES;
    
//    btnSend.hidden = NO;
//    btnCancel.hidden = NO;
    
    lblNoDataFond.hidden = YES;
    viewSysMsg.hidden = YES;
    tblSysMsg.hidden = YES;
    viewMessage.hidden = YES;
    viewCustMsg.hidden = NO;
    msgView.hidden = NO;
    if (IS_IPAD) {
        heightOfContentView.constant = 300;
    }
    else {
        heightOfContentView.constant = 230;
    }
    
//    btnSend.hidden = NO;
//    btnCancel.hidden = NO;
    [btnCustomMsg setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    [btnSystemMsg setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnMessage setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    
    isMesageList = @"CMSG";
}

- (IBAction)btnMessagePress:(id)sender {
    
    tblSysMsg.delegate = nil;
    tblSysMsg.dataSource = nil;
    
    lblNoDataFond.hidden = YES;
    viewMessage.hidden = NO;
    viewSysMsg.hidden = YES;
    viewCustMsg.hidden = YES;
    msgView.hidden = YES;
    heightOfContentView.constant = ScreenHeight - 120;
    [btnCustomMsg setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnSystemMsg setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnMessage setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    
    btnSend.hidden = YES;
    btnCancel.hidden = YES;
    btnESend.hidden = YES;
    btnEcancel.hidden = YES;
    
    viewType = 2;
    
    [self getEmgMessage];
}

- (IBAction)btnEsendPress:(id)sender {
    
    if ([isMesageList isEqualToString:@"SMSG"])
    {
        
        if ([MesageText isEqualToString:@""] || MesageText == nil) {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_MESSAGE"]];
        }
        else {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_EMERGANCY_ALERT_MSG_TITLE"] Delegate:self];
        }
    }
}

- (IBAction)btnEcancelPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnNextPress:(id)sender {
    
    if ([isMesageList isEqualToString:@"CMSG"]) {
        
        NSString *tempMsg = txvMessage.text;
        MesageText = [tempMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([MesageText isEqualToString:@""] || MesageText == nil) {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_MESSAGE"]];
        }
        else {
            
            SelecteGroupForEmgViewController *vc = [[SelecteGroupForEmgViewController alloc] initWithNibName:@"SelecteGroupForEmgViewController" bundle:nil];
            vc.Msg = MesageText;
            [self.navigationController pushViewController:vc animated:YES];
            
           // [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_EMERGANCY_ALERT_MSG_TITLE"] Delegate:self];
        }
    }
    else if ([isMesageList isEqualToString:@"SMSG"])
    {
        
        if ([MesageText isEqualToString:@""] || MesageText == nil) {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_MESSAGE"]];
        }
        else {
            
            SelecteGroupForEmgViewController *vc = [[SelecteGroupForEmgViewController alloc] initWithNibName:@"SelecteGroupForEmgViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
          //  [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_EMERGANCY_ALERT_MSG_TITLE"] Delegate:self];
        }
    }
}

- (IBAction)btnSendPress:(id)sender {

    if ([isMesageList isEqualToString:@"CMSG"]) {
        
        NSString *tempMsg = txvMessage.text;
        MesageText = [tempMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([MesageText isEqualToString:@""] || MesageText == nil) {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_MESSAGE"]];
        }
        else {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_EMERGANCY_ALERT_MSG_TITLE"] Delegate:self];
        }
    }
}

-(void)getEmgMessage {

    [userObj getAllEmgMessage:[GeneralUtil getUserPreference:key_teacherId]  :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            tblSysMsg.delegate = self;
            tblSysMsg.dataSource = self;
            
            [arrEmgMsg removeAllObjects];
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                arrEmgMsg = [dicRes valueForKey:@"details"];
                tblSysMsg.hidden = NO;
                [tblSysMsg reloadData];
            }
            else {
                tblSysMsg.hidden = YES;
                lblNoDataFond.hidden = NO;
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)sendMesaage:(NSString *)msg {

//    [userObj sendEmgMessage:[GeneralUtil getUserPreference:key_teacherId] schoolId:[GeneralUtil getUserPreference:key_schoolId] message:MesageText :^(NSObject *resObj) {
//        
//        [GeneralUtil hideProgress];
//        
//        NSDictionary *dicRes = (NSDictionary *)resObj;
//        
//        if (dicRes != nil) {
//            
//            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
//                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_MESSAGE_SEND_SUCCESS"]];
//                txvMessage.text = @"";
//                lblMessage.hidden = NO;
//            }
//        }
//        else {
//            NSLog(@"Request Fail...");
//        }
//    }];
}

- (IBAction)btnCancelPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGSize)getSizeOfContent:(NSString *)text {
    
    CGSize maximumSize = CGSizeMake(SCREEN_WIDTH - 110, CGFLOAT_MAX);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:maximumSize
                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_16_REGULER} context:context].size;
    
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZDebug(@"numberOfRowsInSection %d", arrEmgMsg.count);
    return arrEmgMsg.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (viewType == 1) {
        
        CGSize textSize = [self getSizeOfContent:[[arrEmgMsg objectAtIndex:indexPath.row] valueForKey:@"message"]];
        return textSize.height + 40;
    }
    else {
        
        NSString *tempMsg = [[arrEmgMsg objectAtIndex:indexPath.row] valueForKey:@"message_desc"];
        NSString *actualMsg = [tempMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        CGSize textSize = [self getSizeOfContent:actualMsg];
        
        int height = textSize.height + 10 + 10 + 5 + 30 + 10;
        
        if (height < 70) {
            return 70;
        }
        else {
            return height;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    ZDebug(@"cellForRowAtIndexPath %d - %d", (int)indexPath.section, (int)indexPath.row);
    if (viewType == 1) {
    
        static NSString *simpleTableIdentifier = @"SimpleTableItem1";
        
        UIImageView *imgMsg;
        UILabel *lblEmgMessage;
        UIButton *btnSelect;
        UIView *bgView;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.backgroundColor = [UIColor clearColor];
            
            imgMsg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 40, 40)];
            imgMsg.tag = 100;
            imgMsg.contentMode = UIViewContentModeCenter;
            
            CGSize textSize = [self getSizeOfContent:[[arrEmgMsg objectAtIndex:indexPath.row] valueForKey:@"message"]];
            
            lblEmgMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, textSize.width, textSize.height)];
            lblEmgMessage.font = FONT_16_REGULER;
            lblEmgMessage.textColor = [UIColor whiteColor];
            lblEmgMessage.tag = 200;
            lblEmgMessage.lineBreakMode = NSLineBreakByWordWrapping;
            lblEmgMessage.numberOfLines = 0;
            
            btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
            [btnSelect setImage:[UIImage imageNamed:@"radio-button"] forState:UIControlStateNormal];
            [btnSelect setImage:[UIImage imageNamed:@"radio-button-select"] forState:UIControlStateSelected];
            //[btnSelect addTarget:self action:@selector(btnSelecte:) forControlEvents:UIControlEventTouchUpInside];
            btnSelect.tag = 300;
            
            bgView = [[UIView alloc] initWithFrame:CGRectMake(75, 10, textSize.width + 20, textSize.height + 20)];
            bgView.backgroundColor = TEXT_COLOR_DARK_BLUE;
            
            bgView.layer.cornerRadius = 5;
            
            [bgView addSubview:lblEmgMessage];
            
            [cell.contentView addSubview:imgMsg];
            [cell.contentView addSubview:bgView];
            [cell.contentView addSubview:btnSelect];
        }
        else {
            lblEmgMessage = (UILabel *)[cell.contentView viewWithTag:200];
            imgMsg = (UIImageView *)[cell.contentView viewWithTag:100];
            btnSelect = (UIButton *)[cell.contentView viewWithTag:300];
        }
        
        NSDictionary *dicStudantDetail = [arrEmgMsg objectAtIndex:indexPath.row];
        
        lblEmgMessage.text = [dicStudantDetail valueForKey:@"message"];
        imgMsg.image = [UIImage imageNamed:[dicStudantDetail valueForKey:@"icon"]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == curSelInx) {
            btnSelect.selected = YES;
            btnPre = btnSelect;
        }
        else {
            btnSelect.selected = NO;
        }
        return cell;
    }
    else {
    
        static NSString *simpleTableIdentifier = @"SimpleTableItem2";
        
        UIImageView *imgMsg;
        UILabel *lblEmgMessage,*lblDate;
        UIView *bgView;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
            cell.backgroundColor = [UIColor clearColor];
            
            imgMsg = [[UIImageView alloc] init];
            imgMsg.tag = 500;
            imgMsg.contentMode = UIViewContentModeCenter;
            imgMsg.image = [UIImage imageNamed:@"alert"];
            
           // CGSize textSize = [self getSizeOfContent:[[arrEmgMsg objectAtIndex:indexPath.row] valueForKey:@"message_desc"]];
            
            bgView = [[UIView alloc] init];
            bgView.backgroundColor = TEXT_COLOR_DARK_BLUE;
            bgView.layer.cornerRadius = 5;
            bgView.tag = 800;
            
            lblEmgMessage = [[UILabel alloc] init];
            lblEmgMessage.font = FONT_16_REGULER;
            lblEmgMessage.textColor = [UIColor whiteColor];
            lblEmgMessage.tag = 600;
            lblEmgMessage.lineBreakMode = NSLineBreakByWordWrapping;
            lblEmgMessage.numberOfLines = 0;
            
            lblDate = [[UILabel alloc] init];
            lblDate.font = FONT_17_BOLD;
            lblDate.textColor = TEXT_COLOR_LIGHT_CYNA;
            lblDate.tag = 700;
            
            [bgView addSubview:lblEmgMessage];
            
            [cell.contentView addSubview:bgView];
            [cell.contentView addSubview:imgMsg];
            [cell.contentView addSubview:lblDate];
         
        }
        else {
            bgView = (UIView *)[cell.contentView viewWithTag:800];
            lblEmgMessage = (UILabel *)[cell.contentView viewWithTag:600];
            lblDate = (UILabel *)[cell.contentView viewWithTag:700];
            imgMsg = (UIImageView *)[cell.contentView viewWithTag:500];
        }
        
        NSString *tempMsg = [[arrEmgMsg objectAtIndex:indexPath.row] valueForKey:@"message_desc"];
        NSString *actualMsg = [tempMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        CGSize textSize = [self getSizeOfContent:actualMsg];
        
        bgView.frame = CGRectMake(75, 10, textSize.width + 20, textSize.height + 20);
        lblEmgMessage.frame = CGRectMake(10, 10, textSize.width, textSize.height);
        imgMsg.frame = CGRectMake(20, 12, 40, 40);
        lblDate.frame = CGRectMake(75, textSize.height + 35, SCREEN_WIDTH - 100, 30);
        
        NSDictionary *dicStudantDetail = [arrEmgMsg objectAtIndex:indexPath.row];
        lblEmgMessage.text = [dicStudantDetail valueForKey:@"message_desc"];
        lblDate.text = [GeneralUtil formateData:[dicStudantDetail valueForKey:@"created_at"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (viewType == 1) {
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btnSelect = (UIButton *)[cell.contentView viewWithTag:300];
        
        if (btnPre) {
            btnPre.selected = NO;
        }
        
        btnPre = btnSelect;
        btnSelect.selected = YES;
        curSelInx = indexPath.row;
        
        NSDictionary *dicStudantDetail = [arrEmgMsg objectAtIndex:indexPath.row];
        
        MesageText = [dicStudantDetail valueForKey:@"message"];
        
    }
    else {
        NSDictionary *dicStudantDetail = [arrEmgMsg objectAtIndex:indexPath.row];
    }
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
        if (buttonIndex == 1) {
            
        }
        else {
            
            [self sendMesaage:MesageText];
        }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    lblMessage.hidden = YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([txvMessage.text isEqualToString:@""]) {
        lblMessage.hidden = NO;
    }
}
@end
