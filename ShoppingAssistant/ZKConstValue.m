//
//  ZKConstValue.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-26.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKConstValue.h"

@implementation ZKConstValue

+ (void)setLoginUsername:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"loginstatus_username"];
}

+ (NSString *)getLoginStatus
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginstatus_username"];
}

+ (void)setLogin:(BOOL)status
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:status] forKey:@"loginstatus"];
}

+ (BOOL)getLogin
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"loginstatus"] boolValue];
}

@end
