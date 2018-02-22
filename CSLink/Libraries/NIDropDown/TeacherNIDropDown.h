//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeacherNIDropDown;
@protocol TeacherNIDropDownDelegate
- (void) niDropDownDelegateMethod: (TeacherNIDropDown *) sender;
@end

@interface TeacherNIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}

@property (nonatomic, retain) id <TeacherNIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
@property (nonatomic, readwrite) int index;
@property (nonatomic, assign) BOOL isSingleSelect;
@property(nonatomic, strong) NSMutableArray *arrSelectValue;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction;

- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction withSelect:(BOOL)singleSelect withSelectedData:(NSArray *)selectedStud;

@end
