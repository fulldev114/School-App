//
//  MenuViewController.h
//  Onjyb
//
//  Created by eTech on 20/05/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UIView *profileView;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *lblUserName;
    IBOutlet UITableView *tblMenu;
    __weak IBOutlet UILabel *lblVersone;
}
@end

