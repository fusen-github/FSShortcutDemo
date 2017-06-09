//
//  FSFilterView.m
//  FSShortcutDemo
//
//  Created by 付森 on 17/6/9.
//  Copyright © 2017年 四维图新. All rights reserved.
//

#import "FSFilterView.h"

@implementation FSFilterView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self)
    {
        return nil;
    }
    else
    {
        return hitView;
    }
}

@end
