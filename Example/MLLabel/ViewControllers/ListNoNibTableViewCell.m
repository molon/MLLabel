//
//  ListNoNibTableViewCell.m
//  MLLabel
//
//  Created by molon on 15/6/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "ListNoNibTableViewCell.h"

#define SHOW_SIMPLE_TIPS(m) [[[UIAlertView alloc] initWithTitle:@"" message:(m) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

@interface ListNoNibTableViewCell()

@property (nonatomic, strong) MLLinkLabel *label;

@end

@implementation ListNoNibTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        tapG.delegate = self;
        [self.contentView addGestureRecognizer:tapG];
        
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)tap
{
    SHOW_SIMPLE_TIPS(@"tapped");
}

#pragma mark - getter
- (MLLinkLabel *)label
{
    if (!_label) {
        _label = [MLLinkLabel new];
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor colorWithRed:0.137 green:0.780 blue:0.118 alpha:1.000];
        
        _label.font = [UIFont systemFontOfSize:16.0f];
        
        _label.numberOfLines = 0;
        _label.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _label.lineHeightMultiple = 1.1f;
        
        _label.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
        _label.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
        
        [_label setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
            SHOW_SIMPLE_TIPS(tips);
        }];
        
        [_label setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"LongPress\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
            SHOW_SIMPLE_TIPS(tips);
        }];
        
    }
    return _label;
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //    return ![self.label linkAtPoint:[touch locationInView:self.label]];
    
    //如果此手势在外层的外层view的话，不方便直接定位到label的话，可以使用这种方式。
    CGPoint location = [touch locationInView:gestureRecognizer.view];
    UIView *view = [gestureRecognizer.view hitTest:location withEvent:nil];
    if ([view isKindOfClass:[MLLinkLabel class]]) {
        if ([((MLLinkLabel*)view) linkAtPoint:[touch locationInView:view]]) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(10, 5, self.contentView.frame.size.width-10*2, self.contentView.frame.size.height-5*2);
}

#pragma mark - height
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
