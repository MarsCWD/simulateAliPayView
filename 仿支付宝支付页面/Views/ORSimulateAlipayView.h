//
//  ORSimulateAlipayView.h
//  仿支付宝支付页面
//
//  Created by Chen on 15/7/26.
//  Copyright © 2015年 chenweidong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ORAliPayViewDelegate <NSObject>

@optional
- (void)validateAliPayPsw:(NSString *)aliPayPsw;

@end

@interface ORSimulateAlipayView : UIView
@property (nonatomic, weak) id<ORAliPayViewDelegate> aliPayDelegate;

- (void)show;
- (void)dismiss;
- (void)repeatInput;
@end
