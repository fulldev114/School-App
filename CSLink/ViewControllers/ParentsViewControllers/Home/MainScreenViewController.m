//
//  MainScreenViewController.m
//  CSLink
//
//  Created by MobileMaster on 5/15/17.
//  Copyright © 2017 eTech. All rights reserved.
//

#import "MainScreenViewController.h"
#import "BaseViewController.h"
#import "ParentConstant.h"
#import "ParentLoginViewController.h"
#import "TeacherLoginViewController.h"

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [BaseViewController setBackGroud:self];
    [self setUpUi];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)setUpUi
{
    [BaseViewController formatButton:self.btnTeacher withBgColor:TEXT_COLOR_CYNA title:[GeneralUtil getLocalizedText:@"BTN_ARE_YOU_A_TEACHER"] withIcon:@"btn-teacher"];
    
    [BaseViewController formatButton:self.btnParent withColor:TEXT_COLOR_CYNA title:[GeneralUtil getLocalizedText:@"BTN_ARE_YOU_A_PARENT"] withIcon:@"btn-parent"];
    
    self.lblCopyRight.font      = FONT_16_LIGHT;
    self.lblCopyRight.text      = [GeneralUtil getLocalizedText:@"LBL_COPY_RIGHT"];
    self.lblCopyRight.textColor = TEXT_COLOR_WHITE;
}

-(void) showTeacherLoginView
{
    TeacherLoginViewController * pvc = [[TeacherLoginViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void) showParentLoginView
{
    ParentLoginViewController * pvc = [[ParentLoginViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (IBAction)buttonClicked:(id)sender
{
    switch ([(UIButton *)sender tag])
    {
        case 1:
            [self showTeacherLoginView];
            break;
        case 2:
            [self showParentLoginView];
            break;
        default:
            break;
    }
    
}
@end
