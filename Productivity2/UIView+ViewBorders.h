//
//  UIView+ViewBorders.h
//  Productivity2
//
//  Created by Kim on 09/07/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewBorders)

- (CALayer *)addBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness;
@end
