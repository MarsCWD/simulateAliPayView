//
//  ORSimulateAlipayView.m
//  仿支付宝支付页面
//
//  Created by Chen on 15/7/26.
//  Copyright © 2015年 chenweidong. All rights reserved.
//

#import "ORSimulateAlipayView.h"
#import "ORCustomNumberKeyboardView.h"
#import "UIView+Layout.h"

static const NSInteger kKeyboardHeight = 216;//键盘高度
#define ScreenWidth       [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight      [[UIScreen mainScreen] bounds].size.height
#define F(string, args...)  [NSString stringWithFormat:string, args]
#define RGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c)       [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0];


@interface ORSimulateAlipayView ()<ORCustomNumberKeyboardDelegate>
@property (nonatomic, strong) UIImageView *backgroundImg;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, copy) NSMutableArray *textFieldArr;
@property (nonatomic, assign) NSInteger textFIndex;
@property (nonatomic, strong) ORCustomNumberKeyboardView *keyBoardView;
@end
@implementation ORSimulateAlipayView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        CGFloat bgWidth = 300;//背景宽度
        self.backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - bgWidth)/2, ScreenHeight, bgWidth, 180)];
        self.backgroundImg.backgroundColor = [UIColor clearColor];
        self.backgroundImg.image = [UIImage imageNamed:@"ORSubscribrAlertPopBgView"];
        [self addSubview:self.backgroundImg];
        
        self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.backgroundImg.left, 40, self.backgroundImg.width, 15)];
        self.promptLabel.textColor = HEXCOLOR(0x323232);
        self.promptLabel.textAlignment = NSTextAlignmentCenter;
        self.promptLabel.font = [UIFont systemFontOfSize:15];
        self.promptLabel.text = @"输入支付密码";
        [self.backgroundImg addSubview:self.promptLabel];
        
        CGFloat textFieldWidth = 40;//textField宽度
        CGFloat textFieldNumber = 6;//textField个数
        CGFloat textFieldFont = 20; //textField文字字体大小
        for (int i = 0; i < textFieldNumber; i ++) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((self.backgroundImg.frame.size.width - textFieldNumber * textFieldWidth + 2) / 2.0 + i * (textFieldWidth - 2), self.backgroundImg.frame.size.height - textFieldWidth * 2, textFieldWidth, textFieldWidth)];
            textField.background = [UIImage imageNamed:@"ORBalancePayTextBg"];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.textColor = [UIColor blackColor];
            textField.font = [UIFont systemFontOfSize:textFieldFont];
            textField.secureTextEntry = YES;
            textField.userInteractionEnabled = NO;
            [self.backgroundImg addSubview:textField];
            
            [self.textFieldArr addObject:textField];
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tapGesture];
        
        self.keyBoardView = [[ORCustomNumberKeyboardView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, kKeyboardHeight)];
        self.keyBoardView.delegate = self;
        [self addSubview:self.keyBoardView];
    }
    return self;
}

- (NSMutableArray *)textFieldArr {
    if (nil == _textFieldArr) {
        _textFieldArr = [NSMutableArray array];
    }
    return _textFieldArr;
}

//显示
- (void)show {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundImg.centerY = (ScreenHeight - self.keyBoardView.height)/2;
        self.keyBoardView.top = ScreenHeight - self.keyBoardView.height;
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
    } completion:^(BOOL finished) {
    }];
}

//隐藏
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundImg.top = ScreenHeight;
        self.keyBoardView.top = ScreenHeight;
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//点击键盘数字键
- (void)numberKeyboardInput:(NSInteger)number {
    ((UITextField *)self.textFieldArr[self.textFIndex]).text = F(@"%zd",number);
    if (self.textFIndex != self.textFieldArr.count - 1) {
        self.textFIndex ++ ;
    } else {
        __block NSMutableString *balancePsw = [NSMutableString string];
        [self.textFieldArr enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
            [balancePsw appendString:textField.text];
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundImg.centerY = ScreenHeight/2.0;
            self.keyBoardView.top = ScreenHeight;
        } completion:^(BOOL finished) {
//            [self performSelector:@selector(repeatInput) withObject:nil afterDelay:2.0];
        }];
        
        if ([self.aliPayDelegate respondsToSelector:@selector(validateAliPayPsw:)]) {
            [self.aliPayDelegate validateAliPayPsw:[balancePsw copy]];
        }
    }
}

//点击键盘删除键
- (void)numberKeyboardBackspace {
    if (self.textFIndex >= 1) {
        ((UITextField *)self.textFieldArr[self.textFIndex - 1]).text = @"";
        self.textFIndex -- ;
    } else {
        ((UITextField *)self.textFieldArr.firstObject).text = @"";
    }
}

//点击阴影隐藏视图
- (void)tapClick:(UIGestureRecognizer *)tapGesture {
    CGPoint tapPoint = [tapGesture locationInView:self];
    if (tapPoint.y < (ScreenHeight - self.keyBoardView.height) && !CGRectContainsPoint(self.backgroundImg.frame, tapPoint)) {
        [self dismiss];
    }
}

//当密码错误时重新输入
- (void)repeatInput {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundImg.centerY = (ScreenHeight - kKeyboardHeight)/2;
        self.keyBoardView.top = ScreenHeight - self.keyBoardView.height;
    }];
    
    [self.textFieldArr enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
        textField.text = @"";
    }];
    self.textFIndex = 0;
}

@end
