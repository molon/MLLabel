//
//  MLLabelTextContainer.m
//  Pods
//
//  Created by molon on 15/11/2.
//
//

#import "MLLabelTextContainer.h"

@implementation MLLabelTextContainer

-(CGRect)lineFragmentRectForProposedRect:(CGRect)proposedRect atIndex:(NSUInteger)characterIndex writingDirection:(NSWritingDirection)baseWritingDirection remainingRect:(CGRect *)remainingRect
{
    NSLog(@"lineFragmentRectForProposedRect:%@   charIndex:%ld",NSStringFromCGRect(proposedRect),characterIndex);
    
    CGRect rect = [super lineFragmentRectForProposedRect:proposedRect atIndex:characterIndex writingDirection:baseWritingDirection remainingRect:remainingRect];
    
//    NSAttributedString *subString = [self.layoutManager.textStorage attributedSubstringFromRange:NSMakeRange(characterIndex, self.layoutManager.textStorage.length-characterIndex)];
//    
//    CGSize size = [subString boundingRectWithSize:rect.size
//                              options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    
//    if (characterIndex==64) {
//        NSLog(@"%@",NSStringFromCGSize(size));
////        CGRect newR = rect;
////        newR.size = size;
////        return CGRectIntersection(rect, newR);
//    }
    
    return rect;
}

@end
