//
//  FSShortcutController.h
//  FSShortcutDemo
//
//  Created by 付森 on 17/6/9.
//  Copyright © 2017年 四维图新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSShortcutController : UIViewController

- (void)beginDrag:(UIButton *)button;

- (void)isDraging:(UIButton *)button;

- (void)endDraging:(UIButton *)button;

@end

