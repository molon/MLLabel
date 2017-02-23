//
//  NormalViewController.m
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "NormalViewController.h"

@interface NormalViewController ()

@end

@implementation NormalViewController

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
    return [MLLabel class];
}

- (NSInteger)resultCount
{
    return 5;
}

- (void)changeToResult:(int)result
{
    self.label.textColor = [UIColor redColor];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.numberOfLines = 1;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.textInsets = UIEdgeInsetsZero;
    self.label.lineSpacing = 0.0f;
    self.label.text = @"人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。\n何如薄幸锦衣郎，比翼连枝当日愿。";
    [self.label setDoBeforeDrawingTextBlock:nil];

    if (result==0) {
    }else if (result==1) {
        self.label.text = @"人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。";
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont systemFontOfSize:16.0f];
        self.label.numberOfLines = 6;
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.lineSpacing = 5.0f;
        self.label.adjustsFontSizeToFitWidth = NO;
        self.label.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }else if (result==2) {
        self.label.textColor = [UIColor blueColor];
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.textInsets = UIEdgeInsetsMake(20, 5, 5, 5);
        self.label.adjustsFontSizeToFitWidth = NO;
    }else if (result==3){
        //测试绘制回调
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.textInsets = UIEdgeInsetsMake(0, 10, 0, 5);
        [self.label setDoBeforeDrawingTextBlock:^(CGRect rect, CGPoint beginOffset, CGSize drawSize) {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            if (!ctx) return;
            
            [[UIColor darkGrayColor] setFill];
            
            CGContextFillRect(ctx, CGRectMake(beginOffset.x-10.0f, beginOffset.y, 5.0f, drawSize.height));
        }];
    }else if (result==4){
        self.label.numberOfLines = 0;
        //测试下attrStr
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。"];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2, 10)];
        self.label.attributedText = attrStr;
    }
    
    if (result!=0) {
        self.label.frameWidth = self.view.frameWidth-10.0f*2;
        [self.label sizeToFit];
    }
}
@end
