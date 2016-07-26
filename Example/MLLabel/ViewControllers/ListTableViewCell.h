//
//  ListTableViewCell.h
//  MLLabel
//
//  Created by molon on 15/6/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MLLabel/MLLinkLabel.h>

@interface ListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MLLinkLabel *contentLabel;

+ (CGFloat)heightForExpressionText:(NSAttributedString*)expressionText width:(CGFloat)width;

@end
