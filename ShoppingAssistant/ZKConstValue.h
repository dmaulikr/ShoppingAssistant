//
//  ZKConstValue.h
//  ShoppingAssistant
//
//  Created by zikong on 14-5-26.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SERVER_URL @"http://127.0.0.1:1337"
#define SERVER_URL_WITHOUT_HTTP @"127.0.0.1:1337"

#define LOGIN_NOTIFICATION @"loginNotification"



@interface ZKConstValue : NSObject

+ (void)setLoginUsername:(NSString *)username;
+ (NSString *)getLoginStatus;
+ (void)setLogin:(BOOL)status;
+ (BOOL)getLogin;
@end
