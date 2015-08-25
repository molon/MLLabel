//
//  ClipExpressionViewController.m
//  MLLabel
//
//  Created by molon on 15/8/25.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "ClipExpressionViewController.h"
#import "UIImage+Trim.h"
#import "MolonDebug.h"

@interface ClipExpressionViewController ()

@end

@implementation ClipExpressionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
#if !TARGET_IPHONE_SIMULATOR
    NSString *tips = @"请使用模拟器做表情处理";
#else
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *expressionDir = [paths[0] stringByAppendingPathComponent:@"ClippedExpression"];
    
    
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:expressionDir]){
        //有的话就先删除了
        if(![[NSFileManager defaultManager]removeItemAtPath:expressionDir error:&error]){
            _po(error);
            return;
        }
    }
    
    if(![[NSFileManager defaultManager] createDirectoryAtPath:expressionDir withIntermediateDirectories:YES attributes:nil error:&error]){
        _po(error);
        return;
    }

    for (NSInteger i=1; i<=105; i++) {
        NSString *originalImageName = [NSString stringWithFormat:@"Expression_%ld@2x.png",i];
        
        NSString *originalImagePath = [@"OriginalExpression.bundle" stringByAppendingPathComponent:originalImageName];
        
        UIImage *originalImage = [UIImage imageNamed:originalImagePath];
        NSAssert(originalImage, @"发现不存在的原图像%@",originalImagePath);
        
#warning 切割表情的tips
        //!!!!!!!!!!!!!!!!!!!!
        //https://github.com/molon/MLLabel/issues/1
        //将表情的多余的透明部分去除，并且左右留2个像素的padding，然后保存
        //用以尽可能的显示和文字高度一致的图像，并且留左右padding不会黏在一块
        //!!!!!!!!!!!!!!!!!!!!
        UIImage *newImage = [originalImage imageByTrimmingTransparentPixelsRequiringFullOpacity:NO withXPadding:2.0f];
        NSString *newImagePath = [expressionDir stringByAppendingPathComponent:originalImageName];
        
        [UIImagePNGRepresentation(newImage) writeToFile:newImagePath atomically:YES];
    }
    
    NSString *tips = [NSString stringWithFormat:@"表情处理完毕，请前往%@获取图像",expressionDir];
#endif
    _po(tips);
    
    [[[UIAlertView alloc]initWithTitle:@"" message:tips delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil]show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
