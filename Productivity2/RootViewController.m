//
//  RootViewController.m
//  Productivity2
//
//  Created by Kim on 04/07/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "Productivity2-Swift.h"

@interface RootViewController ()

@end

@implementation RootViewController {
    
#define PAGE_COUNT 3
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create page view controller;
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
   
    NSUInteger index = ((PageContentViewController *)viewController).pageIndex;
    
//    if ((index == 0) || (index == NSNotFound)) {
//        return nil;
//    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
   
    NSUInteger index = ((PageContentViewController *)viewController).pageIndex;
    
//    if ((index == 0) || (index == NSNotFound)) {
//        return nil;
//    }
    
    index++;
    if (index == PAGE_COUNT) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index{
    if (index >= PAGE_COUNT) {
        return nil;
    }
    
    //create a new view controller and pass the suitable data
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentController"];
    if (index == 0) {
        ArchiveViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArchiveViewController"];
        
        [pageContentViewController addChildViewController:VC];
        [pageContentViewController.view addSubview:VC.view];
        [VC didMoveToParentViewController:pageContentViewController];
    } else if (index == 1) {
        ViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [pageContentViewController addChildViewController:VC];
        [pageContentViewController.view addSubview:VC.view];
        [VC didMoveToParentViewController:pageContentViewController];
    } else if (index == 2){
        CalendarViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"CalendarViewController"];
        [pageContentViewController addChildViewController:VC];
        [pageContentViewController.view addSubview:VC.view];
        [VC didMoveToParentViewController:pageContentViewController];
        
    } else {
        return nil;
    }
    
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

//
//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
//    return PAGE_COUNT;
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//    return 1;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
