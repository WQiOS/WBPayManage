//
//  WBPayManageYuENavSelectView.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/5/31.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageYuENavSelectView.h"

@interface WBPayManageYuENavSelectView()

@property (nonatomic, strong) UILabel *xiaoquLabel;
@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation WBPayManageYuENavSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithARGB:0xFF2389E8];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {    
    [self addSubview:self.xiaoquLabel];
    [self addSubview:self.selectImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.xiaoquLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(-20);
        make.width.mas_equalTo(self);
    }];
    [self.selectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 7.5));
    }];
}

//MARK: - setter / getter

- (void)setXiaoquName:(NSString *)xiaoquName {
    if ([xiaoquName isKindOfClass:[NSNull class]] || xiaoquName == nil || xiaoquName.length == 0) {
        return;
    }
    self.xiaoquLabel.text = xiaoquName;
    self.xiaoquLabel.hidden = NO;
    self.selectImageView.hidden = NO;
}

- (UILabel *)xiaoquLabel {
    if (!_xiaoquLabel) {
        _xiaoquLabel = [[UILabel alloc] init];
        _xiaoquLabel.textColor = [UIColor whiteColor];
        _xiaoquLabel.font = [UIFont regularPingFangFontOfSize:12];
        _xiaoquLabel.textAlignment = NSTextAlignmentRight;
        _xiaoquLabel.adjustsFontSizeToFitWidth = YES;
        _xiaoquLabel.hidden = YES;
    }
    return _xiaoquLabel;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"wbzf_todown"];
        _selectImageView.hidden = YES;
    }
    return _selectImageView;
}

@end
