//
//  HtmlViewController.m
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "HtmlViewController.h"
#import <MLLabel/NSAttributedString+MLLabel.h>

#define LABEL ((MLLinkLabel*)self.label)
@interface HtmlViewController ()

@end

@implementation HtmlViewController

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
    return 1;
}

- (void)changeToResult:(int)result
{
    self.label.textColor = [UIColor redColor];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    LABEL.dataDetectorTypesOfAttributedLinkValue = MLDataDetectorTypeAll;
    
    [LABEL setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
        SHOW_SIMPLE_TIPS(tips);
    }];
    
    NSString* html = @"<div style='font-size:14px'><center><b>黄莺儿</b></center><br/>"
    "<p>园林晴昼春谁主。<br/>暖律潜催，幽谷暄和，黄鹂翩翩，<font color='red'>乍迁芳树</font>。<br/>观露湿缕金衣，叶映如簧语。<br/>晓来枝上绵蛮，似把芳心、深意低诉。<sup>(1)</sup></p>"
    "<p>基本的html元素都支持，例如设置字体 <font face='Zapfino'>font</font>, 加粗"
    " <b>bold</b>, 斜体 <i>italics</i> 或者下划线 <u>underlined</u> <span style='color:red'>CSS</span> 等等。</p>"
    "<p>列表(注意里面的链接必须有:xxx//):<ul>"
    "<li>链接:&nbsp;<a href='https://github.com/molon/MLLabel'>MLLabel</a></li>"
    "<li>邮箱:&nbsp;<a href='mailto://dudl@qq.com'>我的邮箱</a></li>"
    "<li>电话:&nbsp;<a href='tel://13612341234'>假电话号码</a></li>"
    "</ul></p>"
    "当然这些还是需要使用者自己尝试下，最好不要随便拿html源码使用，这里只是为了更好的利用html生成可用的NSAttributedString，仅仅作为辅助来用。</div>";
    
    //注意，默认转成的html会给链接+上下划线属性，我们这里可直接覆盖掉
    LABEL.linkTextAttributes = @{NSForegroundColorAttributeName:kDefaultLinkColorForMLLinkLabel,NSUnderlineStyleAttributeName:@(0)};
    LABEL.activeLinkTextAttributes = @{NSForegroundColorAttributeName:kDefaultLinkColorForMLLinkLabel,NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel,NSUnderlineStyleAttributeName:@(0)};
    
    
    //最好不要随便拿html源码使用，这里只是为了更好的利用html生成可用的NSAttributedString，仅仅作为辅助来用。
    //这解析也有点耗费时间，而且必须在主线程使用，所以酌情使用
    self.label.attributedText = [NSAttributedString attributedStringWithHTML:html];
    
    self.label.frameWidth = self.view.frameWidth-10.0f*2;
    [self.label sizeToFit];
}


@end
