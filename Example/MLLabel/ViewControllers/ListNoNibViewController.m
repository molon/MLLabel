//
//  ListNoNibViewController.m
//  MLLabel
//
//  Created by molon on 15/6/19.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "ListNoNibViewController.h"
#import <MLLabel/NSString+MLExpression.h>
#import "ListNoNibTableViewCell.h"
#import "UITableViewCell+Common.h"
#import "UIView+Convenience.h"
#import "MolonDebug.h"
#import "CommonData.h"

@interface ListNoNibViewController ()

@property (nonatomic, strong) NSArray *expressionData;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;

@end

@implementation ListNoNibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ListNoNib(wait 1.0sec)";
    
    [self.tableView registerClass:[ListNoNibTableViewCell class] forCellReuseIdentifier:[ListNoNibTableViewCell cellReuseIdentifier]];
    
//    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"OriginalExpression"];
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];
    
//    self.expressionData = [MLExpressionManager expressionAttributedStringsWithStrings:kCommonListData() expression:exp];
    //模拟回调处理表情
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MLExpressionManager expressionAttributedStringsWithStrings:kCommonListData() expression:exp callback:^(NSArray *result) {
            self.expressionData = result;
            [self.tableView reloadData];
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (NSMutableDictionary *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = [NSMutableDictionary new];
    }
    return _cellHeights;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.expressionData?100:0; //配合模拟回调处理表情
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ListNoNibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ListNoNibTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
    
    cell.label.attributedText = self.expressionData[indexPath.row%self.expressionData.count];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.cellHeights[indexPath]) {
        self.cellHeights[indexPath] = @([self heightForRowAtIndexPath:indexPath tableView:tableView]);
    }
    return [self.cellHeights[indexPath] floatValue];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    CGFloat height = [ListNoNibTableViewCell heightForExpressionText:self.expressionData[indexPath.row%self.expressionData.count] width:self.view.frameWidth];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
