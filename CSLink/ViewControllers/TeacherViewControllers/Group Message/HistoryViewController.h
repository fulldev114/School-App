//
//  HistoryViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/13/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryMessageDeleget;

@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UIView *popupView;
}

@property (assign, nonatomic) id <HistoryMessageDeleget> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDate:(id)obj;
- (IBAction)btnClose:(id)sender;

@end

@protocol HistoryMessageDeleget<NSObject>

@optional
- (void)selectedValue:(NSString *)Message;

@end