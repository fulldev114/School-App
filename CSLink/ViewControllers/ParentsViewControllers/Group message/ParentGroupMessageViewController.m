//
//  GroupMessageViewController.m
//  CSLink
//
//  Created by etech-dev on 6/27/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentGroupMessageViewController.h"
#import "BaseViewController.h"
#import "ParentgroupcellTableViewCell.h"

@interface ParentGroupMessageViewController ()
{
    ParentUser *userObj;
    NSMutableArray *arrMessage;
    CGSize contentSize;
}
@end

@implementation ParentGroupMessageViewController
@synthesize tblMessage;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.demoData = [[Teacher alloc] init];
    
    userObj = [[ParentUser alloc] init];
    arrMessage = [[NSMutableArray alloc] init];
    
    
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_GROUP_MESSAGE"] WithSel:@selector(btnBackClick)];
    [BaseViewController setBackGroud:self];
    
    UIImageView *selectedStud = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    selectedStud.contentMode = UIViewContentModeScaleAspectFit;
    
    [BaseViewController setRoudRectImage:selectedStud];
    [selectedStud setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithCustomView:selectedStud];
    
    self.navigationItem.rightBarButtonItem = btnRight;
    
    tblMessage.rowHeight = UITableViewAutomaticDimension;
    
    if (IS_IPAD) {
        tblMessage.estimatedRowHeight = 80.0;
    }
    else {
        tblMessage.estimatedRowHeight = 60.0;
    }
    //[self getMessageOfTeacher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [self getMessageOfTeacher];
    [GeneralUtil clearBadge:[appDelegate getCurrentChildId] badgeType:key_abi_badge];
}

