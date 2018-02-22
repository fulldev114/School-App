//
//  ProfileDetailViewController.m
//  CSLink
//
//  Created by common on 7/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "BaseViewController.h"
#import "ProfileDetailTableViewCell.h"
#import "ProfileDetailTableViewCell2.h"
#import "TeacherUser.h"

@interface ProfileDetailViewController ()
{
    TeacherUser *userObj;
    NSMutableArray *arrCheckOutRule;
    NSMutableDictionary *dicProfile;
    NSMutableDictionary *dicStudentDetail;
    BOOL isEdit;
    UITextField *lastTextField;
}
@end

@implementation ProfileDetailViewController 
@synthesize profileImg;
@synthesize popView, btnDone, btnCancel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(id)obj {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    dicStudentDetail = [[NSMutableDictionary alloc] initWithDictionary:obj];
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUi];
    // Do any additional setup after loading the view from its nib.
}

-(void)setUpUi {
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    userObj = [[TeacherUser alloc] init];
    
    self.studentDetailTable.dataSource = self;
    self.studentDetailTable.delegate = self;
    [self.studentDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [BaseViewController setRoudRectImage:profileImg];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UPLOAD_URL,[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"child_image"]]] placeholderImage:[UIImage imageNamed:@"profile.png"]];
    
    popView.layer.cornerRadius = 5.0f;
    
    self.lblName.text = [dicStudentDetail valueForKey:@"student_name"];
    self.lblName.textColor = TEXT_COLOR_WHITE;
    self.lblName.font = FONT_18_SEMIBOLD;
    
    self.lblClass.text = [dicStudentDetail valueForKey:@"class_name"];
    self.lblClass.textColor = TEXT_COLOR_WHITE;
    self.lblClass.font = FONT_18_LIGHT;
    
    [BaseViewController formateButtonCyne:btnDone title:[GeneralUtil getLocalizedText:@"BTN_DONE_TITLE"]];
    [BaseViewController formateButton:btnCancel withBackgourdColor:[UIColor colorWithRed:0.0f/255 green:46.0f/255 blue:89.0f/255 alpha:1.0f] withTextColor:[UIColor whiteColor] title:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]];
    
    if ([[UIScreen mainScreen] bounds].size.width > 320)
    {
        self.constButtonLeft.constant = 30;
        self.constButtonRight.constant = 30;
    }
    else
    {
        self.constButtonLeft.constant = 15;
        self.constButtonRight.constant = 15;
    }

    arrCheckOutRule = [dicStudentDetail objectForKey:@"check_out_rules"];
    
    dicProfile = [[NSMutableDictionary alloc] init];
    for ( int i = 0; i < 10; i++)
    {
        [dicProfile setValue:@"" forKey:[NSString stringWithFormat:@"%d", i]];
    }
    isEdit = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickEditButton:(UIButton *)sender {
    isEdit = YES;
    [self.btnDone setTitle:@"Save" forState:UIControlStateNormal];
    
    for ( int i = 0; i < 10; i++)
    {
        switch (i) {
            case 0:
                [dicProfile setValue:[dicStudentDetail valueForKey:@"first_name"] forKey:@"0"];
                break;
            case 1:
                [dicProfile setValue:[dicStudentDetail valueForKey:@"last_name"] forKey:@"1"];
                break;
            case 2:
                [dicProfile setValue:[dicStudentDetail valueForKey:@"email"] forKey:@"2"];
                break;
            case 3:
                [dicProfile setValue:[dicStudentDetail valueForKey:@"mobile"] forKey:@"3"];
                break;
            case 4:
                [dicProfile setValue:[dicStudentDetail valueForKey:@"telephone"] forKey:@"4"];
                break;
            case 5:
                if ([[dicStudentDetail valueForKey:@"flag"] integerValue] == 1)
                    [dicProfile setValue:@"Full day" forKey:@"5"];
                else
                    [dicProfile setValue:@"Half day" forKey:@"5"];
                break;
            case 6:
                [dicProfile setValue:[dicStudentDetail valueForKey:@"class_name"] forKey:@"6"];
                break;
            case 7:
                [dicProfile setValue:[dicStudentDetail valueForKey:@"contact_sfo"] forKey:@"7"];
                break;
            case 8:
                [dicProfile setValue:[dicStudentDetail valueForKey:@"doctor_name"] forKey:@"8"];
                break;
            case 9:
                [dicProfile setValue:[dicStudentDetail valueForKey:@"doctor_contact"] forKey:@"9"];
                break;
            default:
                break;
        }
    }
    
    [self.studentDetailTable reloadData];
}

