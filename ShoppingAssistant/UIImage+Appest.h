//
//  UIImage+Appest.h
//  GTasks
//
//  Created by Chenchao on 4/26/13.
//  Copyright (c) 2013 Appest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Appest)

+ (UIImage*)imageWithColor:(UIColor*)color;
+ (UIImage*)imageWithColor:(UIColor*)color rect:(CGRect)rect;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
