//
//  WBPayManagePayDetailView.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/8.
//

#import "WBPayManagePayDetailView.h"

#import <Masonry/Masonry.h>

@interface WBPayManagePayDetailView ()

@property (nonatomic, strong) UIImageView *payDetailIconImageView;
@property (nonatomic, strong) UILabel *payDetailTipLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation WBPayManagePayDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.payDetailIconImageView];
    [self.payDetailIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(146);
        make.width.height.mas_equalTo(100);
    }];
    
    [self addSubview:self.payDetailTipLabel];
    [self.payDetailTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.payDetailIconImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(25);
    }];
    
    [self addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.mas_equalTo(-100);
        make.height.mas_equalTo(40);
    }];
}

-(void)confirmButtonDidClicked
{
    if([self.delegate respondsToSelector:@selector(WBPayManagePayDetailViewDidClickConfirmButton)])
    {
        [self.delegate WBPayManagePayDetailViewDidClickConfirmButton];
    }
}

-(UIImageView *)payDetailIconImageView
{
    if(!_payDetailIconImageView)
    {
        _payDetailIconImageView = [[UIImageView alloc]init];
        _payDetailIconImageView.image = [UIImage imageNamed:@"evaluate_pay_success"];
    }
    return _payDetailIconImageView;
}

-(UILabel *)payDetailTipLabel
{
    if(!_payDetailTipLabel)
    {
        _payDetailTipLabel = [[UILabel alloc] init];
        _payDetailTipLabel.font = [UIFont boldPingFangFontOfSize:18];
        _payDetailTipLabel.textColor = ColorFromRGB(0x333333, 1.0);
        _payDetailTipLabel.text = @"支付成功";
        _payDetailTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _payDetailTipLabel;
}

-(UIButton *)confirmButton
{
    if(!_confirmButton)
    {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"查看服务计划" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:ColorFromRGB(0x2389E8, 1.0)];
        _confirmButton.titleLabel.font = [UIFont regularPingFangFontOfSize:18];
        _confirmButton.layer.cornerRadius = 4;
        _confirmButton.clipsToBounds = YES;
        [_confirmButton addTarget:self action:@selector(confirmButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
