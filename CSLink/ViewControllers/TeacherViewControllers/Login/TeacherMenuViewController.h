//
//  MenuViewController.h
//  Onjyb
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLExpandableTableView.h"
#import "GroupMessageViewController.h"
@interface TeacherMenuViewController : UIViewController<SLExpandableTableViewDatasource,SLExpandableTableViewDelegate>{

    IBOutlet UIView *profileView;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *lblUserName;
    
    __weak IBOutlet SLExpandableTableView *tblMenu;
    __weak IBOutlet UILabel *lblVersone;
}
@end
