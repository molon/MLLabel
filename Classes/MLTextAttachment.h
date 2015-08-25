//
//  MLTextAttachment.h
//  MLLabel
//
//  Created by molon on 15/6/11.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLTextAttachment : NSTextAttachment

@property (readonly, nonatomic, assign) CGFloat width;
@property (readonly, nonatomic, assign) CGFloat height;

/**
 *  优先级比上面的高，以lineHeight为根据来决定高度
 *  1.如果有提供imageBlock,并且其支持imageBounds为CGRectZero下返回图像的话，宽度会根据图像比例自适应
 *  2.如果没提供imageBlock或者其返回image为nil,会设置宽度和高度相等
 */
@property (readonly, nonatomic, assign) CGFloat lineHeightMultiple;

+ (instancetype)textAttachmentWithWidth:(CGFloat)width height:(CGFloat)height imageBlock:(UIImage * (^)(CGRect imageBounds,NSTextContainer *textContainer,NSUInteger charIndex,MLTextAttachment *textAttachment))imageBlock;

+ (instancetype)textAttachmentWithLineHeightMultiple:(CGFloat)lineHeightMultiple imageBlock:(UIImage * (^)(CGRect imageBounds,NSTextContainer *textContainer,NSUInteger charIndex,MLTextAttachment *textAttachment))imageBlock;

@end
