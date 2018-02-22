//
//  ChatViewController.m
//  CSAdmin
//
//  Created by etech-dev on 7/1/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ChatViewController.h"
#import "BaseViewController.h"
#import "IQKeyboardManager.h"
#import "EtechMassage.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "SendMessageTableViewCell.h"
#import "ReceiveMessageTableViewCell.h"
#import "TeacherConstant.h"

#define MIN_CELL_W IS_IPAD ? SCREEN_WIDTH - 100 : SCREEN_WIDTH - 80
#define MIN_LEFT_CELL_H 70
#define MIN_RIGHT_CELL_H 50
#define PROFILE_PIC_CONSTANT 40

#define MARGIN_TOP 10
#define MARGIN_BOTTOM 10

@interface ChatViewController ()
{
    NSMutableArray *arrMessages;
    NSString *toJId;
    NSString *preText;
    HPGrowingTextView *textView;
    CGFloat kOFFSET_FOR_KEYBOARD;
    CGFloat tblOriHeight;
    
    NSString *number;
    UIButton *doneBtn;
    
    BOOL isFetching;
    BOOL hasMoreData;
    BOOL isCallLive;
    
    int keybordHeight;
    int statusBarHeight;
    float changeHeight;
}
@end

@implementation ChatViewController

@synthesize studDetail,isTeacher;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    keybordHeight = 0;
    statusBarHeight = 0;
    
    changeHeight = 0;
    
//#if TARGET_OS_SIMULATOR
//    toJId = @"cs-5kpmmucc@constore.no";
//#else
//    toJId = @"csadmin@constore.no";
//#endif
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

    toJId = [studDetail valueForKey:@"jid"];
    
    [BaseViewController setBackGroud:self];
    
    hasMoreData = YES;
    arrMessages = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ConnectingChanged:) name:@"ConnectingStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:@"MessageReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingStatusChanged:) name:@"TypingStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingStatusPaused:) name:@"TypingPaused" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deliveryStateUpdated:) name:@"DeliveryState" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callReceived:) name:CTCallStateIncoming object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callEnded:) name:CTCallStateDisconnected object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callConnected:) name:CTCallStateConnected object:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 50)];
    
//    UILabel *lblTeacherClass = [[UILabel alloc]initWithFrame:CGRectMake(35, 20, 180, 25)];
//    [lblTeacherClass setText:[studDetail valueForKey:@"class_name"]];
//    [lblTeacherClass setBackgroundColor:[UIColor clearColor]];
//    [lblTeacherClass setFont:FONT_NAVIGATION_TITLE];
//    lblTeacherClass.textColor = TEXT_COLOR_WHITE;
//    [lblTeacherClass setTextAlignment:NSTextAlignmentLeft];
//    lblTeacherClass.font = FONT_16_BOLD;
//    
//    [view addSubview:lblTeacherClass];
    
    int expecteHeight = 25;
    
    CGSize heightOfstring = [self getSizeOfContent:[studDetail valueForKey:@"kid_name"] font:FONT_BTN_TITLE_18];
    
    NSString *sName;
    
    if (![[studDetail valueForKey:@"class_name"] isEqualToString:@""]) {
        if(heightOfstring.height > expecteHeight) {
            sName = [NSString stringWithFormat:@"%@ - %@",[studDetail valueForKey:@"kid_name"],[studDetail valueForKey:@"class_name"]];
        }
        else {
            sName = [NSString stringWithFormat:@"%@\n%@",[studDetail valueForKey:@"kid_name"],[studDetail valueForKey:@"class_name"]];
        }
    }
    else {
        sName = [studDetail valueForKey:@"kid_name"];
    }
    
    //Create mutable string from original one
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:sName];
    
    //Fing range of the string you want to change colour
    //If you need to change colour in more that one place just repeat it
    NSRange range = [sName rangeOfString:[studDetail valueForKey:@"kid_name"]];
    [attString addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_CYNA range:range];
    
    if (![[studDetail valueForKey:@"class_name"] isEqualToString:@""]) {
        range = [sName rangeOfString:@"-"];
        [attString addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_WHITE range:range];
        range = [sName rangeOfString:[studDetail valueForKey:@"class_name"]];
        [attString addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_WHITE range:range];
    }
    
    //Add it to the label - notice its not text property but it's attributeText
    
    UILabel *lblTeacherName = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 180, 45)];
    [lblTeacherName setAttributedText:attString];
    [lblTeacherName setBackgroundColor:[UIColor clearColor]];
    [lblTeacherName setFont:FONT_NAVIGATION_TITLE];
    [lblTeacherName setTextAlignment:NSTextAlignmentLeft];
    lblTeacherName.font = FONT_BTN_TITLE_17;
    
    lblTeacherName.lineBreakMode = NSLineBreakByWordWrapping;
    lblTeacherName.numberOfLines = 0;
    
