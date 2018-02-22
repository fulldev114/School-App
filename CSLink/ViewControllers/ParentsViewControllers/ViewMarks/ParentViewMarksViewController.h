//
//  ViewMarksViewController.h
//  CSAdmin
//
//  Created by etech-dev on 10/6/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEARImageSlideViewController.h"

@interface ParentViewMarksViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PEARSlideViewDelegate>
{

    __weak IBOutlet UIView *viewFirstSem;
    __weak IBOutlet UIView *viewSecSem;
    __weak IBOutlet UIButton *btnFirstSem;
    __weak IBOutlet UIButton *btnSecondSem;
    __weak IBOutlet UILabel *lblSubjectInfo;
    __weak IBOutlet UILabel *lblTestInfo;
    __weak IBOutlet UITableView *tblMarkView;
    __weak IBOutlet UIButton *btnDownload;
    __weak IBOutlet UIView *bottomFistSem;
    __weak IBOutlet UIView *BottomRight;
    __weak IBOutlet UILabel *lblNoDataFond;
    __weak IBOutlet UIButton *btnDownload1;
    __weak IBOutlet UIButton *btnCancel;
    __weak IBOutlet UIButton *btnWithImg;
    __weak IBOutlet UILabel *lblWithImg;
    __weak IBOutlet NSLayoutConstraint *bottomSpach;
}
@property (nonatomic , strong) NSDictionary *dicStudantDetail;
@property (nonatomic,retain) PEARImageSlideViewController * slideImageViewController;
- (IBAction)btnFirstSemPress:(id)sender;
- (IBAction)btnSecondSemPress:(id)sender;
- (IBAction)btnDownloadPress:(id)sender;
- (IBAction)btnCancelPress:(id)sender;
- (IBAction)btnDonload1Press:(id)sender;
- (IBAction)btnWithImgPress:(id)sender;
@end
