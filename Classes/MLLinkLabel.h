//
//  MLLinkLabel.h
//  MLLabel
//
//  Created by molon on 15/6/6.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "MLLabel.h"

typedef NS_OPTIONS(NSUInteger, MLDataDetectorTypes) {
    MLDataDetectorTypeURL           = 1 << 1,          // 链接，不用link定义，是因为link作为统称
    MLDataDetectorTypePhoneNumber   = 1 << 0,          // 电话
    MLDataDetectorTypeNone          = 0,               // 禁用
    MLDataDetectorTypeAll           = NSUIntegerMax,    // 所有
    //上面4个和UIDataDetectorTypes的对应，下面是自己加的
    
    MLDataDetectorTypeEmail         = 1 << 4,          // 邮箱
    MLDataDetectorTypeUserHandle    = 1 << 5,          //@
    MLDataDetectorTypeHashtag       = 1 << 6,          //#..#
    //上面是个性化的匹配
    
    
    //这个是对attributedText里带有Link属性的检测，至于为什么31，预留上面空间以添加新的个性化
    //这个东西和dataDetectorTypesOfAttributedLinkValue对应起来，会对带有NSLinkAttributeName区间的value进行检测，匹配则给予对应的LinkType，找不到则为Other
    MLDataDetectorTypeAttributedLink = 1 << 31,
};


typedef NS_ENUM(NSUInteger, MLLinkType) {
    MLLinkTypeNone          = 0,
    MLLinkTypeURL           = 1,          // 电话
    MLLinkTypePhoneNumber   = 2,          // 链接
    MLLinkTypeEmail         = 3,          // 邮箱
    MLLinkTypeUserHandle    = 4,          //@
    MLLinkTypeHashtag       = 5,          //#..#
    
    MLLinkTypeOther        = 31,          //这个一般是和MLDataDetectorTypeAttributedLink对应的，但是也可以自己随意添加啦，不过是一个标识而已，至于为什么31，随便定的，预留上面空间以添加新的个性化
};


@class MLLink,MLLinkLabel;

@protocol MLLinkLabelDelegate <NSObject>

- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel;
- (void)didLongPressLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel;

@end

@interface MLLinkLabel : MLLabel

//默认为MLDataDetectorTypeAll，自动检测全部类型并且转换为链接
@property (nonatomic, assign) MLDataDetectorTypes dataDetectorTypes;

//这个是当dataDetectorTypes的MLDataDetectorTypeAttributedLink可用时候，自动对attributedText里Link属性value检测给予linkType的检测类型，默认为MLDataDetectorTypeNone，也就是默认最终得到的linkType为MLLinkTypeOther
@property (nonatomic, assign) MLDataDetectorTypes dataDetectorTypesOfAttributedLinkValue;

@property (nonatomic, strong) NSDictionary *linkTextAttributes;
@property (nonatomic, strong) NSDictionary *activeLinkTextAttributes;

//是否不允许在link内line break，默认为NO，即为允许，这个玩意设置为YES，之后链接会尽量的不换行
@property (nonatomic, assign) BOOL dontAllowLineBreakInsideLinks;

@property (nonatomic, copy) void(^didClickLinkBlock)(MLLink *link,NSString *linkText,MLLinkLabel *label);
@property (nonatomic, copy) void(^didLongPressLinkBlock)(MLLink *link,NSString *linkText,MLLinkLabel *label);

@property (nonatomic, weak) id<MLLinkLabelDelegate> delegate; //这个优先级没有block高

- (MLLink *)linkAtPoint:(CGPoint)location;

- (BOOL)addLink:(MLLink*)link;
- (MLLink*)addLinkWithType:(MLLinkType)type value:(NSString*)value range:(NSRange)range;

//下面俩是为了编写代码时候外部设置block时候不需要自定义名字了，方便。
- (void)setDidClickLinkBlock:(void (^)(MLLink *link, NSString *linkText, MLLinkLabel *label))didClickLinkBlock;
- (void)setDidLongPressLinkBlock:(void (^)(MLLink *link, NSString *linkText, MLLinkLabel *label))didLongPressLinkBlock;

@end

@interface MLLink : NSObject

@property (readonly, nonatomic, assign) MLLinkType linkType;
@property (readonly, nonatomic, copy) NSString *linkValue;
@property (readonly, nonatomic, assign) NSRange linkRange;

//可以单独设置且覆盖label的三个参数
@property (readonly, nonatomic, strong) NSDictionary *linkTextAttributes;
@property (readonly, nonatomic, strong) NSDictionary *activeLinkTextAttributes;

//初始化
+ (instancetype)linkWithType:(MLLinkType)type value:(NSString*)value range:(NSRange)range;
+ (instancetype)linkWithType:(MLLinkType)type value:(NSString*)value range:(NSRange)range linkTextAttributes:(NSDictionary*)linkTextAttributes activeLinkTextAttributes:(NSDictionary*)activeLinkTextAttributes;

@property (nonatomic, copy) void(^didClickLinkBlock)(MLLink *link,NSString *linkText,MLLinkLabel *label);
@property (nonatomic, copy) void(^didLongPressLinkBlock)(MLLink *link,NSString *linkText,MLLinkLabel *label);

//下面俩是为了编写代码时候外部设置block时候不需要自定义名字了，方便。
- (void)setDidClickLinkBlock:(void (^)(MLLink *link, NSString *linkText, MLLinkLabel *label))didClickLinkBlock;
- (void)setDidLongPressLinkBlock:(void (^)(MLLink *link, NSString *linkText, MLLinkLabel *label))didLongPressLinkBlock;

@end
