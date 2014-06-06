//
//  ZKLoginViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-26.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKLoginViewController.h"

@interface ZKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic)  UIButton *loginButton;
@property (strong, nonatomic)  UIButton *cancelButton;

@end

@implementation ZKLoginViewController

#pragma mark - Accesser
- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.69f blue:0.28f alpha:1.00f]] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.59f blue:0.28f alpha:1.00f]] forState:UIControlStateHighlighted];
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3]] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark - Life Circle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.cancelButton];
}

- (void)viewWillLayoutSubviews
{
    self.loginButton.frame = CGRectMake(170, 267, 130, 44);
    self.cancelButton.frame = CGRectMake(20, 267, 130, 44);
}

- (void)backgroundTap:(id)sender
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)textFieldReturnEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Method

- (void)login:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlstr = [NSString stringWithFormat:@"%@/login?username=%@&password=%@", SERVER_URL, self.usernameTextField.text, [self.passwordTextField.text md5]];
        NSError *error = nil;
        NSString *downloadData = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlstr] encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:[downloadData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            if ([[dict objectForKey:@"code"] intValue] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                });
            }
            else {
                if ([[dict objectForKey:@"login"] boolValue]) {
                    [ZKConstValue setLoginUsername:self.usernameTextField.text];
                    [self dismissViewControllerAnimated:YES completion:^{
                        self.block(YES);
                    }];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"帐号密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                
            }
        });
    });
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
