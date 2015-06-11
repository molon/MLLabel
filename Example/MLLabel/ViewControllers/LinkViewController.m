//
//  LinkViewController.m
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "LinkViewController.h"

#define LABEL ((MLLinkLabel*)self.label)
@interface LinkViewController ()

@end

@implementation LinkViewController

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
    return 7;
}

- (void)changeToResult:(int)result
{
    self.label.textColor = [UIColor redColor];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.label.text = @"人生若只如初见，http://g.cn何事秋风悲画扇。http://baidu.com等闲变却故人心，dudl@qq.com却道故人心易变。13612341234骊山语罢清宵半，泪雨零铃终不怨。#何如 薄幸@锦衣郎，比翼连枝当日愿。";
    LABEL.allowLineBreakInsideLinks = NO;
    LABEL.linkTextAttributes = nil;
    LABEL.activeLinkTextAttributes = nil;
    
    [LABEL setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
        SHOW_SIMPLE_TIPS(tips);
    }];
    
    if (result==0) {
    }else if (result==1) {
        //测试更改链接样式
        self.label.textColor = [UIColor blueColor];
        LABEL.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
        LABEL.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor blackColor]};
    }else if (result==2) {
        //测试切换链接break换行
        LABEL.allowLineBreakInsideLinks = YES;
    }else if (result==3){
        //测试添加链接,以及对链接单独设置长按事件
        MLLink *link = [LABEL addLinkWithType:MLLinkTypeURL value:@"http://molon.me" range:NSMakeRange(1, 2)];
        [link setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"LongPress\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
            SHOW_SIMPLE_TIPS(tips);
        }];
    }else if (result==4){
        //测试去除话题和@识别
        LABEL.dataDetectorTypes = MLDataDetectorTypeAll & ~MLDataDetectorTypeUserHandle & ~MLDataDetectorTypeHashtag;
    }else if (result==5){
        //测试给一个含有链接的attrStr
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。"];
        [attrStr addAttribute:NSLinkAttributeName value:@"http://google.com" range:NSMakeRange(0, 2)];
        [attrStr addAttribute:NSLinkAttributeName value:@"dudl@qq.com" range:NSMakeRange(3, 2)];
        [attrStr addAttribute:NSLinkAttributeName value:@"13612341234" range:NSMakeRange(10, 2)];
        LABEL.attributedText = attrStr;
    }else if (result==6){
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。"];
        [attrStr addAttribute:NSLinkAttributeName value:@"http://google.com" range:NSMakeRange(0, 2)];
        [attrStr addAttribute:NSLinkAttributeName value:@"dudl@qq.com" range:NSMakeRange(3, 2)];
        [attrStr addAttribute:NSLinkAttributeName value:@"13612341234" range:NSMakeRange(10, 2)];
        LABEL.attributedText = attrStr;
        
        //测试给一个含有链接的attrStr，并且自动检测其value所对应linkType
        LABEL.dataDetectorTypesOfAttributedLinkValue = MLDataDetectorTypeAll;
    }
    
    self.label.frameWidth = self.view.frameWidth-10.0f*2;
    [self.label sizeToFit];
}


@end
