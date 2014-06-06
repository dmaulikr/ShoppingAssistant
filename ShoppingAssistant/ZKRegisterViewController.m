//
//  ZKRegisterViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-27.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKRegisterViewController.h"

@interface ZKRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic)  UIButton *registerButton;
@property (strong, nonatomic)  UIButton *cancelButton;

@end

@implementation ZKRegisterViewController
#pragma mark - Getter
- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.69f blue:0.28f alpha:1.00f]] forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.59f blue:0.28f alpha:1.00f]] forState:UIControlStateHighlighted];
        [_registerButton addTarget:self action:@selector(register:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.cancelButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews
{
    self.registerButton.frame = CGRectMake(170, 314, 130, 44);
    self.cancelButton.frame = CGRectMake(20, 314, 130, 44);
}

#pragma mark - Private Method

- (IBAction)textFieldReturnEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (void)register:(id)sender
{
    if ([self.usernameTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if ([self.emailTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入邮箱"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlstr = [NSString stringWithFormat:@"%@/register?username=%@&password=%@&email=%@", SERVER_URL, self.usernameTextField.text, [self.passwordTextField.text md5], self.emailTextField.text];
        NSError *error = nil;
        NSString *downloadData = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlstr] encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVProgressHUD showErrorWithStatus:@"注册失败"];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:[downloadData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            if ([[dict objectForKey:@"code"] intValue] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                });
            }
            else {
                if ([[dict objectForKey:@"success"] boolValue]) {
                    //注册成功
                    [ZKConstValue setLoginUsername:self.usernameTextField.text];
                    [self dismissViewControllerAnimated:NO completion:^{
                        self.registerBlock(self.usernameTextField.text);
                    }];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"用户名已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
