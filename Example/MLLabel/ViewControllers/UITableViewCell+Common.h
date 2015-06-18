//
//  UITableViewCell+Common.h
//  MLLabel
//
//  Created by molon on 15/6/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Common)

+ (UINib *)nib;
+ (instancetype)instanceFromNib;

+ (NSString *)cellReuseIdentifier;

@end
