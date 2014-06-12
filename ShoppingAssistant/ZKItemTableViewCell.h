//
//  ZKItemTableViewCell.h
//  ShoppingAssistant
//
//  Created by zikong on 14/6/11.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
