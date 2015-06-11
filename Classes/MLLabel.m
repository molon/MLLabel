//
//  MLLabel.m
//  MLLabel
//
//  Created by molon on 15/5/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLLabel.h"
#import "NSMutableAttributedString+MLLabel.h"
#import "MLLabelLayoutManager.h"
#import "MLLabelTextStorage.h"

#define kAdjustFontSizeEveryScalingFactor (M_E / M_PI)
//总得有个极限
static CGFloat MLFLOAT_MAX = 100000.0f;
static CGFloat ADJUST_MIN_FONT_SIZE = 1.0f;
static CGFloat ADJUST_MIN_SCALE_FACTOR = 0.01f;

static inline NSArray * kStylePropertyNames() {
    static NSArray *_stylePropertyNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stylePropertyNames = @[@"font",@"textAlignment",@"textColor",@"highlighted",
                                @"highlightedTextColor",@"shadowColor",@"shadowOffset",@"enabled"];
    });
    return _stylePropertyNames;
}

@interface MLLabelStylePropertyRecord : NSObject

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) BOOL enabled;

@end
@implementation MLLabelStylePropertyRecord
@end


@interface MLLabel()<NSLayoutManagerDelegate>

@property (nonatomic, strong) MLLabelTextStorage *textStorage;
@property (nonatomic, strong) MLLabelLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;

@property (nonatomic, assign) MLLastTextType lastTextType;

@property (nonatomic, strong) MLLabelStylePropertyRecord *styleRecord;

//为什么需要这个，是因为setAttributedText之后内部可能会对其进行了改动，然后例如再次更新style属性，然后更新绘制会出问题。索性都以记录的为准。
@property (nonatomic, strong) NSAttributedString *lastAttributedText;

@end

