//
//  MLLabelLayoutManager.m
//  MLLabel
//
//  Created by molon on 15/6/11.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLLabelLayoutManager.h"

@interface MLLabelLayoutManager()

@property (nonatomic, assign) CGPoint lastDrawPoint;

@end

@implementation MLLabelLayoutManager

- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin
{
    self.lastDrawPoint = origin;
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
    self.lastDrawPoint = CGPointZero;
}

//为了由于word-wrap或者center align产生的每行的空白区域不绘制上背景色，所以重载的。
- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) {
        [super fillBackgroundRectArray:rectArray count:rectCount forCharacterRange:charRange color:color];
        return;
    }
    
    CGContextSaveGState(ctx);
    {
        [color setFill];
        
        NSRange glyphRange = [self glyphRangeForCharacterRange:charRange actualCharacterRange:NULL];
        
        CGPoint textOffset = self.lastDrawPoint;
        
        NSRange lineRange = NSMakeRange(glyphRange.location, 1);
        while (NSMaxRange(lineRange)<=NSMaxRange(glyphRange)) {
            CGRect lineBounds = [self lineFragmentUsedRectForGlyphAtIndex:lineRange.location effectiveRange:&lineRange];
            lineBounds.origin.x += textOffset.x;
            lineBounds.origin.y += textOffset.y;
            
            for (NSInteger i=0; i<rectCount; i++) {
                //找到相交的区域并且绘制
                CGRect validRect = CGRectIntersection(lineBounds, rectArray[i]);
                if (!CGRectIsEmpty(validRect)) {
                    CGContextFillRect(ctx, validRect);
                }
            }
            lineRange = NSMakeRange(NSMaxRange(lineRange), 1);
        }
    }
    CGContextRestoreGState(ctx);
}

@end
