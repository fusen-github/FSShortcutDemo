//
//  FSMenuView.h
//  FSShortcutDemo
//
//  Created by 付森 on 17/6/9.
//  Copyright © 2017年 四维图新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSMenuView;
@protocol FSMenuViewDelegate <NSObject>

@optional
- (void)menu:(FSMenuView *)menu beginDragButton:(UIButton *)button;

- (void)menu:(FSMenuView *)menu isDragingButton:(UIButton *)button;

- (void)menu:(FSMenuView *)menu endDragButton:(UIButton *)button;

@end

@interface FSMenuView : UIView

@property (nonatomic, weak) id<FSMenuViewDelegate> delegate;

@end
