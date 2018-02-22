//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "ParentNIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "ParentConstant.h"

@interface ParentNIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@end

@implementation ParentNIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;
@synthesize index;

- (id)showDropDown:(UIButton *)btnView :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction {
    
    selfRef = self;
    //MAX([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)
    
    button = btnView;
    
    bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.tag = NIDROPDOWN_VIEW_TAG;
    bgView.backgroundColor = [UIColor clearColor];
    
    closeButton = [[UIButton alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [closeButton addTarget:self action:@selector(closeWithoutSel:) forControlEvents:UIControlEventTouchUpInside];
    
    
    closeButton.backgroundColor = [UIColor clearColor];
    
    [bgView addSubview:closeButton];
    
    [appDelegate.window addSubview:bgView];
    
    btnSender = btnView;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        
        CGPoint originInSuperview = [bgView convertPoint:CGPointZero fromView:btnView];
        
        CGRect btn = CGRectMake(originInSuperview.x, originInSuperview.y, btnView.frame.size.width, btnView.frame.size.height);
        
        self.list = [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }
        else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        //table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = APP_BACKGROUD_COLOR;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:table.frame byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight  ) cornerRadii:CGSizeMake(4.0, 4.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = table.bounds;
        maskLayer.path  = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
        borderLayer.frame =  table.bounds;
        borderLayer.path  = maskPath.CGPath;
        borderLayer.lineWidth   = 1.0f;
        borderLayer.strokeColor = [UIColor whiteColor].CGColor;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        [table.layer addSublayer:borderLayer];
        
        [UIView commitAnimations];
        [bgView addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }
    else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    
    [UIView commitAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [bgView removeFromSuperview];
        selfRef = nil;
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (IS_IPAD) {
        return 50;
    }
    else {
        return 40;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (IS_IPAD) {
            cell.textLabel.font = [UIFont systemFontOfSize:20];
        }
        else {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        //cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    if ([self.imageList count] == [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        cell.imageView.image = [imageList objectAtIndex:indexPath.row];
    } else if ([self.imageList count] > [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    } else if ([self.imageList count] < [self.list count]) {
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        if (indexPath.row < [imageList count]) {
            cell.imageView.image = [imageList objectAtIndex:indexPath.row];
        }
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    
    
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    
//    for (UIView *subview in btnSender.subviews) {
//        if ([subview isKindOfClass:[UIImageView class]]) {
//            [subview removeFromSuperview];
//        }
//    }
//    
//    imgView.image = c.imageView.image;
//    imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
//    imgView.frame = CGRectMake(5, 5, 25, 25);
//    [btnSender addSubview:imgView];
    
    index = (int)indexPath.row;
    [self myDelegate];
}

-(void)viewDidLayoutSubviews
{
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        [table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
        [table setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void) myDelegate {
    [self hideDropDown:button];
    [self.delegate niDropDownDelegateMethod:self];
}

-(void)closeWithoutSel:(UIButton *)btn {
     [self hideDropDown:button];
}

-(void)dealloc {
//    [super dealloc];
//    [table release];
//    [self release];
}

@end
