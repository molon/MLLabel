//
//  IndexTableViewController.m
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "IndexTableViewController.h"
#import "UITableViewCell+Common.h"

static NSArray * kVCClassNames() {
    static NSArray *_VCClassNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _VCClassNames = @[@"Normal",@"Link",@"Expression",
                          @"Html",@"ListNoNib",@"List",@"ClipExpression"];
    });
    return _VCClassNames;
}

@interface IndexTableViewController ()

@end

@implementation IndexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MLLabel";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell cellReuseIdentifier]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kVCClassNames().count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell cellReuseIdentifier] forIndexPath:indexPath];
    
    cell.textLabel.text = kVCClassNames()[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class cls = NSClassFromString([NSString stringWithFormat:@"%@ViewController",kVCClassNames()[indexPath.row]]);
    UIViewController *vc = [cls new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