@implementation MLLabel

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    //设置TextKit初始相关
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    
    //label helper相关
    self.lastTextType = MLLastTextTypeNormal;
    self.lastAttributedText = self.attributedText;
    
    //kvo 监视style属性
    for (NSString *key in kStylePropertyNames()) {
        [self.styleRecord setValue:[self valueForKey:key] forKey:key];
        //不直接使用NSKeyValueObservingOptionInitial来初始化赋值record，是防止无用的resettext
        [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)dealloc
{
    //kvo 移除监视style属性
    for (NSString *key in kStylePropertyNames()) {
        [self removeObserver:self forKeyPath:key context:nil];
    }
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([kStylePropertyNames() containsObject:keyPath]) {
        //存到记录对象里
        [_styleRecord setValue:[object valueForKey:keyPath] forKey:keyPath];
        
        [self reSetText];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - getter
- (MLLabelTextStorage *)textStorage
{
    if (!_textStorage) {
        _textStorage = [MLLabelTextStorage new];
    }
    return _textStorage;
}

- (MLLabelLayoutManager *)layoutManager
{
    if (!_layoutManager) {
        _layoutManager = [MLLabelLayoutManager new];
        _layoutManager.delegate = self;
    }
    return _layoutManager;
}

- (NSTextContainer *)textContainer
{
    if (!_textContainer) {
        _textContainer = [NSTextContainer new];
        _textContainer.maximumNumberOfLines = self.numberOfLines;
        _textContainer.lineBreakMode = self.lineBreakMode;
        _textContainer.lineFragmentPadding = 0.0f;
        _textContainer.size = self.frame.size;
    }
    return _textContainer;
}

- (MLLabelStylePropertyRecord *)styleRecord
{
    if (!_styleRecord) {
        _styleRecord = [MLLabelStylePropertyRecord new];
    }
    return _styleRecord;
}


#pragma mark - set text
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    self.lastTextType = MLLastTextTypeNormal;
    
    [_textStorage setAttributedString:[self attributedTextForTextStorageFromLabelProperties]];
    
    //如果text和原本的一样的话 super 是不会触发redraw的，但是很遗憾我们的label比较灵活，验证起来很麻烦，所以还是都重绘吧
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    self.lastAttributedText = attributedText;
    
    self.lastTextType = MLLastTextTypeAttributed;
    
    [_textStorage setAttributedString:[self attributedTextForTextStorageFromLabelProperties]];
    
    //如果text和原本的一样的话 super 是不会触发redraw的，但是很遗憾我们的label比较灵活，验证起来很麻烦，所以还是都重绘吧
    [self setNeedsDisplay];
}

#pragma mark - common helper
- (CGSize)textContainerSizeWithBoundsSize:(CGSize)size
{
    //bounds改了之后，要相应的改变textContainer的size，但是要根据insets调整
    CGFloat width = MAX(0, size.width-_textInsets.left-_textInsets.right);
    CGFloat height = MAX(0, size.height-_textInsets.top-_textInsets.bottom);
    return CGSizeMake(width, height);
}

- (void)reSetText
{
    if (_lastTextType == MLLastTextTypeNormal) {
        self.text = self.text;
    }else{
        self.attributedText = _lastAttributedText;
    }
}

/**
 *  根据label的属性来进行处理并返回给textStorage使用的
 */
- (NSMutableAttributedString*)attributedTextForTextStorageFromLabelProperties
{
    if (self.lastTextType==MLLastTextTypeNormal) {
        if (!self.text) {
            return [[NSMutableAttributedString alloc]initWithString:@""];
        }
        
        //根据text和label默认的一些属性得到attributedText，实际上，在[super setText:xxx]之后，这种self.attributedText也会跟随改变成这种的，不过直接拿来用会有问题，这里我们自己搞一份一样的。
        return [[NSMutableAttributedString alloc] initWithString:self.text attributes:[self attributesFromLabelProperties]];
    }
    
    if (!self.lastAttributedText) {
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
    //遍历并且添加Label默认的属性
    NSMutableAttributedString *newAttrStr = [[NSMutableAttributedString alloc]initWithString:self.lastAttributedText.string attributes:[self attributesFromLabelProperties]];
    
    [self.lastAttributedText enumerateAttributesInRange:NSMakeRange(0, newAttrStr.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (attrs.count>0) {
            [newAttrStr removeAttributes:[attrs allKeys] range:range];
            [newAttrStr addAttributes:attrs range:range];
        }
    }];
    return newAttrStr;
}

- (NSDictionary *)attributesFromLabelProperties
{
    //颜色
    UIColor *color = _styleRecord.textColor;
    if (!_styleRecord.enabled)
    {
        color = [UIColor lightGrayColor];
    }
    else if (_styleRecord.highlighted)
    {
        color = _styleRecord.highlightedTextColor;
    }
    if (!color) {
        color = _styleRecord.textColor;
        if (!color) {
            color = [UIColor darkTextColor];
        }
    }
    
    //阴影
    NSShadow *shadow = shadow = [[NSShadow alloc] init];
    if (_styleRecord.shadowColor)
    {
        shadow.shadowColor = _styleRecord.shadowColor;
        shadow.shadowOffset = _styleRecord.shadowOffset;
    }
    else
    {
        shadow.shadowOffset = CGSizeMake(0, -1);
        shadow.shadowColor = nil;
    }
    
    //水平位置
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = _styleRecord.textAlignment;
    
    if (!_styleRecord.font) {
        _styleRecord.font = [UIFont systemFontOfSize:17.0f];
    }
    //最终
    NSDictionary *attributes = @{NSFontAttributeName : _styleRecord.font,
                                 NSForegroundColorAttributeName : color,
                                 NSShadowAttributeName : shadow,
                                 NSParagraphStyleAttributeName : paragraph,
                                 };
    return attributes;
}


- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines ignoreCurrentTextSotrage:(BOOL)ignoreCurrentTextSotrage lineCount:(NSInteger*)lineCount
{
    CGSize newTextContainerSize = [self textContainerSizeWithBoundsSize:bounds.size];
    if (newTextContainerSize.width<=0||newTextContainerSize.height<=0){
        CGRect textBounds = CGRectZero;
        textBounds.size = CGSizeMake(_textInsets.left+_textInsets.right, _textInsets.top+_textInsets.bottom);
        return textBounds;
    }
    
#define NEW
#ifdef NEW
    
    //TODO 最好回头把重复赋值和初始化这些工作也给减掉，尝试是否能提高性能
    MLLabelTextStorage *textStorage = [MLLabelTextStorage new];
    NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:newTextContainerSize];
    textContainer.maximumNumberOfLines = numberOfLines;
    textContainer.lineBreakMode = _textContainer.lineBreakMode;
    textContainer.lineFragmentPadding = _textContainer.lineFragmentPadding;
    MLLabelLayoutManager *layoutManager = [[MLLabelLayoutManager alloc]init];
    layoutManager.delegate = self;
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];
    
    if (ignoreCurrentTextSotrage) {
        [textStorage setAttributedString:[self attributedTextForTextStorageFromLabelProperties]];
    }else{
        [textStorage setAttributedString:_textStorage];
    }
    
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
    
    if (lineCount) {
        [layoutManager enumerateLineFragmentsForGlyphRange:glyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainer, NSRange glyphRange, BOOL *stop) {
            (*lineCount)++;
        }];
    }
    //执行这个之前必须执行glyphRangeForTextContainer
    CGRect textBounds = [layoutManager usedRectForTextContainer:textContainer];

    textBounds.size.width = MIN(ceilf(textBounds.size.width), newTextContainerSize.width);
    textBounds.size.height = MIN(ceilf(textBounds.size.height), newTextContainerSize.height);
    textBounds.origin = bounds.origin;
    
#else
    
    //发现设置AttributedString以及size都比较耗费时间，所以回头最好得搞个副本，减少重复的赋值耗费性能的操作，现在有处理在上面，下面的暂时不删
    
    CGSize savedTextContainerSize = _textContainer.size;
    NSInteger savedTextContainerNumberOfLines = _textContainer.maximumNumberOfLines;
    NSAttributedString *savedAttributedString = nil;
    
    if (ignoreCurrentTextSotrage) {
        savedAttributedString = [_textStorage copy];
        //重新设置其初始,因为一些特别的原因，例如adjustsFontSizeToFitWidth处理之后此_textStorage已经会不是原来那个了。
        [_textStorage setAttributedString:[self attributedTextForTextStorageFromLabelProperties]];
    }
    
    void (^setTextContainerProperties)(CGSize size,NSInteger numberOfLines) = ^(CGSize size,NSInteger numberOfLines)
    {
        if (!CGSizeEqualToSize(_textContainer.size, size)) {
            _textContainer.size = size;
        }
        
        if (_textContainer.maximumNumberOfLines!=numberOfLines) {
            _textContainer.maximumNumberOfLines = numberOfLines;
            
            //如果不重新invalidate，结果会出问题
            [_layoutManager invalidateLayoutForCharacterRange:NSMakeRange(0, _textStorage.string.length) actualCharacterRange:NULL];
        }
    };
    
    //设置临时属性
    setTextContainerProperties(newTextContainerSize,numberOfLines);
    
    NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
    if (lineCount) {
        [_layoutManager enumerateLineFragmentsForGlyphRange:glyphRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainer, NSRange glyphRange, BOOL *stop) {
            (*lineCount)++;
        }];
    }
    //执行这个之前必须执行glyphRangeForTextContainer
    CGRect textBounds = [_layoutManager usedRectForTextContainer:_textContainer];
    textBounds.size.width = MIN(ceilf(textBounds.size.width), newTextContainerSize.width);
    textBounds.size.height = MIN(ceilf(textBounds.size.height), newTextContainerSize.height);
    textBounds.origin = bounds.origin;
    
    if (ignoreCurrentTextSotrage) {
        [_textStorage setAttributedString:savedAttributedString];
    }
    
    //还原属性
    setTextContainerProperties(savedTextContainerSize,savedTextContainerNumberOfLines);
    
