//
//  HistoryViewController.m
//  CSAdmin
//
//  Created by etech-dev on 6/13/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "HistoryViewController.h"
#import "BaseViewController.h"

@interface HistoryViewController ()
{
    NSMutableArray *arrMessage;
}
@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDate:(id)obj {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    arrMessage = (NSMutableArray *)obj;
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
    }
    return self;
}

- (IBAction)btnClose:(id)sender {
    
    [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    popupView.layer.cornerRadius = 10.0f;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setUpUi];
}

-(void)setUpUi {
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    UILabel *lblMsgHistory = [[UILabel alloc] init];
    
    if (IS_IPAD) {
        lblMsgHistory.frame = CGRectMake(0, 0, popupView.frame.size.width , 50);
    }
    else {
        lblMsgHistory.frame = CGRectMake(0, 0, popupView.frame.size.width , 40);
    }
    lblMsgHistory.backgroundColor = TEXT_COLOR_CYNA;
    lblMsgHistory.font = FONT_16_BOLD;
    lblMsgHistory.textColor = TEXT_COLOR_WHITE;
    lblMsgHistory.textAlignment = NSTextAlignmentCenter;
    lblMsgHistory.text = [GeneralUtil getLocalizedText:@"LBL_MSG_HISTORY_TITLE"];
    [popupView addSubview:lblMsgHistory];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:lblMsgHistory.frame byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight ) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = lblMsgHistory.bounds;
    maskLayer.path  = maskPath.CGPath;
    lblMsgHistory.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.frame =  lblMsgHistory.bounds;
    borderLayer.path  = maskPath.CGPath;
    borderLayer.lineWidth   = 1.0f;
    borderLayer.strokeColor = [UIColor clearColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [lblMsgHistory.layer addSublayer:borderLayer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrMessage.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPAD) {
        return 80;
    }
    else {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UILabel *lblStudantName,*lblDate,*lblClass;
    UIView *seperator;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        lblStudantName = [BaseViewController getRowTitleLable:250 text:@""];
        lblStudantName.font = FONT_16_REGULER;
        lblStudantName.textColor = APP_BACKGROUD_COLOR;
        lblStudantName.tag = 200;
        lblStudantName.lineBreakMode = NSLineBreakByWordWrapping;
        lblStudantName.numberOfLines = 0;
        
        lblDate = [BaseViewController  getRowDetailLable:250 text:@""];
        lblDate.font = FONT_12_REGULER;
        lblDate.textColor = TEXT_COLOR_CYNA;
        lblDate.tag = 300;
        
        lblClass = [BaseViewController  getRowDetailLable:250 text:@""];
        lblClass.font = FONT_12_REGULER;
        lblClass.textColor = APP_BACKGROUD_COLOR;
        lblClass.textAlignment = NSTextAlignmentRight;
        lblClass.tag = 400;
        
        seperator = [[UIView alloc] init];
        seperator.backgroundColor = SEPERATOR_COLOR;
        
        if (IS_IPAD) {
            lblStudantName.frame = CGRectMake(10, 5, lblStudantName.frame.size.width, 45);
            lblDate.frame = CGRectMake(10, 35, lblDate.frame.size.width, 45);
            lblClass.frame = CGRectMake(popupView.frame.size.width - 210, 37, 200, 35);
            seperator.frame = CGRectMake(0, 79, popupView.frame.size.width, 1);
        }
        else {
            lblStudantName.frame = CGRectMake(10, 0, lblStudantName.frame.size.width, 40);
            lblDate.frame = CGRectMake(10, 27, lblDate.frame.size.width, 40);
            lblClass.frame = CGRectMake(popupView.frame.size.width - 110, 30, 100, 30);
            seperator.frame = CGRectMake(0, 69, popupView.frame.size.width, 1);
        }
        
        [cell.contentView addSubview:lblStudantName];
        [cell.contentView addSubview:lblDate];
        [cell.contentView addSubview:lblClass];
        [cell.contentView addSubview:seperator];
    }
    else {
        lblStudantName = (UILabel *)[cell.contentView viewWithTag:200];
        lblDate = (UILabel *)[cell.contentView viewWithTag:300];
        lblClass = (UILabel *)[cell.contentView viewWithTag:400];
    }
    
    NSDictionary *dicStudantDetail = [arrMessage objectAtIndex:indexPath.row];
    
    lblStudantName.text = [dicStudantDetail valueForKey:@"message_desc"];
    lblDate.text = [GeneralUtil formateData:[dicStudantDetail valueForKey:@"created_at"]];
    lblClass.text = [NSString stringWithFormat:@"class to:%@",[dicStudantDetail valueForKey:@"class_names"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dicStudantDetail = [arrMessage objectAtIndex:indexPath.row];
    
    [self.delegate selectedValue:[dicStudantDetail valueForKey:@"message_desc"]];
    
    [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

@end
