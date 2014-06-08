//
//  ZKHomeViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-14.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKHomeViewController.h"

@interface ZKHomeViewController ()

@end

@implementation ZKHomeViewController

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
    self.title = @"购物单";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(ZKNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogin) name:LOGIN_NOTIFICATION object:nil];
    
    if ([ZKConstValue getLogin]) {
        [self handleLogin];
        [ZKConstValue setLogin:NO];
    }
}

#pragma mark - private method
- (void)handleLogin
{
    [SVProgressHUD show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *username = [ZKConstValue getLoginStatus];
    NSString *imageUrl = [NSString stringWithFormat:@"%@/avatar?username=%@", SERVER_URL, username];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDownloadTask *getImageTask = [session downloadTaskWithURL:[NSURL URLWithString:imageUrl] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [SVProgressHUD dismiss];
        });
        if (error) {
            NSLog(@"error:%@", error.description);
            return ;
        }
        NSData *downloadedImage = [NSData dataWithContentsOfURL:location];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/avatar.png"];
        [downloadedImage writeToFile:path atomically:YES];
        
    }];
    [getImageTask resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
