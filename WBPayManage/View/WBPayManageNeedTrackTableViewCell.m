//
//  WBPayManageNeedTrackTableViewCell.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/4.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageNeedTrackTableViewCell.h"
#import <WQRoundedCorner/WQRoundedCorner.h>
#import "WBPayManageNeedTrackModel.h"

@interface WBPayManageNeedTrackTableViewCell ()

/** 公司名称 */
@property (nonatomic,strong) UILabel *companyNameLabel;
/** 时间 */
@property (nonatomic,strong) UILabel *timeLabel;
/** line1 */
@property (nonatomic,strong) UIView *line1Label;
/** 小区名字 */
@property (nonatomic,strong) UILabel *xiaoquNameLabel;
/** 电梯类型 */
@property (nonatomic,strong) UILabel *diantiTypeLabel;
/** 维保类型（大包、小包等） */
@property (nonatomic,strong) UILabel *weibaoTypeLabel;
/** 支付状态 */
@property (nonatomic,strong) UILabel *payStateLabel;
/** 地点 */
@property (nonatomic,strong) UILabel *placeLabel;
/** line2 */
@property (nonatomic,strong) UIView *line2Label;
/** 反馈 */
@property (nonatomic,strong) UIButton *feedbackButton;
/** 阴影 */
@property (nonatomic,strong) UIView *yinyingLabel;
/** 当前数据 */
@property (nonatomic,strong) WBPayManageNeedTrackModel *currentModel;
/** delegate */
@property (nonatomic, weak) id<WBPayManageNeedTrackClick> delegate;

@end

@implementation WBPayManageNeedTrackTableViewCell

#pragma mark - init
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.companyNameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.line1Label];
        [self.contentView addSubview:self.xiaoquNameLabel];
        [self.contentView addSubview:self.diantiTypeLabel];
        [self.contentView addSubview:self.weibaoTypeLabel];
        [self.contentView addSubview:self.payStateLabel];
        [self.contentView addSubview:self.placeLabel];
        [self.contentView addSubview:self.line2Label];
        [self.contentView addSubview:self.feedbackButton];
        [self.contentView addSubview:self.yinyingLabel];
        [self layoutSubview];
    }
    return  self;
}

//MARK: - layoutSubviews
- (void)layoutSubview {
    [self.companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2 + 30, 20));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyNameLabel.mas_right);
        make.right.mas_equalTo(self).offset(-20);
        make.top.mas_equalTo(self).offset(20);
        make.height.mas_equalTo(20);
    }];
    [self.line1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self).offset(-20);
        make.top.mas_equalTo(self.companyNameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    [self.xiaoquNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self.line1Label.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    [self.diantiTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.xiaoquNameLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.xiaoquNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 18));
    }];
    [self.weibaoTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.diantiTypeLabel.mas_right).offset(8);
        make.centerY.mas_equalTo(self.xiaoquNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    [self.payStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.centerY.mas_equalTo(self.xiaoquNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self.xiaoquNameLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 20));
    }];
    [self.line2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self).offset(-20);
        make.top.mas_equalTo(self.placeLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
    [self.feedbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.top.mas_equalTo(self.line2Label.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(75, 22));
    }];
    [self.yinyingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
    }];
}

//MARK: - feedbackButtonAction
- (void)feedbackButtonAction:(UIButton *)sender {
    NSInteger index = sender.tag - 2018;
    if (!self.currentModel.status.integerValue) {
        //去反馈
        if ([self.delegate respondsToSelector:@selector(goToFeedback:)]) {
            [self.delegate goToFeedback:index];
        }
    } else if (self.currentModel.status.integerValue == 100 || self.currentModel.status.integerValue == 200) {
        //取消报价
        if ([self.delegate respondsToSelector:@selector(didClickCancelOffer:)]) {
            [self.delegate didClickCancelOffer:index];
        }
    } else if (self.currentModel.status.integerValue == 300) {
        //去执行服务
        if ([self.delegate respondsToSelector:@selector(toDoServices:)]) {
            [self.delegate toDoServices:index];
        }
    } else if (self.currentModel.status.integerValue == 400 || self.currentModel.status.integerValue == 500) {
        //删除需求
        if ([self.delegate respondsToSelector:@selector(deleteNeed:)]) {
            [self.delegate deleteNeed:index];
        }
    }
}

//MARK: - bind cellModel
- (void)bindCellModel:(WBPayManageNeedTrackModel *)cellModel indexPath:(NSIndexPath *)indexPath delegate:(id) delegate {
    self.delegate = delegate;
    NSString *diantiType = [NSString stringWithFormat:@"%@(%ld)",cellModel.liftTypeName,cellModel.num];
    self.currentModel = cellModel;
    self.companyNameLabel.text = cellModel.propertyComName;
    self.timeLabel.text = cellModel.createTime;
    self.xiaoquNameLabel.text = cellModel.plotName;
    self.diantiTypeLabel.text = diantiType;
    self.weibaoTypeLabel.text = cellModel.maintTypeName;
    self.placeLabel.text = cellModel.plotAddress;
    self.feedbackButton.tag = 2018 + indexPath.row;

    CGSize xiaoquSize = [cellModel.plotName sizeWithFont:[UIFont boldPingFangFontOfSize:18] MaxSize:CGSizeMake(SCREEN_WIDTH/2 - 20, 25)];
    CGSize diantiTypeSize = [diantiType sizeWithFont:[UIFont regularPingFangFontOfSize:12] MaxSize:CGSizeMake(80, 18)];

    [self.xiaoquNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self.line1Label.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(xiaoquSize.width + 5, 25));
    }];
    [self.diantiTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.xiaoquNameLabel.mas_right);
        make.centerY.mas_equalTo(self.xiaoquNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(diantiTypeSize.width + 12, 18));
    }];
    [self.weibaoTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.diantiTypeLabel.mas_right).offset(8);
        make.centerY.mas_equalTo(self.xiaoquNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(44, 18));
    }];

    NSString *payStateLabelString,*feedbackButtonString;
    if (!cellModel.status.integerValue) {
        //未反馈
        payStateLabelString = @"待反馈";
        feedbackButtonString = @"反馈";
    }else if (cellModel.status.integerValue == 100 || cellModel.status.integerValue == 200) {
        //已经反馈、已经确认
        payStateLabelString = @"待物业支付";
        feedbackButtonString = @"取消报价";
    } else if (cellModel.status.integerValue == 300) {
        //已经付款
        payStateLabelString = @"物业已支付";
        feedbackButtonString = @"执行服务";
    } else if (cellModel.status.integerValue == 400) {
        //已经执行
        payStateLabelString = @"物业未采购";
        feedbackButtonString = @"删除";
    } else if (cellModel.status.integerValue == 500) {
        //已经执行
        payStateLabelString = @"已退款";
        feedbackButtonString = @"删除";
    }

    self.payStateLabel.text = payStateLabelString;
    [self.feedbackButton setTitle:feedbackButtonString forState:UIControlStateNormal];
}

