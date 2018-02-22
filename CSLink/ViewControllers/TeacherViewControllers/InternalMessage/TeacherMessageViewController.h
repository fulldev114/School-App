//
//  TeacherMessageViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/24/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UITableView *tblTeacherList;

}

@property (assign, nonatomic) BOOL bTeacherMode;

@end
