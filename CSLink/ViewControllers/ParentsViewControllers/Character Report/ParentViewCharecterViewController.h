//
//  ViewCharecterViewController.h
//  CSAdmin
//
//  Created by etech-dev on 10/19/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentViewCharecterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{

    __weak IBOutlet UIView *verticalSeparetor;
    __weak IBOutlet UIView *celanderView;
    __weak IBOutlet UILabel *lblToDate;
    __weak IBOutlet UILabel *lblFromDate;
    __weak IBOutlet UILabel *lblTo;
    __weak IBOutlet UITableView *tblBehaviyor;
    __weak IBOutlet UILabel *lblNoDataFond;
    
    __weak IBOutlet UIButton *btnDescipline;
    __weak IBOutlet UIButton *btnBehaviour;
    __weak IBOutlet UIView *leftTopView;
    __weak IBOutlet UIView *rightTopView;
    __weak IBOutlet UIView *leftBottomView;
    __weak IBOutlet UIView *rightBottomView;
    __weak IBOutlet UIButton *btnDownload;
}
@property (nonatomic , strong) NSDictionary *dicStudantDetail;
- (IBAction)btnFromDate:(id)sender;
- (IBAction)btnToDate:(id)sender;
- (IBAction)btnDescplinePress:(id)sender;
- (IBAction)btnBehaviourPress:(id)sender;
- (IBAction)btnDownloadPress:(id)sender;
@end
