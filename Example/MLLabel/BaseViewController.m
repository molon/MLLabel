//
//  BaseViewController.m
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *clsName = NSStringFromClass([self class]);
    self.title = [clsName substringToIndex:clsName.length-@"ViewController".length];
    
    
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
        _label = [[self lableClass] new];
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
    
    int result = i%[self resultCount];
    
    [self.button setTitle:[NSString stringWithFormat:@"Change(Now:%d)",result] forState:UIControlStateNormal];
    
    [self changeToResult:result];
    
    i++;
}

#pragma mark - override
- (Class)lableClass
{
    return [MLLabel class];
}

- (NSInteger)resultCount
{
    return 1;
}

- (void)changeToResult:(int)result
{
    
}

@end
