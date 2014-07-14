//
//  ZKHomeViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-14.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKHomeViewController.h"
#import "ZKItem.h"
#import "ZKItemTableViewCell.h"

@interface ZKHomeViewController () <UITableViewDataSource, UITableViewDelegate, XHRefreshControlDelegate>
@property (nonatomic, strong) NSMutableArray *likeItemIds;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) XHRefreshControl *refeshControl;
@property (nonatomic) BOOL isLoading;
@end

@implementation ZKHomeViewController
#pragma mark - Accessor
- (NSMutableArray *)likeItemIds
{
    if (!_likeItemIds) {
        _likeItemIds = [NSMutableArray array];
    }
    return _likeItemIds;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
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
    self.title = @"收藏的商品";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(ZKNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogin) name:LOGIN_NOTIFICATION object:nil];
    
    [self.view addSubview:self.tableView];
    if ([ZKConstValue getLogin]) {
        [self handleLogin];
        [ZKConstValue setLogin:NO];
    }
    self.refeshControl = [[XHRefreshControl alloc] initWithScrollView:self.tableView delegate:self];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.refeshControl startPullDownRefreshing];
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

- (void)getUserInfo
{
    self.isLoading = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *username = [ZKConstValue getLoginStatus];
    NSString *dataUrl = [NSString stringWithFormat:@"%@/userinfo?username=%@", SERVER_URL, username];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataUrl]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        if (dict) {
            self.likeItemIds = [dict objectForKey:@"likeList"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            for (NSString *one in self.likeItemIds) {
                [self getLikeList:one];
            }
        });
    }];
    [getDataTask resume];
}

- (void)getLikeList:(NSString *)id
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *dataUrl = [NSString stringWithFormat:@"%@/item?itemId=%@",SERVER_URL, id];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataUrl]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        ZKItem *item = [[ZKItem alloc] init];
        item.name = [dict objectForKey:@"name"];
        item.itemId = [dict objectForKey:@"_id"];
        item.shortInfo = [dict objectForKey:@"shortInfo"];
        item.price = [[dict objectForKey:@"price"] floatValue];
        item.info = [dict objectForKey:@"info"];
        item.category = [dict objectForKey:@"category"];
        item.image = [dict objectForKey:@"image"];
        [self.items addObject:item];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (self.items.count == self.likeItemIds.count) {
                self.isLoading = NO;
                [self.refeshControl endPullDownRefreshing];
                [self.tableView reloadData];
            }
        });
    }];
    [getDataTask resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    if (self.items.count != 0) {
        cell.nameLabel.text = [self.items[indexPath.row] name];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.items[indexPath.row] price]];
        [self downloadImage:[self.items[indexPath.row] itemId] withIndexPath:indexPath];
    }
    
    UIView *devideView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, 320, 1)];
    devideView.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
    [cell addSubview:devideView];
    return cell;
}

#pragma mark - XHRefreshControlDelegate
- (BOOL)isLoading
{
    return self.isLoading;
}

- (BOOL)isLoadMoreRefreshed
{
    return NO;
}

- (void)beginPullDownRefreshing
{
    [self.items removeAllObjects];
    [self getUserInfo];
}

- (void)beginLoadMoreRefreshing
{
    
}

- (NSDate *)lastUpdateTime {
    return [NSDate date];
}

- (BOOL)keepiOS7NewApiCharacter {
    return NO;
}

@end
