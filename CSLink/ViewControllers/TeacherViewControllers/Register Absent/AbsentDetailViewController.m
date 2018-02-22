//
//  AbsentDetailViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/14/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "AbsentDetailViewController.h"
#import "TeacherConstant.h"
#import "BaseViewController.h"
#import "GroupMessageViewController.h"


@interface AbsentDetailViewController ()
{
    int expandingSection,collapsingSection ;
    BOOL needToExpand ;
    
    int flag;
    TeacherUser *userObj;
    
    NSMutableArray *arrStudant;
    NSMutableArray *sectionsArray;
    NSMutableIndexSet *expandableSections;
    
    NSDictionary *AllDetail;
    
    int currentSectionIndex;
    
    UILabel *lblResone;
    NSString *strResone;
}
@end

@implementation AbsentDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(id)obj {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    AllDetail = (NSDictionary *)obj;
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
    }
    return self;
}

- (IBAction)btnDonePress:(id)sender {
    
    //NSDictionary *studantDetail = [AllDetail valueForKey:@"studants"];
    /*
    for (NSDictionary *changedValue in sectionsArray) {
        
        for (int i =  1; i< [[AllDetail valueForKey:@"arrAbsentStud"] count] + [[AllDetail valueForKey:@"arrPnoticeStud"] count] ; i++) {
            
            NSMutableDictionary *lectureDetail = [[NSMutableDictionary alloc] init];
            
            
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"attend"];
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"date"];
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"image"];
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"lecture_no"];
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"name"];
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"period_id"];
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"subject_id"];
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"teacher_id"];
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"reason"];
            [lectureDetail setObject:<#(nonnull id)#> forKey:@"user_id"];
            
            if ([[changedValue valueForKey:@"lecture_no"] intValue] == [[dicAbsentDetail valueForKey:@"lecture_no"] intValue] && [[changedValue valueForKey:@"selected"] intValue] == 1) {
                
                break;
            }
        }
        for (NSDictionary *dicAbsentDetail in  [AllDetail valueForKey:@"arrPnoticeStud"]) {
            
        }
    }
    
    for ( NSDictionary *dicAbsentDetail in  [AllDetail valueForKey:@"arrAbsentStud"]) {
       if ([[studantDetail valueForKey:@"user_id"] isEqualToString:[dicAbsentDetail valueForKey:@"user_id"]] && [[dicAbsentDetail valueForKey:@"lecture_no"] intValue] == [[sectionsArray valueForKey:@"lecture_no"] intValue]) {
            if()
            [dicClass setObject:@"1" forKey:@"selected"];
        }
        */
    //}
    /*
    for ( NSDictionary *dicAbsentDetail in  [AllDetail valueForKey:@"arrPnoticeStud"]) {
        if ([[studantDetail valueForKey:@"user_id"] isEqualToString:[dicAbsentDetail valueForKey:@"user_id"]] && [[dicAbsentDetail valueForKey:@"lecture_no"] intValue] == [[dicValue valueForKey:@"lecture_no"] intValue]) {
            [dicClass setObject:@"2" forKey:@"selected"];
        }
    }
    */

    NSMutableDictionary *changedValue = [[NSMutableDictionary alloc] init];
    [changedValue setObject:lblResone.text forKey:@"reason"];
    [changedValue setObject:sectionsArray  forKey:@"changeValue"];
    [self.delegate Done:changedValue];
    
    [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (IBAction)btnCancelPress:(id)sender {
    
    [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (IBAction)btnCheckFullDay:(id)sender {
    
    if (flag == 1) {
        [btnCheckFull setImage:[UIImage imageNamed:@"absent-yellow"] forState:UIControlStateNormal];
        
        for (int i =0 ; i < [sectionsArray count]; i++) {
            [[sectionsArray objectAtIndex:i] setObject:@"2" forKey:@"selected"];
        }
        flag = 2;
    }
    else if (flag == 2) {
        [btnCheckFull setImage:[UIImage imageNamed:@"absent-red"] forState:UIControlStateNormal];
        for (int i =0 ; i < [sectionsArray count]; i++) {
            [[sectionsArray objectAtIndex:i] setObject:@"1" forKey:@"selected"];
        }
        flag = 0;
    }
    else {
        [btnCheckFull setImage:[UIImage imageNamed:@"present"] forState:UIControlStateNormal];
        for (int i =0 ; i < [sectionsArray count]; i++) {
            [[sectionsArray objectAtIndex:i] setObject:@"0" forKey:@"selected"];
        }
        flag = 1;
    }
    
    [tblExpandeble reloadDataAndResetExpansionStates:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sectionsArray = [[NSMutableArray alloc] init];
    flag = 1;
    [btnCheckFull setImage:[UIImage imageNamed:@"present"] forState:UIControlStateNormal];
    
    [self setUpUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleView.bounds byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight ) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleView.bounds;
    maskLayer.path  = maskPath.CGPath;
    titleView.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.frame =  titleView.bounds;
    borderLayer.path  = maskPath.CGPath;
    borderLayer.lineWidth   = 1.0f;
    borderLayer.strokeColor = [UIColor clearColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [titleView.layer addSublayer:borderLayer];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self setUpUi];
}

-(void)setUpUi {
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [BaseViewController formateButtonCyne:btnDone title:[GeneralUtil getLocalizedText:@"BTN_REGISTER_AB_DONE_TITLE"]];
    [BaseViewController formateButtonCyne:btnCancel title:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]];
    
    lbluserName.textColor = TEXT_COLOR_WHITE;
    lbluserName.font = FONT_16_BOLD;
    
    
    lblClassName.textColor = TEXT_COLOR_WHITE;
    lblClassName.font = FONT_16_BOLD;
    
    
    lblSelectDay.font = FONT_16_REGULER;
    lblSelectDay.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_FULL_DAY_TITLE"];
    
    [BaseViewController setRoudRectImage:profileImg];
    
    mainView.layer.cornerRadius = 10.0f;
    
    titleView.backgroundColor = TEXT_COLOR_CYNA;
    
    NSDictionary *studantDetail = [AllDetail valueForKey:@"studants"];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[studantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    lbluserName.text = [studantDetail valueForKey:@"name"];
    
    strResone = [AllDetail valueForKey:@"selectedReason"];
    
    for (int i = 0 ; i < [[AllDetail valueForKey:@"allLacture"] count] ; i++ ) {
        
        NSDictionary *dicValue = [[AllDetail valueForKey:@"allLacture"] objectAtIndex:i];
        NSMutableDictionary *dicClass = [[NSMutableDictionary alloc] init];
        
        [dicClass setObject:[dicValue valueForKey:@"lecture_no"] forKey:@"lecture_no"];
        [dicClass setObject:@"0" forKey:@"selected"];
        [dicClass setObject:[dicValue valueForKey:@"time"] forKey:@"time"];
        
        [dicClass setObject:[dicValue valueForKey:@"period_id"] forKey:@"period_id"];
        [dicClass setObject:[studantDetail valueForKey:@"user_id"] forKey:@"user_id"];
        
        for ( NSDictionary *dicAbsentDetail in  [AllDetail valueForKey:@"arrAbsentStud"]) {
            if ([[studantDetail valueForKey:@"user_id"] isEqualToString:[dicAbsentDetail valueForKey:@"user_id"]] && [[dicAbsentDetail valueForKey:@"lecture_no"] intValue] == [[dicValue valueForKey:@"lecture_no"] intValue]) {
                [dicClass setObject:@"1" forKey:@"selected"];
            }
        }
        
        for ( NSDictionary *dicAbsentDetail in  [AllDetail valueForKey:@"arrPnoticeStud"]) {
            if ([[studantDetail valueForKey:@"user_id"] isEqualToString:[dicAbsentDetail valueForKey:@"user_id"]] && [[dicAbsentDetail valueForKey:@"lecture_no"] intValue] == [[dicValue valueForKey:@"lecture_no"] intValue]) {
                [dicClass setObject:@"2" forKey:@"selected"];
            }
        }
        
        [sectionsArray addObject:dicClass];
    }
    
    NSMutableDictionary *dicClass = [[NSMutableDictionary alloc] init];
    [dicClass setObject:[AllDetail valueForKey:@"arrResone"] forKey:@"arrResone"];
    
    [sectionsArray insertObject:dicClass atIndex:0];
    
    [tblExpandeble reloadData];
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
    NSString *CellIdentifier = [NSString stringWithFormat:@"SLExpandableTableViewControllerHeaderCell_%d", (int)section];
    SLExpandableTableViewControllerHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *lblLecture,*lblStatus;
    UIButton *btnDropDown,*btnCheck;
    UIView *seperator;
    
    if (!cell) {
        cell = [[SLExpandableTableViewControllerHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        lblLecture = [BaseViewController  getRowDetailLable:250 text:@""];
        lblLecture.textColor = [UIColor blackColor];
        lblLecture.font = FONT_16_LIGHT;
        lblLecture.tag = 1001;
        
        btnCheck = [[UIButton alloc] init];
        [btnCheck addTarget:self action:@selector(btnCheckPress:) forControlEvents:UIControlEventTouchUpInside];
        [btnCheck setImage:[UIImage imageNamed:@"present"] forState:UIControlStateNormal];
        btnCheck.tag = section + 100;
        
        btnDropDown = [[UIButton alloc] init];
        //[btnDropDown addTarget:self action:@selector(btnCheckPress:) forControlEvents:UIControlEventTouchUpInside];
        [btnDropDown setImage:[UIImage imageNamed:@"dropDwonBlack"] forState:UIControlStateNormal];
        btnDropDown.tag = 600;
        
        lblStatus = [BaseViewController  getRowDetailLable:80 text:@""];
        lblStatus.textColor = [UIColor blackColor];
        lblStatus.font = FONT_16_LIGHT;
        
        lblStatus.tag = 300;
        
        if (IS_IPAD) {
            
            lblLecture.frame = CGRectMake(15, 14, lblLecture.frame.size.width, 40);
            btnDropDown.frame = CGRectMake(mainView.frame.size.width - 65, 15, 20, 20);
            
            
            if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
                btnCheck.frame = CGRectMake(mainView.frame.size.width - 245, 14, 40, 40);
            }
            else {
                btnCheck.frame = CGRectMake(mainView.frame.size.width - 215, 14, 40, 40);
            }
            
            if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
                lblStatus.frame = CGRectMake(mainView.frame.size.width - 210, 14, 210, 40);
            }
            else {
                lblStatus.frame = CGRectMake(mainView.frame.size.width - 180, 14, 180, 40);
            }
            
            if (section == 0) {
                
                lblLecture.frame = CGRectMake(15, 10, lblLecture.frame.size.width, 30);
                
                lblResone = [BaseViewController  getRowDetailLable:250 text:@""];
                lblResone.textColor = [UIColor blackColor];
                lblResone.font = FONT_16_LIGHT;
                lblResone.frame = CGRectMake(15, 40, lblResone.frame.size.width, 25);
                lblResone.tag = 330;
                
                [cell.contentView addSubview:lblResone];
                
                seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 74, ScreenWidth, 1)];
            }
            else {
                seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 69, ScreenWidth, 1)];
            }
        }
        else {
            
            if (section == 0) {
                
                lblLecture.frame = CGRectMake(15, 5, lblLecture.frame.size.width, 30);
                
                lblResone = [BaseViewController  getRowDetailLable:250 text:@""];
                lblResone.textColor = [UIColor blackColor];
                lblResone.font = FONT_16_LIGHT;
                lblResone.frame = CGRectMake(15, 30, lblResone.frame.size.width, 25);
                lblResone.tag = 330;
                
                [cell.contentView addSubview:lblResone];
                
                seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 54, ScreenWidth, 1)];
            }
            else {
                seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
            }
            
            lblLecture.frame = CGRectMake(15, 5, lblLecture.frame.size.width, 40);
            btnDropDown.frame = CGRectMake(mainView.frame.size.width - 65, 10, 20, 20);
            
            if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
                btnCheck.frame = CGRectMake(mainView.frame.size.width - 115, 15, 20, 20);
            }
            else {
                btnCheck.frame = CGRectMake(mainView.frame.size.width - 95, 15, 20, 20);
            }
            
            if ([[GeneralUtil getUserPreference:key_selLang] isEqualToString:value_LangNorwegian]) {
                lblStatus.frame = CGRectMake(mainView.frame.size.width - 90, 5, lblStatus.frame.size.width, 40);
            }
            else {
                lblStatus.frame = CGRectMake(mainView.frame.size.width - 70, 5, lblStatus.frame.size.width, 40);
            }
        }
        seperator.backgroundColor = [UIColor lightGrayColor];
        
        [cell.contentView addSubview:seperator];
        [cell.contentView addSubview:lblLecture];
        [cell.contentView addSubview:btnCheck];
        [cell.contentView addSubview:lblStatus];
        [cell.contentView addSubview:btnDropDown];
    }
    else {
        
        lblLecture = (UILabel *)[cell.contentView viewWithTag:1001];
        lblStatus = (UILabel *)[cell.contentView viewWithTag:300];
        btnCheck = (UIButton *)[cell.contentView viewWithTag:section + 100];
        btnDropDown = (UIButton *)[cell.contentView viewWithTag:600];
        
        if (section == 0)
            lblResone = (UILabel *)[cell.contentView viewWithTag:330];
    }
    
    if (section == 0) {
        lblLecture.text = [GeneralUtil getLocalizedText:@"LBL_SELECT_RESONE_TITLE"];
        lblStatus.text = @"";
        btnCheck.hidden = YES;
        lblResone.text = strResone;
    }
    else {
        
        btnDropDown.hidden = YES;
        
        NSDictionary *dicClass = [sectionsArray objectAtIndex:section];
        
        lblLecture.text = [NSString stringWithFormat:@"%@ %@",[dicClass valueForKey:@"lecture_no"],[dicClass valueForKey:@"time"]];
        
        if ([[dicClass valueForKey:@"selected"] isEqualToString:@"1"]) {
            [btnCheck setImage:[UIImage imageNamed:@"absent-red"] forState:UIControlStateNormal];
            lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_ABSENT_TITLE"];
        }
        else if ([[dicClass valueForKey:@"selected"] isEqualToString:@"2"]){
            [btnCheck setImage:[UIImage imageNamed:@"absent-yellow"] forState:UIControlStateNormal];
            lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_ABSENT_TITLE"];
        }
        else {
            [btnCheck setImage:[UIImage imageNamed:@"present"] forState:UIControlStateNormal];
            lblStatus.text = [GeneralUtil getLocalizedText:@"LBL_PRESENT_TITLE"];
        }
    }
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
    
    if (IS_IPAD) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 75;
        }
        else {
            return 70;
        }
    }
    else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 55;
        }
        else {
            return 50;
        }
    }
    //return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataArray = [[sectionsArray objectAtIndex:section] valueForKey:@"arrResone"];
    return dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSArray *dataArray = [[sectionsArray objectAtIndex:indexPath.section] valueForKey:@"arrResone"];
    cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row - 1] valueForKey:@"template_title"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        [sectionsArray removeObjectAtIndex:indexPath.section];
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lblResone.text = [[[[sectionsArray objectAtIndex:0] objectForKey:@"arrResone"] objectAtIndex:indexPath.row - 1] valueForKey:@"template_title"];
    strResone = [[[[sectionsArray objectAtIndex:0] objectForKey:@"arrResone"] objectAtIndex:indexPath.row - 1] valueForKey:@"template_title"];
    [tblExpandeble collapseSection:0 animated:YES];
}

- (IBAction)btnCheckPress:(UIButton*)sender{

    NSDictionary *dicValue = [sectionsArray objectAtIndex:sender.tag - 100];
    
    //0 = green (present), 1 = red (absent), 2 = yellow (p notice)
    
    if ([[dicValue valueForKey:@"selected"] isEqualToString:@"0"]) {
        [[sectionsArray objectAtIndex:sender.tag - 100] setObject:@"1" forKey:@"selected"];
    }
    else if ([[dicValue valueForKey:@"selected"] isEqualToString:@"1"]){
        [[sectionsArray objectAtIndex:sender.tag - 100] setObject:@"2" forKey:@"selected"];
    }
    else{
        [[sectionsArray objectAtIndex:sender.tag - 100] setObject:@"0" forKey:@"selected"];
    }
    [tblExpandeble reloadDataAndResetExpansionStates:YES];
}

@end
