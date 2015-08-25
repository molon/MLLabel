//
//  ExpressionViewController.m
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "ExpressionViewController.h"

#define LABEL ((MLLinkLabel*)self.label)
@interface ExpressionViewController ()

@end

@implementation ExpressionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override
- (Class)lableClass
{
    return [MLLinkLabel class];
}

- (NSInteger)resultCount
{
    return 2;
}

- (void)changeToResult:(int)result
{
    self.label.textColor = [UIColor redColor];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    LABEL.allowLineBreakInsideLinks = NO;
    LABEL.linkTextAttributes = nil;
    LABEL.activeLinkTextAttributes = nil;
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];
    
    //注意，[心碎了]这个其实是匹配了正则，但是没有对应图像的，这里是故意加个这样的来测试。
    LABEL.attributedText = [@"人生若只如初见，[坏笑]何事秋风悲画扇。http://baidu.com等闲变却故人心[亲亲]，dudl@qq.com却道故人心易变。13612341234骊山语罢清宵半[心碎了]，泪雨零铃终不怨[左哼哼]。#何如 薄幸@锦衣郎，比翼连枝当日愿。" expressionAttributedStringWithExpression:exp];
    
    [LABEL setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
        SHOW_SIMPLE_TIPS(tips);
    }];
    
    if (result==0) {
    }else{
        LABEL.numberOfLines = 1;
        LABEL.attributedText = [@"扬之水，[得意]不流束楚" expressionAttributedStringWithExpression:exp];
    }
    self.label.frameWidth = self.view.frameWidth-10.0f*2;
    [self.label sizeToFit];
}

@end
