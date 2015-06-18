//
//  UITableViewCell+Common.m
//  MLLabel
//
//  Created by molon on 15/6/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "UITableViewCell+Common.h"

@implementation UITableViewCell (Common)


+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

+ (instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass([self class]);
}


@end
