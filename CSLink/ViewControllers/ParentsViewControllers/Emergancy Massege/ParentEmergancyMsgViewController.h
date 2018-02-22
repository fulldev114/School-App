//
//  EmergancyMsgViewController.h
//  CSLink
//
//  Created by etech-dev on 7/26/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentEmergancyMsgViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UITableView *tblEmergancyMsg;
    __weak IBOutlet UILabel *lblNoDataFound;
}
@end
