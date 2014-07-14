//
//  ZKAppDelegate.h
//  ShoppingAssistant
//
//  Created by zikong on 14-5-14.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKAppDelegate : UIResponder <UIApplicationDelegate>
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL isInPay;
@property (nonatomic) BOOL isIn;
+ (void)SetSubViewExternNone:(UIViewController *)viewController;
@end
