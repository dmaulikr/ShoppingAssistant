//
//  ZKPayViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14/6/13.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKPayViewController.h"
#import "ZKItemTableViewCell.h"
#import "ZKItem.h"
//#import <LocalAuthentication/LocalAuthentication.h>

@interface ZKPayViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic) float price;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ZKPayViewController
#pragma mark - Accessor
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_payButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.69f blue:0.28f alpha:1.00f]] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.59f blue:0.28f alpha:1.00f]] forState:UIControlStateHighlighted];
        [_payButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
        _payButton.frame = CGRectMake(220, 0, 100, 44);
    }
    return _payButton;
}
#pragma mark - Life circle
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
    self.title = @"支付单";
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancel)];
    UIView *devideView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 45, 320, 1)];
    devideView.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
    [self.view addSubview:devideView];
    [self.view addSubview:self.payButton];
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.textColor = [UIColor colorWithRed:0.88f green:0.31f blue:0.23f alpha:1.00f];
    self.label.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:self.label];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self downLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 44.0f);
    self.payButton.frame = CGRectMake(220, self.view.bounds.size.height - 44, 100, 44);
    self.label.frame = CGRectMake(30, self.view.bounds.size.height - 44, 220, 44);
}
#pragma mark - PrivateMethod
- (void)pay:(id)sender
{
//    LAContext *lol = [[LAContext alloc] init];
//    NSError *error = nil;
//    NSString *msg = @"支付身份认证";
//    if ([lol canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
//        [lol evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:msg reply:^(BOOL succes, NSError *error)
//         {
//             if (succes) {
                 [SVProgressHUD show];
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                 NSString *dataUrl = [NSString stringWithFormat:@"%@/payMoney?username=%@&price=%f", SERVER_URL, [ZKConstValue getLoginStatus], self.price];
                 NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                 NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataUrl]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                     NSError *err = nil;
                     NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                     if ([[dict objectForKey:@"code"] intValue] == 0) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
                         });
                     }
                     else {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
                             [self dismissViewControllerAnimated:YES completion:nil];
                         });
                     }
                 }];
                 [getDataTask resume];
//             }
//             else
//             {
//                 [SVProgressHUD showErrorWithStatus:@"身份认证失败"];
//             }
//         }];
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:@"设备不支持"];
//    }
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)downLoad
{
    [SVProgressHUD show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *dataUrl = [NSString stringWithFormat:@"%@/pay", SERVER_URL];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataUrl]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        for (NSDictionary *one in [dict objectForKey:@"item"]) {
            ZKItem *item = [[ZKItem alloc] init];
            item.name = [one objectForKey:@"name"];
            item.itemId = [one objectForKey:@"_id"];
            item.shortInfo = [one objectForKey:@"shortInfo"];
            item.price = [[one objectForKey:@"price"] floatValue];
            item.info = [one objectForKey:@"info"];
            item.category = [one objectForKey:@"category"];
            item.image = [one objectForKey:@"image"];
            [self.items addObject:item];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [SVProgressHUD dismiss];
            float value = 0.0f;
            for (ZKItem *item in self.items) {
                value += item.price;
            }
            self.price = value;
            self.label.text = [NSString stringWithFormat:@"¥%0.2f",self.price];
            [self.tableView reloadData];
        });
    }];
    [getDataTask resume];
}

- (void)downloadImage:(NSString *)itemId withIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *imageUrl = [NSString stringWithFormat:@"%@/itemImage?itemId=%@", SERVER_URL, itemId];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDownloadTask *getImageTask = [session downloadTaskWithURL:[NSURL URLWithString:imageUrl] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (error) {
                    NSLog(@"error:%@", error.description);
                    return ;
                }
                NSData *downloadedImage = [NSData dataWithContentsOfURL:location];
                UIImage *image = [UIImage imageWithData:downloadedImage];
                ZKItemTableViewCell *cell = (ZKItemTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                cell.iconImageView.image = image;
            });
        }];
        [getImageTask resume];
    });
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UINib *nib = [UINib nibWithNibName:@"ZKItemTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    ZKItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = [self.items[indexPath.row] name];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.items[indexPath.row] price]];
    [self downloadImage:[self.items[indexPath.row] itemId] withIndexPath:indexPath];
    
    UIView *devideView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, 320, 1)];
    devideView.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
    [cell addSubview:devideView];
    return cell;
}

@end
