//
//  StudantDetailViewController.m
//  CSLink
//
//  Created by etech-dev on 7/20/16.
//  Copyright © 2016 eTech. All rights reserved.
//

#import "StudantDetailViewController.h"
#import "ParentConstant.h"

@interface StudantDetailViewController ()
{
    NSDictionary *studantDetail;
}
@end

@implementation StudantDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDate:(id)obj {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    studantDetail = (NSDictionary *) obj;
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    [self setUpUi];
//}

-(CGSize)getSizeOfContent:(NSString *)text :(NSString *)font{
    
    CGSize maximumSize = CGSizeMake(220, CGFLOAT_MAX);
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:maximumSize
                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:context].size;
    
    CGSize size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size;
}

-(void)setUpUi {
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    popupView.layer.cornerRadius = 5.0f;
    [BaseViewController formateButtonCyne:btnOk title:[GeneralUtil getLocalizedText:@"BTN_OK_TITLE"]];
    [BaseViewController formateButtonCyne:btnCancel title:[GeneralUtil getLocalizedText:@"BTN_CANCEL_TITLE"]];
    
    lblTitle.text = [GeneralUtil getLocalizedText:@"LBL_STUD_ADD_TITLE"];
    lblTitle.textColor = APP_BACKGROUD_COLOR;
    lblTitle.font = FONT_18_SEMIBOLD;
    
    lblStudName.text = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"LBL_NAME_TITLE"],[studantDetail valueForKey:@"name"]];
    lblStudName.textColor = APP_BACKGROUD_COLOR;
    lblStudName.font = FONT_16_SEMIBOLD;
    
    lblSchAndClass.text = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"LBL_SCHOOL_TITLE"],[studantDetail valueForKey:@"school_name"]];
    lblSchAndClass.textColor = APP_BACKGROUD_COLOR;
    lblSchAndClass.font = FONT_16_SEMIBOLD;
    
    lblClass.text = [NSString stringWithFormat:@"%@: %@",[GeneralUtil getLocalizedText:@"LBL_CLASS_TITLE"],[studantDetail valueForKey:@"class_name"]];
    lblClass.textColor = APP_BACKGROUD_COLOR;
    lblClass.font = FONT_16_SEMIBOLD;
    NSDate *edate = [[NSDate alloc] init];
    
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    
    [dformat setDateFormat:@"yyyy-MM-dd"];
    
//    if ([studantDetail valueForKey:@"birthday"] == [NSNull null]) {
//        birthDate.text = @"";
//    }
//    else {
//        edate = [dformat dateFromString:[studantDetail valueForKey:@"birthday"]];
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"dd-MMM-yyyy"];
//        
//        NSString *ed=[formatter stringFromDate:edate];
//        
//        birthDate.text = [NSString stringWithFormat:@"Birth Date: %@",ed];
//        birthDate.textColor = APP_BACKGROUD_COLOR;
//        birthDate.font = FONT_16_SEMIBOLD;
//    }
    birthDate.hidden = YES;
}

- (IBAction)btnOkPress:(id)sender {
    [self.delegate Done:studantDetail];
    
    if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
        [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }
    else {
        [((UINavigationController *)appDelegate.navigationController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }
}

- (IBAction)btnCancelPress:(id)sender {
    
    if ([[GeneralUtil getUserPreference:key_isStudantSelected] isEqualToString:@"Yes"]) {
        [((UINavigationController *)appDelegate.deckController.centerController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }
    else {
        [((UINavigationController *)appDelegate.navigationController).topViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }
}
@end
