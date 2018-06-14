//
//  WBPayManageEstimatePriceView.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/7.
//

#import "WBPayManageEstimatePriceView.h"
#import <Masonry/Masonry.h>

@interface WBPayManageEstimatePriceView ()

@property (nonatomic, strong) UIImageView *estimatePriceIconImageView;

@end

@implementation WBPayManageEstimatePriceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(269);
        make.bottom.equalTo(self.mas_centerY).offset(-30);
        make.height.mas_equalTo(12);
    }];
    
    [self addSubview:self.estimatePriceTipLabel];
    [self.estimatePriceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self.progressView.mas_top).offset(-11);
        make.height.mas_equalTo(22);
    }];
    
    [self addSubview:self.estimatePriceIconImageView];
    [self.estimatePriceIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.estimatePriceTipLabel.mas_top).offset(-35);
        make.height.mas_equalTo(79);
        make.width.mas_equalTo(71);
    }];
    
    [self addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-100);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-20);
    }];
}

-(void)cancleButtonDidClicked
{
    if([self.delegate respondsToSelector:@selector(WBPayManageEstimatePriceViewDidClickCancelButton)])
    {
        [self.delegate WBPayManageEstimatePriceViewDidClickCancelButton];
    }
}

-(UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progress= 0;
        _progressView.layer.cornerRadius = 6;
        _progressView.clipsToBounds = YES;
        _progressView.progressTintColor = ColorFromRGB(0x2389E8, 1.0);
        _progressView.trackTintColor = ColorFromRGB(0xF1F1F1, 1.0);
    }
    return _progressView;
}

-(UIImageView *)estimatePriceIconImageView
{
    if(!_estimatePriceIconImageView)
    {
        _estimatePriceIconImageView = [[UIImageView alloc]init];
        _estimatePriceIconImageView.image = [UIImage imageNamed:@"evaluate_evaluating"];
    }
    return _estimatePriceIconImageView;
}

-(UILabel *)estimatePriceTipLabel
{
    if(!_estimatePriceTipLabel)
    {
        _estimatePriceTipLabel = [[UILabel alloc] init];
        _estimatePriceTipLabel.font = [UIFont regularPingFangFontOfSize:16];
        _estimatePriceTipLabel.textColor = ColorFromRGB(0x666666, 1.0);
        _estimatePriceTipLabel.text = @"...正在评估服务价格...";
        _estimatePriceTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _estimatePriceTipLabel;
}

-(UIButton *)cancleButton
{
    if(!_cancleButton)
    {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancleButton setBackgroundColor:[UIColor colorWithARGB:0xFF2389E8]];
        _cancleButton.layer.cornerRadius = 4;
        _cancleButton.clipsToBounds = YES;
        _cancleButton.titleLabel.font = [UIFont regularPingFangFontOfSize:18];
        [_cancleButton addTarget:self action:@selector(cancleButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

@end
