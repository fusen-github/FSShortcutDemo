//
//  FSMainController.m
//  FSShortcutDemo
//
//  Created by 付森 on 17/6/9.
//  Copyright © 2017年 四维图新. All rights reserved.
//

#import "FSMainController.h"
#import "FSMenuView.h"
#import "FSModalController.h"
#import "FSShortcutController.h"


@interface FSMainController ()<FSMenuViewDelegate>

@property (nonatomic, strong) FSShortcutController *shortcutCon;

@property (nonatomic, strong) FSMenuView *menuView;

@end

@implementation FSMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FSShortcutController *controller = [[FSShortcutController alloc] init];
    
    self.shortcutCon = controller;
    
    [self addChildViewController:controller];
    
    [self.view addSubview:controller.view];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemAction)];
}

- (void)leftBarItemAction
{
    FSMenuView *menuView = [[FSMenuView alloc] initWithFrame:CGRectMake(0, 0, 500, 400)];
    
    self.menuView = menuView;
    
    menuView.backgroundColor = [UIColor redColor];
    
    menuView.delegate = self;
    
    [FSModalController shareInstance].touchDismiss = YES;
    
    [[FSModalController shareInstance] presentView:menuView];
}

#pragma mark FSMenuViewDelegate
- (void)menu:(FSMenuView *)menu beginDragButton:(UIButton *)button
{
    [[FSModalController shareInstance] dismissViewAnimated:YES];
    
    [self.shortcutCon.view addSubview:button];
    
    [self.shortcutCon beginDrag:button];
}

- (void)menu:(FSMenuView *)menu isDragingButton:(UIButton *)button
{
    [self.shortcutCon isDraging:button];
}

- (void)menu:(FSMenuView *)menu endDragButton:(UIButton *)button
{
    [self.menuView removeFromSuperview];
    
    self.menuView = nil;
    
    [self.shortcutCon endDraging:button];
}

@end
