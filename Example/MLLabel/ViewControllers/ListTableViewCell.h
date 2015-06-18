//
//  ListTableViewCell.h
//  MLLabel
//
//  Created by molon on 15/6/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MLLabel/MLExpressionLabel.h>

@interface ListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MLExpressionLabel *textlabel;

+ (CGFloat)heightForExpressionText:(id)expressionText width:(CGFloat)width;

@end
