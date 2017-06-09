//
//  FSModalController.h
//  FSShortcutDemo
//
//  Created by 付森 on 17/6/9.
//  Copyright © 2017年 四维图新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FSModalController : NSObject

/// default [[UIColor blackColor] colorWithAlphaComponent:0.75];
@property (nonatomic, strong) UIColor *coverColor;

/// default NO
@property (nonatomic) BOOL touchDismiss;

+ (instancetype)shareInstance;

- (void)presentView:(UIView *)view;

- (void)presentView:(UIView *)view center:(CGPoint)center;

- (void)presentView:(UIView *)view center:(CGPoint)center complect:(void(^)())complect;

- (void)presentView:(UIView *)view origin:(CGPoint)origin complect:(void(^)())complect;

- (void)dismissViewAnimated:(BOOL)animated;

- (void)dismissViewAnimated:(BOOL)animated complect:(void(^)())complect;

@end
