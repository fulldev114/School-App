//
//  EnterCharecterViewController.h
//  CSAdmin
//
//  Created by etech-dev on 7/5/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterCharecterViewController : UIViewController<UITextViewDelegate>
{
    __weak IBOutlet UILabel *lblSubjectInfo;
    __weak IBOutlet UIView *subjectSepView;
    __weak IBOutlet UILabel *lblStudyYear;
    __weak IBOutlet UIButton *btnSelecteYear;
    __weak IBOutlet UIView *seperatorView1;
    __weak IBOutlet UILabel *lblSemesterNum;
    __weak IBOutlet UIButton *btnSelecteSem;
    __weak IBOutlet UIView *seperatorView2;
    __weak IBOutlet UILabel *lblselectSubject;
    __weak IBOutlet UIButton *btnSelectSub;
   
    __weak IBOutlet UIView *seperatorView3;
    __weak IBOutlet UITextView *txvComments;
    __weak IBOutlet UIButton *btnSave;
    __weak IBOutlet UILabel *lblComment;
    __weak IBOutlet UIView *commentView;
}

@property (nonatomic ,strong) NSDictionary *dicStud;

- (IBAction)btnSelectYearPress:(id)sender;
- (IBAction)btnSelecteSemPress:(id)sender;
- (IBAction)btnSelecteSubPress:(id)sender;
- (IBAction)btnSavePress:(id)sender;
@end
