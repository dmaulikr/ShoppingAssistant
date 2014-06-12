//
//  ZKMenuViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-14.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKMenuViewController.h"
#import "ZKSettingsViewController.h"
#import "ZKAppDelegate.h"
#import "ZKUserViewController.h"
#import "ZKAllViewController.h"

@interface ZKMenuViewController ()
@end

@implementation ZKMenuViewController

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
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
#pragma mark -
#pragma mark UITableView Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/avatar.png"];
    UIImage *avatar = [UIImage imageWithContentsOfFile:path];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    if (avatar) {
        imageView.image = avatar;
    }
    else {
        imageView.image = [UIImage imageNamed:@"avator"];
    }
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 50.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 3.0f;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    imageView.layer.shouldRasterize = YES;
    imageView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
    NSString *username = [ZKConstValue getLoginStatus];
    if (username && ![username isEqualToString:@""]) {
        label.text = username;
    }
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    [label sizeToFit];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    
    
    [view addSubview:imageView];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 184.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    if (indexPath.row == 0) {
        ZKHomeViewController *homeViewController = [[ZKHomeViewController alloc] init];
        [ZKAppDelegate SetSubViewExternNone:homeViewController];
        navigationController.viewControllers = @[homeViewController];
    } else if (indexPath.row == 1) {
        ZKAllViewController *allViewController = [[ZKAllViewController alloc] init];
         [ZKAppDelegate SetSubViewExternNone:allViewController];
        navigationController.viewControllers = @[allViewController];
    } else if (indexPath.row == 2) {
        ZKUserViewController *userViewController = [[ZKUserViewController alloc] init];
        [ZKAppDelegate SetSubViewExternNone:userViewController];
        navigationController.viewControllers = @[userViewController];
    } else if (indexPath.row == 3) {
        ZKSettingsViewController *settingsViewContoller = [[ZKSettingsViewController alloc] init];
        [ZKAppDelegate SetSubViewExternNone:settingsViewContoller];
        navigationController.viewControllers = @[settingsViewContoller];
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"主页", @"所有", @"用户", @"设置"];
        cell.textLabel.text = titles[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

@end