#endif
    
    textBounds.size = CGSizeMake(CGRectGetWidth(textBounds)+_textInsets.left+_textInsets.right, CGRectGetHeight(textBounds)+_textInsets.top+_textInsets.bottom);
    
    return textBounds;
}

#pragma mark - draw
- (BOOL)adjustsCurrentFontSizeToFitWidthWithScaleFactor:(CGFloat)scaleFactor numberOfLines:(NSInteger)numberOfLines originalAttributedText:(NSAttributedString*)originalAttributedText bounds:(CGRect)bounds
{
    __block BOOL mustReturnYES = NO;
    if (self.minimumScaleFactor > scaleFactor) {
        scaleFactor = self.minimumScaleFactor; //这个的话 就不能在循环验证了
        mustReturnYES = YES;
    }
    //总得有个极限
    scaleFactor = MAX(scaleFactor, ADJUST_MIN_SCALE_FACTOR);
    
    //遍历并且设置一个新的字体
    NSMutableAttributedString *attrStr = [originalAttributedText mutableCopy];
    
    if (scaleFactor!=1.0f) { //如果是1.0f的话就没有调整font size的必要
        [attrStr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            UIFont *font = (UIFont *)value;
            if (font&&[font isKindOfClass:[UIFont class]]) {
                NSString *fontName = font.fontName;
                CGFloat newSize = font.pointSize*scaleFactor;
                if (newSize<ADJUST_MIN_FONT_SIZE) { //字体的极限
                    mustReturnYES = YES;
                }
                UIFont *newFont = [UIFont fontWithName:fontName size:newSize];
                
                [attrStr removeAttribute:NSFontAttributeName range:range];
                [attrStr addAttribute:NSFontAttributeName value:newFont range:range];
            }
        }];
    }
    
    [_textStorage setAttributedString:attrStr];
    
    //返回是否需要继续调整字体大小
    if (mustReturnYES) {
        return YES;
    }
    
    
    CGSize currentTextSize = CGSizeZero;
    if (numberOfLines>0) {
        NSInteger lineCount = 0;
        currentTextSize = [self textRectForBounds:CGRectMake(0, 0, CGRectGetWidth(bounds), MLFLOAT_MAX) limitedToNumberOfLines:0 ignoreCurrentTextSotrage:NO lineCount:&lineCount].size;
        //如果求行数大于设置行数，也不认为塞满了
        if (lineCount>numberOfLines) {
            return NO;
        }
    }else{
        currentTextSize = [self textRectForBounds:CGRectMake(0, 0, CGRectGetWidth(bounds), MLFLOAT_MAX) limitedToNumberOfLines:0 ignoreCurrentTextSotrage:NO lineCount:NULL].size;
    }
    
    //宽度已经富余就认作OK。
    if (currentTextSize.width<CGRectGetWidth(bounds)) {
        return YES;
    }
    //高度已经足够就认作OK
    if (currentTextSize.height<=CGRectGetHeight(bounds)) {
        return YES;
    }
    
    return NO;
}

