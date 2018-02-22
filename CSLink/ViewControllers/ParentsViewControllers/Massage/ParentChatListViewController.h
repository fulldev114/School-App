//
//  ChatListViewController.h
//  CSLink
//
//  Created by etech-dev on 6/3/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentChatListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{


    __weak IBOutlet UITableView *tblChatList;
}

- (void)reloadData:(NSString *)from;
@end
