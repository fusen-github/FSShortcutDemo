//
//  FSModalController.m
//  FSShortcutDemo
//
//  Created by 付森 on 17/6/9.
//  Copyright © 2017年 四维图新. All rights reserved.
//

#import "FSModalController.h"

@interface FSModalController ()

@property (nonatomic, weak) UIControl *translucentView;

@property (nonatomic, weak) UIView *modalView;

@end

@implementation FSModalController

static FSModalController *instance = nil;

static dispatch_once_t onceToken;

+ (instancetype)shareInstance
{
    dispatch_once(&onceToken, ^{
        
        instance = [[FSModalController alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.coverColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.touchDismiss = NO;
    }
    return self;
}

- (void)presentView:(UIView *)view
{
    CGPoint center = [UIApplication sharedApplication].windows.firstObject.center;
    
    [self presentView:view center:center];
}

- (void)presentView:(UIView *)view center:(CGPoint)center
{
    [self presentView:view center:center complect:nil];
}

- (void)presentView:(UIView *)view origin:(CGPoint)origin complect:(void (^)())complect
{
    CGPoint center = CGPointMake(origin.x + view.width * 0.5, origin.y + view.height * 0.5);
    
    [self presentView:view center:center complect:complect];
}

- (void)presentView:(UIView *)view center:(CGPoint)center complect:(void (^)())complect
{
    [self.translucentView removeFromSuperview];
    
    self.modalView = view;
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    if (window == nil) return;
    
    if (!self.translucentView)
    {
        UIControl *control = [[UIControl alloc] init];
        
        control.userInteractionEnabled = self.touchDismiss;
        
        self.translucentView = control;
        
        control.frame = window.bounds;;
        
        control.backgroundColor = self.coverColor;
        
        [control addTarget:self
                    action:@selector(touchClickControl:)
          forControlEvents:UIControlEventTouchUpInside];
        
        control.alpha = 0;
        
        [window addSubview:control];
    }
    
    view.alpha = 0;
    
    view.center = window.center;
    
    [window addSubview:view];
    
    self.translucentView.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
       
        self.translucentView.alpha = 1;
        
        view.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        if (complect)
        {
            complect();
        }
    }];
}

- (void)dismissViewAnimated:(BOOL)animated
{
    [self dismissViewAnimated:animated complect:nil];
}

- (void)dismissViewAnimated:(BOOL)animated complect:(void (^)())complect
{
    if (animated)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.translucentView.alpha = 0;
            
            self.modalView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [self.translucentView removeFromSuperview];
            
            [self.modalView removeFromSuperview];
            
            [self deatroySelf];
            
            if (complect)
            {
                complect();
            }
        }];
    }
    else
    {
        [self.translucentView removeFromSuperview];
        
        [self.modalView removeFromSuperview];
        
        if (complect)
        {
            complect();
        }
        
        [self deatroySelf];
    }
}

- (void)touchClickControl:(UIControl *)control
{
    if (_touchDismiss == NO) return;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.translucentView.alpha = 0;
        
        self.modalView.alpha = 0;
        
    } completion:^(BOOL finished) {
       
        [self.translucentView removeFromSuperview];
        
        [self.modalView removeFromSuperview];
        
        [self deatroySelf];
    }];
}

- (void)setCoverColor:(UIColor *)coverColor
{
    if (coverColor == nil) return;
    
    _coverColor = coverColor;
    
    self.translucentView.backgroundColor = coverColor;
}

- (void)setTouchDismiss:(BOOL)touchDismiss
{
    _touchDismiss = touchDismiss;
    
    self.translucentView.userInteractionEnabled = touchDismiss;
}

- (void)deatroySelf
{
    instance = nil;
    
    onceToken = 0;
}

@end
