//
//  ZKConstValue.h
//  ShoppingAssistant
//
//  Created by zikong on 14-5-26.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SERVER_URL @"http://192.168.0.100:1337"
#define SERVER_URL_WITHOUT_HTTP @"192.168.0.100:1337"



@interface ZKConstValue : NSObject

+ (void)setLoginUsername:(NSString *)username;
+ (NSString *)getLoginStatus;
@end
