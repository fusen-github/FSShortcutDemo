//
//  FSShortcutController.m
//  FSShortcutDemo
//
//  Created by 付森 on 17/6/9.
//  Copyright © 2017年 四维图新. All rights reserved.
//

#import "FSShortcutController.h"
#import "FSFilterView.h"
#import "UIButton+Extension.h"

@interface FSSlotView : UIView

@property (nonatomic) BOOL highlighted;

@property (nonatomic, weak) UIView *relatedView;

- (BOOL)isContantPoint:(CGPoint)point;

@end

@interface FSShortcutController ()

@property (nonatomic, strong) NSArray *slotArray;

@property (nonatomic, weak) UIVisualEffectView *veView;

@end

@implementation FSShortcutController

- (void)loadView
{
    self.view = [[FSFilterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++)
    {
        FSSlotView *view = [[FSSlotView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        
        view.center = CGPointMake(45, 350 + 70 * i);
        
        [array addObject:view];
    }
    
    for (int i = 0; i < 3; i++)
    {
        FSSlotView *view = [[FSSlotView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        
        view.center = CGPointMake(self.view.width - 45, 350 + 70 * i);
        
        [array addObject:view];
    }
    
    self.slotArray = array;
}

- (void)beginDrag:(UIButton *)button
{
    for (FSSlotView *view in self.slotArray)
    {
        [self.view addSubview:view];
    }
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *veView = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    self.veView = veView;
    
    veView.frame = self.view.bounds;
    
    [self.view addSubview:veView];
    
    [self.view sendSubviewToBack:veView];
    
    [self.view bringSubviewToFront:button];
}

- (void)isDraging:(UIButton *)button
{
    for (FSSlotView *view in self.slotArray)
    {
        view.highlighted = [view isContantPoint:button.center];
    }
}

- (void)endDraging:(UIButton *)button
{
    if ([button.allTargets anyObject] != self) // 从外面拖进来一个button
    {
        FSSlotView *hiSlotView = nil;
        
        for (int i = 0; i < self.slotArray.count; i++)
        {
            FSSlotView *slotView = [self.slotArray objectAtIndex:i];
            
            if (slotView.highlighted)
            {
                hiSlotView = slotView;
                
                break;
            }
        }
        
        if (hiSlotView)
        {
            UIButton *newButton = [self buttonWithItem:button.userInfo];
            
            newButton.layer.cornerRadius = 10;
            
            newButton.layer.masksToBounds = YES;
            
            newButton.frame = CGRectInset(hiSlotView.frame, 5, 5);
            
            [hiSlotView.relatedView removeFromSuperview];
            
            hiSlotView.relatedView = newButton;
            
            [self.view addSubview:newButton];
        }
        
        [button removeFromSuperview];
        
        [self.slotArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    else
    {
        FSSlotView *hiSlotView = nil;
        
        for (int i = 0; i < self.slotArray.count; i++)
        {
            FSSlotView *slotView = [self.slotArray objectAtIndex:i];
            
            if (slotView.highlighted)
            {
                hiSlotView = slotView;
                
                break;
            }
        }
        
        if (hiSlotView)
        {
            [hiSlotView.relatedView removeFromSuperview];
            
            hiSlotView.relatedView = button;
            
            button.frame = CGRectInset(hiSlotView.frame, 5, 5);
            
            [self.view addSubview:button];
        }
        else
        {
            [button removeFromSuperview];
        }
        
        [self.slotArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self.veView removeFromSuperview];
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

- (void)clickItemButton:(UIButton *)button
{
    
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    UIButton *button = (UIButton *)gesture.view;
    
    CGPoint point = [gesture locationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        button.center = point;
        
        for (FSSlotView *view in self.slotArray)
        {
            [self.view addSubview:view];
            
            if ([view.relatedView isEqual:button])
            {
                view.relatedView = nil;
                
                break;
            }
        }
        
        [self beginDrag:button];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        button.center = point;
        
        [self isDraging:button];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        button.center = point;
        
        [self endDraging:button];
    }
    else
    {
        
    }
}


@end

@implementation FSSlotView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    
    [self setNeedsDisplay];
}

- (BOOL)isContantPoint:(CGPoint)point
{
    return CGRectContainsPoint(CGRectInset(self.frame, 10, 10), point);
}

- (CGRect)contentRect
{
    return CGRectInset(self.bounds, 5, 5);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_highlighted)
    {
        CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 5, 5) cornerRadius:10];
    
    CGContextAddPath(context, path.CGPath);
    
    if (_highlighted)
    {
        CGContextSetLineWidth(context, 5);
        
        CGContextSetStrokeColorWithColor(context, [[UIColor yellowColor] colorWithAlphaComponent:0.3].CGColor);
        
        CGContextAddPath(context, path.CGPath);
    }
    
    CGContextStrokePath(context);
}

@end
