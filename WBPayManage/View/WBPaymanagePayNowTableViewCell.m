//
//  WBPaymanagePayNowTableViewCell.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPaymanagePayNowTableViewCell.h"
#import "PlatformAccountDTO.h"
#import "NSString+Category.h"

@interface WBPaymanagePayNowTableViewCell ()

/** title */
@property (nonatomic,strong) UILabel *titleLabel;
/** 内容 */
@property (nonatomic,strong) UILabel *contentLabel;
/** 横线 */
@property (nonatomic,strong) UIView *lineView;

@end

@implementation WBPaymanagePayNowTableViewCell

#pragma mark - init
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.right.mas_equalTo(self).offset(-20);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self.mas_bottom).offset(-1.2);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 1));
    }];
}

//MARK: - bind cellModel
- (void)bindCellModel:(PlatformAccountDTO *)paymentDetail indexPath:(NSIndexPath *)indexPath {
    NSString *titleString,*contentString;
    if (!indexPath.section && !indexPath.row) {
        titleString = @"开户名称";
        contentString = paymentDetail.depositName;
    } else if (!indexPath.section && indexPath.row == 1){
        titleString = @"银行账号";
        contentString = paymentDetail.bankAccount;
    } else if (!indexPath.section && indexPath.row == 2){
        titleString = @"开户行";
        contentString = paymentDetail.depositBank;
    } else if (!indexPath.section && indexPath.row == 3){
        titleString = @"支付金额";
        contentString = [NSString stringWithFormat:@"￥ %@",[[NSString stringWithFormat:@"%ld",(long)paymentDetail.payMoney] moneyNumberHandle]];
    }

    self.titleLabel.text = titleString;
    self.contentLabel.text = contentString;
    self.lineView.hidden = !indexPath.section && indexPath.row == 3;
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
        _contentLabel.font = [UIFont regularPingFangFontOfSize:16];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _contentLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    }
    return _lineView;
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
