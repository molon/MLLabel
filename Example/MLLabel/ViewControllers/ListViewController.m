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

//#define kTempText @"[微笑]-[撇嘴]-[色]-[发呆][得意]-[流泪][害羞][闭嘴][睡][大哭][尴尬]-[发怒]-[调皮][呲牙][惊讶][难过][酷]-[冷汗]-[抓狂][吐][偷笑][愉快][白眼][傲慢][饥饿][困][惊恐][流汗][憨笑][悠闲][奋斗][咒骂][疑问][嘘][晕][疯了][衰][骷髅][敲打][再见][擦汗][抠鼻][鼓掌][糗大了][坏笑][左哼哼][右哼哼][哈欠][鄙视][委屈][快哭了][阴险][亲亲][吓][可怜][菜刀][西瓜][啤酒][篮球][乒乓][咖啡][饭][猪头][玫瑰][凋谢][嘴唇][爱心][心碎][蛋糕][闪电][炸弹][刀][足球][瓢虫][便便][月亮][太阳][礼物][拥抱][强][弱][握手][胜利][抱拳][勾引][拳头][差劲][爱你][NO][OK][爱情][飞吻][跳跳][发抖][怄火][转圈][磕头][回头][跳绳][投降]"

#define kTempText @"github:https://github.com/molon/MLEmojiLabel @撒旦 哈哈哈哈#九歌#九黎电话13612341234邮箱13612341234@qq.com旦旦[太阳][礼物]旦[发呆][得意]啊是大三的拉了[饥饿][困][惊恐][流汗][憨笑][悠闲][奋斗][咒骂]啊是大三的拉了[西瓜][啤酒]链接:http://baidu.com dudl@qq.com"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"List";
    
    [self.tableView registerNib:[ListTableViewCell nib] forCellReuseIdentifier:[ListTableViewCell cellReuseIdentifier]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ListTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
    
    cell.textlabel.expressionText = kTempText;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [ListTableViewCell heightForExpressionText:kTempText width:self.view.frameWidth];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
