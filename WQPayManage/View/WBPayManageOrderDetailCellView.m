//
//  WBPayManageOrderDetailCellView.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageOrderDetailCellView.h"
#import "AppMaintInfoDTO.h"
#import <WQRoundedCorner/WQRoundedCorner.h>
#import "NSString+Category.h"
#import "Masonry.h"

@implementation WBPayManageOrderDetailCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.leftImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.serviceElevatorNumLabel];
    [self addSubview:self.serviceYearLabel];
    [self addSubview:self.levelLabel];

    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];

    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(35, 16));
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(14);
        make.top.mas_equalTo(20);
        make.right.equalTo(self.levelLabel.mas_left);
        make.height.mas_equalTo(20);
    }];

    [self.serviceElevatorNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 17));
        make.centerY.mas_equalTo(self.leftImageView.mas_centerY);
    }];

    [self.serviceYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.serviceElevatorNumLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 17));
        make.centerY.mas_equalTo(self.serviceElevatorNumLabel.mas_centerY);
    }];
}

- (void)setMainInfo:(AppMaintInfoDTO *)mainInfo {
    _mainInfo = mainInfo;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:mainInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    self.nameLabel.text = mainInfo.unitName;
    self.levelLabel.text = mainInfo.levelName;
    if ([mainInfo.levelName containsString:@"A级"]) {
        [self.levelLabel setCornerRadius:3 backgroundColor:[UIColor colorWithRed:35/255.0 green:137/255.0 blue:232/255.0 alpha:1]];
    } else if ([mainInfo.levelName containsString:@"B级"]) {
        [self.levelLabel setCornerRadius:3 backgroundColor:[UIColor colorWithRed:249/255.0 green:208/255.0 blue:101/255.0 alpha:1]];
    } else {
        [self.levelLabel setCornerRadius:3 backgroundColor:[UIColor colorWithRed:249/255.0 green:101/255.0 blue:101/255.0 alpha:1]];
    }
    NSString *str = [NSString stringWithFormat:@"服务电梯数 %@",mainInfo.serviceLiftNum];
    self.serviceElevatorNumLabel.text = str;
    CGSize size = [str sizeWithFont:[UIFont regularPingFangFontOfSize:12] MaxSize:CGSizeMake(150, 17)];
    [self.serviceElevatorNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width + 8, 17));
        make.centerY.mas_equalTo(self.leftImageView.mas_centerY);
    }];
    [self.serviceYearLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.serviceElevatorNumLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 17));
        make.centerY.mas_equalTo(self.serviceElevatorNumLabel.mas_centerY);
    }];
    self.serviceYearLabel.text = mainInfo.serviceTime;
    [self addSubview:self.starRateView];
    
    int score = (int)mainInfo.star;
    int littleScore = (int)((mainInfo.star - score) * 100);
    if(littleScore < 25)
    {
        self.starRateView.currentScore = (double)score;
    }else if(littleScore >= 25 && littleScore < 75)
    {
        self.starRateView.currentScore = (double)(score + 0.55);
    }else
    {
        self.starRateView.currentScore = (double)(score + 1);
    }
}

- (UIImageView *)leftImageView {
    if(!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AppIcon"]];
        _leftImageView.layer.cornerRadius = 4;
        _leftImageView.clipsToBounds = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftImageView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [self getLabelWithFont:[UIFont boldPingFangFontOfSize:14] andColor:ColorFromRGB(0x333333, 1.0)];
    }
    return _nameLabel;
}

- (UILabel *)levelLabel {
    if(!_levelLabel) {
        _levelLabel = [self getLabelWithFont:[UIFont regularPingFangFontOfSize:12] andColor:[UIColor whiteColor]];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _levelLabel;
}

- (UILabel *)serviceElevatorNumLabel {
    if(!_serviceElevatorNumLabel) {
        _serviceElevatorNumLabel = [self getLabelWithFont:[UIFont regularPingFangFontOfSize:12] andColor:ColorFromRGB(0x333333, 1.0)];
        _serviceElevatorNumLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _serviceElevatorNumLabel;
}

- (UILabel *)serviceYearLabel {
    if(!_serviceYearLabel) {
        _serviceYearLabel = [self getLabelWithFont:[UIFont semiboldPingFangFontOfSize:12] andColor:ColorFromRGB(0x333333, 1.0)];
        _serviceYearLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _serviceYearLabel;
}

- (ZLStarRateView *)starRateView {
    if(!_starRateView) {
        _starRateView = [[ZLStarRateView alloc]initWithFrame:CGRectMake(98, 64, 102, 17) numberOfStars:5 rateStyle:HalfStar isAnination:YES finish:^(CGFloat currentScore) {
        }];
        _starRateView.userInteractionEnabled = NO;
    }
    return _starRateView;
}

- (UILabel *)getLabelWithFont:(UIFont *)font andColor:(UIColor *)color {
    UILabel *normalLabel = [[UILabel alloc]init];
    normalLabel.textColor = color ? : nil;
    normalLabel.font = font ? : nil;
    return normalLabel;
}

@end
