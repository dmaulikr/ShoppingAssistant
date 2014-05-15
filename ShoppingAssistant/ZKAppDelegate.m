//
//  ZKAppDelegate.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-14.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKAppDelegate.h"

@interface ZKAppDelegate () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL isInsideRegion;
@end

@implementation ZKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ZKNavigationController *navigationController = [[ZKNavigationController alloc] initWithRootViewController:[[ZKHomeViewController alloc] init]];
    ZKMenuViewController *menuController = [[ZKMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;

    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initLocationManger];
    
    return YES;
}

#pragma mark - PrivateMethod
- (void)initLocationManger
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"0C8CBFDD-B4B8-1DBF-C966-200713AEBB25"];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"iBeacon"];
    
    region.notifyEntryStateOnDisplay = YES;
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
    {
        [self.locationManager startMonitoringForRegion:region];
        [self.locationManager startRangingBeaconsInRegion:region];
        
        // get status update right away for UI
        [self.locationManager requestStateForRegion:region];
    }
    else
    {
        NSLog(@"This device does not support monitoring beacon regions");
    }
}


- (void)_sendEnterLocalNotification
{
    if (!_isInsideRegion)
    {
        UILocalNotification *notice = [[UILocalNotification alloc] init];
        
        notice.alertBody = @"Inside Estimote beacon region!";
        notice.alertAction = @"Open";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notice];
    }
    
    _isInsideRegion = YES;
}

- (void)_sendExitLocalNotification
{
    if (_isInsideRegion)
    {
        UILocalNotification *notice = [[UILocalNotification alloc] init];
        
        notice.alertBody = @"Left Estimote beacon region!";
        notice.alertAction = @"Open";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notice];
    }
    
    _isInsideRegion = NO;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"-------------> didDetermineState");
    
//    [self.locationManager requestStateForRegion:region];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        // don't send any notifications
        return;
    }
    if (state == CLRegionStateInside)
    {
        [self _sendEnterLocalNotification];
    }
    else
    {
        [self _sendExitLocalNotification];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"-------------> didRangeBeacons");
    if ([beacons count] > 0) {
        CLBeacon *nearestExhibit = [beacons firstObject];
        NSLog(@"proximity:%ld        rssi:%ld", nearestExhibit.proximity, (long)nearestExhibit.rssi);
    }
}

@end
