//
//  UpdateYappoViewController.h
//  Yappo
//
//  Created by Susheel on 28/07/14.
//  Copyright (c) 2014 kETAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateYappoViewController : UIViewController {
    
    IBOutlet UILabel *lblMsg;
    IBOutlet UIButton *btnUpgrade;
    IBOutlet UIButton *btnSkip;
   
    IBOutlet NSLayoutConstraint *bottomspace;
}
@property (nonatomic, retain) NSDictionary *dictUpdateApp;
- (IBAction)btnPressUpgrade:(id)sender;


@end
