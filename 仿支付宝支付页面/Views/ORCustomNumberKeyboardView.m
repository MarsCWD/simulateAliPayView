//
//  ORCustomNumberKeyboardView.m
//  仿支付宝支付页面
//
//  Created by Chen on 15/7/26.
//  Copyright © 2015年 chenweidong. All rights reserved.
//

#import "ORCustomNumberKeyboardView.h"

static const NSInteger kLineWidth = 1;
static const NSInteger kKeyboardHeight = 216;//键盘高度
static const NSInteger kFrameH = 54.0;

#define kNumFont          [UIFont systemFontOfSize:27]
#define ScreenWidth       [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight      [[UIScreen mainScreen] bounds].size.height

@interface ORCustomNumberKeyboardView ()
@property (nonatomic, copy) NSArray *arrLetter;
@end

@implementation ORCustomNumberKeyboardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, ScreenWidth, kKeyboardHeight);
        
        self.arrLetter = [NSArray arrayWithObjects:@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"RST",@"UVW",@"XYZW", nil];
        
        
        for (int i=0; i<4; i++) {
            for (int j=0; j<3; j++) {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        
        CGFloat itemWidth = (self.frame.size.width - 2)/3.0;
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(itemWidth, 0, kLineWidth, 216)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(itemWidth*2 + 1, 0, kLineWidth, kKeyboardHeight)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<3; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameH * (i + 1), self.frame.size.width, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
    }
    return self;
}

-(UIButton *)creatButtonWithX:(NSInteger)x Y:(NSInteger)y {
    UIButton *button;
    
    CGFloat frameX;
    CGFloat frameW = (self.frame.size.width - 2) / 3.0;
    switch (y) {
        case 0:
            frameX = 0.0;
            break;
        case 1:
            frameX = frameW + 1;
            break;
        case 2:
            frameX = frameW * 2 + 2;
            break;
            
        default:
            break;
    }
    CGFloat frameY = kFrameH * x;
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, frameW, kFrameH)];
    
    NSInteger num = y + 3 * x + 1;
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
    
    if (num == 10 || num == 12) {
        UIColor *colorTemp = colorNormal;
        colorNormal = colorHightlighted;
        colorHightlighted = colorTemp;
    }
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(frameW, kFrameH);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];
    
    if (num<10) {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, frameW, 28)];
        labelNum.opaque = YES;
        labelNum.text = [NSString stringWithFormat:@"%zd",num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = kNumFont;
        [button addSubview:labelNum];
        
        if (num != 1) {
            UILabel *labelLetter = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, frameW, 16)];
            labelLetter.opaque = YES;
            labelLetter.text = [self.arrLetter objectAtIndex:num-2];
            labelLetter.textColor = [UIColor blackColor];
            labelLetter.textAlignment = NSTextAlignmentCenter;
            labelLetter.font = [UIFont systemFontOfSize:12];
            [button addSubview:labelLetter];
        }
    } else if (num == 11) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.opaque = YES;
        label.text = @"0";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
    } else if (num == 10) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        //        label.text = @"ABC";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
        button.enabled = NO;//暂时设为不可点
    } else {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake((button.frame.size.width - 22)/2, 19, 22, 17)];
        arrow.image = [UIImage imageNamed:@"ORarrowInKeyboard"];
        [button addSubview:arrow];
    }
    return button;
}

-(void)clickButton:(UIButton *)sender {
    if (sender.tag == 10) {//改变键盘
        if ([self.delegate respondsToSelector:@selector(changeKeyboardType)]) {
            [self.delegate changeKeyboardType];
        }
        return;
    } else if(sender.tag == 12) {//删除按钮
        if ([self.delegate respondsToSelector:@selector(numberKeyboardBackspace)]) {
            [self.delegate numberKeyboardBackspace];
        }
    } else {//数字键盘
        NSInteger num = sender.tag;
        if (sender.tag == 11) {//第11个按钮是0
            num = 0;
        }
        if ([self.delegate respondsToSelector:@selector(numberKeyboardInput:)]) {
            [self.delegate numberKeyboardInput:num];
        }
    }
}

@end
