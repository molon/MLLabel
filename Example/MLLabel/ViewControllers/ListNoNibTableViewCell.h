//
//  ListNoNibTableViewCell.h
//  MLLabel
//
//  Created by molon on 15/6/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MLLabel/MLLinkLabel.h>

@interface ListNoNibTableViewCell : UITableViewCell

@property (nonatomic, strong,readonly) MLLinkLabel *label;

+ (CGFloat)heightForExpressionText:(NSAttributedString*)expressionText width:(CGFloat)width;

@end
