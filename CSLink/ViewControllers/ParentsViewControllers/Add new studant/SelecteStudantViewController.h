//
//  SelecteStudantViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/23/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudantDetailViewController.h"

@interface SelecteStudantViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CustomPopupViewController,UIAlertViewDelegate,UISearchBarDelegate>
{

    __weak IBOutlet UITableView *tblStudant;
    __weak IBOutlet UILabel *lblNoStudant;
    __weak IBOutlet UISearchBar *searchBox;
}
@property (nonatomic,strong) NSMutableArray *arrStudant;
@end
