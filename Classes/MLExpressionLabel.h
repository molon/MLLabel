//
//  MLExpressionLabel.h
//  MLLabel
//
//  Created by molon on 15/6/11.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLLinkLabel.h"

@interface MLExpressionLabel : MLLinkLabel

@property (nonatomic, copy) NSString *expressionRegex; //表情正则
@property (nonatomic, copy) NSString *expressionPlistName; //表情标识字符串和表情名称的对应
@property (nonatomic, copy) NSString *expressionBundleName; //表情图像包bundle名字


//因为原文本最终会因为表情会修正，所以操作时候还是使用expressionText合适点，取出原文本也用expressionText取合适
//给这玩意赋值前必须先指定emojiRegex和emojiPlistName
@property (nonatomic, copy) id expressionText;

@end
