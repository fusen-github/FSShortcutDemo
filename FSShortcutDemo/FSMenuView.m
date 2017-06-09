//
//  FSMenuView.m
//  FSShortcutDemo
//
//  Created by 付森 on 17/6/9.
//  Copyright © 2017年 四维图新. All rights reserved.
//

#import "FSMenuView.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation FSMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    NSArray *itmeArray = @[@"001",@"002",@"003",@"004",
                           @"005",@"006",@"007",@"007",
                           @"008",@"009",@"010",@"011"];
    
    int allColumn = 4;
    
    CGFloat margin = 10;
    
    CGFloat btnW = (self.width - (allColumn + 1) * margin) / allColumn;
    
    CGFloat btnH = btnW;
    
    CGFloat btnX = 0;
    
    CGFloat btnY = 0;
    
    for (int i = 0; i < itmeArray.count; i++)
    {
        NSString *title = [itmeArray objectAtIndex:i];
        
        UIButton *button = [self buttonWithItem:title];
        
        int row = i / allColumn;
        
        int column = i % allColumn;
        
        btnX = margin + (btnW + margin) * column;
        
        btnY = margin + (btnH + margin) * row;
        
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [self addSubview:button];
    }
}

- (void)clickItemButton:(UIButton *)button
{
    
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    UIButton *btn = (UIButton *)gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
//        UIButton *cpButton = [self buttonWithItem:btn.userInfo];
//        
//        cpButton.frame = btn.frame;
//        
//        [btn.superview addSubview:cpButton];
        
        CGPoint point = [gesture locationInView:self];
        
        point.x += self.frame.origin.x;
        
        point.y += self.frame.origin.y;
        
        btn.layer.cornerRadius = 15;
        
        btn.layer.masksToBounds = YES;
        
        btn.alpha = 0.5;
        
        if ([self.delegate respondsToSelector:@selector(menu:beginDragButton:)])
        {
            [self.delegate menu:self beginDragButton:btn];
        }
        
        btn.center = point;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [gesture locationInView:btn.superview];
        
        btn.center = point;
        
        if ([self.delegate respondsToSelector:@selector(menu:isDragingButton:)])
        {
            [self.delegate menu:self isDragingButton:btn];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(menu:endDragButton:)])
        {
            [self.delegate menu:self endDragButton:btn];
        }
    }
}

- (UIButton *)buttonWithItem:(id)item
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor blueColor];
    
    [button setTitle:item forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(clickItemButton:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    
    [button addGestureRecognizer:longGesture];
    
    return button;
}


@end
