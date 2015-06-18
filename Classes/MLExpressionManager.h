//
//  MLExpressionManager.h
//  Pods
//
//  Created by molon on 15/6/18.
//
//

#import <Foundation/Foundation.h>

@interface MLExpression : NSObject

@property (readonly, nonatomic, strong) NSString *regex;
@property (readonly, nonatomic, strong) NSString *plistName;
@property (readonly, nonatomic, strong) NSString *bundleName;

+ (instancetype)expressionWithRegex:(NSString*)regex plistName:(NSString*)plistName bundleName:(NSString*)bundleName;

@end

@interface MLExpressionManager : NSObject

+ (instancetype)sharedInstance;

- (NSAttributedString*)expressionAttributedStringWithAttributedString:(NSAttributedString*)attributedString expression:(MLExpression*)expression;

@end
