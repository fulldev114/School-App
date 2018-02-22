//
//  AbsentDetailViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/14/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLExpandableTableView.h"

@protocol CustomPopupLoginViewController;

@interface AbsentDetailViewController : UIViewController<SLExpandableTableViewDatasource,SLExpandableTableViewDelegate>
{

    __weak IBOutlet UIView *mainView;
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet UIImageView *profileImg;
    __weak IBOutlet UILabel *lbluserName;
    __weak IBOutlet UILabel *lblClassName;
    __weak IBOutlet UIButton *btnDone;
    __weak IBOutlet UIButton *btnCancel;
    __weak IBOutlet SLExpandableTableView *tblExpandeble;
    __weak IBOutlet UILabel *lblSelectDay;
    __weak IBOutlet UIButton *btnCheckFull;
}

@property (assign, nonatomic) id <CustomPopupLoginViewController>delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(id)obj;

- (IBAction)btnDonePress:(id)sender;
- (IBAction)btnCancelPress:(id)sender;
- (IBAction)btnCheckFullDay:(id)sender;
@end

@protocol CustomPopupLoginViewController<NSObject>

@optional
- (void)Done:(NSMutableDictionary *)dicValue;

@end