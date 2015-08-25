//
//  ListViewController.m
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "UITableViewCell+Common.h"
#import "UIView+Convenience.h"
#import "MolonDebug.h"
#import <MLLabel/NSString+MLExpression.h>
#import "CommonData.h"

@interface ListViewController ()

@property (nonatomic, strong) NSArray *expressionData;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"List";
    
    [self.tableView registerNib:[ListTableViewCell nib] forCellReuseIdentifier:[ListTableViewCell cellReuseIdentifier]];
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];
    
    self.expressionData = [MLExpressionManager expressionAttributedStringsWithStrings:kCommonListData() expression:exp];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ListTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
    
    cell.textlabel.attributedText = self.expressionData[indexPath.row%self.expressionData.count];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [ListTableViewCell heightForExpressionText:self.expressionData[indexPath.row%self.expressionData.count] width:self.view.frameWidth];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