//    lblTeacherName.adjustsFontSizeToFitWidth=YES;
//    lblTeacherName.minimumScaleFactor=0.25;
    
    lblTeacherName.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
   // [lblTeacherName sizeToFit];
    
    [view addSubview:lblTeacherName];
    
    UIImageView *profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 30, 30)];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[studDetail valueForKey:@"kid_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
        profileImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [BaseViewController setRoudRectImage:profileImg];
    
    [view addSubview:profileImg];
    
    [self.navigationItem setTitleView:view];
    
    self.navigationItem.leftBarButtonItem = [BaseViewController getBackButtonWithSel:@selector(backButtonClick) addTarget:self];
    
  //  [txtMessageBox addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    containerView.backgroundColor = [UIColor clearColor];
    
    textView = [[HPGrowingTextView alloc] init];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 3;
    
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = FONT_16_REGULER;
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_MESSAGE_TYPE_HERE"];
    textView.placeholderColor = APP_BACKGROUD_COLOR;
    
    textView.layer.cornerRadius = 5;
    
    [self.view addSubview:containerView];
    
    [containerView addSubview:textView];
    
    doneBtn = btnSend;
    [doneBtn addTarget:self action:@selector(btnSendPress:) forControlEvents:UIControlEventTouchUpInside];
   // [containerView addSubview:doneBtn];
    
    lblChateStatus.textColor = TEXT_COLOR_WHITE;
    statusBgView.layer.cornerRadius = 10;
    statusBgView.backgroundColor = [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)202/255 blue:(CGFloat)251/255 alpha:.5];
    
    if (IS_IPAD) {
        
        textView.frame = CGRectMake(6, 5, ScreenWidth - 150, 45);
       // doneBtn.frame = CGRectMake(ScreenWidth - 130, heightOfContaintView.constant - 51, 120, 45);
    }
    else {
        textView.frame = CGRectMake(6, 8, ScreenWidth - 100, 35);
       // doneBtn.frame = CGRectMake(ScreenWidth - 87, heightOfContaintView.constant - 42, 80, 33);
    }
    
    [BaseViewController formateButtonCyne:doneBtn title:[GeneralUtil getLocalizedText:@"BTN_SEND_TITLE"] withIcon:@"send" withBgColor:TEXT_COLOR_CYNA];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)];
    
    [self.view addGestureRecognizer:tap];
    
    heightOfTableView.constant = SCREEN_HEIGHT - heightOfContaintView.constant;
    tblOriHeight = heightOfTableView.constant;
    
    static NSString *CellIdentifier1 = @"SendMessageTableViewCell";
    static NSString *CellIdentifier2 = @"ReceiveMessageTableViewCell";
    
    UINib *nib = [UINib nibWithNibName:@"SendMessageTableViewCell" bundle:nil];
    [tblMessages registerNib:nib forCellReuseIdentifier:CellIdentifier1];
    
    nib = [UINib nibWithNibName:@"ReceiveMessageTableViewCell" bundle:nil];
    [tblMessages registerNib:nib forCellReuseIdentifier:CellIdentifier2];
    
    tblMessages.rowHeight = UITableViewAutomaticDimension;
    
    if (IS_IPAD) {
        tblMessages.estimatedRowHeight = 80.0;
    }
    else {
        tblMessages.estimatedRowHeight = 60.0;
    }
}

-(void)loadHistory
{
    if(!isFetching && hasMoreData) {
        
        isFetching = YES;
        
        if (statusBgView.hidden) {
            statusBgView.hidden = NO;
            lblChateStatus.text = [GeneralUtil getLocalizedText:@"LBL_LOADING_STATUS_TITLE"];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [appDelegate.xmppHelper getMessageArchiveWith:toJId :^(BOOL status, NSMutableArray *archiveMessaages) {
                
                isFetching = NO;
                statusBgView.hidden = YES;
                if(archiveMessaages) {
                    
                    if(archiveMessaages.count <= 0)
                        hasMoreData = NO;
                    
                    if(!arrMessages) {
                        arrMessages = [[NSMutableArray alloc] init];
                    }
                    
                    [arrMessages addObjectsFromArray:archiveMessaages];
                    
                    [tblMessages reloadData];
                    
                    if(arrMessages.count > 0) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrMessages.count - 1 inSection:0];
                            [tblMessages scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        });
                    }
                }
            }];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    appDelegate.curJabberIdSel = [studDetail valueForKey:@"jid"];
    
    if (!appDelegate.isConnected) {
        statusBgView.hidden = NO;
        lblChateStatus.text = [GeneralUtil getLocalizedText:@"LBL_CONNECTING_STATUS_TITLE"];
        [doneBtn setUserInteractionEnabled:NO];
        doneBtn.backgroundColor = TEXT_COLOR_GRAY;
    }
    else {
        statusBgView.hidden = YES;
        [doneBtn setUserInteractionEnabled:YES];
        doneBtn.backgroundColor = TEXT_COLOR_CYNA;
        [self loadHistory];
    }
    
    if (appDelegate.statusViewHeight > 20) {
        [self setNewFream:YES];
    }
    else {
        [self setNewFream:NO];
    }
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    appDelegate.curJabberIdSel = @"";

    [appDelegate.xmppHelper clearBadgeForJid:[studDetail valueForKey:@"jid"]];
    
    [appDelegate.xmppHelper clearBadgeForUser];
    
    [GeneralUtil setUserPreference:key_chat_badge value:@"0"];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)infoBtnClick {
    
}

