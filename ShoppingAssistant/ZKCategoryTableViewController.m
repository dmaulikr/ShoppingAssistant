//
//  ZKCategoryTableViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14/6/11.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKCategoryTableViewController.h"
#import "ZKItem.h"
#import "ZKCategory.h"
#import "ZKItemTableViewCell.h"

@interface ZKCategoryTableViewController ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation ZKCategoryTableViewController
#pragma mark - Accessor
- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

#pragma mark - Life Circle
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.category.name;
     self.clearsSelectionOnViewWillAppear = YES;
    [self downLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Private Method
- (void)downLoad
{
    [SVProgressHUD show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *dataUrl = [NSString stringWithFormat:@"%@/itemWithCategory?categoryId=%@", SERVER_URL, self.category.id];
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

#pragma mark - Table view data source

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
