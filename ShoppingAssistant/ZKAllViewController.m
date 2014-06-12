//
//  ZKAllViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14/6/9.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKAllViewController.h"
#import "ZKCategory.h"
#import "ZKCategoryTableViewController.h"

@interface ZKAllViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *categorys;
@end

@implementation ZKAllViewController
#pragma mark - Accessor
- (UITableView *)tableView
{
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)categorys
{
    if (!_categorys) {
        _categorys = [NSMutableArray array];
    }
    return _categorys;
}
#pragma mark - Life Circle
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
    self.title = @"类目";
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(ZKNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    [self downloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame = self.view.bounds;
}

#pragma mark - PrivateMethod
- (void)downloadData
{
    [SVProgressHUD show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *dataUrl = [NSString stringWithFormat:@"%@/category", SERVER_URL];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataUrl]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        for (NSDictionary *cate in [dict objectForKey:@"categorys"]) {
            ZKCategory *category = [[ZKCategory alloc] init];
            category.name = [cate objectForKey:@"name"];
            category.id = [cate objectForKey:@"_id"];
            [self.categorys addObject:category];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        });
    }];
    [getDataTask resume];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (self.categorys.count != 0) {
        cell.textLabel.text = [self.categorys[indexPath.row] name];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    cell.textLabel.frame = CGRectMake(20, 0, 100, cell.bounds.size.height);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKCategoryTableViewController *categoryController = [[ZKCategoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    categoryController.category = self.categorys[indexPath.row];
    [ZKAppDelegate SetSubViewExternNone:categoryController];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:categoryController animated:YES];
}




@end