-(void)resignTextView
{
    [textView resignFirstResponder];
  //  heightOfTableView.constant = tblOriHeight;
    
    if (isCallLive) {
        heightOfTableView.constant = tblOriHeight - statusBarHeight - changeHeight;
    }
    else {
        heightOfTableView.constant = tblOriHeight - changeHeight;
    }
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
  //  CGRect r = containerView.frame;
    heightOfContaintView.constant -= diff;
    
    changeHeight -= diff;
    //r.origin.y += diff;
    //containerView.frame = r;
    
    heightOfTableView.constant = heightOfTableView.constant + diff;
    
    if(arrMessages.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrMessages.count - 1 inSection:0];
        [tblMessages scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#define kOFFSET_FOR_SUGGESTIONS 30.0

-(void)setNewFream:(BOOL)isCall {

    if (isCall) {
        isCallLive = true;
        statusBarHeight = 20;
        heightOfTableView.constant = tblOriHeight - keybordHeight - statusBarHeight - changeHeight;
    }
    else {
        isCallLive = false;
        statusBarHeight = 0;
        heightOfTableView.constant = tblOriHeight - keybordHeight;
    }
}

-(void)keyboardWillShow:(NSNotification *)note {
    
    NSLog(@"note.userInfo: %@", note.userInfo);
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    kOFFSET_FOR_KEYBOARD = keyboardBounds.size.height;
    
    NSLog(@"kOFFSET_FOR_KEYBOARD: %f", kOFFSET_FOR_KEYBOARD);
    
    heightOfTableView.constant = tblOriHeight - kOFFSET_FOR_KEYBOARD - statusBarHeight - changeHeight;
    
    keybordHeight = kOFFSET_FOR_KEYBOARD;
    
    if (arrMessages.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrMessages.count - 1 inSection:0];
            [tblMessages scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
}

-(void)keyboardWillHide:(NSNotification *)note {
    
    keybordHeight = 0;
   // heightOfTableView.constant = tblOriHeight - statusBarHeight;
    
//    if (self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else if (self.view.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        //rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        //rect.size.height += kOFFSET_FOR_KEYBOARD;
        
        heightOfTableView.constant = heightOfTableView.constant - kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        heightOfTableView.constant = heightOfTableView.constant + kOFFSET_FOR_KEYBOARD;
        
    }

}

//-(void)textFieldDidChange:(NSNotification *)notification {
//    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifyChatState) object:nil];
//    [self performSelector:@selector(notifyChatState) withObject:nil afterDelay:2.0];
//}
//
//- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
//    
//    
//}
//
//- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView{
//    
//}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifyChatState) object:nil];
    [self performSelector:@selector(notifyChatState) withObject:nil afterDelay:0.0];
}

-(void)notifyChatState {
    
    if(textView.text.length > 0) {
        preText = textView.text;
        [appDelegate.xmppHelper sendChatStateNotification:@"composing" :toJId];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifyChatStatePause) object:nil];
    [self performSelector:@selector(notifyChatStatePause) withObject:nil afterDelay:0.5];
}

-(void)notifyChatStatePause {
    
    if(textView.text.length > 0) {
        if([textView.text isEqualToString:preText]) {
            [appDelegate.xmppHelper sendChatStateNotification:@"paused" :toJId];
        }
    }
    else
        [appDelegate.xmppHelper sendChatStateNotification:@"inactive" :toJId];
}


