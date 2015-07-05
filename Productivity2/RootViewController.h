//
//  RootViewController.h
//  Productivity2
//
//  Created by Kim on 04/07/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface RootViewController : UIViewController <UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;

@end
