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
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.contentLabel.font = [UIFont systemFontOfSize:16.0f];
    
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.contentLabel.lineHeightMultiple = 1.1f;
    
    self.contentLabel.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    self.contentLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
    
    [self.contentLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
        SHOW_SIMPLE_TIPS(tips);
    }];
    
    [self.contentLabel setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
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
    return ![self.contentLabel linkAtPoint:[touch locationInView:self.contentLabel]];
}


static MLLinkLabel * kProtypeLabel() {
    static MLLinkLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [MLLinkLabel new];
        _protypeLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _protypeLabel.numberOfLines = 0;
        _protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _protypeLabel.lineHeightMultiple = 1.1f;
    });
    return _protypeLabel;
}


+ (CGFloat)heightForExpressionText:(NSAttributedString*)expressionText width:(CGFloat)width
{
    //nib里左右边距是10
    width-=10.0f*2;
    
    MLLinkLabel *label = kProtypeLabel();
    label.attributedText = expressionText;
    return [label preferredSizeWithMaxWidth:width].height + 5.0f*2; //上下间距
}

@end
