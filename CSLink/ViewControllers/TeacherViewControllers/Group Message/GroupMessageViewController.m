//
//  GroupMessageViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/10/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "GroupMessageViewController.h"
#import "SLExpandableTableView.h"
#import "BaseViewController.h"
#import "TeacherConstant.h"
#import "TeacherUser.h"
#import "TeacherNIDropDown.h"
#import "HistoryViewController.h"
#import "IQKeyboardManager.h"

@implementation SLExpandableTableViewControllerHeaderCell

- (NSString *)accessibilityLabel
{
    return self.textLabel.text;
}

- (void)setLoading:(BOOL)loading
{
    if (loading != _loading) {
        _loading = loading;
        [self _updateDetailTextLabel];
    }
}

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated
{
    if (expansionStyle != _expansionStyle) {
        _expansionStyle = expansionStyle;
        [self _updateDetailTextLabel];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _updateDetailTextLabel];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)_updateDetailTextLabel
{
    if (self.isLoading) {
        self.detailTextLabel.text = @"";
    }
    else {
        switch (self.expansionStyle) {
            case UIExpansionStyleExpanded:
                self.detailTextLabel.text = @"";
                break;
            case UIExpansionStyleCollapsed:
                self.detailTextLabel.text = @"";
                break;
        }
    }
}

@end

@interface GroupMessageViewController ()<SLExpandableTableViewDatasource,SLExpandableTableViewDelegate,TeacherNIDropDownDelegate>
{
    int expandingSection,collapsingSection ;
    BOOL needToExpand ;
    
    BOOL flag;
    TeacherUser *userObj;
    
    NSMutableArray *arrStudant;
    NSMutableArray *sectionsArray;
    NSMutableIndexSet *expandableSections;
    
    NSMutableArray *arrFilterSections;
    
    NSMutableArray *arrClass;
    
    NSMutableArray *arrGrade;
    
    NSMutableArray *arrCurrStudDrop;
    NSMutableDictionary *dicCurrentSection;
    
    TeacherNIDropDown *dropDown;
    
    NSArray *arrMsgHistory;
    
    int currentSectionIndex;
    
    NSMutableArray *allSectionCells;
    
    UIButton *btnLarg;
    
    NSMutableArray *arrSelctedStudants;
    UIButton * fakeButton;
    
    HPGrowingTextView *textView;
    UIButton *doneBtn;
    
    CGFloat kOFFSET_FOR_KEYBOARD;
}

@end

@implementation GroupMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userObj = [[TeacherUser alloc] init];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    sectionsArray = [[NSMutableArray alloc] init];
    arrStudant = [[NSMutableArray alloc] init];
    
    arrGrade = [[NSMutableArray alloc] init];
    arrFilterSections = [[NSMutableArray alloc] init];
    
    expandableSections = [NSMutableIndexSet indexSet];
    
   // tblExpandableView.frame = tblStudantAndClass.frame;
    
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_GROUP_MASSAGE"] WithSel:@selector(btnBackClick)];
    
    [BaseViewController formateButtonCyne:btnHistory title:[GeneralUtil getLocalizedText:@"BTN_SEARCH_HISTORY_TITLE"]];
    
    [BaseViewController getDropDownBtn:btnClass withString:[GeneralUtil getLocalizedText:@"BTN_ALL_TITLE"]];
    [BaseViewController setBackGroud:self];
    
    [BaseViewController getRoundRectTextField:txtMassage];
    txtMassage.backgroundColor = [UIColor whiteColor];
    txtMassage.textColor = [UIColor blackColor];
    txtMassage.font = [UIFont fontWithName:@"System" size:14];
    
    txtMassage.textColor = [UIColor blackColor];
    txtMassage.placeholder = [GeneralUtil getLocalizedText:@"TXT_PLC_MESSAGE_TYPE_HERE"];
    
    txtMassage.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtMassage.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    [BaseViewController formateButtonCyne:btnSend title:[GeneralUtil getLocalizedText:@"BTN_SEND_TITLE"] withIcon:@"send" withBgColor:TEXT_COLOR_CYNA];
    
    [btnDone setTitle:[GeneralUtil getLocalizedText:@"BTN_DONE_TITLE"] forState:UIControlStateNormal];
    
    lblInformation.font = FONT_18_BOLD;
    lblInformation.textColor = TEXT_COLOR_WHITE;
    
    lblSelectAll.textColor = TEXT_COLOR_LIGHT_GREEN;
    lblGrade.textColor = TEXT_COLOR_LIGHT_GREEN;
    
    lblSelectAll.font = FONT_18_BOLD;
    lblGrade.font = FONT_18_BOLD;
    
    lblGrade.text = [GeneralUtil getLocalizedText:@"LBL_GRADE_TITLE"];
    lblInformation.text = [GeneralUtil getLocalizedText:@"LBL_GROUP_INGO_MSG_TITLE"];
    lblSelectAll.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_ALL_TITLE"];
    
    [tblExpandableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    
    [btnSelectAll setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [btnSelectAll setImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateSelected];
    
    [self getTeacherClass];
    
    bottomView.backgroundColor = [UIColor clearColor];
    
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
    
    [textView setInputAccessoryView:inputView];
    
    [self.view addSubview:bottomView];
    [bottomView addSubview:textView];
    
    doneBtn = btnSend;
   // doneBtn.frame = CGRectMake(ScreenWidth - 87, bottomViewHeight.constant - 44, 80, 33);
    
    [doneBtn addTarget:self action:@selector(btnSendPress:) forControlEvents:UIControlEventTouchUpInside];
   // [bottomView addSubview:doneBtn];
    
    if (IS_IPAD) {
        
        textView.frame = CGRectMake(6, 10, ScreenWidth - 150, 45);
        // doneBtn.frame = CGRectMake(ScreenWidth - 130, heightOfContaintView.constant - 51, 120, 45);
    }
    else {
        textView.frame = CGRectMake(6, 8, ScreenWidth - 100, 35);
        // doneBtn.frame = CGRectMake(ScreenWidth - 87, heightOfContaintView.constant - 42, 80, 33);
    }
    
    [BaseViewController formateButtonCyne:doneBtn title:[GeneralUtil getLocalizedText:@"BTN_SEND_TITLE"] withIcon:@"send" withBgColor:TEXT_COLOR_CYNA];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)];
