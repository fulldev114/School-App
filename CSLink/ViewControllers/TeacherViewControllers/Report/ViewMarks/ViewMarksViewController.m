//
//  ViewMarksViewController.m
//  CSAdmin
//
//  Created by etech-dev on 10/6/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ViewMarksViewController.h"
#import "BaseViewController.h"
#import "viewMarksTableViewCell.h"
#import "TeacherConstant.h"
#import "TestInfoViewController.h"
#import "EnterMarkViewController.h"
#import "NewMarksViewTableViewCell.h"

@interface ViewMarksViewController ()<EnterMarkViewControllerDelegate, NewMarksViewTableViewCellDelegate>
{
    NSMutableArray *arrMarksDetail;
    TeacherUser *userObj;
    NSMutableArray *arrAllSemester;
    
    NSMutableArray *arrSelectedSubject;
    
    NSMutableArray *arrYear;
    NSString *selectedYear;
    
    NSIndexPath *selectedIndexPath;
    CGSize pageSize;
    NSString *PathOfReportGenerated;
    
    int contextX,contextY, contextWidth, margin;
    
    BOOL checkBoxSelected;
    NSString *isImagWith;
    
}

@property (nonatomic, getter=isPseudoEditing) BOOL pseudoEdit;

@end

@implementation ViewMarksViewController
@synthesize dicStudantDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    //self.view.backgroundColor = [UIColor whiteColor];
    //[BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_REPORT"] WithSel:@selector(btnBackClick)];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 50)];
    
    UILabel *lblStudName = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 180, 25)];
    [lblStudName setText:[dicStudantDetail valueForKey:@"name"]];
    [lblStudName setBackgroundColor:[UIColor clearColor]];
    [lblStudName setFont:FONT_NAVIGATION_TITLE];
    lblStudName.textColor = TEXT_COLOR_CYNA;
    [lblStudName setTextAlignment:NSTextAlignmentLeft];
    lblStudName.font = FONT_BTN_TITLE_18;
    
    UILabel *lblStudClass = [[UILabel alloc]initWithFrame:CGRectMake(35, 20, 180, 25)];
    [lblStudClass setText:[dicStudantDetail valueForKey:@"class_name"]];
    [lblStudClass setBackgroundColor:[UIColor clearColor]];
    [lblStudClass setFont:FONT_NAVIGATION_TITLE];
    lblStudClass.textColor = TEXT_COLOR_WHITE;
    [lblStudClass setTextAlignment:NSTextAlignmentLeft];
    lblStudClass.font = FONT_16_BOLD;
    
    [view addSubview:lblStudClass];
    [view addSubview:lblStudName];
    
    UIImageView *profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 30, 30)];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[dicStudantDetail valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    profileImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [BaseViewController setRoudRectImage:profileImg];
    
    [view addSubview:profileImg];
    
    [self.navigationItem setTitleView:view];
    
    self.navigationItem.leftBarButtonItem = [BaseViewController getBackButtonWithSel:@selector(backButtonClick) addTarget:self];
    
    arrMarksDetail = [[NSMutableArray alloc] init];
    arrSelectedSubject = [[NSMutableArray alloc] init];
    
    viewSecSem.hidden = YES;
    bottomFirstSem.hidden = YES;
    viewSecSem.backgroundColor = TEXT_COLOR_CYNA;
    viewFirstSem.backgroundColor = TEXT_COLOR_CYNA;
    
    lblTestInfo.font = FONT_16_BOLD;
    lblSubjectInfo.font = FONT_16_BOLD;
    
    lblTestInfo.textColor = TEXT_COLOR_WHITE;
    lblSubjectInfo.textColor = TEXT_COLOR_WHITE;
    
    lblSubjectInfo.text = [GeneralUtil getLocalizedText:@"LBL_SUBJECT_INFO_TITLE"];
    lblTestInfo.text = [GeneralUtil getLocalizedText:@"LBL_TEST_INFO_TITLE"];
    
    btnFirstSem.titleLabel.font = FONT_16_BOLD;
    btnSecondSem.titleLabel.font = FONT_16_BOLD;
    
    btnFirstSem.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnSecondSem.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [btnFirstSem setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    [btnSecondSem setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    
  //  [btnFirstSem setTitle:[GeneralUtil getLocalizedText:@"BTN_FIRST_SEM_TITLE"] forState:UIControlStateNormal];
  //  [btnSecondSem setTitle:[GeneralUtil getLocalizedText:@"BTN_SECOND_SEM_TITLE"] forState:UIControlStateNormal];
    
    [BaseViewController formateButtonCyne:btnDownload title:[GeneralUtil getLocalizedText:@"BTN_GENERATE_PDF_TITLE"]];
    
    [BaseViewController formateButtonCyne:btnDownload1 title:[GeneralUtil getLocalizedText:@"BTN_DOWNLOAD_PDF_TITLE"]];
    [BaseViewController formateButtonCyne:btnCancel title:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]];
    
    btnCancel.hidden = YES;
    btnDownload1.hidden = YES;
    
    userObj = [[TeacherUser alloc] init];
    
  //  tblMarkView.rowHeight = UITableViewAutomaticDimension;
  //  tblMarkView.estimatedRowHeight = 45.0;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTestInfo:) name:@"updateTestInfo" object:nil];
    
    [self getSemester];
    
    lblNoDataFond.font = FONT_18_BOLD;
    lblNoDataFond.textColor = TEXT_COLOR_LIGHT_GREEN;
    lblNoDataFond.text = [GeneralUtil getLocalizedText:@"LBL_NO_DATA_FOUND_TITLE"];
    lblNoDataFond.hidden = YES;
    
    checkBoxSelected = false;
    [btnWithImg setBackgroundImage:[UIImage imageNamed:@"unchecked.png"]
                          forState:UIControlStateNormal];
    [btnWithImg setBackgroundImage:[UIImage imageNamed:@"unchecked_selected.png"]
                          forState:UIControlStateSelected];
    lblWithImg.font = FONT_16_REGULER;
    lblWithImg.text = [GeneralUtil getLocalizedText:@"LBL_INCLU_IMG_TITLE"];
    lblWithImg.textColor = TEXT_COLOR_LIGHT_GREEN;
    
    btnWithImg.hidden = YES;
    lblWithImg.hidden = YES;
    
    isImagWith = @"no";
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [lblWithImg addGestureRecognizer:tapGestureRecognizer];
    lblWithImg.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateTestInfo:(NSNotification *)notification {
    
    NSLog(@"newMessageReceived > Message Data: %@", notification.object);
    
    NSMutableDictionary *testDetail = (NSMutableDictionary *)notification.object;
    
    NSMutableArray *marks = [[arrMarksDetail objectAtIndex:selectedIndexPath.row] valueForKey:@"marks"];
    
    for (int i = 0 ; i < [marks count]; i++) {
        if ([[[marks objectAtIndex:i] valueForKey:@"exam_no"] isEqualToString:[testDetail valueForKey:@"exam_no"]]) {
            [marks replaceObjectAtIndex:i withObject:testDetail];
        }
    }
    
    [[arrMarksDetail objectAtIndex:selectedIndexPath.row] setObject:marks forKey:@"marks"];
}
-(void)getSemester {
    
    [userObj getSemseterAndSubj:[dicStudantDetail valueForKey:@"class_id"] schoolId:[GeneralUtil getUserPreference:key_schoolId] userId:[dicStudantDetail valueForKey:@"user_id"] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSMutableDictionary *dicRes = (NSMutableDictionary *)resObj;
        
        if (dicRes != nil) {
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                arrAllSemester = (NSMutableArray *)[dicRes valueForKey:@"semester_list"];
            }
            
            [btnFirstSem setTitle:[[arrAllSemester objectAtIndex:0] valueForKey:@"semester_name"] forState:UIControlStateNormal];
            [btnSecondSem setTitle:[[arrAllSemester objectAtIndex:1] valueForKey:@"semester_name"] forState:UIControlStateNormal];
            
            arrYear = [GeneralUtil getYear:[GeneralUtil getYearStartDate]];
            
            selectedYear = [arrYear firstObject];
            
            [self getSubjectAndMarks:[[arrAllSemester objectAtIndex:0] valueForKey:@"semester_id"]];
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(void)getSubjectAndMarks:(NSString *)semId {
    
    [userObj getSubjectAndMarks:[dicStudantDetail valueForKey:@"class_id"] year:selectedYear semesterId:semId userId:[dicStudantDetail valueForKey:@"user_id"]  :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        if (resObj != nil) {
            
            if ([[resObj valueForKey:@"flag"] intValue] == 1) {
                
                arrMarksDetail = [resObj valueForKey:@"marks_details"];
                
                if (arrMarksDetail && [arrMarksDetail isKindOfClass:[NSArray class]] && [arrMarksDetail count] > 0) {
                    [tblMarkView reloadData];
                    lblNoDataFond.hidden = YES;
                    tblMarkView.hidden = NO;
                    btnDownload.hidden = NO;
                    btnCancel.hidden = YES;
                    btnDownload1.hidden = YES;
                }
                else {
                    lblNoDataFond.hidden = NO;
                    tblMarkView.hidden = YES;
                    btnDownload.hidden = YES;
                    btnCancel.hidden = YES;
                    btnDownload1.hidden = YES;
                }
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrMarksDetail.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int total = [[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"marks"] count];
    
    if (IS_IPAD) {
        
        float col = 5.0f;
        
        float theFloat = total / col;
        
        int roundedUp = ceilf(theFloat);
        
        return (roundedUp * 40) + 10;
    }
    else {
    
        float col = 4.0f;
        
        float theFloat = total / col;
        
        int roundedUp = ceilf(theFloat);
        
      //  return (roundedUp * 30) + 10;
        
        return (roundedUp * 30) + 25 + 15;
    }
   // return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"NewMarksViewTableViewCell";
    
    NewMarksViewTableViewCell *cell = (NewMarksViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"NewMarksViewTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        
        //        UIView *v = [[UIView alloc] initWithFrame:cell.contentView.frame];
        //        v.backgroundColor = [UIColor clearColor];
        //        cell.selectedBackgroundView = v;
        
       // cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
//    static NSString *simpleTableIdentifier = @"viewMarksTableViewCell";
//    
//    viewMarksTableViewCell *cell = (viewMarksTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        
//        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"viewMarksTableViewCell" owner:self options:nil];
//        cell=[nib objectAtIndex:0];
//        cell.backgroundColor = [UIColor clearColor];
//        
////        UIView *v = [[UIView alloc] initWithFrame:cell.contentView.frame];
////        v.backgroundColor = [UIColor clearColor];
////        cell.selectedBackgroundView = v;
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
    
    cell.delegate = self;
    
    [cell setEditing:self.isEditing];
    
    NSArray *marks = [[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"marks"];
    
    int total = [[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"marks"] count];
    
    if (IS_IPAD) {
        
        float col = 5.0f;
        
        float theFloat = total / col;
        
        int roundedUp = ceilf(theFloat);
        
        cell.heightOfTestView.constant = (roundedUp * 40);
        
        int y = 0;
        int k = 0;
        for (int i = 0; i < roundedUp; i++) {
            
            int x = 0;
            
            for (int j = 1; j <= 5 ; j++,k++) {
                
                if (k >= total) {
                    
                    break;
                }
                else {
                    
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 30, 30)];
                    
                    //[img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[marks objectAtIndex:k] valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"gray-image"]];
                    UIButton *btnImg = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 30, 30)];
                    [btnImg addTarget:self action:@selector(btnImgPress:) forControlEvents:UIControlEventTouchUpInside];
                    btnImg.tag = k + 1000;
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 30, 30)];
                    // [btn setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
                    
                    if (![[[marks objectAtIndex:k] valueForKey:@"image"] isEqualToString:@""]) {
                        
                        img.image = [UIImage imageNamed:@"image"];
                    }
                    else {
                        img.image = [UIImage imageNamed:@"gray-image"];
                    }
                    
                    x += btn.frame.size.width + 6;
                    
                    UIButton *btnInfo = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 30, 30)];
                    [btnInfo setImage:[UIImage imageNamed:@"info-green"] forState:UIControlStateNormal];
                    [btnInfo addTarget:self action:@selector(btnInfoPress:) forControlEvents:UIControlEventTouchUpInside];
                    
                    btnInfo.tag = k + 100;
                    
                    x +=  btnInfo.frame.size.width + 12;
                    
                    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 30)];
                    seperator.backgroundColor = TEXT_COLOR_LIGHT_GREEN;
                    
                    x +=  seperator.frame.size.width + 12;
                    
                    [cell.testView addSubview:img];
                    [cell.testView addSubview:btn];
                    [cell.testView addSubview:btnInfo];
                    [cell.testView addSubview:btnImg];
                    
                    if (j % 5 != 0 && k != (total -1) ) {
                        [cell.testView addSubview:seperator];
                    }
                }
            }
            y += 40;
        }
    }
    else {
        
        float col = 4.0f;
        
        float theFloat = total / col;
        
        int roundedUp = ceilf(theFloat);
        
        cell.heightOfTestView.constant = (roundedUp * 30);
        
        int y = 0;
        int k = 0;
        int height = 0;
        int width = 0;
        
        if (IS_IPHONE_5) {
            height = 20;
            width = 20;
        }
        else if (IS_IPHONE_6) {
            height = 25;
            width = 25;
        }
        
        for (int i = 0; i < roundedUp; i++) {
            
            int x = 0;
            
            for (int j = 1; j <= 4; j++,k++) {
                
                if (k >= total) {
                    
                    break;
                }
                else {
                    
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    
                    //[img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[marks objectAtIndex:k] valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"gray-image"]];
                    UIButton *btnImg = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    [btnImg addTarget:self action:@selector(btnImgPress:) forControlEvents:UIControlEventTouchUpInside];
                    btnImg.tag = k + 1000;
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    // [btn setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
                    
                    if (![[[marks objectAtIndex:k] valueForKey:@"image"] isEqualToString:@""]) {
                        
                        img.image = [UIImage imageNamed:@"image"];
                    }
                    else {
                        img.image = [UIImage imageNamed:@"gray-image"];
                    }
                    
                    x += btn.frame.size.width + 3;
                    
                    UIButton *btnInfo = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    [btnInfo setImage:[UIImage imageNamed:@"info-green"] forState:UIControlStateNormal];
                    [btnInfo addTarget:self action:@selector(btnInfoPress:) forControlEvents:UIControlEventTouchUpInside];
                    
                    btnInfo.tag = k + 100;
                    
                    x +=  btnInfo.frame.size.width + 5;
                    
                    UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    [btnDelete setImage:[UIImage imageNamed:@"deleteRed"] forState:UIControlStateNormal];
                    [btnDelete addTarget:self action:@selector(btnDeletePress:) forControlEvents:UIControlEventTouchUpInside];
                    
                    btnDelete.tag = k + 200;
                    
                    x +=  btnDelete.frame.size.width + 5;
                    
                    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, height)];
                    seperator.backgroundColor = TEXT_COLOR_LIGHT_GREEN;
                    
                    x +=  seperator.frame.size.width + 5;
                    
                    [cell.testView addSubview:img];
                    [cell.testView addSubview:btn];
                    [cell.testView addSubview:btnInfo];
                    [cell.testView addSubview:btnImg];
                    [cell.testView addSubview:btnDelete];
                    
                    if (j % 4 != 0 && k != (total -1) ) {
                        [cell.testView addSubview:seperator];
                    }
                }
            }
            y += 30;
        }
    }
    
    NSDictionary *subjectDetail = [arrMarksDetail objectAtIndex:indexPath.row];

    cell.lblSubjectName.text = [subjectDetail valueForKey:@"subject_name"];
    cell.tintColor = TEXT_COLOR_LIGHT_GREEN;//[UIColor redColor];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    viewMarksTableViewCell *cell = (viewMarksTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor yellowColor];
    
    [arrSelectedSubject addObject:[arrMarksDetail objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [arrSelectedSubject removeObject:[arrMarksDetail objectAtIndex:indexPath.row]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 3;
}

#pragma mark - CustomTableViewCellDelegate

- (void)selectCell:(NewMarksViewTableViewCell *)cell {
    NSIndexPath *indexPath =  [tblMarkView indexPathForCell:cell];
    UITableView *tableView = tblMarkView;
    
    if (!!cell.selected) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        // Above method will not call the below delegate methods
        if ([tableView.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
        }
        if ([tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
        }
        
    } else {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        // Above method will not call the below delegate methods
        if ([tableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
        }
        if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

- (IBAction)btnFirstSemPress:(id)sender {
    
    viewSecSem.hidden = YES;
    viewFirstSem.hidden = NO;
    bottomFirstSem.hidden = YES;
    bottomSecSem.hidden = NO;
    
    [btnFirstSem setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    [btnSecondSem setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    
    [self getSubjectAndMarks:[[arrAllSemester objectAtIndex:0] valueForKey:@"semester_id"]];
    
    [tblMarkView setEditing:NO animated:YES];
    btnCancel.hidden = YES;
    btnDownload1.hidden = YES;
    
    if (checkBoxSelected) {
        isImagWith = @"no";
        checkBoxSelected = !checkBoxSelected; /* Toggle */
        [btnWithImg setSelected:checkBoxSelected];
    }
    
    btnWithImg.hidden = YES;
    lblWithImg.hidden = YES;
    
    [arrSelectedSubject removeAllObjects];
    
}

- (IBAction)btnSecondSemPress:(id)sender {
    
    viewSecSem.hidden = NO;
    viewFirstSem.hidden = YES;
    bottomFirstSem.hidden = NO;
    bottomSecSem.hidden = YES;
    [btnFirstSem setTitleColor:TEXT_COLOR_WHITE forState:UIControlStateNormal];
    [btnSecondSem setTitleColor:TEXT_COLOR_CYNA forState:UIControlStateNormal];
    
    [self getSubjectAndMarks:[[arrAllSemester objectAtIndex:1] valueForKey:@"semester_id"]];
    
    [tblMarkView setEditing:NO animated:YES];
    btnCancel.hidden = YES;
    btnDownload1.hidden = YES;
    
    if (checkBoxSelected) {
        isImagWith = @"no";
        checkBoxSelected = !checkBoxSelected; /* Toggle */
        [btnWithImg setSelected:checkBoxSelected];
    }
    
    btnWithImg.hidden = YES;
    lblWithImg.hidden = YES;
    [arrSelectedSubject removeAllObjects];
}

-(void)btnImgPress:(UIButton *)sender {

    NSIndexPath *indexPath = [tblMarkView indexPathForCell:(NewMarksViewTableViewCell *)sender.superview.superview.superview.superview];
    
    NSArray *marks = [[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"marks"];
    
    NSDictionary *tempDetail = [marks objectAtIndex:sender.tag - 1000];
    
    if (![[tempDetail valueForKey:@"image"] isEqualToString:@""]) {
        
        UIImageView *tempImage = [[UIImageView alloc] init];
        
        ZDebug(@"%@%@", UPLOAD_URL,[tempDetail valueForKey:@"image"]);
        
        [tempImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[tempDetail valueForKey:@"image"]]]];
        
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[tempDetail valueForKey:@"image"]]];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
        [GeneralUtil showProgress];
        [tempImage setImageWithURLRequest:imageRequest
                         placeholderImage:nil
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             [GeneralUtil hideProgress];
             tempImage.image = image;
             _slideImageViewController = [PEARImageSlideViewController new];
             _slideImageViewController.dele = self;
             // NSArray *imageLists = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[tempDetail valueForKey:@"image"]]]].copy;
             
             NSArray *imageLists = @[tempImage.image].copy;
             
             [_slideImageViewController setImageLists:imageLists];
             [_slideImageViewController showAtIndex:0];
         }
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         {
             [GeneralUtil hideProgress];
             [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_IMAGE_LOADING_FAIL"]];
         }];
    }
}

-(void)btnInfoPress:(UIButton *)sender {

    NSIndexPath *indexPath = [tblMarkView indexPathForCell:(NewMarksViewTableViewCell *)sender.superview.superview.superview.superview];
    
    NSArray *marks = [[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"marks"];
    
    NSDictionary *tempDetail = [marks objectAtIndex:sender.tag - 100];
    
    NSMutableDictionary *testDetail = [[NSMutableDictionary alloc] init];
    
    selectedIndexPath = indexPath;
    
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"semester_id"] forKey:@"semester_id"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"subject_id"] forKey:@"subject_id"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"subject_name"] forKey:@"subject_name"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"teacher_name"] forKey:@"teacher_name"];
    
//    [testDetail setObject:[dicStudantDetail valueForKey:@"name"] forKey:@"studant_name"];
//    [testDetail setObject:[dicStudantDetail valueForKey:@"class_name"] forKey:@"class_name"];
    
    [testDetail setObject:dicStudantDetail  forKey:@"studant_Detail"];
    [testDetail setObject:tempDetail  forKey:@"mark_Detail"];
    
    TestInfoViewController *custompopup = [[TestInfoViewController alloc] initWithNibName:@"TestInfoViewController" bundle:nil andDetail:testDetail];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:custompopup];
    navigationController.navigationBarHidden = YES;
    [self presentPopupViewController:navigationController animationType:MJPopupViewAnimationFade];
}

