//
//  MainScreenViewController.h
//  CSLink
//
//  Created by MobileMaster on 5/15/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnTeacher;
@property (weak, nonatomic) IBOutlet UIButton *btnParent;

@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
- (IBAction)buttonClicked:(id)sender;

@end
