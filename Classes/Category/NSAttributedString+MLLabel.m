//
//  NSAttributedString+MLLabel.m
//  Pods
//
//  Created by molon on 15/6/13.
//
//

#import "NSAttributedString+MLLabel.h"

@implementation NSAttributedString (MLLabel)

+ (instancetype)attributedStringWithHTML:(NSString*)htmlString
{
    NSData* htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    if (htmlData) {
        __block id attributedString = nil;
        dispatch_block_t block = ^{
            attributedString = [[self alloc] initWithData:htmlData
                                                  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                            NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                       documentAttributes:nil
                                                    error:NULL];
        };
        
        //这个解析必须在主线程执行，文档上要求的
        if ([NSThread isMainThread]) {
            block();
        }else{
            dispatch_sync(dispatch_get_main_queue(), block);
        }
        
        return attributedString;
    }
    
    return nil;
}

- (NSAttributedString*)linkAttributedStringWithLinkRegex:(NSRegularExpression*)linkRegex groupIndexForDisplay:(NSInteger)groupIndexForDisplay groupIndexForValue:(NSInteger)groupIndexForValue {
    NSParameterAssert(linkRegex);
    NSAssert(groupIndexForDisplay>0&&groupIndexForValue>0, @"groupIndexForDisplay and groupIndexForValue must >0!");
    
    NSInteger length = [self length];
    if (length<=0) {
        return self;
    }
    
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    
    //正则匹配所有内容
    NSArray *results = [linkRegex matchesInString:self.string
                                          options:NSMatchingWithTransparentBounds
                                            range:NSMakeRange(0, length)];
    
    //遍历结果，找到结果中被()包裹的区域作为显示内容
    NSUInteger location = 0;
    for (NSTextCheckingResult *result in results) {
        NSAssert([result numberOfRanges]>1&&[result numberOfRanges]>groupIndexForDisplay&&[result numberOfRanges]>groupIndexForValue, @"Please ensure that group sign `()` in the linkRegex is correct!");
        NSRange range = [result rangeAtIndex:0];
        
        //把前面的非匹配出来的区域加进来
        NSAttributedString *subAttrStr = [self attributedSubstringFromRange:NSMakeRange(location, range.location - location)];
        [resultAttributedString appendAttributedString:subAttrStr];
        //下次循环从当前匹配区域的下一个位置开始
        location = NSMaxRange(range);
        
        //找到要显示的区域内容加上
        NSRange rangeForDisplay = [result rangeAtIndex:groupIndexForDisplay];
        NSMutableAttributedString *displayStr = [[self attributedSubstringFromRange:rangeForDisplay]mutableCopy];
        //对其添加link属性
        NSString *linkValue = nil;
        if (groupIndexForValue==groupIndexForDisplay) {
            linkValue = displayStr.string;
        }else{
            NSRange rangeForValue = [result rangeAtIndex:groupIndexForValue];
            linkValue = [self attributedSubstringFromRange:rangeForValue].string;
        }
        [displayStr addAttribute:NSLinkAttributeName value:linkValue range:NSMakeRange(0, displayStr.length)];
        
        [resultAttributedString appendAttributedString:displayStr];
    }
    
    if (location < length) {
        //到这说明最后面还有非表情字符串
        NSRange range = NSMakeRange(location, length - location);
        NSAttributedString *subAttrStr = [self attributedSubstringFromRange:range];
        [resultAttributedString appendAttributedString:subAttrStr];
    }
    
    return resultAttributedString;
}

@end
