//
//  PageContentViewController.m
//  
//
//  Created by Kim on 04/07/15.
//
//

#import "PageContentViewController.h"

@interface PageContentViewController ()


@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        CGPoint touchPoint = [touch locationInView:self.view];
       
        if (touchPoint.x > 50 && touchPoint.x < 430) {
            return NO;
        }
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
