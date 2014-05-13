//
//  ZKNavigationController.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-14.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKNavigationController.h"

@interface ZKNavigationController ()

@end

@implementation ZKNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma public Method
- (void)showMenu
{
    [self.frostedViewController presentMenuViewController];
}


#pragma mark - Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.frostedViewController panGestureRecognized:sender];
}


@end
