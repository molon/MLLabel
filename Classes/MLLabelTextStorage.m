//
//  MLLabelTextStorage.m
//  MLLabel
//
//  Created by molon on 15/6/11.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLLabelTextStorage.h"
#import "NSMutableAttributedString+MLLabel.h"

@interface MLLabelTextStorage()

@property (nonatomic, strong) NSMutableAttributedString *cache;

@end

@implementation MLLabelTextStorage

- (void)setAttributedString:(NSAttributedString *)attrString
{
    [super setAttributedString:attrString];
    //本身继承NSTextStorage，就是为了去除在add了layoutmanager之后，然后再set之后出现的一堆NSOriginalFont属性
    //但是突然发现在继承之后，这个属性不会被add上去了。所以就不执行下面这条语句了吧(当然不继承的话是达不到这个效果的)
//    [self removeAllNSOriginalFontAttributes];
}

#pragma mark - 作为子类必须继承的方法
- (id)init
{
    self = [super init];
    
    if (self) {
        self.cache = [NSMutableAttributedString new];
    }
    
    return self;
}

- (NSString *)string
{
    return _cache.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_cache attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [_cache replaceCharactersInRange:range withString:str];
    
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [_cache setAttributes:attrs range:range];
    
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}
@end
