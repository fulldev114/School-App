//
//  EnterMarkViewController.h
//  CSAdmin
//
//  Created by etech-dev on 7/4/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "PEARImageSlideViewController.h"

@protocol EnterMarkViewControllerDelegate;

@interface EnterMarkViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,CustomIOS7AlertViewDelegate,PEARSlideViewDelegate>
{
    UIImagePickerController *ipc;
    
    __weak IBOutlet UIScrollView *scrollView;
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
    
    __weak IBOutlet UILabel *lblExamNo;
    __weak IBOutlet UIButton *btnSelectExam;
    
    __weak IBOutlet UILabel *lblSelecteDate;
    __weak IBOutlet UIButton *btnSelecteDate;
    __weak IBOutlet UIView *seperatorView4;
    
    __weak IBOutlet UILabel *lblSetMark;
    __weak IBOutlet UIView *setMarkView;
    __weak IBOutlet UILabel *lblEnterMark;
    __weak IBOutlet UITextField *txtEnterMark;
    __weak IBOutlet UITextField *txtExamAbout;
    __weak IBOutlet UITextView *txvComments;
    __weak IBOutlet UIButton *btnSave;
    __weak IBOutlet UILabel *lblComment;
    __weak IBOutlet UIView *commentView;
    __weak IBOutlet UILabel *lblCurrentYear;
    __weak IBOutlet UIImageView *imgMarks;
    __weak IBOutlet UIButton *btnTackeOrZoomPhoto;
    __weak IBOutlet UIButton *btnDeleteImage;
}

@property (nonatomic ,strong) NSMutableDictionary *dicStud;
@property (nonatomic ,assign) BOOL isEdit;
@property (nonatomic ,strong) NSMutableDictionary *dicEditMark;
@property (nonatomic,retain) PEARImageSlideViewController * slideImageViewController;
@property (strong, nonatomic) id <EnterMarkViewControllerDelegate>delegate;

- (IBAction)btnTackeOrZoomPhoto:(id)sender;
- (IBAction)btnDeleteImg:(id)sender;
- (IBAction)btnSelecteExamPress:(id)sender;
- (IBAction)btnSelectYearPress:(id)sender;
- (IBAction)btnSelecteSemPress:(id)sender;
- (IBAction)btnSelecteSubPress:(id)sender;
- (IBAction)btnSavePress:(id)sender;
- (IBAction)btnSelecteDatePress:(id)sender;
@end

@protocol EnterMarkViewControllerDelegate<NSObject>
@optional

- (void)onSaveCompleted:(NSMutableDictionary *)dicMarkDetail;

@end