//
//  LinkViewController.m
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "LinkViewController.h"
#import "NSString+MLLabel.h"

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
    return 10;
}

- (void)changeToResult:(int)result
{
    self.label.textColor = [UIColor redColor];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.label.lineHeightMultiple = 1.0f;
    self.label.lineSpacing = 0.0f;
    LABEL.beforeAddLinkBlock = nil;
    self.label.text = @"人生若只如初见，何事秋风悲画扇。等闲变却故人心，http://baidu.com却😷😷😷😷http://baidu.com道13743237899故+8613978432345人心易8613743237899变。骊山语罢135-3458-9876清宵半，泪雨573946558@qq.com零铃http://192.168.0.100终不怨192.168.0.100:9090。http://baidu.com😷😷😷https://big-up.style/tokyobigup😷";
    LABEL.dataDetectorTypes = MLDataDetectorTypeAll;
    LABEL.allowLineBreakInsideLinks = YES;
    LABEL.linkTextAttributes = nil;
    LABEL.activeLinkTextAttributes = nil;
    
    [LABEL setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        if (link.linkType==MLLinkTypePhoneNumber) {
            NSString *url = [NSString stringWithFormat:@"telprompt://%@",link.linkValue];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            return;
        }
        NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
        SHOW_SIMPLE_TIPS(tips);
    }];
    
    if (result==0) {
        self.label.text = @"人生若只如初见，何事秋风悲画扇。等闲变却故人心，http://baidu.com却😷😷😷😷http://baidu.com道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。http://baidu.com😷😷😷😷";
        self.label.frameWidth = self.view.frameWidth-10.0f*2;
        self.label.frameHeight = 60.0f;
        self.label.lineBreakMode = NSLineBreakByTruncatingTail;
        return;
    }else if (result==1) {
        //测试绘制背景色不会受到行间距设置的影响
        self.label.lineHeightMultiple = 1.5f;
        self.label.lineSpacing = 10.0f;
    }else if (result==2) {
        //测试更改链接样式
        self.label.textColor = [UIColor blueColor];
        LABEL.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
        LABEL.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor blackColor]};
    }else if (result==3) {
        //测试切换链接break换行
        LABEL.allowLineBreakInsideLinks = YES;
    }else if (result==4){
        //测试添加链接,以及对链接单独设置长按事件
        MLLink *link = [LABEL addLinkWithType:MLLinkTypeURL value:@"http://molon.me" range:NSMakeRange(1, 2)];
        [link setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"LongPress\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
            SHOW_SIMPLE_TIPS(tips);
        }];
    }else if (result==5){
        //测试去除话题和@识别
        LABEL.dataDetectorTypes = MLDataDetectorTypeAll & ~MLDataDetectorTypeUserHandle & ~MLDataDetectorTypeHashtag;
    }else if (result==6){
        //测试给一个含有链接的attrStr
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。"];
        [attrStr addAttribute:NSLinkAttributeName value:@"http://google.com" range:NSMakeRange(0, 2)];
        [attrStr addAttribute:NSLinkAttributeName value:@"dudl@qq.com" range:NSMakeRange(3, 2)];
        [attrStr addAttribute:NSLinkAttributeName value:@"13612341234" range:NSMakeRange(10, 2)];
        LABEL.attributedText = attrStr;
        
        //测试给一个含有链接的attrStr，但是不自动检测其value所对应的linkType
        LABEL.dataDetectorTypesOfAttributedLinkValue = MLDataDetectorTypeNone;
        
        //在设置了text后针对修改link样式的例子
        for (MLLink *link in LABEL.links) {
            if ([link.linkValue isEqualToString:@"13612341234"]) {
                link.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:1.000 green:0.607 blue:0.172 alpha:1.000]};
            }
        }
        [LABEL invalidateDisplayForLinks];
    }else if (result==7){
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。"];
        [attrStr addAttribute:NSLinkAttributeName value:@"http://google.com" range:NSMakeRange(0, 2)];
        [attrStr addAttribute:NSLinkAttributeName value:@"dudl@qq.com" range:NSMakeRange(3, 2)];
        [attrStr addAttribute:NSLinkAttributeName value:@"13612341234" range:NSMakeRange(10, 2)];
        //设置text之前针对自定义link样式的例子
        [LABEL setBeforeAddLinkBlock:^(MLLink *link) {
            if (link.linkType==MLLinkTypeEmail) {
                link.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.961 green:0.292 blue:1.000 alpha:1.000]};
                link.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor colorWithRed:0.211 green:0.753 blue:0.158 alpha:1.000]};
            }
        }];
        LABEL.attributedText = attrStr;
        
        //测试给一个含有链接的attrStr，并且自动检测其value所对应linkType
        LABEL.dataDetectorTypesOfAttributedLinkValue = MLDataDetectorTypeAll;
    }else if (result==8) {
        //测试不自动检测type，实际情况一般是检测，但是如果号码和库的原本正则逻辑不一致的话就需要在回调里自己去对Other类型的做处理了
        LABEL.dataDetectorTypesOfAttributedLinkValue = MLDataDetectorTypeNone;
        
        NSString *str = @"张三的电话[tel=000000]李四的电话[tel=00444000]王五的电话[tel=000300]都在这了";
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\\[tel=(\\d{6,11})\\]" options:kNilOptions error:nil];
        self.label.attributedText = [str linkAttributedStringWithLinkRegex:regex groupIndexForDisplay:1 groupIndexForValue:1];
    }else if (result==9) {
        //测试不自动检测type，实际情况一般是检测，但是如果号码和库的原本正则逻辑不一致的话就需要在回调里自己去对Other类型的做处理了
        LABEL.dataDetectorTypesOfAttributedLinkValue = MLDataDetectorTypeNone;
        
        NSString *str = @"张三的电话[tel=000000 name=tel1]李四的电话[tel=00444000 name=tel2]王五的电话[tel=000300 name=tel3]都在这了";
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\\[tel=(\\d{6,11}) name=(\\w+)\\]" options:kNilOptions error:nil];
        self.label.attributedText = [str linkAttributedStringWithLinkRegex:regex groupIndexForDisplay:2 groupIndexForValue:1];
    }
    
    self.label.frameWidth = self.view.frameWidth-10.0f*2;
    [self.label sizeToFit];
}


@end
