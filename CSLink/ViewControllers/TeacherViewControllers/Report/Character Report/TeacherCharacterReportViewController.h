//
//  CharacterReportViewController.h
//  CSLink
//
//  Created by etech-dev on 7/5/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherCharacterReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
//    __weak IBOutlet UIView *yearView;
//    __weak IBOutlet UILabel *lblYear;

    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITableView *tblSemesterList;
//    __weak IBOutlet UIButton *btnselecteYear;
    __weak IBOutlet NSLayoutConstraint *tableViewHeight;
}
//- (IBAction)btnselecteYearPress:(id)sender;
@property (nonatomic , strong) NSDictionary *dicStudantDetail;
@end