-(void)btnDeletePress:(UIButton *)sender {
    
    NSIndexPath *indexPath = [tblMarkView indexPathForCell:(NewMarksViewTableViewCell *)sender.superview.superview.superview.superview];
    
    NSArray *marks = [[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"marks"];
    
    NSDictionary *tempDetail = [marks objectAtIndex:sender.tag - 200];
    
    NSMutableDictionary *testDetail = [[NSMutableDictionary alloc] init];
    
    selectedIndexPath = indexPath;
    
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"semester_id"] forKey:@"semester_id"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"subject_id"] forKey:@"subject_id"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"subject_name"] forKey:@"subject_name"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"teacher_name"] forKey:@"teacher_name"];
    
    CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@""] WithDelegate:self];
    alertView.tag = 10;
    [alertView show];
}


//-(BOOL)isPseudoEditing {
//    
//    return pseudoEdit;
//}

- (IBAction)btnDownloadPress:(id)sender {
    
    self.pseudoEdit = YES;
    
    [tblMarkView setEditing:YES animated:YES];
    
    if (arrMarksDetail && [arrMarksDetail count] > 0) {
        btnDownload.hidden = YES;
        
        btnCancel.hidden = NO;
        btnDownload1.hidden = NO;
        btnWithImg.hidden = NO;
        lblWithImg.hidden = NO;
        
        bottomSpach.constant = 45;
    }
}

