//
//  NSString+MLExpression.m
//  Pods
//
//  Created by molon on 15/6/18.
//
//

#import "NSString+MLExpression.h"

@implementation NSString (MLExpression)

- (NSAttributedString*)expressionAttributedStringWithExpression:(MLExpression*)expression;
{
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:self];
    return [[MLExpressionManager sharedInstance] expressionAttributedStringWithAttributedString:attributedString expression:(MLExpression*)expression];
}

@end
