//
//  UIView+Convenience.h
//
//  Created by Molon on 13/11/12.
//  Copyright (c) 2013 Molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Convenience)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

- (CGRect)midFrameWithHeight:(CGFloat)height width:(CGFloat)width;

- (BOOL)containsSubViewOfClassType:(Class)cls;
- (void)removeAllSubViews;
- (void)removeSubviewsWithSubviewClass:(Class)cls;

+ (UINib *)nib;
+ (instancetype)instanceFromNib;


- (void)simpleTransitionWithDuration:(CFTimeInterval)duration andType:(NSString*)type;

@end
