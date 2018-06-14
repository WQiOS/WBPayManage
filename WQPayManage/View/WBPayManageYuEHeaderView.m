//
//  WBPayManageYuEHeaderView.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/5/31.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageYuEHeaderView.h"
#import "UILabel+WQCounter.h"

@interface WBPayManageYuEHeaderView()<CAAnimationDelegate>

@property (nonatomic, strong) UILabel *yueLabel;
@property (nonatomic, strong) UILabel *yueNuberLabel;
@property (nonatomic, assign) BOOL isAmplify;//是否是放大操作
@property (nonatomic, assign) BOOL isAnimation;//是否正在动画

@end

@implementation WBPayManageYuEHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithARGB:0xFF2389E8];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.yueLabel];
    [self addSubview:self.yueNuberLabel];

    [self.yueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(25);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
    }];
    [self.yueNuberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self.yueLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(self).offset(-40);
        make.height.mas_equalTo(70);
    }];
}

- (void)startAnimation {
    if (!self.isAnimation) {
        self.isAmplify = YES;
        self.isAnimation = YES;
        //创建动画对象
        CABasicAnimation *basicAni = [CABasicAnimation animation];
        //设置动画属性
        basicAni.keyPath = @"position";
        //设置动画的起始位置。也就是动画从哪里到哪里
        basicAni.fromValue = [NSValue valueWithCGPoint:self.yueNuberLabel.center];
        //动画结束后，layer所在的位置
        basicAni.toValue = [NSValue valueWithCGPoint:CGPointMake((SCREEN_WIDTH - CGRectGetMaxX(self.yueLabel.frame) - 15)/2 + CGRectGetMaxX(self.yueLabel.frame), 30)];
        //动画持续时间
        basicAni.duration = 0.45;
        //动画填充模式
        basicAni.fillMode = kCAFillModeForwards;
        //动画完成不删除
        basicAni.removedOnCompletion = NO;
        //xcode8.0之后需要遵守代理协议
        basicAni.delegate = self;
        //把动画添加到要作用的Layer上面
        [self.yueNuberLabel.layer addAnimation:basicAni forKey:nil];
    }
}

- (void)cancelAnimation {
    if (!self.isAnimation) {
        self.isAmplify = NO;
        self.isAnimation = YES;
        self.yueNuberLabel.layer.position = CGPointMake((SCREEN_WIDTH - CGRectGetMaxX(self.yueLabel.frame) - 15)/2 + CGRectGetMaxX(self.yueLabel.frame), 30);
        self.yueNuberLabel.layer.bounds = CGRectMake(0, 0, SCREEN_WIDTH - CGRectGetMaxX(self.yueLabel.frame) - 15, 20);
        //创建动画对象
        CABasicAnimation *basicAni = [CABasicAnimation animation];
        //设置动画属性
        basicAni.keyPath = @"position";
        //设置动画的起始位置。也就是动画从哪里到哪里
        basicAni.fromValue = [NSValue valueWithCGPoint:CGPointMake((SCREEN_WIDTH - CGRectGetMaxX(self.yueLabel.frame) - 15)/2 + CGRectGetMaxX(self.yueLabel.frame), 30)];
        //动画结束后，layer所在的位置
        basicAni.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, CGRectGetMaxY(self.yueLabel.frame) + 45)];
        //动画持续时间
        basicAni.duration = 0.45;
        //动画填充模式
        basicAni.fillMode = kCAFillModeForwards;
        //动画完成不删除
        basicAni.removedOnCompletion = NO;
        //xcode8.0之后需要遵守代理协议
        basicAni.delegate = self;
        //把动画添加到要作用的Layer上面
        [self.yueNuberLabel.layer addAnimation:basicAni forKey:nil];
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    if (self.isAmplify) {
        [UIView animateWithDuration:0.45 animations:^{
            self.yueNuberLabel.layer.bounds = CGRectMake(0, 0, SCREEN_WIDTH - CGRectGetMaxX(self.yueLabel.frame) - 15, 20);
            self.yueNuberLabel.font = [UIFont boldPingFangFontOfSize:18];
        }];
    }else{
        [UIView animateWithDuration:0.45 animations:^{
            self.yueNuberLabel.layer.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 70);
            self.yueNuberLabel.font = [UIFont boldPingFangFontOfSize:52];
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isAnimation = NO;
        });
    }
}

//MARK: - setter / getter

- (void)setYueNumberString:(NSString *)yueNumberString {
    if ([yueNumberString isKindOfClass:[NSNull class]] || yueNumberString == nil || yueNumberString.length == 0) {
        return ;
    }
    [self layoutIfNeeded];
    [_yueNuberLabel animationFromNumber:0.00 toNumber:yueNumberString.floatValue duration:1.2 animationOptions:WQCounterAnimationOptionCurveEaseInOut format:^NSString *(CGFloat currentNumber) {
        NSString *s = [[NSString stringWithFormat:@"%.2f",currentNumber] moneyNumberHandle];        
        return s;
    } completion:^{
    }];
}

- (UILabel *)yueLabel {
    if (!_yueLabel) {
        _yueLabel = [[UILabel alloc] init];
        _yueLabel.textColor = [UIColor whiteColor];
        _yueLabel.font = [UIFont regularPingFangFontOfSize:14];
        _yueLabel.textAlignment = NSTextAlignmentLeft;
        _yueLabel.text = @"余额账户(元)";
        _yueLabel.textColor = [UIColor colorWithRed:187/255.0 green:218/255.0 blue:242/255.0 alpha:1];
    }
    return _yueLabel;
}

- (UILabel *)yueNuberLabel {
    if (!_yueNuberLabel) {
        _yueNuberLabel = [[UILabel alloc] init];
        _yueNuberLabel.textColor = [UIColor whiteColor];
        _yueNuberLabel.text = @"0.00";
        _yueNuberLabel.font = [UIFont boldPingFangFontOfSize:52];
        _yueNuberLabel.textAlignment = NSTextAlignmentRight;
        _yueNuberLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _yueNuberLabel;
}

@end