//MARK: - setter / getter
- (UILabel *)companyNameLabel {
    if (!_companyNameLabel) {
        _companyNameLabel = [[UILabel alloc] init];
        //        _companyNameLabel.text = @"杭州格林费尔科技有限公司";
        _companyNameLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _companyNameLabel.font = [UIFont regularPingFangFontOfSize:14];
        _companyNameLabel.textAlignment = NSTextAlignmentLeft;
        _companyNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _companyNameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        //        _timeLabel.text = @"05-31 09:43:56";
        _timeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _timeLabel.font = [UIFont regularPingFangFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _timeLabel;
}

- (UIView *)line1Label {
    if (!_line1Label) {
        _line1Label = [[UILabel alloc] init];
        _line1Label.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    }
    return _line1Label;
}

- (UILabel *)xiaoquNameLabel {
    if (!_xiaoquNameLabel) {
        _xiaoquNameLabel = [[UILabel alloc] init];
        //        _xiaoquNameLabel.text = @"冠山小区";
        _xiaoquNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _xiaoquNameLabel.font = [UIFont boldPingFangFontOfSize:18];
        _xiaoquNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _xiaoquNameLabel;
}

- (UILabel *)diantiTypeLabel {
    if (!_diantiTypeLabel) {
        _diantiTypeLabel = [[UILabel alloc] init];
        //        _diantiTypeLabel.text = @"直梯（28）";
        _diantiTypeLabel.textColor = [UIColor colorWithRed:34/255.0 green:134/255.0 blue:227/255.0 alpha:1];
        _diantiTypeLabel.font = [UIFont regularPingFangFontOfSize:12];
        _diantiTypeLabel.textAlignment = NSTextAlignmentCenter;
        [_diantiTypeLabel setCornerRadius:3 borderColor:[UIColor colorWithRed:34/255.0 green:134/255.0 blue:227/255.0 alpha:1] borderWidth:2 backgroundColor:[UIColor whiteColor]];
    }
    return _diantiTypeLabel;
}

- (UILabel *)weibaoTypeLabel {
    if (!_weibaoTypeLabel) {
        _weibaoTypeLabel = [[UILabel alloc] init];
        //        _weibaoTypeLabel.text = @"小包";
        _weibaoTypeLabel.textColor = [UIColor colorWithRed:34/255.0 green:134/255.0 blue:227/255.0 alpha:1];
        _weibaoTypeLabel.font = [UIFont regularPingFangFontOfSize:12];
        _weibaoTypeLabel.textAlignment = NSTextAlignmentCenter;
        [_weibaoTypeLabel setCornerRadius:3 borderColor:[UIColor colorWithRed:34/255.0 green:134/255.0 blue:227/255.0 alpha:1] borderWidth:2 backgroundColor:[UIColor whiteColor]];
    }
    return _weibaoTypeLabel;
}

- (UILabel *)payStateLabel {
    if (!_payStateLabel) {
        _payStateLabel = [[UILabel alloc] init];
        //        _payStateLabel.text = @"待物业支付";
        _payStateLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _payStateLabel.font = [UIFont regularPingFangFontOfSize:14];
        _payStateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _payStateLabel;
}

- (UILabel *)placeLabel {
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] init];
        //        _placeLabel.text = @"浙江省-杭州市-滨江区-杭州市-滨江区";
        _placeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _placeLabel.font = [UIFont regularPingFangFontOfSize:14];
        _placeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _placeLabel;
}

- (UIView *)line2Label {
    if (!_line2Label) {
        _line2Label = [[UILabel alloc] init];
        _line2Label.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    }
    return _line2Label;
}

- (UIButton *)feedbackButton {
    if (!_feedbackButton) {
        _feedbackButton = [UIButton buttonWithType:UIButtonTypeSystem];
        //        [_feedbackButton setTitle:@"取消报价" forState:UIControlStateNormal];
        [_feedbackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _feedbackButton.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
        [_feedbackButton setCornerRadius:3 backgroundColor:[UIColor colorWithRed:35/255.0 green:137/255.0 blue:232/255.0 alpha:1]];
        [_feedbackButton addTarget:self action:@selector(feedbackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _feedbackButton;
}

- (UIView *)yinyingLabel {
    if (!_yinyingLabel) {
        _yinyingLabel = [[UILabel alloc] init];
        _yinyingLabel.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    }
    return _yinyingLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


