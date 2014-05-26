//
//  ZKWelcomeViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-26.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKWelcomeViewController.h"
#import "ZKLoginViewController.h"
#import "ZKRegisterViewController.h"

@interface ZKWelcomeViewController ()
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation ZKWelcomeViewController
#pragma mark - Accesser
- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3]] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]] forState:UIControlStateHighlighted];
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)joinButton
{
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton setTitle:@"注册" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_joinButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.69f blue:0.28f alpha:1.00f]] forState:UIControlStateNormal];
        [_joinButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.59f blue:0.28f alpha:1.00f]] forState:UIControlStateHighlighted];
        [_joinButton addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Welcome_background"]];
    }
    return _backgroundImageView;
}

#pragma mark - Life Circle

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundImageView];
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.joinButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews
{
    self.backgroundImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.loginButton.frame = CGRectMake(20, self.view.bounds.size.height - 64, 130, 44);
    self.joinButton.frame = CGRectMake(170, self.view.bounds.size.height - 64, 130, 44);
}

#pragma mark - private method

- (void)login:(id)sender
{
    ZKLoginViewController *loginViewController = [[ZKLoginViewController alloc] initWithNibName:@"ZKLoginViewController" bundle:nil];
    __weak ZKWelcomeViewController *me = self;
    loginViewController.block = ^(BOOL success){
        if (success) {
            [me dismissViewControllerAnimated:NO completion:nil];
        }
    };
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)join:(id)snder
{
    ZKRegisterViewController *registerViewController = [[ZKRegisterViewController alloc] initWithNibName:@"ZKRegisterViewController" bundle:nil];
    __weak ZKWelcomeViewController *me = self;
    registerViewController.block = ^(BOOL success){
        if (success) {
            [me dismissViewControllerAnimated:NO completion:nil];
        }
    };
    [self presentViewController:registerViewController animated:YES completion:nil];
}

@end