- (IBAction)btnCancelPress:(id)sender {
    
    btnDownload.hidden = NO;
    [arrSelectedSubject removeAllObjects];
    
    btnCancel.hidden = YES;
    btnDownload1.hidden = YES;
    btnWithImg.hidden = YES;
    lblWithImg.hidden = YES;
    
    if (checkBoxSelected) {
        isImagWith = @"no";
        checkBoxSelected = !checkBoxSelected; /* Toggle */
        [btnWithImg setSelected:checkBoxSelected];
    }

    bottomSpach.constant = 8;
    
    self.pseudoEdit = YES;
    [tblMarkView setEditing:NO animated:YES];
}

- (IBAction)btnDonload1Press:(id)sender {
    
    
    if ([arrSelectedSubject count] > 0) {
        
       [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_IS_SEND_MAIL_PDF"] Delegate:self];
    }
    else {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_ANY_SUBJECT"]];
    }
    
    //[self generatePDF];
    //[self uploadPdf];
}

-(void) generatePDF

{
    /*** This is the method called by your "PDF generating" Button. Just give initial PDF page frame, Name for your PDF file to be saved as, and the path for storing it to documnets directory ***/
    pageSize = CGSizeMake(612, 792);
    
    NSString *fileName = @"StuantMarks.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSLog(@"pdfpath %@",pdfFilePath);
    
    PathOfReportGenerated=pdfFilePath;
    
    [self generatePdfWithFilePath:pdfFilePath];
}

#pragma mark Gnerate PDf

#define kBorderInset            20.0
#define kBorderWidth            1.0
#define kMarginInset            12.0
#define kLineWidth              1.0

- (void) generatePdfWithFilePath: (NSString *)thefilePath

{
    /*** Now generating the pdf  and storing it to the documents directory of device on selected path. Customize do-while loop to meet your pdf requirements like number of page, Size of NSstrings/texts you want to fit. Basically just call all the above methods depending on your requirements from do-while loop or you can recustomize it. ****/
    
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    
    [self drawHeader:dicStudantDetail];
    
    [self drawLine];
    
    [self drawSubjectAndMarks:arrSelectedSubject];
    
}

-(CGSize)getSizeOfContent:(NSString *)text font:(UIFont *)font {
    
    CGSize maximumSize = CGSizeMake(pageSize.width - 2*kBorderInset-2*kMarginInset, pageSize.height - 2*kBorderInset - 2*kMarginInset);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:maximumSize
                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:context].size;
    
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size;
}