- (void)drawTextInRect:(CGRect)rect
{
    //不调用super方法
    //            [super drawTextInRect:rect]; //这里调用可以查看是否绘制和原来的不一致
    
    //如果绘制区域本身就为0，就应该直接返回，不做多余操作。
    if (_textContainer.size.width<=0||_textContainer.size.height<=0){
        return;
    }
    
    if (self.adjustsFontSizeToFitWidth) {
        //初始scale，每次adjust都需要从头开始，因为也可能有当前font被adjust小过需要还原。
        CGFloat scaleFactor = 1.0f;
        BOOL mustContinueAdjust = YES;
        //numberOfLine>0时候可以直接尝试找寻一个preferredScale
        if (self.numberOfLines>0) {
            //找到当前text绘制在一行时候需要占用的宽度，其实这个值很可能不够，因为多行时候可能会因为wordwrap的关系多行+起的总宽度会多。
            CGFloat textWidth = [self textRectForBounds:CGRectMake(0, 0, MLFLOAT_MAX, MLFLOAT_MAX) limitedToNumberOfLines:0 ignoreCurrentTextSotrage:YES lineCount:NULL].size.width;
            textWidth = MAX(0, textWidth-_textInsets.left-_textInsets.right);
            if (textWidth>0) {
                CGFloat availableWidth = _textContainer.size.width*self.numberOfLines;
                if (textWidth > availableWidth) {
                    //这里得到的scaleFactor肯定是大于这个的是必然不满足的,目的就是找这个，以能减少下面的矫正次数。
                    scaleFactor = availableWidth / textWidth;
                }
            }else{
                mustContinueAdjust = NO;
            }
        }
        
        if (mustContinueAdjust) {
            //一点点矫正,以使得内容能放到当前的size里
            NSAttributedString *originalAttributedText = [self attributedTextForTextStorageFromLabelProperties];
            while (![self adjustsCurrentFontSizeToFitWidthWithScaleFactor:scaleFactor numberOfLines:self.numberOfLines originalAttributedText:originalAttributedText bounds:self.bounds]){
                scaleFactor *=  kAdjustFontSizeEveryScalingFactor;
            };
        }
    }
    
    
    CGPoint textOffset;
    //这里根据container的size和manager布局属性以及字符串来得到实际绘制的range区间
    NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
    
    //获取绘制区域大小
    CGRect drawBounds = [_layoutManager usedRectForTextContainer:_textContainer];
    
    //因为label是默认垂直居中的，所以需要根据实际绘制区域的bounds来调整出居中的offset
    textOffset = [self textOffsetWithTextSize:drawBounds.size];
    
    if (self.doBeforeDrawingTextBlock) {
        //而实际上drawBounds的宽度可能不是我们想要的，我们想要的是_textContainer的宽度，但是高度需要是真实绘制高度
        CGSize drawSize = CGSizeMake(_textContainer.size.width, drawBounds.size.height);
        self.doBeforeDrawingTextBlock(rect,textOffset,drawSize);
    }
    
    //绘制文字
    [_layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];
    [_layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];
}