- (IBAction)onClickDoneButton:(UIButton *)sender {
    if (isEdit) {
        isEdit = NO;
        
        if (lastTextField != nil)
        {
            [lastTextField resignFirstResponder];
            [dicProfile setValue:lastTextField.text forKey:[NSString stringWithFormat:@"%ld", lastTextField.tag]];
        }
        
        for ( int i = 0; i < 10; i++)
        {
            NSString *value = [dicProfile valueForKey:[NSString stringWithFormat:@"%d", i]];
            
            switch (i) {
                case 0:
                    [dicStudentDetail setValue:value forKey:@"first_name"];
                    break;
                case 1:
                    [dicStudentDetail setValue:value forKey:@"last_name"];
                    break;
                case 2:
                    [dicStudentDetail setValue:value forKey:@"email"];
                    break;
                case 3:
                    [dicStudentDetail setValue:value forKey:@"mobile"];
                    break;
                case 4:
                    [dicStudentDetail setValue:value forKey:@"telephone"];
                    break;
                case 5:
                    if ([value isEqualToString:@"Full day"])
                        [dicStudentDetail setValue:@"1" forKey:@"flag"];
                    else
                        [dicStudentDetail setValue:@"0" forKey:@"flag"];
                    break;
                case 6:
                    [dicStudentDetail setValue:value forKey:@"class_name"];
                    break;
                case 7:
                    [dicStudentDetail setValue:value forKey:@"contact_sfo"];
                    break;
                case 8:
                    [dicStudentDetail setValue:value forKey:@"doctor_name"];
                    break;
                case 9:
                    [dicStudentDetail setValue:value forKey:@"doctor_contact"];
                    break;
                default:
                    break;
            }
        }
        
                [self.studentDetailTable reloadData];
        
        NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];

        [userObj editStudentDetail:[dicStudentDetail valueForKey:@"student_id"] Language:lang Data:dicStudentDetail :^(NSObject *resObj) {
            [GeneralUtil hideProgress];
            
            NSDictionary *dicRes = (NSDictionary *)resObj;
            
            if (dicRes != nil) {
                if ([[dicRes valueForKey:@"msg"] isEqualToString:@"Success"])
                {
                    [self.btnDone setTitle:@"Done" forState:UIControlStateNormal];
                    NSLog(@"Request Success...");
                }
                else
                    NSLog(@"Request Fail...");
            }
            else {
                NSLog(@"Request Fail...");
            }

        }];
    }
    else
    {
        [((UINavigationController*)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }
}

- (void) editStudentDetail
{
    
}

- (IBAction)onClickCancelButton:(UIButton *)sender {
    if (isEdit) {
        isEdit = NO;
        
        if (lastTextField != nil)
        {
            [lastTextField resignFirstResponder];
        }
        
        [self.btnDone setTitle:@"Done" forState:UIControlStateNormal];
        [self.studentDetailTable reloadData];
    }
    else
        [((UINavigationController*)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    lastTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [dicProfile setValue:textField.text forKey:[NSString stringWithFormat:@"%ld", textField.tag]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
        return 10;
    else
    {
        int count = (int)arrCheckOutRule.count;
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if ( indexPath.section == 0 )
    {
        ProfileDetailTableViewCell *cell = (ProfileDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileDetailTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        NSString *caption = @"";
        NSString *content = @"";
        
        switch (indexPath.row) {
            case 0:
                caption = @"First Name";
                content = [dicStudentDetail valueForKey:@"first_name"];
                break;
            case 1:
                caption = @"Last Name";
                content = [dicStudentDetail valueForKey:@"last_name"];
                break;
            case 2:
                caption = @"Email";
                content = [dicStudentDetail valueForKey:@"email"];
                break;
            case 3:
                caption = @"Mobile";
                content = [dicStudentDetail valueForKey:@"mobile"];
                break;
            case 4:
                caption = @"Telephone";
                content = [dicStudentDetail valueForKey:@"telephone"];
                break;
            case 5:
                caption = @"Half/Full day";
                if ([[dicStudentDetail valueForKey:@"flag"] integerValue] == 1)
                    content = @"Full day";
                else
                    content = @"Half day";
                break;
            case 6:
                caption = @"Classname";
                content = [dicStudentDetail valueForKey:@"class_name"];
                break;
            case 7:
                caption = @"Contact SFO";
                content = [[dicStudentDetail valueForKey:@"contact_sfo"] isEqual:[NSNull null]] ? @"" : [dicStudentDetail valueForKey:@"contact_sfo"];
                break;
            case 8:
                caption = @"Doctor Name";
                content = [[dicStudentDetail valueForKey:@"doctor_name"] isEqual:[NSNull null]] ? @"" : [dicStudentDetail valueForKey:@"doctor_name"];
                break;
            case 9:
                caption = @"Doctor Contact";
                content = [[dicStudentDetail valueForKey:@"doctor_contact"] isEqual:[NSNull null]] ? @"" : [dicStudentDetail valueForKey:@"doctor_contact"];
                cell.lblSeparator.hidden = YES;
                break;
            default:
                break;
        }
        cell.lblCaption.text = caption;
        if (isEdit)
        {
            cell.txtEditContent.text = content;
            cell.txtEditContent.hidden = NO;
            cell.txtEditContent.tag = indexPath.row;
            cell.txtEditContent.delegate = self;
            cell.lblContent.hidden = YES;
        }
        else
        {
            cell.lblContent.text = content;
            cell.txtEditContent.hidden = YES;
            cell.lblContent.hidden = NO;
        }
        return cell;
    }
    
    ProfileDetailTableViewCell2 *cell = (ProfileDetailTableViewCell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileDetailTableViewCell2" owner:self options:nil] objectAtIndex:0];
    }
    
    NSDictionary *dic = [arrCheckOutRule objectAtIndex:indexPath.row];
    
    NSString *date = @"";
    
    switch ([[dic valueForKey:@"weekday"] integerValue]) {
        case 0:
            date = @"Sunday";
            break;
        case 1:
            date = @"Monday";
            break;
        case 2:
            date = @"TuesDay";
            break;
        case 3:
            date = @"WednesDay";
            break;
        case 4:
            date = @"Thursday";
            break;
        case 5:
            date = @"Friday";
            break;
        case 6:
            date = @"SaturDay";
            break;
        default:
            break;
    }
    
    NSString *method = @"bus";
    switch ([[dic valueForKey:@"type"] integerValue]) {
        case 0:
            method = @"bus";
            break;
        case 1:
            method = @"parent";
            break;
        case 2:
            method = @"friend";
            break;
        default:
            break;
    }
    
    cell.lblType.text = [NSString stringWithFormat:@"%@ - %@ (%@)", date, method, [dic valueForKey:@"time"]];
    [cell.imgStatus setImage:[UIImage imageNamed:method]];
    
        /*
    NSString *type = @"";
    NSString *imgStatus = @"";

    switch (indexPath.row) {
        case 0:
            type = @"First Name";
            imgStatus = @"Chris";
            break;
        case 1:
            type = @"First Name";
            imgStatus = @"Chris";
            break;

        default:
            break;
    }
    cell.lblType.text = type;
    cell.lblContent.text = content;
    [cell.imgStatus setImage:[UIImage imageNamed:imgStatus];
*/
    
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -5, tableView.frame.size.width, 40)];
        view.backgroundColor = [UIColor colorWithRed:221.0f/255.0 green:221.0f/255.0 blue:221.0f/255.0 alpha:1.0];
        UILabel *lblWeek = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, tableView.frame.size.width, 16)];
        lblWeek.textColor = [UIColor colorWithRed:0.0f/255.0 green:42.0f/255.0 blue:84.0f/255.0 alpha:1.0f];
        lblWeek.text = @"WEEKLY CHECKOUT STATUS";
        lblWeek.font = FONT_16_BOLD;
        
        [view addSubview:lblWeek];
        
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
        return view;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
