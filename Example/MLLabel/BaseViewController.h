//
//  BaseViewController.h
//  MLLabel
//
//  Created by molon on 15/6/12.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MLLabel/MLLabel.h>
#import <MLLabel/MLLinkLabel.h>
#import <MLLabel/NSString+MLExpression.h>
#import <MLLabel/NSAttributedString+MLExpression.h>

#import <MLTextAttachment.h>
#import "UIView+Convenience.h"
#import "MolonDebug.h"

#define SHOW_SIMPLE_TIPS(m) [[[UIAlertView alloc] initWithTitle:@"" message:(m) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

@interface BaseViewController : UIViewController

@property (nonatomic, strong) MLLabel *label;
@property (nonatomic, strong) UIButton *button;


//for override
- (Class)lableClass;
- (NSInteger)resultCount;
- (void)changeToResult:(int)result;

@end
