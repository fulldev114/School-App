//
//  PEARSlideImageViewController.h
//  ImageSlideViewer
//
//  Created by hirokiumatani on 2015/12/01.
//  Copyright © 2015年 hirokiumatani. All rights reserved.
//

#import <UIKit/UIKit.h>
// view
#import "PEARSlideView.h"
#import "PEARZoomView.h"
// util
#import "PEARUtility.h"

/**
 UIWindow(window)
    
    └ PEARSlideView(scrollView)
        └ PEARSlideView(contentView)
            
            └ PEARZoomView(scrollView)
                └ PEARZoomView(imageView)
            
            └ PEARZoomView(scrollView)
                └ PEARZoomView(imageView)
 */

@interface PEARImageSlideViewController : UIViewController
<UIScrollViewDelegate,PEARSlideViewDelegate>{

}

@property(retain,nonatomic) id<PEARSlideViewDelegate>dele;


- (void)showAtIndex:(NSInteger)index;
- (void)setImageLists:(NSArray *)imageLists;
@end
