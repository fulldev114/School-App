//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "TeacherNIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "TeacherConstant.h"

@interface TeacherNIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@property(nonatomic, retain) NSArray *selectedStudents;
@property(nonatomic, retain) NSMutableArray *arrBtnCheck;
@end

@implementation TeacherNIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;
@synthesize index;
@synthesize isSingleSelect;
@synthesize arrSelectValue;
@synthesize selectedStudents;


- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction {
    return [self showDropDown:b :height :arr :imgArr :direction withSelect:YES withSelectedData:nil];
}

- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction withSelect:(BOOL)singleSelect withSelectedData:(NSArray *)selectedStud {

    ZDebug(@"all ready selc :%@", selectedStud);
    
    
    isSingleSelect = singleSelect;
    selectedStudents = selectedStud;
    arrSelectValue = [[NSMutableArray alloc] init];
    
    if (selectedStud != nil) {
        for (NSString *stdname in selectedStud) {
            [arrSelectValue addObject:[NSString stringWithFormat:@"%ld",[arr indexOfObject:stdname]]];
        }
    }
    
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        //table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.backgroundColor = [UIColor colorWithRed:0/255.0f green:48/255.0f blue:84/255.0f alpha:1.0f];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        table.separatorColor = [UIColor colorWithRed:63/255.0f green:100/255.0f blue:127/255.0f alpha:1.0f];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    
    
    self.arrBtnCheck = [[NSMutableArray alloc] init];
   // [self setBackgroundColor:[UIColor redColor]];
    
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
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
    if (isSingleSelect)
        return [self.list count];
    
    NSInteger rows = [self.list count] + 1;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%ld", indexPath.row];
    UIButton *btnCheckBox;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (IS_IPAD) {
            cell.textLabel.font = [UIFont systemFontOfSize:20];
        }
        else {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (!isSingleSelect) {
            
            if (indexPath.row == [self.list count])
            {
                cell.textLabel.text = @"Select All";
                cell.textLabel.font = FONT_18_BOLD;
                cell.backgroundColor = [UIColor colorWithRed:0/255.0f green:198/255.0f blue:255/255.0f alpha:1.0f];
            }
            else
            {
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                
                btnCheckBox = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 10, 15, 15)];
                [btnCheckBox setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
                [btnCheckBox setImage:[UIImage imageNamed:@"check-white"] forState:UIControlStateSelected];
                [btnCheckBox addTarget:self action:@selector(btnCheckBox:) forControlEvents:UIControlEventTouchUpInside];
                btnCheckBox.tag = indexPath.row;
                [cell.contentView addSubview:btnCheckBox];
                
                [self.arrBtnCheck addObject:btnCheckBox];
                
                cell.backgroundColor = [UIColor clearColor];

            }
            
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if (indexPath.row < [self.list count])
    {
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
     
        if (selectedStudents != nil && [selectedStudents containsObject:[self.list objectAtIndex:indexPath.row]]) {
         //[btnCheckBox setImage:[UIImage imageNamed:@"checkBlue"] forState:UIControlStateSelected];
         
         //if (![arrSelctecValue containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
            [btnCheckBox setSelected:YES];
         // [arrSelctecValue addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
         // }
        }
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    
    
    for (UIView *subview in btnSender.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    if (btnSender.tag == 777) {
        
    }
    else {
        
        imgView = [[UIImageView alloc] init];
        if (IS_IPAD) {
            if (btnSender.tag == 8) {
                imgView.frame = CGRectMake(btnSender.frame.size.width - 40 , 8, 30, 30);
            }
            else {
                imgView.frame = CGRectMake(btnSender.frame.size.width - 40 , 15, 30, 30);
            }
        }
        else {
            imgView.frame = CGRectMake(btnSender.frame.size.width - 32 , 0, 25, btnSender.frame.size.height);
        }
        imgView.image = [UIImage imageNamed:@"dropdown.png"];
        imgView.contentMode = UIViewContentModeCenter;
        [btnSender addSubview:imgView];
        index = (int)indexPath.row;

    }
    
    if (isSingleSelect) {
        [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
        [self hideDropDown:btnSender];
        [self myDelegate];
    }
    else {
        if (indexPath.row == [self.list count])
        {
            for ( int i = 0; i < self.arrBtnCheck.count; i++)
            {
                UIButton *btn = (UIButton*)[self.arrBtnCheck objectAtIndex:i];
                [btn setSelected:YES];
            }
            
            [arrSelectValue removeAllObjects];
            
            for (int i = 0; i < [self.list count]; i++)
            {
                [arrSelectValue addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
            ZDebug(@"%@",arrSelectValue);
            
            [self myDelegate];


        }
        else
        {
            for (UIView *subview in [c.contentView subviews]) {
                if ([subview isKindOfClass:[UIButton class]]) {
                    [self btnCheckBox:(UIButton *)subview];
                    break;
                }
            }
        }
        

//        UIButton *btn = [ indexOfObject:(UIButton *)];
//        UIButton *btncheck = (UIButton *)[c.contentView viewWithTag:indexPath.row];
//        [self btnCheckBox:btncheck];
    }
}


- (void) myDelegate {
    [self.delegate niDropDownDelegateMethod:self];
}

-(void)dealloc {
//    [super dealloc];
//    [table release];
//    [self release];
}

-(void)btnCheckBox:(UIButton *)sender {
    
    index = (int)sender.tag;
    
    if (sender.selected) {
        sender.selected = !sender.selected;
        [arrSelectValue removeObject:[NSString stringWithFormat:@"%d",index]];
    }
    else {
        
        if (![arrSelectValue containsObject:[NSString stringWithFormat:@"%d",index]]) {
            sender.selected = !sender.selected;
            [arrSelectValue addObject:[NSString stringWithFormat:@"%d",index]];
        }
    }
    
    ZDebug(@"%@",arrSelectValue);
    
    [self myDelegate];

}

@end