- (IBAction)btnSendPress:(id)sender {
    
    NSString *tempMsg = textView.text;
    NSString *orMsg = [tempMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([orMsg length] > 0) {
        
        ZDebug(@"%@", appDelegate.curJabberId);
        ZDebug(@"%@", toJId);
        
        EtechMassage *objMsg = [[EtechMassage alloc] init];
        objMsg.text = orMsg;
        objMsg.from = appDelegate.curJabberId;
        objMsg.to = toJId;
        objMsg.timestamp = [NSDate date];
        objMsg.deliveryState = [NSNumber numberWithInteger:0];
        
        NSString *messageId = [appDelegate.xmppHelper sendMassage:objMsg ToJId:toJId];
        
        objMsg.messageId = messageId;
        [arrMessages addObject:objMsg];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrMessages.count-1 inSection:0];
        
        [tblMessages beginUpdates];
        [tblMessages insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [tblMessages endUpdates];
        
        [tblMessages scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        textView.text = @"";
    }
}

-(CGSize)getSizeOfContent:(NSString *)text font:(UIFont *)font {
    
    CGSize maximumSize = CGSizeMake(220, CGFLOAT_MAX);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:maximumSize
                                        options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:context].size;
    
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!isFetching && hasMoreData) {
        
        if (arrMessages && arrMessages.count > 0) {
            NSIndexPath *topVisibleIndexPath = [[tblMessages indexPathsForVisibleRows] objectAtIndex:0];
            
            if (topVisibleIndexPath.row == 0) {
                
                statusBgView.hidden = NO;
                lblChateStatus.text = [GeneralUtil getLocalizedText:@"LBL_LOADING_STATUS_TITLE"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [appDelegate.xmppHelper nextMessageArchiveWith:toJId :^(BOOL status, NSMutableArray *archiveMessaages) {
                        
                        isFetching = NO;
                        
                        statusBgView.hidden = YES;
                        
                        if(archiveMessaages) {
                            
                            if(archiveMessaages.count <= 0)
                                hasMoreData = NO;
                            
                            if(!arrMessages) {
                                arrMessages = [[NSMutableArray alloc] init];
                            }
                            
                            for (int i = (int)archiveMessaages.count - 1; i >= 0; i--) {
                                [arrMessages insertObject:[archiveMessaages objectAtIndex:i] atIndex:0];
                            }
                            
                            [tblMessages reloadData];
                        }
                    }];
                });
            }
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  arrMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  /*  EtechMassage *objMsg = [arrMessages objectAtIndex:indexPath.row];
    CGSize textSize = [self getSizeOfContent:objMsg.text font:FONT_16_REGULER];
    
    int height = 0;
    
    if ([[objMsg.to lowercaseString] isEqualToString:[appDelegate.curJabberId lowercaseString]]) {
        height = textSize.height + MIN_LEFT_CELL_H;
        
        if (isTeacher)
            height = textSize.height + MIN_RIGHT_CELL_H;
    }
    else {
        height = textSize.height + MIN_RIGHT_CELL_H;
    }
    
    height = height + MARGIN_TOP + MARGIN_BOTTOM;
    return height; */
    
    return UITableViewAutomaticDimension;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"SendMessageTableViewCell";
    static NSString *CellIdentifier2 = @"ReceiveMessageTableViewCell";
    
    EtechMassage *objMsg = [arrMessages objectAtIndex:indexPath.row];
    
    if ([[objMsg.to lowercaseString] isEqualToString:[appDelegate.curJabberId lowercaseString]]) {
        
        ReceiveMessageTableViewCell *cell = (ReceiveMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *image = [UIImage imageNamed:@"send_bg"];
        UIEdgeInsets edgeInsets;
        edgeInsets.left = 40.0f;
        edgeInsets.top = 20.0f;
        edgeInsets.right = 20.0f;
        edgeInsets.bottom = 20.0f;
        
        cell.imgBubel.image = [image resizableImageWithCapInsets:edgeInsets];
        
        [cell.imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[studDetail valueForKey:@"kid_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
        
        
        
        if (isTeacher) {
            cell.btnCall.constant = 0;
            cell.parentStatus.constant = 0;
            cell.lblParent.text = @"";
        }
        else {
            
            NSString *parentDetail;
            
            cell.btnCall.constant = 23;
            
            if ([objMsg.parent isEqualToString:@"1"]) {
                if ([[studDetail valueForKey:@"parent1mobile"] isEqualToString:@""]) {
                    parentDetail = [GeneralUtil getLocalizedText:@"LBL_PARENT1_TITLE"];
                    cell.btnCall.constant = 0;
                }
                else {
                    parentDetail = [NSString stringWithFormat:@"%@, %@",[studDetail valueForKey:@"parent1mobile"],[GeneralUtil getLocalizedText:@"LBL_PARENT1_TITLE"]];
                }
            }
            else if ([objMsg.parent isEqualToString:@"2"]) {
                if ([[studDetail valueForKey:@"parent2mobile"] isEqualToString:@""]) {
                    parentDetail = [GeneralUtil getLocalizedText:@"LBL_PARENT2_TITLE"];
                    cell.btnCall.constant = 0;
                }
                else {
                    parentDetail = [NSString stringWithFormat:@"%@, %@",[studDetail valueForKey:@"parent2mobile"],[GeneralUtil getLocalizedText:@"LBL_PARENT2_TITLE"]];
                }
            }
            else {
                if ([[studDetail valueForKey:@"parent3mobile"] isEqualToString:@""]) {
                    parentDetail = [GeneralUtil getLocalizedText:@"LBL_OTHER_CONTACT_TITLE"];
                    cell.btnCall.constant = 0;
                }
                else {
                    parentDetail = [NSString stringWithFormat:@"%@, %@",[studDetail valueForKey:@"parent3mobile"],[GeneralUtil getLocalizedText:@"LBL_OTHER_CONTACT_TITLE"]];
                }
            }
            
            cell.lblParent.text = parentDetail;
        }
        
        
        cell.lblMessage.text = objMsg.text;
        cell.lblDate.text = [GeneralUtil formateDataWithDate:objMsg.timestamp];
        
        [cell.btnCallPress addTarget:self action:@selector(btnCallPress:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    else {
        
        SendMessageTableViewCell *cell = (SendMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *image = [UIImage imageNamed:@"reciver-bg-2x"];
        UIEdgeInsets edgeInsets;
        edgeInsets.left = 20.0f;
        edgeInsets.top = 20.0f;
        edgeInsets.right = 40.0f;
        edgeInsets.bottom = 20.0f;
        
        cell.imgBubble.image = [image resizableImageWithCapInsets:edgeInsets];
        
        [cell.imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[GeneralUtil getUserPreference:key_UserImage]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
        
        ZDebug(@"status : %d", [objMsg.deliveryState intValue]);
        
        if([objMsg.deliveryState intValue] == -1) {
            cell.lblStatus.hidden = YES;
        }
        else {
            cell.lblStatus.hidden = NO;
            
            if([objMsg.deliveryState intValue] == 1) {
                cell.lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_SEEN_TITLE"];
            }
            else {
                cell.lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_UNSEEN_TITLE"];
            }
        }
        
        cell.lblMessage.text = objMsg.text;
        cell.lblDate.text = [GeneralUtil formateDataWithDate:objMsg.timestamp];
        
        return cell;
    }

 /*   static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UIImageView *imgProfile, *imgBubble;//, *imgCallIcon;
    UILabel *lblMessage,*lblStatus,*lblDate,*lblUser;
    UIButton *imgCallIcon;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        imgProfile = [[UIImageView alloc] init];
        imgProfile.tag = 100;
        imgProfile.contentMode = UIViewContentModeScaleAspectFit;
        imgProfile.image = [UIImage imageNamed:@"profile.png"];
        
        imgCallIcon = [[UIButton alloc] init];
        imgCallIcon.tag = 700;
        imgCallIcon.contentMode = UIViewContentModeScaleAspectFit;
       
        [imgCallIcon addTarget:self action:@selector(btnCallPress:) forControlEvents:UIControlEventTouchUpInside];
        [imgCallIcon setImage:[UIImage imageNamed:@"mobile-icon"] forState:UIControlStateNormal];
        
        imgBubble = [[UIImageView alloc] init];
        imgBubble.tag = 500;
        
        lblMessage = [[UILabel alloc] init];
        lblMessage.textColor = [UIColor blackColor];
        lblMessage.tag = 200;
        lblMessage.font = FONT_16_REGULER;
        lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
        lblMessage.numberOfLines = 0;
        
        lblStatus = [[UILabel alloc] init];
        lblStatus.tag = 300;
        lblStatus.font = FONT_14_REGULER;
        lblStatus.textAlignment = NSTextAlignmentRight;
        
        lblDate = [[UILabel alloc] init];
        lblDate.tag = 400;
        lblDate.font = FONT_14_REGULER;
        lblDate.textColor = TEXT_COLOR_LIGHT_CYNA;
        lblDate.textAlignment = NSTextAlignmentLeft;
        
        lblUser = [[UILabel alloc] init];
        lblUser.tag = 600;
        lblUser.textColor = TEXT_COLOR_WHITE;
        lblUser.font = FONT_14_REGULER;
        lblUser.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:imgProfile];
        [cell.contentView addSubview:imgBubble];
        [cell.contentView addSubview:lblMessage];
        [cell.contentView addSubview:lblDate];
        [cell.contentView addSubview:lblStatus];
        [cell.contentView addSubview:lblUser];
        [cell.contentView addSubview:imgCallIcon];
    }
    else {
        lblMessage = (UILabel *)[cell.contentView viewWithTag:200];
        lblStatus = (UILabel *)[cell.contentView viewWithTag:300];
        lblDate = (UILabel *)[cell.contentView viewWithTag:400];
        imgProfile = (UIImageView *)[cell.contentView viewWithTag:100];
        imgBubble = (UIImageView *)[cell.contentView viewWithTag:500];
        imgCallIcon = (UIButton *)[cell.contentView viewWithTag:700];
        lblUser = (UILabel *)[cell.contentView viewWithTag:600];
    }
    
    EtechMassage *objMsg = [arrMessages objectAtIndex:indexPath.row];
    CGSize textSize = [self getSizeOfContent:objMsg.text font:FONT_16_REGULER];
    
    if ([[objMsg.to lowercaseString] isEqualToString:[appDelegate.curJabberId lowercaseString]]) {

        cell.backgroundColor = [UIColor clearColor];
        
        int userLblHeight = 20;
        
        if (isTeacher)
            userLblHeight = 0;
        
        int bubbleWidth = textSize.width + 20 + 20;
        int cellHeight = textSize.height + MIN_LEFT_CELL_H + MARGIN_TOP;
        
        if (isTeacher)
            cellHeight = textSize.height + MIN_RIGHT_CELL_H;
        
        if(bubbleWidth < MIN_CELL_W)
            bubbleWidth = MIN_CELL_W;
    
        int xPos = 10;
    
        imgProfile.frame = CGRectMake(xPos, cellHeight - PROFILE_PIC_CONSTANT, PROFILE_PIC_CONSTANT, PROFILE_PIC_CONSTANT);
        
        [imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[studDetail valueForKey:@"kid_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
        
        xPos = xPos + imgProfile.frame.size.width;
        
        imgBubble.frame = CGRectMake(xPos, MARGIN_TOP + userLblHeight, bubbleWidth, cellHeight - (userLblHeight + MARGIN_TOP));
        
        xPos = xPos + 30;
        
        lblMessage.frame = CGRectMake(xPos, imgBubble.frame.origin.y + 10, bubbleWidth - 40, textSize.height);
        lblMessage.text = objMsg.text;
        
        lblDate.frame = CGRectMake(lblMessage.frame.origin.x, (imgBubble.frame.origin.y + imgBubble.frame.size.height) - 30, imgBubble.frame.size.width, 20);
        //lblDate.text = [GeneralUtil relativeDateStringForDate:objMsg.timestamp];
        lblDate.text = [GeneralUtil formateDataWithDate:objMsg.timestamp];
        
        imgCallIcon.frame = CGRectMake((imgBubble.frame.size.width + imgBubble.frame.origin.x) - 30, imgBubble.frame.origin.y - 25, 20, 20);
        
        lblUser.frame = CGRectMake((imgCallIcon.frame.origin.x - 10) - imgBubble.frame.size.width, imgBubble.frame.origin.y - 25, imgBubble.frame.size.width, 20);
      //  lblUser.text = @"87565253, Parent1";
        NSString *parentDetail;
        
        if ([objMsg.parent isEqualToString:@"1"]) {
            parentDetail = [NSString stringWithFormat:@"%@, %@",[studDetail valueForKey:@"parent1mobile"],[GeneralUtil getLocalizedText:@"LBL_PARENT1_TITLE"]];
        }
        else if ([objMsg.parent isEqualToString:@"2"]) {
            parentDetail = [NSString stringWithFormat:@"%@, %@",[studDetail valueForKey:@"parent2mobile"],[GeneralUtil getLocalizedText:@"LBL_PARENT2_TITLE"]];
        }
        else {
            parentDetail = [NSString stringWithFormat:@"%@, %@",[studDetail valueForKey:@"parent3mobile"],[GeneralUtil getLocalizedText:@"LBL_PARENT1_TITLE"]];
        }
        
        lblUser.text = parentDetail;
        lblUser.font = FONT_15_REGULER;
        
        lblStatus.hidden = YES;
        
        if (!isTeacher) {
            lblUser.hidden = NO;
            imgCallIcon.hidden = NO;
        }
        else {
            lblUser.hidden = YES;
            imgCallIcon.hidden = YES;
        }
    
//        imgBubble.backgroundColor = [UIColor brownColor];
        UIImage *image = [UIImage imageNamed:@"send_bg"];
        UIEdgeInsets edgeInsets;
        edgeInsets.left = 40.0f;
        edgeInsets.top = 20.0f;
        edgeInsets.right = 20.0f;
        edgeInsets.bottom = 20.0f;
        
        imgBubble.image = [image resizableImageWithCapInsets:edgeInsets];
    }
    else {
    
        cell.backgroundColor = [UIColor clearColor];
        
        int hMargin = 10;
        
        int bubbleWidth = textSize.width + 20;
        int cellHeight = textSize.height + MIN_RIGHT_CELL_H + MARGIN_TOP;
        
        if(bubbleWidth < MIN_CELL_W)
            bubbleWidth = MIN_CELL_W;
        
        imgProfile.frame = CGRectMake(ScreenWidth - (PROFILE_PIC_CONSTANT + hMargin),
                                      cellHeight - PROFILE_PIC_CONSTANT,PROFILE_PIC_CONSTANT, PROFILE_PIC_CONSTANT);
        
        [imgProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,
                                                          [GeneralUtil getUserPreference:key_UserImage]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
        
        int xPos = ScreenWidth - (bubbleWidth + imgProfile.frame.size.width + hMargin);
        
        imgBubble.frame = CGRectMake(xPos, MARGIN_TOP , bubbleWidth, cellHeight - MARGIN_TOP);
        
        lblMessage.frame = CGRectMake(xPos + 10, imgBubble.frame.origin.y + 10, bubbleWidth - 30, textSize.height);
        lblMessage.text = objMsg.text;
        
        lblDate.frame = CGRectMake(lblMessage.frame.origin.x, imgBubble.frame.size.height-20, imgBubble.frame.size.width, 20);
       // lblDate.text = [GeneralUtil relativeDateStringForDate:objMsg.timestamp];
        
        lblDate.text = [GeneralUtil formateDataWithDate:objMsg.timestamp];
        
        lblStatus.frame = CGRectMake(imgBubble.frame.origin.x + imgBubble.frame.size.width - 110, imgBubble.frame.size.height-20, 80, 20);
        
        if([objMsg.deliveryState intValue] == -1) {
            lblStatus.hidden = YES;
        }
        else {
            lblStatus.hidden = NO;
            
            if([objMsg.deliveryState intValue] == 1) {
                lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_SEEN_TITLE"];
            }
            else {
                lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_UNSEEN_TITLE"];
            }
        }
        
        lblUser.hidden = YES;
        imgCallIcon.hidden = YES;
        
//        imgBubble.backgroundColor = [UIColor lightTextColor];
        
        UIImage *image = [UIImage imageNamed:@"receive_bg"];
        UIEdgeInsets edgeInsets;
        edgeInsets.left = 20.0f;
        edgeInsets.top = 20.0f;
        edgeInsets.right = 40.0f;
        edgeInsets.bottom = 20.0f;
        
        imgBubble.image = [image resizableImageWithCapInsets:edgeInsets];
    }
    
    [BaseViewController setRoudRectImage:imgProfile];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell; */
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)){
        
        NSLog(@"in real life, we'd now copy somehow");
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        
        if ([cell isKindOfClass:[SendMessageTableViewCell class]]) {
            
            SendMessageTableViewCell *cell = (SendMessageTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            
            [pasteBoard setString:cell.lblMessage.text];
            
        }
        else {
            ReceiveMessageTableViewCell *cell = (ReceiveMessageTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            
            [pasteBoard setString:cell.lblMessage.text];
        }
    }
}

-(void)btnCallPress:(UIButton *)sender {
    
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *mnc = [carrier mobileNetworkCode];
    // User will get an alert error when they will try to make a phone call in airplane mode.
    if (([mnc length] == 0)) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CALL_NOT_PROVIDE"]];
    } else {
        
        NSIndexPath *indexPath = [tblMessages indexPathForCell:(UITableViewCell *)sender.superview.superview];
        
        EtechMassage *objMsg = [arrMessages objectAtIndex:indexPath.row];
        
        NSString *parentDetail;
        
        if ([objMsg.parent isEqualToString:@"1"]) {
            parentDetail = [studDetail valueForKey:@"parent1mobile"];
        }
        else if ([objMsg.parent isEqualToString:@"2"]) {
            parentDetail = [studDetail valueForKey:@"parent2mobile"];
        }
        else {
            parentDetail = [studDetail valueForKey:@"parent3mobile"];
        }
        
        number = [NSString stringWithFormat:@"+47%@",parentDetail];
        NSMutableArray *arrBtn = [[NSMutableArray alloc] initWithObjects:[GeneralUtil getLocalizedText:@"BTN_CALL_TITLE"],[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"], nil];
        CustomIOS7AlertView *aletview = [BaseViewController customAlertDisplay:[NSString stringWithFormat:@"+ 47 %@",parentDetail] Btns:arrBtn];
        aletview.delegate =self;
        [aletview show];
    }
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 1) {
        
    }
    else {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
            // Check if iOS Device supports phone calls
            CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
            CTCarrier *carrier = [netInfo subscriberCellularProvider];
            NSString *mnc = [carrier mobileNetworkCode];
            // User will get an alert error when they will try to make a phone call in airplane mode.
            if (([mnc length] == 0)) {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CALL_NOT_PROVIDE"]];
            } else {
                NSString *num = [NSString stringWithFormat:@"tel:%@",number];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
            }
        } else {
            [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_CALL_NOT_PROVIDE"]];
        }
    }
}

-(void)newMessageReceived:(NSNotification *)notification {
    
    NSLog(@"newMessageReceived > Message Data: %@", notification.object);
    
    NSMutableDictionary *message = (NSMutableDictionary *)notification.object;
    NSString* str= [message objectForKey:@"sender"];

    NSRange range= [str rangeOfString: @"/" options: NSBackwardsSearch];
    
    NSString *sender = @"";
    if(range.location == NSNotFound) {
        
    }
    else {
        sender = [[str substringToIndex: range.location] lowercaseString];
    }

    EtechMassage *objMsg = [[EtechMassage alloc] init];
    objMsg.text = [message objectForKey:@"msg"];
    
    if([[toJId lowercaseString] isEqualToString:sender] && message) {
        objMsg.from = [message objectForKey:@"sender"];
        objMsg.to = appDelegate.curJabberId;
        objMsg.timestamp = [NSDate date];
        objMsg.parent = [message objectForKey:@"parent"];
        
        [arrMessages addObject:objMsg];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrMessages.count-1 inSection:0];
        
        [tblMessages beginUpdates];
        [tblMessages insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [tblMessages endUpdates];
        
        [tblMessages scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else {
        
        ZDebug(@"%@ == %@", appDelegate.curJabberId, sender);
        
        if([[appDelegate.curJabberId lowercaseString] isEqualToString:[sender lowercaseString]]) {
            objMsg.from = appDelegate.curJabberId;
            objMsg.to = [message objectForKey:@"sender"];
            objMsg.timestamp = [NSDate date];
            objMsg.parent = [message objectForKey:@"parent"];
            objMsg.deliveryState = [NSNumber numberWithInteger:-1];
            
            [arrMessages addObject:objMsg];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrMessages.count-1 inSection:0];
            
            [tblMessages beginUpdates];
            [tblMessages insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [tblMessages endUpdates];
            
            [tblMessages scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
//    if(message && [[toJId lowercaseString] isEqualToString:sender]) {
//        EtechMassage *objMsg = [[EtechMassage alloc] init];
//        objMsg.text = [message objectForKey:@"msg"];
//        objMsg.from = [message objectForKey:@"sender"];
//        objMsg.to = appDelegate.curJabberId;
//        objMsg.timestamp = [NSDate date];
//        
//        [arrMessages addObject:objMsg];
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrMessages.count-1 inSection:0];
//        
//        [tblMessages beginUpdates];
//        [tblMessages insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//        [tblMessages endUpdates];
//        
//        [tblMessages scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
}

-(void)typingStatusChanged:(NSNotification *)notification {
    
    NSDictionary *message = (NSMutableDictionary *)notification.object;
    NSString *status= [message objectForKey:@"status"];
    NSString *sender= [message objectForKey:@"from"];
    
    if(status && [[sender lowercaseString] hasPrefix:[toJId lowercaseString]]) {
        
        if([status isEqualToString:@"inactive"]) {
            statusBgView.hidden = YES;
            lblChateStatus.text = status;
            
        }else {
            if ([[sender lowercaseString] isEqualToString:[toJId lowercaseString]]) {
                
            }
            else {
                statusBgView.hidden = NO;
                lblChateStatus.text = [GeneralUtil getLocalizedText:@"LBL_STANSA_STATUS_TITLE"];
            }
        }
    }
}

-(void)typingPausedChanged:(NSNotification *)notification {
    
    NSDictionary *message = (NSMutableDictionary *)notification.object;
    NSString *status= [message objectForKey:@"status"];
    NSString *sender= [message objectForKey:@"from"];
    
    if(status && [[sender lowercaseString] hasPrefix:[toJId lowercaseString]]) {
        
        if([status isEqualToString:@"inactive"]) {
            statusBgView.hidden = YES;
            lblChateStatus.text = status;
            
        }else {
            if ([[sender lowercaseString] isEqualToString:[toJId lowercaseString]]) {
                
            }
            else {
                statusBgView.hidden = YES;
            }
        }
    }
}

-(void)deliveryStateUpdated:(NSNotification *)notification {
    NSMutableDictionary *message = (NSMutableDictionary *)notification.object;
    NSString *messageId = [message objectForKey:@"message_id"];
    NSNumber *state = [message objectForKey:@"state"];
    if(messageId) {
        NSLog(@"deliveryStateUpdated > state: %d, messageId: %@", [state intValue], messageId);
        
        
        if (arrMessages.count > 0) {
            int msgIndex = -1;
            
            for (int i = (int)arrMessages.count - 1; i > 0; i--) {
                EtechMassage *objMsg = [arrMessages objectAtIndex:i];
                if([objMsg.messageId isEqualToString:messageId]) {
                    msgIndex = i;
                    objMsg.deliveryState = state;
                    [arrMessages replaceObjectAtIndex:i withObject:objMsg];
                }
            }
            
            if(msgIndex >= 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:msgIndex inSection:0];
                SendMessageTableViewCell *cell = (SendMessageTableViewCell *)[tblMessages cellForRowAtIndexPath:indexPath];
                
                if([state intValue] == 1)
                    cell.lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_SEEN_TITLE"];
                else
                    cell.lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_UNSEEN_TITLE"];
            }
        }
    }
}

-(void)ConnectingChanged:(NSNotification *)notification {

    NSMutableDictionary *connect = (NSMutableDictionary *)notification.object;
    
    NSNumber *numObj = [connect valueForKey:@"is_Connected"];
    if ([numObj boolValue]) {
        statusBgView.hidden = YES;
    }
    else {
        statusBgView.hidden = NO;
        [doneBtn setUserInteractionEnabled:NO];
        doneBtn.backgroundColor = TEXT_COLOR_GRAY;
        lblChateStatus.text = [GeneralUtil getLocalizedText:@"LBL_CONNECTING_STATUS_TITLE"];
    }

    if (appDelegate.isConnected){
        statusBgView.hidden = YES;
        [doneBtn setUserInteractionEnabled:YES];
        doneBtn.backgroundColor = TEXT_COLOR_CYNA;
        [self loadHistory];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:tblMessages];
    
    NSIndexPath *indexPath = [tblMessages indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}
@end