-(void)drawHeader:(NSDictionary *)studantDetail {

    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentLeft;

    
    NSString *schName = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"PGF_SCHOOL_NAME_TITLE"],[studantDetail valueForKey:@"school_name"]];
    
    NSString *studName = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"PGF_STUDENT_NAME_TITLE"],[studantDetail valueForKey:@"name"]];
    
     NSString *className = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"PGF_CLASS_TITLE"],[studantDetail valueForKey:@"class_name"]];
    
    contextX = kBorderInset + kMarginInset;
    contextY = kBorderInset + kMarginInset;
    
    contextWidth = pageSize.width - ((kBorderInset + kMarginInset) * 2);
    
   
    CGSize stringSize = [self getSizeOfContent:schName font:FONT_16_REGULER];
    CGRect renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    
    [schName drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_REGULER, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    
    
    stringSize = [self getSizeOfContent:studName font:FONT_16_BOLD];
    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [studName drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_REGULER, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    
    stringSize = [self getSizeOfContent:className font:FONT_16_BOLD];
    renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [className drawInRect:renderingRect withAttributes:@{NSFontAttributeName:FONT_16_REGULER, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + renderingRect.size.height;
    
    contextY = contextY + 30; // 50 = space btwn header text and line
}

-(void)drawLine {
    
    if (contextY > (pageSize.height - (kBorderInset + kMarginInset))) {
        contextY = kBorderInset + kMarginInset;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    }
    
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, kLineWidth);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blueColor].CGColor);
    
    CGPoint startPoint = CGPointMake(contextX, contextY);
    CGPoint endPoint = CGPointMake(contextWidth, contextY);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}


