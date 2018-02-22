//
//  ClassAndGradeListViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassAndGradeListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *tblClassName;
    __weak IBOutlet UIButton *btnSelectGread;
}
@property (nonatomic,strong) NSDictionary *dicSelectedSchool;
@property (nonatomic,strong) NSArray *arrSchool;
- (IBAction)btnFilter:(id)sender;
@end
