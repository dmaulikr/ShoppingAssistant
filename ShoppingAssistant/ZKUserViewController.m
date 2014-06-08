//
//  ZKUserViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14/6/8.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKUserViewController.h"

@interface ZKUserViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *balance;
@end

@implementation ZKUserViewController
#pragma mark - Accesser
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 176) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
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
    self.title = @"用户信息";
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(ZKNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    [self handleLogin];
}

- (void)handleLogin
{
    [SVProgressHUD show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *username = [ZKConstValue getLoginStatus];
    NSString *dataUrl = [NSString stringWithFormat:@"%@/userinfo?username=%@", SERVER_URL, username];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataUrl]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        if (dict) {
            self.username = [dict objectForKey:@"username"];
            self.email = [dict objectForKey:@"email"];
            self.balance = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"balance"] floatValue]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        });
    }];
    [getDataTask resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"用户名", @"邮箱", @"余额"];
        cell.textLabel.text = titles[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 200, cell.bounds.size.height)];
    label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    if (indexPath.row == 0) {
        label.text = self.username;
    }
    else if (indexPath.row == 1) {
        label.text = self.email;
    }
    else if (indexPath.row == 2) {
        label.text = self.balance;
    }
    [cell addSubview:label];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    cell.textLabel.frame = CGRectMake(20, 0, 100, cell.bounds.size.height);
}

@end
