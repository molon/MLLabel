//
//  NSAttributedString+MLLabel.h
//  Pods
//
//  Created by molon on 15/6/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (MLLabel)

+ (instancetype)attributedStringWithHTML:(NSString*)htmlString;

/**
 根据一个链接相关的正则，返回链接化得AttributedString，linkRegex里一定要包含显示的内容用()包裹起来
 
 Example:
 NSString *str = @"张三的电话[tel=000000 name=tel1]李四的电话[tel=00444000 name=tel2]王五的电话[tel=000300 name=tel3]都在这了";
 NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\\[tel=(\\d{6,11}) name=(\\w+)\\]" options:kNilOptions error:nil];
 self.label.attributedText = [str linkAttributedStringWithLinkRegex:regex groupIndexForDisplay:2 groupIndexForValue:1];
 */
- (NSAttributedString*)linkAttributedStringWithLinkRegex:(NSRegularExpression*)linkRegex groupIndexForDisplay:(NSInteger)groupIndexForDisplay groupIndexForValue:(NSInteger)groupIndexForValue;

@end
