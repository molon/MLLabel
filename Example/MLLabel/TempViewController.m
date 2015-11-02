//
//  TempViewController.m
//  MLLabel
//
//  Created by molon on 15/11/2.
//  Copyright © 2015年 molon. All rights reserved.
//

#import "TempViewController.h"
#import <MLLinkLabel.h>

//为了解决issue https://github.com/molon/MLLabel/issues/20 的测试代码
@interface TempViewController()

@property (nonatomic, strong) MLLinkLabel *textLabel;

@end

@implementation TempViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.textLabel];
    
    NSString *text = @"这是纯文字的动态，你懂得！仅仅是纯文字而已，里吼吼吼怕怕八十三破破那送搜送工地狗儿色色婆后后后后面了吼吼吼肉肉肉三六三六零干一里定你了个给没三松后和黑马http://baidu.com上就送后看日落是世界上零三六三六老婆婆婆婆送婆婆说哦婆婆肉肉肉肉肉吼吼吼搜送肉肉肉肉两天就是世界里公公婆婆红红红没人送婆婆说开通你公公婆婆通能偷偷偷偷偷能偷偷他咯吼吼吼你手头通你婆婆破解的测试通告诉我的动态了监控室外机构号了的测试的动态了咯了监控了咯咯咯嗯，^o^^ω^😂";
    self.textLabel.frame = CGRectMake(10, 200, 320-56-20, 79);
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
    float sizeHeight = [self.textLabel preferredSizeWithMaxWidth:320-56-20].height;
    NSLog(@"height:%f   size:%f",self.textLabel.frame.size.height,sizeHeight);

}

#pragma mark - getter
- (MLLinkLabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[MLLinkLabel alloc]init];
        _textLabel.numberOfLines = 5;
        _textLabel.dataDetectorTypes = MLDataDetectorTypeURL;
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = [UIColor lightGrayColor];
        _textLabel.backgroundColor = [UIColor yellowColor];
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _textLabel;
}

@end
