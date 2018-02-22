//
//  SettingViewController.h
//  CSAdmin
//
//  Created by etech-dev on 6/21/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
{

    __weak IBOutlet UIImageView *imgLogo;
    __weak IBOutlet UIButton *btnEnglish;
    __weak IBOutlet UIButton *btnNorw;
    __weak IBOutlet UIButton *btnAboutAs;
    __weak IBOutlet UIButton *btnChangePin;
}
- (IBAction)btnEnglishPress:(id)sender;
- (IBAction)btnNorwPress:(id)sender;
- (IBAction)btnAboutAsPress:(id)sender;
- (IBAction)btnChangePinPress:(id)sender;
@end
