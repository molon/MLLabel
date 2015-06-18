//
//  ListTableViewCell.m
//  MLLabel
//
//  Created by molon on 15/6/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "ListTableViewCell.h"
#define SHOW_SIMPLE_TIPS(m) [[[UIAlertView alloc] initWithTitle:@"" message:(m) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

@implementation ListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.textlabel.font = [UIFont systemFontOfSize:14.0f];
    self.textlabel.expressionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.textlabel.expressionPlistName = @"Expression";
    self.textlabel.expressionBundleName = @"Expression";
    
    self.textlabel.numberOfLines = 0;
    self.textlabel.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    
    self.textlabel.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    self.textlabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
    
#warning 发现点击位置太绝对了。最好搞可容错范围
    [self.textlabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
        SHOW_SIMPLE_TIPS(tips);
    }];
    
    [self.textlabel setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSString *tips = [NSString stringWithFormat:@"LongPress\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
        SHOW_SIMPLE_TIPS(tips);
    }];
    
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    tapG.delegate = self;
    [self.contentView addGestureRecognizer:tapG];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)tap
{
    SHOW_SIMPLE_TIPS(@"tapped");
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![self.textlabel linkAtPoint:[touch locationInView:self.textlabel]];
}


static inline MLExpressionLabel * kProtypeLabel() {
    static MLExpressionLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [MLExpressionLabel new];
        _protypeLabel.font = [UIFont systemFontOfSize:14.0f];
        _protypeLabel.expressionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _protypeLabel.expressionPlistName = @"Expression";
        _protypeLabel.expressionBundleName = @"Expression";
        
        _protypeLabel.numberOfLines = 0;
        _protypeLabel.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    });
    return _protypeLabel;
}


+ (CGFloat)heightForExpressionText:(id)expressionText width:(CGFloat)width
{
    //nib里左右边距是10
    width-=10.0f*2;
    
    MLExpressionLabel *label = kProtypeLabel();
    label.expressionText = expressionText;
    return [label preferredSizeWithMaxWidth:width].height + 5.0f*2; //上下间距
}

@end
