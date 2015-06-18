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

@interface ListNoNibViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *expressionData;

@end

@implementation ListNoNibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ListNoNib";
    
    [self.tableView registerClass:[ListNoNibTableViewCell class] forCellReuseIdentifier:[ListNoNibTableViewCell cellReuseIdentifier]];
    
    self.data = @[
                  @"[微笑]-[撇嘴]-[色]-[发呆][得意]-[流泪][害羞][闭嘴][睡][大哭][尴尬]-[发怒]-[调皮][呲牙][惊讶][难过][酷]-[冷汗]-[抓狂][吐][偷笑][愉快][白眼][傲慢][饥饿][困][惊恐][流汗][憨笑][悠闲][奋斗][咒骂][疑问][嘘][晕][疯了][衰][骷髅][敲打][再见][擦汗][抠鼻][鼓掌][糗大了][坏笑][左哼哼][右哼哼][哈欠][鄙视][委屈][快哭了][阴险][亲亲][吓][可怜][菜刀][西瓜][啤酒][篮球][乒乓][咖啡][饭][猪头][玫瑰][凋谢][嘴唇][爱心][心碎][蛋糕][闪电][炸弹][刀][足球][瓢虫][便便][月亮][太阳][礼物][拥抱][强][弱][握手][胜利][抱拳][勾引][拳头][差劲][爱你][NO][OK][爱情][飞吻][跳跳][发抖][怄火][转圈][磕头][回头][跳绳][投降]1",
                  @"[微笑]-[撇嘴]-[色]-[发呆][得意]-[流泪][害羞][闭嘴][睡][大哭][尴尬]-[发怒]-[调皮][呲牙][惊讶][难过][酷]-[冷汗]-[抓狂][吐][偷笑][愉快][白眼][傲慢][饥饿][困][惊恐][流汗][憨笑][悠闲][奋斗][咒骂][疑问][嘘][晕][疯了][衰][骷髅][敲打][再见][擦汗][抠鼻][鼓掌][糗大了][坏笑][左哼哼][右哼哼][哈欠][鄙视][委屈][快哭了][阴险][亲亲][吓][可怜][菜刀][西瓜][啤酒][篮球][乒乓][咖啡][饭][猪头][玫瑰][凋谢][嘴唇][爱心][心碎][蛋糕][闪电][炸弹][刀][足球][瓢虫][便便][月亮][太阳][礼物][拥抱][强][弱][握手][胜利][抱拳][勾引][拳头][差劲][爱你][NO][OK][爱情][飞吻][跳跳][发抖][怄火][转圈][磕头][回头][跳绳][投降]2",
                  @"[微笑]-[撇嘴]-[色]-[发呆][得意]-[流泪][害羞][闭嘴][睡][大哭][尴尬]-[发怒]-[调皮][呲牙][惊讶][难过][酷]-[冷汗]-[抓狂][吐][偷笑][愉快][白眼][傲慢][饥饿][困][惊恐][流汗][憨笑][悠闲][奋斗][咒骂][疑问][嘘][晕][疯了][衰][骷髅][敲打][再见][擦汗][抠鼻][鼓掌][糗大了][坏笑][左哼哼][右哼哼][哈欠][鄙视][委屈][快哭了][阴险][亲亲][吓][可怜][菜刀][西瓜][啤酒][篮球][乒乓][咖啡][饭][猪头][玫瑰][凋谢][嘴唇][爱心][心碎][蛋糕][闪电][炸弹][刀][足球][瓢虫][便便][月亮][太阳][礼物][拥抱][强][弱][握手][胜利][抱拳][勾引][拳头][差劲][爱你][NO][OK][爱情][飞吻][跳跳][发抖][怄火][转圈][磕头][回头][跳绳][投降]3",
                  @"[微笑]-[撇嘴]-[色]-[发呆][得意]-[流泪][害羞][闭嘴][睡][大哭][尴尬]-[发怒]-[调皮][呲牙][惊讶][难过][酷]-[冷汗]-[抓狂][吐][偷笑][愉快][白眼][傲慢][饥饿][困][惊恐][流汗][憨笑][悠闲][奋斗][咒骂][疑问][嘘][晕][疯了][衰][骷髅][敲打][再见][擦汗][抠鼻][鼓掌][糗大了][坏笑][左哼哼][右哼哼][哈欠][鄙视][委屈][快哭了][阴险][亲亲][吓][可怜][菜刀][西瓜][啤酒][篮球][乒乓][咖啡][饭][猪头][玫瑰][凋谢][嘴唇][爱心][心碎][蛋糕][闪电][炸弹][刀][足球][瓢虫][便便][月亮][太阳][礼物][拥抱][强][弱][握手][胜利][抱拳][勾引][拳头][差劲][爱你][NO][OK][爱情][飞吻][跳跳][发抖][怄火][转圈][磕头][回头][跳绳][投降]4",
                  @"[微笑]-[撇嘴]-[色]-[发呆][得意]-[流泪][害羞][闭嘴][睡][大哭][尴尬]-[发怒]-[调皮][呲牙][惊讶][难过][酷]-[冷汗]-[抓狂][吐][偷笑][愉快][白眼][傲慢][饥饿][困][惊恐][流汗][憨笑][悠闲][奋斗][咒骂][疑问][嘘][晕][疯了][衰][骷髅][敲打][再见][擦汗][抠鼻][鼓掌][糗大了][坏笑][左哼哼][右哼哼][哈欠][鄙视][委屈][快哭了][阴险][亲亲][吓][可怜][菜刀][西瓜][啤酒][篮球][乒乓][咖啡][饭][猪头][玫瑰][凋谢][嘴唇][爱心][心碎][蛋糕][闪电][炸弹][刀][足球][瓢虫][便便][月亮][太阳][礼物][拥抱][强][弱][握手][胜利][抱拳][勾引][拳头][差劲][爱你][NO][OK][爱情][飞吻][跳跳][发抖][怄火][转圈][磕头][回头][跳绳][投降]5",
                  
                  ];
    
    NSMutableArray *expressionData = [NSMutableArray new];
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"Expression"];
    for (NSString *str in self.data) {
        [expressionData addObject:[str expressionAttributedStringWithExpression:exp]];
    }
    self.expressionData = expressionData;
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
    
    ListNoNibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ListNoNibTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
    
    cell.label.attributedText = self.expressionData[indexPath.row%self.expressionData.count];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [ListNoNibTableViewCell heightForExpressionText:self.expressionData[indexPath.row%self.expressionData.count] width:self.view.frameWidth];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
