//
//  UIButton+Extension.m
//  FSShortcutDemo
//
//  Created by 付森 on 17/6/9.
//  Copyright © 2017年 四维图新. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

const void *userInfoKey;

@implementation UIButton (Extension)

- (void)setUserInfo:(id)userInfo
{
    objc_setAssociatedObject(self, userInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userInfo
{
    return objc_getAssociatedObject(self, userInfoKey);
}

@end
