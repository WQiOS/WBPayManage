//
//  WBPayManageFastOfferDatePickerView.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/6.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageFastOfferDatePickerView.h"
#import "UIButton+Category.h"

static CGFloat kDuration = 0.5;
static CGFloat KContainViewHeight = 250;

@interface WBPayManageFastOfferDatePickerView()

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *containtView;

@end

@implementation WBPayManageFastOfferDatePickerView

-(instancetype)initWithFrame:(CGRect)frame clickSure:(void(^)(NSString *string))clickSure clickCancel:(void(^)(void))clickCancel {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0];
        self.userInteractionEnabled = YES;
        __weak typeof(self) weakSelf = self;
        [self addSubview:self.containtView];
        [self.containtView addSubview:({
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithRed:35/255.0 green:137/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];
            cancelButton.frame = CGRectMake(0, 0, 90, 60);
            [cancelButton addBlock:^(id obj) {
                clickCancel();
                [weakSelf dismissDatePickerView];
            } for:UIControlEventTouchUpInside];
            cancelButton;
        })];

        [self.containtView addSubview:({
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelButton setTitle:@"确定" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithRed:35/255.0 green:137/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];
            cancelButton.frame = CGRectMake(SCREEN_WIDTH - 90, 0, 90, 60);
            [cancelButton addBlock:^(id obj) {
                clickSure(weakSelf.dateString);
                [weakSelf dismissDatePickerView];
            } for:UIControlEventTouchUpInside];
            cancelButton;
        })];

        [self.containtView addSubview:({
            self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, 170)];
            [self.datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            [self.datePicker addTarget:self action:@selector(datePickerDidChange:) forControlEvents:UIControlEventValueChanged];
            self.datePicker;
        })];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    [self datePickerDidChange:self.datePicker];
    return self;
}

//MARK: - datePicker滑动
- (void)datePickerDidChange:(id)sender {
    NSDate *date = self.datePicker.date;
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.dateString = [df1 stringFromDate:date];
}

//MARK: - 开始弹出
- (void)startAnimationDatePickerView {
    [UIView animateWithDuration:kDuration animations:^{
        self.backgroundColor =[UIColor colorWithWhite:0.f alpha:0.4];
        self.containtView.frame = CGRectMake(0, SCREEN_HEIGHT -KContainViewHeight, SCREEN_HEIGHT, KContainViewHeight);
    }];
}

//MARK: - 隐藏
- (void)dismissDatePickerView {
    [UIView animateWithDuration:kDuration animations:^{
        self.backgroundColor =[UIColor colorWithWhite:0.f alpha:0];
        self.containtView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KContainViewHeight);
    } completion:^(BOOL finished) {
        [self.containtView removeFromSuperview];
        self.containtView = nil;
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = touches.anyObject;//获取触摸对象
    UIView *view = touch.view;
    if (view != self.containtView) {
        [self dismissDatePickerView];
    }
}

- (UIView *)containtView {
    if (!_containtView) {
        _containtView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KContainViewHeight)];
        _containtView.backgroundColor = [UIColor whiteColor];
    }
    return _containtView;
}

@end
