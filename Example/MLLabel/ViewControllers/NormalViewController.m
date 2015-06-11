//
//  NormalViewController.m
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "NormalViewController.h"

@interface NormalViewController ()

@property (nonatomic, strong) MLLabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.button];
    [self.view addSubview:self.label];
    
    //这里直接写死吧，demo而已
    self.button.frame = CGRectMake((self.view.frameWidth-150.0f)/2, 64.0f+10.0f, 150.0f, 40.0f);
    self.label.frame = CGRectMake(10.0f, self.button.frameBottom+20.0f, self.view.frameWidth-10.0f*2, 100.0f);
    
    [self change];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (MLLabel *)label
{
    if (!_label) {
        _label = [MLLabel new];
        _label.backgroundColor = [UIColor colorWithWhite:0.920 alpha:1.000];
    }
    return _label;
}

- (UIButton *)button
{
    if (!_button) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"Change" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor darkGrayColor];
        
        _button = button;
    }
    return _button;
}

#pragma mark - event
- (void)change
{
    static int i=0;
    
    int result = i%3;
    
    [self.button setTitle:[NSString stringWithFormat:@"Change(Now:%d)",result] forState:UIControlStateNormal];
    
#warning 有换行符需要修正,显示错误，fit大小正确
    
    self.label.textColor = [UIColor redColor];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.numberOfLines = 1;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.adjustsFontSizeToFitWidth = YES;
//    self.label.textInsets = UIEdgeInsetsZero;
    self.label.text = @"人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。";
    
    if (result==0) {
    }else if (result==1) {
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont systemFontOfSize:16.0f];
        self.label.numberOfLines = 2;
        self.label.adjustsFontSizeToFitWidth = YES;
//        self.label.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }else if (result==2) {
        self.label.textColor = [UIColor blueColor];
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentLeft;
//        self.label.textInsets = UIEdgeInsetsMake(20, 5, 5, 5);
        self.label.adjustsFontSizeToFitWidth = NO;
    }
    
    if (result!=0) {
        self.label.frameWidth = self.view.frameWidth-10.0f*2;
        [self.label sizeToFit];
    }
    
    i++;
}

@end
