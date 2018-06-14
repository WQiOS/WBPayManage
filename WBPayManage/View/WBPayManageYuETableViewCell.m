//
//  WBPayManageYuETableViewCell.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/1.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageYuETableViewCell.h"
#import "WBPayManageAccountInfoModel.h"

@interface WBPayManageYuETableViewCell ()

/** 维保类型 */
@property (nonatomic,strong) UILabel *typeLabel;
/** 余额 */
@property (nonatomic,strong) UILabel *yuELabel;
/** 时间 */
@property (nonatomic,strong) UILabel *timeLabel;
/** 花费金额 */
@property (nonatomic,strong) UILabel *payLabel;

@end

@implementation WBPayManageYuETableViewCell

#pragma mark - init
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.yuELabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.payLabel];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(160, 20));
    }];
    [self.yuELabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(220, 20));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right);
        make.right.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self).offset(15);
        make.height.mas_equalTo(20);
    }];
    [self.payLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yuELabel.mas_right);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark -bind cellModel

- (void)bindCellModel:(TradeInfoDto *)cellModel indexPath:(NSIndexPath *)indexPath {
    self.typeLabel.text = !cellModel.typeName || !cellModel.typeName.length ? cellModel.payTypeName : [NSString stringWithFormat:@"%@-%@",cellModel.payTypeName,cellModel.typeName];
    self.yuELabel.text = [NSString stringWithFormat:@"余额: %@",[[NSString stringWithFormat:@"%.2f",cellModel.currentBalance] moneyNumberHandle]];
    self.timeLabel.text = cellModel.createTime;
    NSString *payTypeStr = @"+";
    if (cellModel.payType.integerValue == 2 || cellModel.payType.integerValue == 4) payTypeStr = @"-";
    self.payLabel.text = [NSString stringWithFormat:@"%@%@",payTypeStr,[[NSString stringWithFormat:@"%.2f",cellModel.payAmount] moneyNumberHandle]];
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
//        _typeLabel.text = @"维保支付-季度";
        _typeLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _typeLabel.font = [UIFont boldPingFangFontOfSize:16];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}

- (UILabel *)yuELabel {
    if (!_yuELabel) {
        _yuELabel = [[UILabel alloc] init];
//        _yuELabel.text = @"余额：2192132201.00";
        _yuELabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _yuELabel.font = [UIFont regularPingFangFontOfSize:14];
        _yuELabel.textAlignment = NSTextAlignmentLeft;
    }
    return _yuELabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
//        _timeLabel.text = @"2018-05-25";
        _timeLabel.font = [UIFont regularPingFangFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)payLabel {
    if (!_payLabel) {
        _payLabel = [[UILabel alloc] init];
        _payLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//        _payLabel.text = @"-21212121";
        _payLabel.font = [UIFont boldPingFangFontOfSize:18];
        _payLabel.textAlignment = NSTextAlignmentRight;
    }
    return _payLabel;
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
