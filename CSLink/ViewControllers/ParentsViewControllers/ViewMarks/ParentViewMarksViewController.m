//
//  ViewMarksViewController.m
//  CSAdmin
//
//  Created by etech-dev on 10/6/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentViewMarksViewController.h"
#import "BaseViewController.h"
#import "ParentviewMarksTableViewCell.h"
#import "ParentConstant.h"
#import "ParentTestInfoViewController.h"
#import "ParentNewMarksViewTableViewCell.h"

@interface ParentViewMarksViewController ()<ParentNewMarksViewTableViewCellDelegate>
{
    NSMutableArray *arrMarksDetail;
    ParentUser *userObj;
    NSMutableArray *arrAllSemester;
    
    NSMutableArray *arrSelectedSubject;
    
    NSMutableArray *arrYear;
    NSString *selectedYear;
    
    CGSize pageSize;
    
    BOOL checkBoxSelected;
    NSString *isImagWith;
}

@property (nonatomic, getter=isPseudoEditing) BOOL pseudoEdit;

@end

@implementation ParentViewMarksViewController
@synthesize dicStudantDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    //self.view.backgroundColor = [UIColor whiteColor];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_REPORT_CARD"] WithSel:@selector(btnBackClick)];
    
    arrMarksDetail = [[NSMutableArray alloc] init];
    arrSelectedSubject = [[NSMutableArray alloc] init];
    
    viewSecSem.hidden = YES;
    bottomFistSem.hidden = YES;
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
    
    userObj = [[ParentUser alloc] init];
    
    tblMarkView.rowHeight = UITableViewAutomaticDimension;
    tblMarkView.estimatedRowHeight = 45.0;
    
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

-(void)btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getSemester {
    
    [userObj getSemseterAndSubj:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"school_class_id"] schoolId:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"school_id"] userId:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] :^(NSObject *resObj) {
        
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
    
    [userObj getSubjectAndMarks:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"school_class_id"] year:selectedYear semesterId:semId userId:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"]  :^(NSObject *resObj) {
        
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
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ParentNewMarksViewTableViewCell";
    
    ParentNewMarksViewTableViewCell *cell = (ParentNewMarksViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ParentNewMarksViewTableViewCell" owner:self options:nil];
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
//      // cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        
        int y = 5;
        int k = 0;
        for (int i = 0; i < roundedUp; i++) {
            
            int x = 0;
            
            for (int j = 1; j <=5 ; j++,k++) {
                
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
                    [btnInfo setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
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
        float col = 3.0f;
        
        float theFloat = total / col;
        
        int roundedUp = ceilf(theFloat);
        
        cell.heightOfTestView.constant = (roundedUp * 30);
        
        int y = 5;
        int k = 0;
        for (int i = 0; i < roundedUp; i++) {
            
            int x = 0;
            
            for (int j = 1; j <= 3; j++,k++) {
                
                if (k >= total) {
                    
                    break;
                }
                else {
                    
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
                    
                    //[img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[marks objectAtIndex:k] valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"gray-image"]];
                    UIButton *btnImg = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
                    [btnImg addTarget:self action:@selector(btnImgPress:) forControlEvents:UIControlEventTouchUpInside];
                    btnImg.tag = k + 1000;
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
                    // [btn setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
                    
                    if (![[[marks objectAtIndex:k] valueForKey:@"image"] isEqualToString:@""]) {
                        
                        img.image = [UIImage imageNamed:@"image"];
                    }
                    else {
                        img.image = [UIImage imageNamed:@"gray-image"];
                    }
                    
                    x += btn.frame.size.width + 3;
                    
                    UIButton *btnInfo = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
                    [btnInfo setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
                    [btnInfo addTarget:self action:@selector(btnInfoPress:) forControlEvents:UIControlEventTouchUpInside];
                    btnInfo.tag = k + 100;
                    
                    x +=  btnInfo.frame.size.width + 10;
                    
                    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 20)];
                    seperator.backgroundColor = TEXT_COLOR_LIGHT_GREEN;
                    
                    x +=  seperator.frame.size.width + 10;
                    
                    [cell.testView addSubview:img];
                    [cell.testView addSubview:btn];
                    [cell.testView addSubview:btnInfo];
                    [cell.testView addSubview:btnImg];
                    
                    if (j % 3 != 0 && k != (total -1) ) {
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
    
    [arrSelectedSubject addObject:[arrMarksDetail objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [arrSelectedSubject removeObject:[arrMarksDetail objectAtIndex:indexPath.row]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 3;
}

#pragma mark - CustomTableViewCellDelegate


- (void)selectCell:(ParentNewMarksViewTableViewCell *)cell {
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
    BottomRight.hidden = NO;
     bottomFistSem.hidden = YES;
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
    bottomFistSem.hidden = NO;
    BottomRight.hidden = YES;
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

-(void)btnImgPress:(UIButton *)sender {
    
    NSIndexPath *indexPath = [tblMarkView indexPathForCell:(ParentNewMarksViewTableViewCell *)sender.superview.superview.superview.superview];
    
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

     NSIndexPath *indexPath = [tblMarkView indexPathForCell:(ParentNewMarksViewTableViewCell *)sender.superview.superview.superview.superview];
    
     NSArray *marks = [[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"marks"];
    
    NSDictionary *tempDetail = [marks objectAtIndex:sender.tag - 100];
    
    NSMutableDictionary *testDetail = [tempDetail mutableCopy];
    
   NSDictionary *pDetail = [GeneralUtil getUserPreference:key_selectedStudant];
    
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"subject_id"] forKey:@"subject_id"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"subject_name"] forKey:@"subject_name"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"teacher_name"] forKey:@"teacher_name"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"semester_id"] forKey:@"semester_id"];
    
    [testDetail setObject:[pDetail valueForKey:@"child_name"] forKey:@"studant_name"];
    [testDetail setObject:[[arrMarksDetail objectAtIndex:indexPath.row] valueForKey:@"class_name"] forKey:@"class_name"];
    
    [testDetail setObject:pDetail  forKey:@"studant_Detail"];
    [testDetail setObject:tempDetail  forKey:@"mark_Detail"];
    
    ParentTestInfoViewController *custompopup = [[ParentTestInfoViewController alloc] initWithNibName:@"ParentTestInfoViewController" bundle:nil andDetail:testDetail];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:custompopup];
    navigationController.navigationBarHidden = true;
    [self presentPopupViewController:navigationController animationType:MJPopupViewAnimationFade];
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
        [appDelegate generateAndUploadPdf:[GeneralUtil getUserPreference:key_selectedStudant] andSubjectDetail:arrSelectedSubject withImg:isImagWith isIndividual:NO];
    }
    else {
        [GeneralUtil alertInfo:[GeneralUtil getLocalizedText:@"MSG_SELECT_ANY_SUBJECT"]];
    }
    
    //[self generatePDF];
    //[self uploadPdf];
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
