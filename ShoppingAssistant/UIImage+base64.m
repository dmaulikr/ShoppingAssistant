//
//  UIImage+base64.m
//  ShoppingAssistant
//
//  Created by zikong on 14-5-27.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "UIImage+base64.h"

@implementation UIImage (base64)
- (NSString *)base64String
{
    NSData * data = [UIImagePNGRepresentation(self) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [NSString stringWithUTF8String:[data bytes]];
}
@end
