//
//  GroupMessageViewController.h
//  CSLink
//
//  Created by etech-dev on 6/27/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"
#import "NSUserDefaults+DemoSettings.h"
#import "JSQMessages.h"
#import "Teacher.h"

@interface ParentGroupMessageViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) Teacher *demoData;
@property (weak, nonatomic) IBOutlet UITableView *tblMessage;

-(void)getMessageOfTeacher;
@end
