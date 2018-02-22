//
//  HomeViewController.h
//  Onjyb
//
//  Created by etech-dev on 5/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBadgeButton.h"

@interface ParentHomeViewController : UIViewController<UIScrollViewDelegate>
{
    __weak IBOutlet UIView *absentNoticeView;
    __weak IBOutlet UIView *groupMassageView;
    __weak IBOutlet UIView *massageView;
    
    __weak IBOutlet MIBadgeButton *btnMassage;
    __weak IBOutlet UIButton *btnAbsentNotice;
    __weak IBOutlet MIBadgeButton *btnGroupMassage;
    
    __weak IBOutlet NSLayoutConstraint *heightOfScrollView;
    
    __weak IBOutlet UIScrollView *listScrollView;
    __weak IBOutlet UIButton *btnNext;
    __weak IBOutlet UIButton *btnPrevious;
	__weak IBOutlet MIBadgeButton *btnSFO;
}

-(void)setbadge;

- (IBAction)btnNextPress:(id)sender;
- (IBAction)btnPreviousPress:(id)sender;
- (IBAction)btnGroupMessagePress:(id)sender;
- (IBAction)btnMessagePress:(id)sender;
- (IBAction)btnSendAbsent:(id)sender;
- (IBAction)btnSFO:(id)sender;
@end
