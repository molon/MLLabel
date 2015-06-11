//
//  MLExpressionLabel.m
//  MLLabel
//
//  Created by molon on 15/6/11.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLExpressionLabel.h"
#import "MLLabel+Override.h"
#import "MLTextAttachment.h"

#define kExpressionLineHeightMultiple 1.4f

//这个是表情的正则对应关系和正则的管理器，可以减少项目所占用内存
@interface MLExpressionLabelExpressionRecordManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *expressionMapRecords;
@property (nonatomic, strong) NSMutableDictionary *expressionRegularExpressionRecords;

@end

@implementation MLExpressionLabelExpressionRecordManager

+ (instancetype)sharedInstance {
    static MLExpressionLabelExpressionRecordManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc]init];
    });
    return _sharedInstance;
}

#pragma mark - getter
- (NSMutableDictionary *)expressionMapRecords
{
    if (!_expressionMapRecords) {
        _expressionMapRecords = [NSMutableDictionary new];
    }
    return _expressionMapRecords;
}

- (NSMutableDictionary *)expressionRegularExpressionRecords
{
    if (!_expressionRegularExpressionRecords) {
        _expressionRegularExpressionRecords = [NSMutableDictionary new];
    }
    return _expressionRegularExpressionRecords;
}

#pragma mark - common
- (NSDictionary*)expressionMapWithPlistName:(NSString*)plistName
{
    NSAssert(plistName&&plistName.length>0, @"expressionMapWithRegex:参数不得为空");
    if (self.expressionMapRecords[plistName]) {
        return self.expressionMapRecords[plistName];
    }
    
    NSString *plistPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plistName];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSAssert(dict,@"表情字典%@找不到,请注意大小写",plistName);
    self.expressionMapRecords[plistName] = dict;
    
    return self.expressionMapRecords[plistName];
}

- (NSRegularExpression*)expressionRegularExpressionWithRegex:(NSString*)regex
{
    NSAssert(regex&&regex.length>0, @"expressionRegularExpressionWithRegex:参数不得为空");
    
    if (self.expressionRegularExpressionRecords[regex]) {
        return self.expressionRegularExpressionRecords[regex];
    }
    
    NSRegularExpression *re = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSAssert(re,@"正则%@有误",regex);
    self.expressionRegularExpressionRecords[regex] = re;
    
    return self.expressionRegularExpressionRecords[regex];
}

@end


@interface MLExpressionLabel()

@property (nonatomic, strong) NSRegularExpression *expressionRegularExpression;
@property (nonatomic, strong) NSDictionary *expressionMap;

@end

@implementation MLExpressionLabel

- (NSString*)imagePathWithName:(NSString*)imageName
{
    return [self.expressionBundleName stringByAppendingPathComponent:imageName];
}

- (NSAttributedString*)expressionAttributedStringWithAttributedString:(NSAttributedString*)attributedString
{
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    
    //处理表情
    NSArray *results = [self.expressionRegularExpression matchesInString:attributedString.string
                                                        options:NSMatchingWithTransparentBounds
                                                          range:NSMakeRange(0, [attributedString length])];
    //遍历表情，然后找到对应图像名称，并且处理
    NSUInteger location = 0;
    for (NSTextCheckingResult *result in results) {
        NSRange range = result.range;
        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:NSMakeRange(location, range.location - location)];
        //先把非表情的部分加上去
        [resultAttributedString appendAttributedString:subAttrStr];
        
        //下次循环从表情的下一个位置开始
        location = NSMaxRange(range);
        
        NSAttributedString *expressionAttrStr = [attributedString attributedSubstringFromRange:range];
        NSString *imageName = self.expressionMap[expressionAttrStr.string];
        if (imageName.length>0) {
            //加个表情到结果中
            NSString *imagePath = [self imagePathWithName:imageName];
            MLTextAttachment *textAttachment = [MLTextAttachment textAttachmentWithLineHeightMultiple:kExpressionLineHeightMultiple imageBlock:^UIImage *(CGRect imageBounds, NSTextContainer *textContainer, NSUInteger charIndex, MLTextAttachment *textAttachment) {
                return [UIImage imageNamed:imagePath];
            }];
            [resultAttributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
        }else{
            //找不到对应图像名称就直接加上去
            [resultAttributedString appendAttributedString:expressionAttrStr];
        }
    }
    
    if (location < [attributedString length]) {
        //到这说明最后面还有非表情字符串
        NSRange range = NSMakeRange(location, [attributedString length] - location);
        NSAttributedString *subAttrStr = [attributedString attributedSubstringFromRange:range];
        [resultAttributedString appendAttributedString:subAttrStr];
    }
    
    return resultAttributedString;
}

#pragma mark - setter
- (void)setExpressionRegex:(NSString *)expressionRegex
{
    NSAssert(expressionRegex.length>0, @"expressionRegex's length must >0");
    NSAssert(!_expressionRegularExpression, @"expressionRegex only can be set once");
    
    _expressionRegex = expressionRegex;
    
    self.expressionRegularExpression = [[MLExpressionLabelExpressionRecordManager sharedInstance]expressionRegularExpressionWithRegex:expressionRegex];
}

- (void)setExpressionPlistName:(NSString *)expressionPlistName
{
    NSAssert(expressionPlistName.length>0, @"expressionPlistName's length must >0");
    NSAssert(!_expressionMap, @"expressionPlistName only can be set once");
    
    if (![[expressionPlistName lowercaseString] hasSuffix:@".plist"]) {
        expressionPlistName = [expressionPlistName stringByAppendingString:@".plist"];
    }
    
    _expressionPlistName = expressionPlistName;
    
    self.expressionMap = [[MLExpressionLabelExpressionRecordManager sharedInstance]expressionMapWithPlistName:expressionPlistName];
}

- (void)setExpressionBundleName:(NSString *)expressionBundleName
{
    NSAssert(expressionBundleName.length>0, @"expressionBundleName's length must >0");
    NSAssert(!_expressionBundleName, @"expressionBundleName only can be set once");
    
    if (![[expressionBundleName lowercaseString] hasSuffix:@".bundle"]) {
        expressionBundleName = [expressionBundleName stringByAppendingString:@".bundle"];
    }
    
    _expressionBundleName = expressionBundleName;
}

- (void)setExpressionText:(id)expressionText
{
    NSAssert(_expressionMap&&_expressionRegularExpression&&_expressionBundleName, @"please set expressionRegex and expressionPlistName and expressionBundleName before setting expressionText");
    NSAssert(!expressionText||([expressionText isKindOfClass:[NSAttributedString class]]||[expressionText isKindOfClass:[NSString class]]),@"expressionText's class must be string");
    
    _expressionText = expressionText;
    
    if (!expressionText) {
        [self setText:nil];
        return;
    }
    
    NSAttributedString *expressionAttrText = [expressionText isKindOfClass:[NSAttributedString class]]?expressionText:[[NSAttributedString alloc]initWithString:expressionText];
    if (expressionAttrText.length<=0) {
        [self setText:@""];
        return;
    }
    
    //根据表情正则和字典来处理text先
    [self setAttributedText:[self expressionAttributedStringWithAttributedString:expressionAttrText]];
}

#pragma mark - UIResponderStandardEditActions
- (void)copy:(__unused id)sender {
    [[UIPasteboard generalPasteboard] setString:self.expressionText];
}

@end