//    
//    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)resignTextView
{
    [textView resignFirstResponder];
    //  heightOfTableView.constant = tblOriHeight;
    
//    if (isCallLive) {
//        heightOfTableView.constant = tblOriHeight - statusBarHeight - changeHeight;
//    }
//    else {
//        heightOfTableView.constant = tblOriHeight - changeHeight;
//    }
}

-(void)btnBackClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
  //  CGRect r = bottomView.frame;
    bottomViewHeight.constant -= diff;
  //  r.origin.y += diff;
  //  bottomView.frame = r;
}

-(void)keyboardWillShow:(NSNotification *)note {
    
    
   // if (bottomSpace.constant == 0) {
        
        NSLog(@"note.userInfo: %@", note.userInfo);
        
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        
        kOFFSET_FOR_KEYBOARD = keyboardBounds.size.height;
        
        NSLog(@"kOFFSET_FOR_KEYBOARD: %f", kOFFSET_FOR_KEYBOARD);
        NSLog(@"kOFFSET_FOR_KEYBOARD: %f", bottomSpace.constant);
        
        bottomSpace.constant = kOFFSET_FOR_KEYBOARD;
        
        NSLog(@"kOFFSET_FOR_KEYBOARD: %f", bottomSpace.constant);
    //}
}

-(void)keyboardWillHide:(NSNotification *)note {
    
    [self.view layoutIfNeeded];
    bottomSpace.constant = 0;
    kOFFSET_FOR_KEYBOARD = 0;
    
    ZDebug(@"%@", NSStringFromCGRect(bottomView.frame));
    
    // or
    
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

-(void)getTeacherClass {
    
    [userObj getTeacherClass:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                NSArray *arrTemp  = [[dicRes valueForKey:@"grades"] valueForKey:@"grades"];
                arrClass = [[dicRes valueForKey:@"classes"] valueForKey:@"classes"];
                
                for (NSString  *grade in arrTemp) {
                    [arrGrade addObject:grade];
                }
                
                [arrGrade insertObject:[GeneralUtil getLocalizedText:@"BTN_ALL_TITLE"] atIndex:0];
                
                [self getRequestStudList];
            }
            else {
                [GeneralUtil hideProgress];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)getRequestStudList {
    
    [userObj getRequestStudantList:[GeneralUtil getUserPreference:key_schoolId] teacherId:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            arrStudant = [dicRes valueForKey:@"allStudents"];
            [arrFilterSections removeAllObjects];
            
            for (NSDictionary *dicValue in arrClass) {
                
                NSMutableDictionary *dicClass = [[NSMutableDictionary alloc] init];
                [dicClass setObject:[dicValue valueForKey:@"class_name"] forKey:@"name"];
                [dicClass setObject:@"0" forKey:@"selected"];
                [dicClass setObject:[dicValue valueForKey:@"class_id"] forKey:@"class_id"];
                [dicClass setObject:[[NSMutableArray alloc] init] forKey:@"Studant"];
                [dicClass setObject:[dicValue valueForKey:@"grade"] forKey:@"grade"];
                [sectionsArray addObject:dicClass];
            }
            
            for (NSDictionary *dicCls in sectionsArray) {
                [arrFilterSections addObject:dicCls];
            }
            [tblExpandableView reloadData];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}


#pragma mark - SLExpandableTableViewDatasource

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"SLExpandableTableViewControllerHeaderCell";
    SLExpandableTableViewControllerHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblClassName;
    UIButton *btnDropDown,*btnCheck;
    UIView *seperator;

    if (!cell) {
        cell = [[SLExpandableTableViewControllerHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        lblClassName = [BaseViewController  getRowDetailLable:200 text:@""];
        lblClassName.textColor = TEXT_COLOR_LIGHT_GREEN;
        lblClassName.font = FONT_18_BOLD;
        lblClassName.frame = CGRectMake(25, 0, lblClassName.frame.size.width, 40);
        lblClassName.tag = 300;
        
        btnDropDown = [[UIButton alloc] initWithFrame:CGRectMake(lblClassName.frame.size.width, 0, 40, 40)];
        [btnDropDown setImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
        [btnDropDown addTarget:self action:@selector(btnClassPress:) forControlEvents:UIControlEventTouchUpInside];
        btnDropDown.tag = 100;
        
        btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 10, 25, 25)];
        [btnCheck addTarget:self action:@selector(btnCheckPress:) forControlEvents:UIControlEventTouchUpInside];
        [btnCheck setImage:[UIImage imageNamed:@"check-green"] forState:UIControlStateSelected];
        [btnCheck setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        btnCheck.tag = 500;
        
        seperator = [[UIView alloc] initWithFrame:CGRectMake(25, 49, ScreenWidth, 1)];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        [cell.contentView addSubview:seperator];
        [cell.contentView addSubview:lblClassName];
        [cell.contentView addSubview:btnDropDown];
        [cell.contentView addSubview:btnCheck];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        
        lblClassName = (UILabel *)[cell.contentView viewWithTag:300];
        btnDropDown = (UIButton *)[cell.contentView viewWithTag:100];
        btnCheck = (UIButton *)[cell.contentView viewWithTag:500];
    }
    
    NSDictionary *dicClass = [arrFilterSections objectAtIndex:section];
    
    lblClassName.text = [dicClass valueForKey:@"name"];
    
    NSString *strName = [dicClass valueForKey:@"name"];
    
    CGSize maximumSize = CGSizeMake(200, CGFLOAT_MAX);
    
    CGSize expectedLabelSize = [strName sizeWithFont:lblClassName.font
                                      constrainedToSize:maximumSize
                                          lineBreakMode:lblClassName.lineBreakMode];
    
    
    lblClassName.frame = CGRectMake(25, 0, expectedLabelSize.width, 40);
    
    btnDropDown.frame = CGRectMake(25 + lblClassName.frame.size.width + 10, 0, 40, 40);
    
    if ([[dicClass valueForKey:@"selected"] isEqualToString:@"1"]) {
        [btnCheck setSelected:YES];
    }
    else {
        [btnCheck setSelected:NO];
    }
    
//    NSDictionary *dicClass = [sectionsArray objectAtIndex:section];
//    
//    cell.textLabel.text = [dicClass valueForKey:@"name"];//[NSString stringWithFormat:@"Section %ld", (long)section];
    
    return cell;
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    [expandableSections addIndex:section];
    [tableView expandSection:section animated:YES];
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
    [expandableSections removeIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section > 0) {
//        
//    }
    
    if (indexPath.row == 0) {
        return 60;
    }
    else {
        return 50;
    }
    //return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrFilterSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataArray = [[arrFilterSections objectAtIndex:section] valueForKey:@"Studant"];
    return dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblStudantName;
    UIButton *btnCheck;
    UIView *seperator;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        lblStudantName = [BaseViewController  getRowDetailLable:250 text:@""];
        lblStudantName.textColor = TEXT_COLOR_WHITE;
        lblStudantName.font = FONT_18_SEMIBOLD;
        lblStudantName.frame = CGRectMake(30, 0, lblStudantName.frame.size.width, 40);
        lblStudantName.tag = 700;
        
        btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 10, 20, 20)];
        [btnCheck setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [btnCheck addTarget:self action:@selector(btnDeletePress:) forControlEvents:UIControlEventTouchUpInside];
        btnCheck.tag = indexPath.row;
        
        seperator = [[UIView alloc] initWithFrame:CGRectMake(25, 49, ScreenWidth, 1)];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        [cell.contentView addSubview:seperator];
        [cell.contentView addSubview:lblStudantName];
        [cell.contentView addSubview:btnCheck];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        
        lblStudantName = (UILabel *)[cell.contentView viewWithTag:700];
        btnCheck = (UIButton *)[cell.contentView viewWithTag:indexPath.row];
        
    }
    NSArray *dataArray = [[arrFilterSections objectAtIndex:indexPath.section] valueForKey:@"Studant"];
    
    lblStudantName.text = [[dataArray objectAtIndex:indexPath.row - 1] valueForKey:@"name"];
    
    ZDebug(@"%@", [[dataArray objectAtIndex:indexPath.row - 1] valueForKey:@"name"]);
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [arrFilterSections removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)btnCheckPress:(UIButton *)sender {
    
    [textView resignFirstResponder];
    
    sender.selected = !sender.selected;
    
    if (btnSelectAll.selected) {
        btnSelectAll.selected = NO;
    }
    
    NSIndexPath *indexPath = [tblExpandableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    
    if ([[[arrFilterSections objectAtIndex:indexPath.section] valueForKey:@"selected"] isEqualToString:@"1"]) {
        [[arrFilterSections objectAtIndex:indexPath.section] setObject:@"0" forKey:@"selected"];
    }
    else{
        
        [[arrFilterSections objectAtIndex:indexPath.section] setObject:@"1" forKey:@"selected"];
        
        int count =  [[[arrFilterSections objectAtIndex:indexPath.section] valueForKey:@"Studant"] count];
        
        NSMutableArray *allCell = [[NSMutableArray alloc] init];
        for (int i=1 ; i<= count; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            [allCell addObject:path];
        }
        [[[arrFilterSections objectAtIndex:indexPath.section] valueForKey:@"Studant"] removeAllObjects];
        [tblExpandableView deleteRowsAtIndexPaths:(NSArray *)allCell withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(void)btnDeletePress:(UIButton *)sender {
    
    NSIndexPath *indexPath = [tblExpandableView indexPathForCell:(UITableViewCell *)sender.superview.superview];

    [[[arrFilterSections objectAtIndex:indexPath.section] objectForKey:@"Studant"] removeObjectAtIndex:indexPath.row - 1];
    [tblExpandableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (IBAction)btnClassPress:(UIButton*)sender {
    
    [textView resignFirstResponder];
    
    ZDebug(@"%d", sender.tag);
    
    NSIndexPath *indexPath = [tblExpandableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    
    if ([[[arrFilterSections objectAtIndex:indexPath.section] valueForKey:@"selected"] isEqualToString:@"0"]) {
        
        dicCurrentSection = [arrFilterSections objectAtIndex:indexPath.section];
        currentSectionIndex = indexPath.section;
        
        NSMutableArray *studantList = [[NSMutableArray alloc] init];
    
        arrCurrStudDrop = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dicstud in arrStudant) {
            
            if ([[dicstud valueForKey:@"class_name"] isEqualToString:
                 [dicCurrentSection valueForKey:@"name"]]) {
                
                [arrCurrStudDrop addObject:dicstud];
                [studantList addObject:[dicstud valueForKey:@"name"]];
            }
        }
        
        CGPoint originInSuperview = [self.view convertPoint:CGPointZero fromView:sender];
        
        fakeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, originInSuperview.y, ScreenWidth - 20, 40)];
        [fakeButton addTarget:self action:@selector(btnLargePress) forControlEvents:UIControlEventTouchUpInside];
        fakeButton.tag = 777;
        fakeButton.hidden = NO;
        
        btnLarg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [btnLarg addTarget:self action:@selector(btnLargePress) forControlEvents:UIControlEventTouchUpInside];
        btnLarg.tag = 2000;
        btnLarg.hidden = NO;
       // btnLarg.backgroundColor = [UIColor colorWithRed:(CGFloat)0/255 green:(CGFloat)255/255 blue:(CGFloat)185/255 alpha:0.5];
        
        [self.view addSubview:btnLarg];
        [self.view addSubview:fakeButton];
        
        if(dropDown == nil) {
            
            CGFloat f;
            if (IS_IPAD) {
                f = [studantList count] * 50;
            }
            else {
                f = [studantList count] * 40;
            }
            
            if (f > ScreenHeight / 2) {
                f = (ScreenHeight) / 2;
                f = f - 50;
            }
            
            NSString *direction = @"down";
            
            
            if (originInSuperview.y > ScreenHeight / 2) {
                direction = @"up";
                f = (ScreenHeight) / 2;
                f = f - 50;
            }
            
            NSMutableArray *selectedStudantList = [[NSMutableArray alloc] init];
            
            if ([[dicCurrentSection objectForKey:@"Studant"]  count] > 0) {
                for (NSDictionary *dicstud in [dicCurrentSection objectForKey:@"Studant"]) {
                    [selectedStudantList addObject:[dicstud valueForKey:@"name"]];
                }
                [[dicCurrentSection objectForKey:@"Studant"]  removeAllObjects];
            }
            dropDown = [[TeacherNIDropDown alloc] showDropDown:fakeButton :&f :(NSArray *)studantList :nil :direction withSelect:NO withSelectedData:(NSArray *)selectedStudantList];
            dropDown.delegate = self;
            dropDown.tag  = 1;
        }
        else {
            [dropDown hideDropDown:sender];
            dropDown = nil;
        }
    }
    else{
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ALL_STUDANT_SELECTED"]];
    }
}

-(void)btnLargePress {
    
    [dropDown hideDropDown:fakeButton];
    [fakeButton removeFromSuperview];
    [btnLarg removeFromSuperview];
    
    arrSelctedStudants = dropDown.arrSelectValue;
    
   // NSIndexSet *studentIndexes = [arrSelctedStudants indexesOfObjectsPassingTest:^(id obj,NSUInteger idx, BOOL stop) { return [obj intValue];}];
    
    for (NSString *index in arrSelctedStudants) {
        NSDictionary *dicValue = [arrCurrStudDrop objectAtIndex:[index intValue]];
        if (![[dicCurrentSection objectForKey:@"Studant"] containsObject:dicValue]) {
            [[dicCurrentSection objectForKey:@"Studant"] addObject:dicValue];
        }
    }
    [tblExpandableView expandSection:currentSectionIndex animated:YES];
    [tblExpandableView reloadDataAndResetExpansionStates:NO];
    
    
    // mark
    [[arrFilterSections objectAtIndex:currentSectionIndex] setObject:@"1" forKey:@"expanded"];
    
    dropDown = nil;
}

- (IBAction)btnSelectAll:(UIButton *)sender {
    
    [textView resignFirstResponder];
    
    [dropDown hideDropDown:btnClass];
    
    if (!sender.selected) {
        for (int i =0 ; i < [arrFilterSections count]; i++) {
            [[arrFilterSections objectAtIndex:i] setObject:@"1" forKey:@"selected"];
            [[[arrFilterSections objectAtIndex:i] valueForKey:@"Studant"] removeAllObjects];
        }
        sender.selected = !sender.selected;
    }
    else {
        for (int i =0 ; i < [arrFilterSections count]; i++) {
            [[arrFilterSections objectAtIndex:i] setObject:@"0" forKey:@"selected"];
        }
        sender.selected = !sender.selected;
    }
    
    [tblExpandableView reloadDataAndResetExpansionStates:YES];
}

- (IBAction)btnSendPress:(id)sender {
    
    [dropDown hideDropDown:btnClass];
    
    [textView resignFirstResponder];
    
    NSString *claId = @"";
    NSString *studId = @"";
    
    NSString *tempClaId;
    
   // NSArray *dtail = sectionsArray;
    
    for (NSDictionary *dicValue in arrFilterSections) {
        
        if ([[dicValue valueForKey:@"selected"] isEqualToString:@"1"]) {
            tempClaId = [dicValue valueForKey:@"class_id"];
            claId = [claId stringByAppendingFormat:@"%@,",[dicValue valueForKey:@"class_id"]];
        }
        else if ([[dicValue valueForKey:@"selected"] isEqualToString:@"0"]) {
        
            for (NSDictionary *dicVal in [dicValue valueForKey:@"Studant"]) {
                studId = [studId stringByAppendingFormat:@"%@,",[dicVal valueForKey:@"user_id"]];
                claId = [claId stringByAppendingFormat:@"%@,",[dicValue valueForKey:@"class_id"]];
            }
        }
    }
 
    ZDebug(@"Class ID :%@", claId);
    ZDebug(@"stud ID :%@", studId);
    ZDebug(@"stud ID :%@", textView.text);
    
    if ([claId isEqualToString:@""] && [studId isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_ANY_STUDANT_OR_CLASS" ]];
    }
    else if ([textView.text isEqualToString:@""]) {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_ENTER_MESSAGE" ]];
    }
    else {
        
//        if ([studId isEqualToString:@""]) {
//            for (NSDictionary *stud in arrStudant) {
//                
//                if ([[stud valueForKey:@"class_id"] isEqualToString:tempClaId]) {
//                    studId = [stud valueForKey:@"user_id"];
//                    break;
//                }
//            }
//        }
        
        NSString *tempMsg = textView.text;
        NSString *orMsg = [tempMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [userObj sendMessageToStudant:[GeneralUtil getUserPreference:key_teacherId] classId:claId studId:studId message:orMsg :^(NSObject *resObj) {
            
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                
                if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_GROUP_MESSAGE_SEND_SUCCESS"]];
                    textView.text = @"";
                }
                else {
                    [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_INTERNAL_SERVER_ERROR"]];
                }
            }
            else {
                NSLog(@"Request Fail...");
            }
        }];
    }
}

- (IBAction)btnDonePress:(id)sender {
    
    [textView resignFirstResponder];
}

- (void)niDropDownDelegateMethod: (TeacherNIDropDown *)sender {
    
    if (sender.tag == 1) {
        
        [fakeButton removeFromSuperview];
        [btnLarg removeFromSuperview];
        dropDown = nil;
        
        NSDictionary *dicValue = [arrCurrStudDrop objectAtIndex:sender.index];
        if (![[dicCurrentSection objectForKey:@"Studant"] containsObject:dicValue]) {
            [[dicCurrentSection objectForKey:@"Studant"] addObject:dicValue];
            [tblExpandableView expandSection:currentSectionIndex animated:YES];
            [tblExpandableView reloadDataAndResetExpansionStates:NO];
        }
        
        [dropDown hideDropDown:fakeButton];
    }
    
    if (sender.tag == 2) {
        
        NSString *selectedClass = [arrGrade objectAtIndex:sender.index];
        [arrFilterSections removeAllObjects];
        
        for (NSDictionary *dicValue in sectionsArray) {
            
            NSString *cid = [dicValue valueForKey:@"grade"];
            
            if ([cid isEqualToString:selectedClass]) {
                [arrFilterSections addObject:dicValue];
            }
            else if ([selectedClass isEqualToString:[GeneralUtil getLocalizedText:@"BTN_ALL_TITLE"]]) {
                [arrFilterSections addObject:dicValue];
            }
        }
        
        [tblExpandableView reloadDataAndResetExpansionStates:NO];
        
        for (int i = 0; i < [arrFilterSections count]; i++) {
            //int count =  [[dicValue valueForKey:@"Studant"] count];
            //if (count > 0) {
                [tblExpandableView expandSection:i animated:NO];
            //}
        }
        //[[arrFilterSections objectAtIndex:currentSectionIndex] setObject:@"1" forKey:@"expanded"];
    }
    
    dropDown = nil;
}

- (IBAction)btnHistoryPress:(id)sender {
    
    [textView resignFirstResponder];
    
    [dropDown hideDropDown:btnClass];
    
    [userObj getTeacherMsgHistory:[GeneralUtil getUserPreference:key_teacherId] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            arrMsgHistory = [[dicRes valueForKey:@"messages"] valueForKey:@"received"];
            
            if ([arrMsgHistory count] > 0) {
                HistoryViewController *custompopup = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil andDate:arrMsgHistory];
                custompopup.delegate = self;
                [self presentPopupViewController:custompopup animationType:MJPopupViewAnimationFade];
            }
            else {
                [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_NO_ANY_HISTORY"]];
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(IBAction)btnGradePress:(UIButton *)sender {

    [textView resignFirstResponder];
    
    if(dropDown == nil) {
        
        CGFloat f;
        if (IS_IPAD) {
            f = [arrGrade count] * 50;
        }
        else {
            f = [arrGrade count] * 40;
        }
        
        if (f > 200) {
            f = 200;
        }
        
        sender.tag = 8;
        
        dropDown = [[TeacherNIDropDown alloc] showDropDown:sender :&f :(NSArray *)arrGrade :nil :@"down"];
        dropDown.delegate = self;
        dropDown.tag  = 2;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

-(void)selectedValue:(NSString *)Message {

    textView.text = Message;
}
@end
