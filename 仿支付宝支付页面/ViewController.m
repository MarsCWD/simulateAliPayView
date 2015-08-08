//
//  ViewController.m
//  仿支付宝支付页面
//
//  Created by Chen on 15/7/26.
//  Copyright © 2015年 chenweidong. All rights reserved.
//

#import "ViewController.h"
#import "ORSimulateAlipayView.h"

@interface ViewController ()<ORAliPayViewDelegate>
@property (nonatomic, strong) ORSimulateAlipayView *simulateAlipayView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AliPayDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 200, 40);
    [btn setTitle:@"Show View" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)showView {
    self.simulateAlipayView = [[ORSimulateAlipayView alloc] init];
    self.simulateAlipayView.aliPayDelegate = self;
    [self.simulateAlipayView show];
    [self.navigationController.view addSubview:self.simulateAlipayView];
}

#pragma mark simulateAlipayView delegate
- (void)validateAliPayPsw:(NSString *)aliPayPsw {
    if (/* DISABLES CODE */ (0)) {//如果密码正确则隐藏视图
        [self.simulateAlipayView dismiss];
    } else {//密码错误重新输入
        
        //一般这个时候都是调用接口验证，所以会有个中间时间段，这里做延迟2秒处理
        [self performSelector:@selector(repeatInput) withObject:nil afterDelay:2.0];
    }
}

- (void)repeatInput {
    [self.simulateAlipayView repeatInput];
}

@end
