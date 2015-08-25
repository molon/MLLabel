//
//  UIImage+Trim.h
//
//  Created by Rick Pastoor on 26-09-12.
//  Based on gist:3549921 ( https://gist.github.com/3549921/8abea8ac9e2450f6a38540de9724d3bf850a62df )
//
//  Copyright (c) 2012 Wrep - http://www.wrep.nl/
//

#import <UIKit/UIKit.h>

@interface UIImage (Trim)

- (UIEdgeInsets)transparencyInsetsRequiringFullOpacity:(BOOL)fullyOpaque;
- (UIImage *)imageByTrimmingTransparentPixels;
- (UIImage *)imageByTrimmingTransparentPixelsRequiringFullOpacity:(BOOL)fullyOpaque;

- (UIImage *)imageByTrimmingTransparentPixelsRequiringFullOpacity:(BOOL)fullyOpaque withXPadding:(CGFloat)xPadding;

@end