-(void)btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getMessageOfTeacher {
    
    [userObj getAbsentNoticeList:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] isAbFlag:@"0" :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            arrMessage = [[dicRes valueForKey:@"All Messages"] valueForKey:@"received"];
            
//            self.demoData.messages = [[NSMutableArray alloc] init];
//            
//            JSQMessagesAvatarImageFactory *avatarFactory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
//            
//            for (NSDictionary *techDetail in arrMessage) {
//                
//                NSString *dateStr = [techDetail valueForKey:@"created_at"];
//                
//                JSQMessagesAvatarImage *jobsImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"profile"]];
//                
//                self.demoData.avatars = @{ [techDetail valueForKey:@"teacher_id"] : jobsImage};
//                
//                // Convert string to date object
//                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//                [dateFormat setDateFormat:@"yyyy-dd-mm HH:mm:ss"];
//                NSDate *date = [dateFormat dateFromString:dateStr];
//                
//                [self.demoData.messages addObject:[[JSQMessage alloc] initWithSenderId:[techDetail valueForKey:@"teacher_id"]
//                                                                     senderDisplayName:[techDetail valueForKey:@"fromname"]
//                                                                                  date:date
//                                                                                  text:[techDetail valueForKey:@"mm.message_desc"]]];
//            }
//            [self.collectionView reloadData];
            
            
            
            [tblMessage reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(CGSize)getSizeOfContent:(NSString *)text {

//    CGSize maximumSize = CGSizeMake(SCREEN_WIDTH -100, 2000);
//  //  NSString *myString = @"This is a long string which wraps";
//  //  UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:14];
//    CGSize myStringSize = [text sizeWithFont:FONT_16_REGULER
//                               constrainedToSize:maximumSize
//                                   lineBreakMode:NSLineBreakByWordWrapping];
//    
//    return myStringSize;
    
    CGSize maximumSize = CGSizeMake(SCREEN_WIDTH - 100, 2000);
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT_16_REGULER};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect myStringSize = [text boundingRectWithSize:maximumSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
    return myStringSize.size;
}

-(CGSize)getSizeOfContent:(NSString *)text andFont:(UIFont*)font {
    
    CGSize maximumSize = CGSizeMake(SCREEN_WIDTH - 100, 2000);
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect myStringSize = [text boundingRectWithSize:maximumSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    return myStringSize.size;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrMessage.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
//    CGSize size = [self getSizeOfContent:[[arrMessage objectAtIndex:indexPath.row] valueForKey:@"mm.message_desc"]];
//    contentSize = size;
//   
//    return size.height + 60 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ParentgroupcellTableViewCell";
    
    ParentgroupcellTableViewCell *cell = (ParentgroupcellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ParentgroupcellTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *image = [UIImage imageNamed:@"ssender-bg_blue"];
        UIEdgeInsets edgeInsets;
        edgeInsets.left = 40.0f;
        edgeInsets.top = 20.0f;
        edgeInsets.right = 20.0f;
        edgeInsets.bottom = 20.0f;
        
        cell.imgBackgroud.image = [image resizableImageWithCapInsets:edgeInsets];
        
        //cell.imgBackgroud.backgroundColor = [UIColor yellowColor];
    }
    
    NSDictionary *dicStudantDetail = [arrMessage objectAtIndex:indexPath.row];
    
    if (indexPath.row - 1 >= 0) {
        
        if ([[dicStudantDetail valueForKey:@"teacher_id"] isEqualToString:[[arrMessage objectAtIndex:indexPath.row -1] valueForKey:@"teacher_id"]]) {
            cell.heightOfUserlable.constant = 0;
            cell.profileImg.hidden = YES;
            cell.lblUserName.hidden = YES;
        }
        else {
            cell.heightOfUserlable.constant = 20;
            cell.profileImg.hidden = NO;
            cell.lblUserName.hidden = NO;
            cell.lblUserName.text = [dicStudantDetail valueForKey:@"fromname"];
            [cell.profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
        }
    }
    else {
        cell.heightOfUserlable.constant = 20;
        cell.profileImg.hidden = NO;
        cell.lblUserName.hidden = NO;
        cell.lblUserName.text = [dicStudantDetail valueForKey:@"fromname"];
        [cell.profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    }
    
    cell.lblContent.text = [dicStudantDetail valueForKey:@"mm.message_desc"];
    cell.lblDate.text = [GeneralUtil formateData:[dicStudantDetail valueForKey:@"created_at"]];
    
    [cell.lblContent sizeToFit];
    CGSize size = [self getSizeOfContent:cell.lblContent.text];
    
    [cell.lblUserName sizeToFit];
    CGSize userSize = [self getSizeOfContent:cell.lblUserName.text andFont:FONT_16_BOLD];
    
    ZDebug(@"===> %@, %@, %@",[dicStudantDetail valueForKey:@"fromname"],NSStringFromCGSize(size),NSStringFromCGSize(userSize) );
    
    if (size.width < userSize.width) {
        size = userSize;
    }
    
    ZDebug(@">>> %@, %@, %@",[dicStudantDetail valueForKey:@"fromname"],NSStringFromCGSize(size),NSStringFromCGSize(userSize) );
    
    if (IS_IPAD) {
        if (size.width < 300) {
            cell.widthOfBubble.constant = 300;
        }
        else {
            cell.widthOfBubble.constant = size.width;
        }
    }
    else {
        if (size.width < 150) {
            cell.widthOfBubble.constant = 150;
        }
        else {
            cell.widthOfBubble.constant = size.width;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // NSDictionary *dicStudantDetail = [arrMessage objectAtIndex:indexPath.row];
}

/*

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
 
    self.collectionView.collectionViewLayout.springinessEnabled = [NSUserDefaults springinessSetting];
}


//- (void)didPressSendButton:(UIButton *)button
//           withMessageText:(NSString *)text
//                  senderId:(NSString *)senderId
//         senderDisplayName:(NSString *)senderDisplayName
//                      date:(NSDate *)date
//{
//    /**
//     *  Sending a message. Your implementation of this method should do *at least* the following:
//     *
//     *  1. Play sound (optional)
//     *  2. Add new id<JSQMessageData> object to your data source
//     *  3. Call `finishSendingMessage`
//     */
//    
//    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
//    
//
//    [JSQSystemSoundPlayer jsq_playMessageSentSound];
//
//    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
//                                         senderDisplayName:senderDisplayName
//                                                      date:date
//                                                      text:text];
//
//    [self.demoData.messages addObject:message];
//
//    [self finishSendingMessageAnimated:YES];
//}

//- (void)didPressAccessoryButton:(UIButton *)sender
//{
//    [self.inputToolbar.contentView.textView resignFirstResponder];
//    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Media messages", nil)
//                                                       delegate:self
//                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:NSLocalizedString(@"Send photo", nil), NSLocalizedString(@"Send location", nil), NSLocalizedString(@"Send video", nil), NSLocalizedString(@"Send audio", nil), nil];
//    
//    [sheet showFromToolbar:self.inputToolbar];
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        [self.inputToolbar.contentView.textView becomeFirstResponder];
//        return;
//    }
//    
//    switch (buttonIndex) {
//        case 0:
//            [self.demoData addPhotoMediaMessage];
//            break;
//            
//        case 1:
//        {
//            __weak UICollectionView *weakView = self.collectionView;
//            
//            [self.demoData addLocationMediaMessageCompletion:^{
//                [weakView reloadData];
//            }];
//        }
//            break;
//            
//        case 2:
//            [self.demoData addVideoMediaMessage];
//            break;
//            
//        case 3:
//            [self.demoData addAudioMediaMessage];
//            break;
//    }
//    
//    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
//    
//    [self finishSendingMessageAnimated:YES];
//}


/*
#pragma mark - JSQMessages CollectionView DataSource

- (NSString *)senderId {
    return @"jack";
}

- (NSString *)senderDisplayName {
    return @"jack deep";
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.demoData.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.demoData.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
 
    
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.demoData.outgoingBubbleImageData;
    }
    
    return self.demoData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
//    if ([message.senderId isEqualToString:self.senderId]) {
//        if (![NSUserDefaults outgoingAvatarSetting]) {
//            return nil;
//        }
//    }
//    else {
//        if (![NSUserDefaults incomingAvatarSetting]) {
//            return nil;
//        }
//    }
    
    if (indexPath.item - 1 >= 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    
    NSLog(@"%@",message.senderId);
    return [self.demoData.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     
//    if (indexPath.item % 3 == 0) {
//        JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
//        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
//    }
    
//    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
//    return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     
//    if ([message.senderId isEqualToString:self.senderId]) {
//        return nil;
//    }
    
    if (indexPath.item - 1 >= 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.demoData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     
    
    JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Custom Action", nil)
                                message:nil
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil]
     show];
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     
    JSQMessage *currentMessage = [self.demoData.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods


- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.demoData.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}
*/
@end
