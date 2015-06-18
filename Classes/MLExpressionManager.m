//
//  MLExpressionManager.m
//  Pods
//
//  Created by molon on 15/6/18.
//
//

#import "MLExpressionManager.h"
#import "MLTextAttachment.h"

#define kExpressionLineHeightMultiple 1.4f

@interface MLExpression()

@property (nonatomic, strong) NSString *regex;
@property (nonatomic, strong) NSString *plistName;
@property (nonatomic, strong) NSString *bundleName;

@property (nonatomic, strong) NSRegularExpression *expressionRegularExpression;
@property (nonatomic, strong) NSDictionary *expressionMap;

- (BOOL)isValid;

@end

@interface MLExpressionManager()

@property (nonatomic, strong) NSMutableDictionary *expressionMapRecords;
@property (nonatomic, strong) NSMutableDictionary *expressionRegularExpressionRecords;

@end

@implementation MLExpressionManager

+ (instancetype)sharedInstance {
    static MLExpressionManager *_sharedInstance = nil;
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



- (NSAttributedString*)expressionAttributedStringWithAttributedString:(NSAttributedString*)attributedString expression:(MLExpression*)expression {
    NSAssert(expression&&[expression isValid], @"expression invalid");
    
    //TODO: 这个最好是放到单独的线程里然后做回调,还需要搞个多线程计算，最后同步结果
    if (attributedString.length<=0) {
        return attributedString;
    }
    
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    
    //处理表情
    NSArray *results = [expression.expressionRegularExpression matchesInString:attributedString.string
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
        NSString *imageName = expression.expressionMap[expressionAttrStr.string];
        if (imageName.length>0) {
            //加个表情到结果中
            NSString *imagePath = [expression.bundleName stringByAppendingPathComponent:imageName];
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

@end



@implementation MLExpression

- (BOOL)isValid
{
    return self.expressionRegularExpression&&self.expressionMap&&self.bundleName.length>0;
}

+ (instancetype)expressionWithRegex:(NSString*)regex plistName:(NSString*)plistName bundleName:(NSString*)bundleName
{
    MLExpression *expression = [MLExpression new];
    expression.regex = regex;
    expression.plistName = plistName;
    expression.bundleName = bundleName;
    NSAssert([expression isValid], @"此expression无效，请检查参数");
    return expression;
}

#pragma mark - setter
- (void)setRegex:(NSString *)regex
{
    NSAssert(regex.length>0, @"regex length must >0");
    _regex = regex;
    
    self.expressionRegularExpression = [[MLExpressionManager sharedInstance]expressionRegularExpressionWithRegex:regex];
}

- (void)setPlistName:(NSString *)plistName
{
    
    NSAssert(plistName.length>0, @"plistName's length must >0");
    

    if (![[plistName lowercaseString] hasSuffix:@".plist"]) {
        plistName = [plistName stringByAppendingString:@".plist"];
    }
    
    _plistName = plistName;
    
    self.expressionMap = [[MLExpressionManager sharedInstance]expressionMapWithPlistName:plistName];
}

- (void)setBundleName:(NSString *)bundleName
{
    if (![[bundleName lowercaseString] hasSuffix:@".bundle"]) {
        bundleName = [bundleName stringByAppendingString:@".bundle"];
    }
    
    _bundleName = bundleName;
    //TODO 这个最好验证下存在性，后期搞
}


@end

