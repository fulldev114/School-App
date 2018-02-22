//
//  ActivityDetailViewController.m
//  CSLink
//
//  Created by adamlucas on 5/26/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "BaseViewController.h"
#import "TeacherUser.h"
#import "TeacherConstant.h"

@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController
{
    TeacherUser *userObj;
    NSDictionary* activityDetails;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[BaseViewController setNavigationBack:self title:@"Swimming" titleColor:TEXT_COLOR_LIGHT_YELLOW WithSel:@selector(onTouchedBack:)];
	
    if (self.isTeacher)
        self.navigationItem.rightBarButtonItem = [BaseViewController getRightButtonWithSel:@selector(deleteBtnClick) addTarget:self icon:@"delete"];

    self.teacherNamesLabel.numberOfLines = 10;
    self.studentNamesLabel.numberOfLines = 3;
	[BaseViewController setBackGroud:self];
    userObj = [[TeacherUser alloc] init];
    
    if (!_isTeacher)
    {
        _studentNamesLabel.hidden = YES;
        _studentTitleLabel.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getActivityDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTouchedBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)getActivityDetails {
    
    [userObj getActivityDetails:self.activityId :^(NSObject *resObj) {
        
        [GeneralUtil hideProgress];
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            activityDetails = dicRes;
            self.titleLabel.text = [activityDetails objectForKey:@"activity_name"];
            self.placeLabel.text = [activityDetails objectForKey:@"place"];
            self.dateLabel.text = [activityDetails objectForKey:@"date"];
            self.timeLabel.text = [activityDetails objectForKey:@"time"];
            
            NSMutableArray *arrTeacher = [activityDetails objectForKey:@"teacher_names"];
            NSMutableArray *arrStudent = [activityDetails objectForKey:@"student_names"];
            NSString *strTeacher = @"", *strStudent = @"";
            for (NSDictionary *dic in arrStudent)
            {
                NSString *student = [dic valueForKey:@"name"];
                NSString *name = [student stringByReplacingOccurrencesOfString:@"," withString:@""];
                strStudent = [strStudent stringByAppendingString:name];
                
                if (![[[arrStudent lastObject] valueForKey:@"name"] isEqualToString:student])
                    [strStudent stringByAppendingString:@", "];
            }
            self.studentNamesLabel.text = strStudent;
            
            for (NSDictionary *dic in arrTeacher)
            {
                NSString *teacher = [dic valueForKey:@"name"];
                NSString *name = [teacher stringByReplacingOccurrencesOfString:@"," withString:@""];
                strTeacher = [strTeacher stringByAppendingString:name];
                
                if (![[[arrTeacher lastObject] valueForKey:@"name"] isEqualToString:teacher])
                    [strTeacher stringByAppendingString:@", "];
            }
            self.teacherNamesLabel.text = strTeacher;
            
        }
        else {
            NSLog(@"Request Fail...");
        }
    }];
}

- (void) deleteBtnClick
{
    
    [userObj getStudentsList:[GeneralUtil getUserPreference:key_teacherId] classId:@"" :^(NSObject *resObj) {
        
        
        NSDictionary *dicRes = (NSDictionary *)resObj;
        
        if (dicRes != nil) {
            
            NSMutableArray *arrData = (NSMutableArray *)[dicRes valueForKey:@"students"];
            
            BOOL isActivityUsing = NO;
            for(NSDictionary* one in arrData)
            {
                if ([one valueForKey:@"sfo_status"] == [NSNull null])
                    continue;
                
                int status = [[one valueForKey:@"sfo_status"] intValue];
                if( status == ACTIVITY_CHECKEDIN && [[one valueForKey:@"activity_id"] isEqualToString:self.activityId])
                {
                    isActivityUsing = YES;
                    break;
                }
            }
            
            if (isActivityUsing) {
                [GeneralUtil hideProgress];

                NSString *msg = @"The students checked in this acticity now.\nPlease check out the student first.";
                
                CustomIOS7AlertView *alertView = [GeneralUtil alertInfo:msg WithDelegate:self];
                [alertView show];
            }
            else
            {
                [userObj deleteActivity:self.activityId :^(NSObject *resObj) {
                    NSDictionary *dicRes = (NSDictionary *)resObj;
                    
                    if (dicRes != nil) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
            
        }
        else {
            [GeneralUtil hideProgress];

            NSLog(@"Request Fail...");
        }
    }];
}

- (void)alertView:(CustomIOS7AlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    

}
@end
