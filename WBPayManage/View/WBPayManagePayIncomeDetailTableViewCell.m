//
//  WBPayManagePayIncomeDetailTableViewCell.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/4.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManagePayIncomeDetailTableViewCell.h"
#import "WBPayManagePayIncomeDetailModel.h"

@interface WBPayManagePayIncomeDetailTableViewCell ()

/** title */
@property (nonatomic,strong) UILabel *titleLabel;
/** 内容 */
@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation WBPayManagePayIncomeDetailTableViewCell

#pragma mark - init
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.right.mas_equalTo(self).offset(-20);
        make.top.mas_equalTo(self).offset(5);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark -bind cellModel

- (void)bindCellModel:(WBPayManagePayIncomeDetailModel *)cellModel indexPath:(NSIndexPath *)indexPath {
    NSString *titleString,*contentString;
    if (!indexPath.section && !indexPath.row) {
        titleString = @"流水号";
        contentString = cellModel.payNo;
    } else if (!indexPath.section && indexPath.row == 1){
        titleString = @"支付类型";
        //交易类型1-充值，2-提现，3-冲销，4-支付
        if (cellModel.payType.integerValue == 1) {
            contentString = @"充值";
        }else if (cellModel.payType.integerValue == 2){
            contentString = @"提现";
        }else if (cellModel.payType.integerValue == 3){
            contentString = @"冲销";
        }else if (cellModel.payType.integerValue == 4){
            contentString = @"维保支付";
        }else if (cellModel.payType.integerValue == 5){
            contentString = @"补助";
        }
    } else if (!indexPath.section && indexPath.row == 2){
        titleString = @"金额";
        contentString = [NSString stringWithFormat:@"￥ %@",[[NSString stringWithFormat:@"%.2f",cellModel.payAmount] moneyNumberHandle]];
    } else if (!indexPath.section && indexPath.row == 3){
        titleString = @"支付对象";
        contentString = cellModel.payTarget;
    } else if (!indexPath.section && indexPath.row == 4){
        titleString = @"时间";
        contentString = cellModel.createTime;
    } else if (indexPath.section && !indexPath.row){
        titleString = @"所在小区";
        contentString = cellModel.plotName;
    } else if (indexPath.section && indexPath.row == 1){
        titleString = @"电梯描述";
        contentString = cellModel.liftName;
    } else if (indexPath.section && indexPath.row == 2){
        titleString = @"注册代码";
        contentString = cellModel.registerCode;
    } else if (indexPath.section && indexPath.row == 3){
        titleString = @"维保类型";
        contentString = [NSString stringWithFormat:@"%@维保",cellModel.typeCodeName];
    } else if (indexPath.section && indexPath.row == 4){
        titleString = @"维保日期";
        contentString = cellModel.maintDate;
    }
    self.titleLabel.text = titleString;
    self.contentLabel.text = contentString;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.text = @"支付类型";
        _titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _titleLabel.font = [UIFont regularPingFangFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.text = @"维保支付";
        _contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _contentLabel.font = [UIFont regularPingFangFontOfSize:16.0];
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentLabel;
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
