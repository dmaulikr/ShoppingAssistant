//
//  ZKSettingsViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14/6/8.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKSettingsViewController.h"
#import "ZKWelcomeViewController.h"
#import "ZKAppDelegate.h"

@interface ZKSettingsViewController ()
@property (nonatomic, strong) UIButton *logoutButton;
@end

@implementation ZKSettingsViewController
#pragma mark - Accesser
- (UIButton *)logoutButton
{
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutButton setTitle:@"退出" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logoutButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.88f green:0.31f blue:0.23f alpha:1.00f]] forState:UIControlStateNormal];
        [_logoutButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.88f green:0.24f blue:0.16f alpha:1.00f]] forState:UIControlStateHighlighted];
        [_logoutButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.88f green:0.24f blue:0.16f alpha:1.00f]] forState:UIControlStateSelected];
        [_logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}
#pragma amrk - Life Circle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    [self.view addSubview:self.logoutButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(ZKNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews
{
    self.logoutButton.frame = CGRectMake(0, 40, 320, 44);
}

#pragma mark - private method
- (void)logout:(id)sender
{
    [ZKConstValue setLoginUsername:nil];
    ZKWelcomeViewController *welcomeViewController = [[ZKWelcomeViewController alloc]init];
    [ZKAppDelegate SetSubViewExternNone:welcomeViewController];
    [self.frostedViewController presentViewController:welcomeViewController animated:NO completion:^{
        
    }];
}


@end
