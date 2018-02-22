//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NIDROPDOWN_VIEW_TAG 75481254

@class ParentNIDropDown;
@protocol ParentNIDropDownDelegate
- (void) niDropDownDelegateMethod: (ParentNIDropDown *) sender;
@end

@interface ParentNIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
    
    UIView *bgView,*selfRef;
    UIButton *button,*closeButton;
}
@property (nonatomic, retain) id <ParentNIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
@property (nonatomic, readwrite) int index;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction;
@end
