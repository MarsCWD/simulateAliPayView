//
//  ORCustomNumberKeyboardView.h
//  仿支付宝支付页面
//
//  Created by Chen on 15/7/26.
//  Copyright © 2015年 chenweidong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ORCustomNumberKeyboardDelegate <NSObject>
@optional
- (void) numberKeyboardInput:(NSInteger) number;
- (void) numberKeyboardBackspace;
- (void) changeKeyboardType;
@end

@interface ORCustomNumberKeyboardView : UIView
@property (nonatomic,assign) id<ORCustomNumberKeyboardDelegate> delegate;
@end
