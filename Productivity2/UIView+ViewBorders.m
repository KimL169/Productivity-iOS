//
//  UIView+ViewBorders.m
//  Productivity2
//
//  Created by Kim on 09/07/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "UIView+ViewBorders.h"

@implementation UIView (ViewBorders)

- (CALayer *)addBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness
{
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame));
            break;
        case UIRectEdgeAll:
            //call itself again for each edge
            [self addBorder:UIRectEdgeBottom color:color thickness:thickness];
            [self addBorder:UIRectEdgeLeft color:color thickness:thickness];
            [self addBorder:UIRectEdgeRight color:color thickness:thickness];
            [self addBorder:UIRectEdgeTop color:color thickness:thickness];
            break;
        default:
            break;
    }
    
    border.backgroundColor = color.CGColor;
    
    [self.layer addSublayer:border];
    
    return border;
}

@end

