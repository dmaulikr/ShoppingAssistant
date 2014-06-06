//
//  ZKSetAvatarViewController.h
//  ShoppingAssistant
//
//  Created by zikong on 14/6/6.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetAvatarBlock)(BOOL success);

@interface ZKSetAvatarViewController : UIViewController
@property (nonatomic, strong) SetAvatarBlock setAvatarBlock;
@end
