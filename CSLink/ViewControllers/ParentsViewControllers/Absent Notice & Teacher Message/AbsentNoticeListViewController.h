//
//  AbsentNoticeListViewController.h
//  CSLink
//
//  Created by etech-dev on 6/9/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbsentNoticeListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UITableView *tblAbsentList;
}
@property (nonatomic,strong) NSString *isAbsentNotice;
@end
