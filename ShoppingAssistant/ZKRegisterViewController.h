//
//  ZKRegisterViewController.h
//  ShoppingAssistant
//
//  Created by zikong on 14-5-27.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RegisterBlock)(NSString *username);

@interface ZKRegisterViewController : UIViewController
@property (nonatomic, strong) RegisterBlock registerBlock;
@end
