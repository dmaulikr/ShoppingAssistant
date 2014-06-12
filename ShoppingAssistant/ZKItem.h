//
//  ZKItem.h
//  ShoppingAssistant
//
//  Created by zikong on 14/6/11.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKItem : NSObject
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortInfo;
@property (nonatomic) float price;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *image;
@end
