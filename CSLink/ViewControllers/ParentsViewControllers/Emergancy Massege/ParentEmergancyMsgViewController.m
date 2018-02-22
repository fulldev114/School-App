//
//  EmergancyMsgViewController.m
//  CSLink
//
//  Created by etech-dev on 7/26/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "ParentEmergancyMsgViewController.h"
#import "BaseViewController.h"

@interface ParentEmergancyMsgViewController ()
{
    NSMutableArray  *arrEmgMsg;
    ParentUser *userObj;
}
@end

@implementation ParentEmergancyMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    [BaseViewController setNavigationBack:self title:[GeneralUtil getLocalizedText:@"TITLE_EMERGANCY_SITUATION"] WithSel:@selector(btnBackClick)];
    
    arrEmgMsg = [[NSMutableArray alloc] init];
    userObj = [[ParentUser alloc] init];
    lblNoDataFound.hidden = YES;
    lblNoDataFound.font = FONT_18_BOLD;
    lblNoDataFound.textColor = TEXT_COLOR_WHITE;
    lblNoDataFound.text = [GeneralUtil getLocalizedText:@"LBL_NO_MASSAGE_TITLE"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllChield];
}
-(void)getAllChield {
    
    [userObj getAllEmgMessage:[[GeneralUtil getUserPreference:key_selectedStudant]  valueForKey:@"user_id"] :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            [arrEmgMsg removeAllObjects];
            
            if ([[dicRes valueForKey:@"flag"] intValue] == 1) {
                
                arrEmgMsg = [dicRes valueForKey:@"details"];
                [tblEmergancyMsg reloadData];
            }
            else {
                tblEmergancyMsg.hidden = YES;
                lblNoDataFound.hidden = NO;
            }
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

-(CGSize)getSizeOfContent:(NSString *)text {
    
    CGSize maximumSize = CGSizeMake(SCREEN_WIDTH - 100, CGFLOAT_MAX);
    
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
    return arrEmgMsg.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        imgMsg.contentMode = UIViewContentModeScaleAspectFit;
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
    //  NSString *actualMsg = [tempMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CGSize textSize = [self getSizeOfContent:tempMsg];
    
    bgView.frame = CGRectMake(75, 10, textSize.width + 20, textSize.height + 20);
    lblEmgMessage.frame = CGRectMake(10, 10, textSize.width, textSize.height);
    imgMsg.frame = CGRectMake(20, 10, 40, 40);
    lblDate.frame = CGRectMake(75, textSize.height + 35, SCREEN_WIDTH - 100, 30);
    
    NSDictionary *dicStudantDetail = [arrEmgMsg objectAtIndex:indexPath.row];
    lblEmgMessage.text = [dicStudantDetail valueForKey:@"message_desc"];
    lblDate.text = [GeneralUtil formateData:[dicStudantDetail valueForKey:@"created_at"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
@end