//这个计算出来的是绘制起点
- (CGPoint)textOffsetWithTextSize:(CGSize)textSize
{
    CGPoint textOffset = CGPointZero;
    //根据insets和默认垂直居中来计算出偏移
    textOffset.x = _textInsets.left;
    CGFloat paddingHeight = (_textContainer.size.height - textSize.height) / 2.0f;
    textOffset.y = paddingHeight+_textInsets.top;
    
    return textOffset;
}

#pragma mark - sizeThatsFit
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    if (numberOfLines>1&&self.adjustsFontSizeToFitWidth) {
        NSAttributedString *savedAttributedString = [_textStorage copy];
        //这时候需要在此调整字体大小去fit当前width，以及numerOfLine得到adjust后的文本占用的区域大小
        CGFloat scaleFactor = 1.0f;
        //找到当前text绘制在一行时候需要占用的宽度，其实这个值很可能不够，因为多行时候可能会因为wordwrap的关系多行+起的总宽度会多。
        CGFloat textWidth = [self textRectForBounds:CGRectMake(0, 0, MLFLOAT_MAX, MLFLOAT_MAX) limitedToNumberOfLines:0 ignoreCurrentTextSotrage:YES lineCount:NULL].size.width;
        textWidth = MAX(0, textWidth-_textInsets.left-_textInsets.right);
        if (textWidth>0) {
            CGFloat availableWidth = _textContainer.size.width*numberOfLines;
            if (textWidth > availableWidth) {
                //这里得到的scaleFactor肯定是大于这个的是必然不满足的,目的就是找这个，以能减少下面的矫正次数。
                scaleFactor = availableWidth / textWidth;
            }
            //一点点矫正,以使得内容能放到当前的size里
            NSAttributedString *originalAttributedText = [self attributedTextForTextStorageFromLabelProperties];
            while (![self adjustsCurrentFontSizeToFitWidthWithScaleFactor:scaleFactor numberOfLines:numberOfLines originalAttributedText:originalAttributedText bounds:bounds]){
                scaleFactor *=  kAdjustFontSizeEveryScalingFactor;
            };
            
            //计算当前adjust之后的合适大小
            CGRect textBounds = [self textRectForBounds:bounds limitedToNumberOfLines:numberOfLines ignoreCurrentTextSotrage:NO lineCount:NULL];
            
            //还原内容
            [_textStorage setAttributedString:savedAttributedString];
            
            return textBounds;
        }
    }
    return  [self textRectForBounds:bounds limitedToNumberOfLines:numberOfLines ignoreCurrentTextSotrage:YES lineCount:NULL];
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:[super intrinsicContentSize]];
}

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth
{
    CGSize size = [self sizeThatFits:CGSizeMake(maxWidth, MLFLOAT_MAX)];
    size.width = MIN(size.width, maxWidth); //在numberOfLine模式下返回的可能会比maxWidth大，所以这里我们限制下
    return size;
}

#pragma mark - 其他的set更新
#pragma mark - set 修改container size相关
- (void)resizeTextContainerSize
{
    _textContainer.size = [self textContainerSizeWithBoundsSize:self.bounds.size];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resizeTextContainerSize];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self resizeTextContainerSize];
}

- (void)setTextInsets:(UIEdgeInsets)insets
{
    _textInsets = insets;
    [self resizeTextContainerSize];
}

#pragma mark - set container相关属性
- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    BOOL isChanged = (numberOfLines!=_textContainer.maximumNumberOfLines);
    
    [super setNumberOfLines:numberOfLines];
    
    _textContainer.maximumNumberOfLines = numberOfLines;
    
    if (isChanged) {
        [_layoutManager invalidateLayoutForCharacterRange:NSMakeRange(0, _textStorage.string.length) actualCharacterRange:NULL];
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [super setLineBreakMode:lineBreakMode];
    
    _textContainer.lineBreakMode = lineBreakMode;
}

#pragma mark - set 其他
- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor
{
    [super setMinimumScaleFactor:minimumScaleFactor];
    
    [self setNeedsDisplay];
}


- (void)setDoBeforeDrawingTextBlock:(void (^)(CGRect rect,CGPoint beginOffset,CGSize drawSize))doBeforeDrawingTextBlock
{
    _doBeforeDrawingTextBlock = doBeforeDrawingTextBlock;
    
    [self setNeedsDisplay];
}

#pragma mark - UIResponder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(__unused id)sender
{
    return (action == @selector(copy:));
}

#pragma mark - UIResponderStandardEditActions
- (void)copy:(__unused id)sender {
    [[UIPasteboard generalPasteboard] setString:self.text];
}

@end
