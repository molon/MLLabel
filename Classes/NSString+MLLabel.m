//
//  NSString+MLLabel.m
//  Pods
//
//  Created by molon on 15/6/13.
//
//

#import "NSString+MLLabel.h"

@implementation NSString (MLLabel)

- (NSUInteger)lineCount
{
    if (self.length<=0) { return 0; }
    
    NSUInteger numberOfLines, index, stringLength = [self length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
        index = NSMaxRange([self lineRangeForRange:NSMakeRange(index, 0)]);
    return numberOfLines;
}

@end