- (void) drawSubjectAndMarks:(NSMutableArray *)arrSubjectDetail
{
    margin = 15;
    
    contextY = contextY + 25;
    
    
    NSString *preSubject;
    
    for (NSDictionary *dicSuject in arrSubjectDetail) {
        
        
        if (!preSubject) {
            preSubject = [dicSuject valueForKey:@"subject_name"];
        }
        
        NSArray *arrMarks = [dicSuject valueForKey:@"marks"];
        
        NSString *teacherName = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"PGF_TEACHER_NAME_TITLE"],[dicSuject valueForKey:@"teacher_name"]];
        
        NSString *subjectName = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"PGF_SUBJECT_NAME_TITLE"],[dicSuject valueForKey:@"subject_name"]];
        
        
        if (![preSubject isEqualToString:[dicSuject valueForKey:@"subject_name"]]) {
            preSubject = [dicSuject valueForKey:@"subject_name"];
            
            contextY = kBorderInset + kMarginInset;
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
        }
        
        
        for (NSDictionary *dicTest in arrMarks) {
            
            contextWidth = contextWidth / 2;
            
            NSString *testNumber = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"PGF_TEST_NUMBER_TITLE"],[dicTest valueForKey:@"exam_no"]];
            
            
            CGRect renderingRect = [self drawText:testNumber :FONT_16_BOLD];
            
            
            NSString *dateOfTest = [NSString stringWithFormat:@"%@ %@",[GeneralUtil getLocalizedText:@"PGF_DATE_OF_TEST_TITLE"],[dicTest valueForKey:@"exam_date"]];
            
            contextY = contextY - 5;
            contextX = contextX + contextWidth + 50;
            
            renderingRect = [self drawText:dateOfTest :FONT_16_BOLD];
            
            contextY = contextY + renderingRect.size.height;
            
            contextX = contextX - contextWidth - 50;
            contextWidth = contextWidth * 2;
            
            
            renderingRect = [self drawText:teacherName :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            
            
            renderingRect = [self drawText:subjectName :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            contextY = contextY + margin;
            
            NSString *ExamAbout = [GeneralUtil getLocalizedText:@"PGF_EXAM_ABOUT_TITLE"];
            renderingRect = [self drawText:ExamAbout :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            
            ExamAbout = [dicTest valueForKey:@"exam_about"];
            renderingRect = [self drawText:ExamAbout :FONT_16_REGULER];
            contextY = contextY + renderingRect.size.height;
            
            contextY = contextY + margin;
            
            NSString *comment = [GeneralUtil getLocalizedText:@"PGF_COMMENT_TITLE"];
            renderingRect = [self drawText:comment :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            comment = [dicTest valueForKey:@"comment"];
            renderingRect = [self drawText:comment :FONT_16_REGULER];
            contextY = contextY + renderingRect.size.height;
            
            contextY = contextY + margin;
            
            NSString *marks = [GeneralUtil getLocalizedText:@"PGF_MARKS_TITLE"];
            renderingRect = [self drawText:marks :FONT_16_BOLD];
            contextY = contextY + renderingRect.size.height;
            
            marks = [dicTest valueForKey:@"marks"];
            renderingRect = [self drawText:marks :FONT_16_REGULER];
            contextY = contextY + renderingRect.size.height;
            
            contextY = contextY + 25;
            
            [self drawLine];
            
            contextY = contextY + 25;
           
        }
    }
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

-(CGRect)drawText:(NSString *)text :(UIFont *)font {

    if (contextY > (pageSize.height - (kBorderInset + kMarginInset))) {
        contextY = kBorderInset + kMarginInset;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    }
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentLeft;
    
    CGSize stringSize = [self getSizeOfContent:text font:font];
    CGRect renderingRect = CGRectMake(contextX, contextY, contextWidth, stringSize.height);
    
    [text drawInRect:renderingRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle}];
    
    contextY = contextY + 5;
    
    return renderingRect;
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *isSend;
    
    if (buttonIndex == 1) {
        isSend = @"No";
    }
    else {
        isSend = @"Yes";
    }
    
    [appDelegate generateAndUploadPdf:dicStudantDetail andSubjectDetail:arrSelectedSubject isMmailSend:isSend withImg:isImagWith isIndividual:NO];
}

- (IBAction)btnWithImgPress:(id)sender {
    
    if (checkBoxSelected) {
        isImagWith = @"no";
    }
    else {
        isImagWith = @"yes";
    }
    checkBoxSelected = !checkBoxSelected; /* Toggle */
    [btnWithImg setSelected:checkBoxSelected];
}

-(void)labelTapped {
    
    if (checkBoxSelected) {
        isImagWith = @"no";
        
    }
    else {
        isImagWith = @"yes";
    }
    checkBoxSelected = !checkBoxSelected; /* Toggle */
    [btnWithImg setSelected:checkBoxSelected];
}

@end
