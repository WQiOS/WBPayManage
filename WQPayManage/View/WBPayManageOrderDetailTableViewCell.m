//
//  WBPayManageOrderDetailTableViewCell.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageOrderDetailTableViewCell.h"
#import "PaymentDetailDTO.h"
#import "AppMaintInfoDTO.h"
#import "ServiceInfoDTO.h"
#import "NSString+Category.h"
#import "WBPayManageOrderDetailCellView.h"

@interface WBPayManageOrderDetailTableViewCell ()

/** title */
@property (nonatomic,strong) UILabel *titleLabel;
/** 内容 */
@property (nonatomic,strong) UILabel *contentLabel;
/** 横线 */
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) WBPayManageOrderDetailCellView *detailCellView;
@end

@implementation WBPayManageOrderDetailTableViewCell


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

#pragma mark -bind cellModel

- (void)bindCellModel:(PaymentDetailDTO *)paymentDetail mainInfo:(AppMaintInfoDTO *)mainInfo serviceInfo:(ServiceInfoDTO *)serviceInfo indexPath:(NSIndexPath *)indexPath hasPayDetail:(BOOL)hasPayDetail{
    NSString *titleString,*contentString;
    if (hasPayDetail && !indexPath.section && !indexPath.row) {
        titleString = @"支付明细";
        contentString = @"";
    } else if (hasPayDetail && !indexPath.section && indexPath.row == 1){
        titleString = @"维保均价";
        contentString = [NSString stringWithFormat:@"￥ %@",[[NSString stringWithFormat:@"%ld",paymentDetail.pricePerLift] moneyNumberHandle]];
    } else if (hasPayDetail && !indexPath.section && indexPath.row == 2){
        titleString = @"电梯数量";
        contentString = [NSString stringWithFormat:@"%ld",paymentDetail.num];
    } else if (hasPayDetail && !indexPath.section && indexPath.row == 3){
        titleString = @"最终合计";
        contentString =  [NSString stringWithFormat:@"￥ %@",[[NSString stringWithFormat:@"%ld",paymentDetail.priceSum] moneyNumberHandle]];
    } else if ((indexPath.section && !indexPath.row) || (!hasPayDetail && !indexPath.row)){
        titleString = @"";
        contentString = @"";
        [self.contentView addSubview:self.detailCellView];
        self.detailCellView.mainInfo = mainInfo;
    } else if ((indexPath.section && indexPath.row == 1) || (!hasPayDetail && indexPath.row == 1)){
        titleString = @"服务信息";
        contentString = @"";
    } else if ((indexPath.section && indexPath.row == 2) || (!hasPayDetail && indexPath.row == 2)){
        titleString = @"所在小区";
        contentString = serviceInfo.plotName;
    } else if ((indexPath.section && indexPath.row == 3) || (!hasPayDetail && indexPath.row == 3)){
        titleString = @"小区地址";
        contentString = serviceInfo.plotAddress;
    } else if ((indexPath.section && indexPath.row == 4) || (!hasPayDetail && indexPath.row == 4)){
        titleString = @"服务类型";
        contentString = serviceInfo.maintTypeName;
    } else if ((indexPath.section && indexPath.row == 5) || (!hasPayDetail && indexPath.row == 5)){
        titleString = @"服务对象";
        contentString = [NSString stringWithFormat:@"%@(%ld)",serviceInfo.liftTypeName,serviceInfo.num];
    } else if ((indexPath.section && indexPath.row == 6) || (!hasPayDetail && indexPath.row == 6)){
        titleString = @"服务期限";
        contentString = [NSString stringWithFormat:@"%@ 个月",serviceInfo.period];
    }
    self.titleLabel.text = titleString;
    self.contentLabel.text = contentString;
    self.titleLabel.font = !indexPath.section ? [UIFont boldPingFangFontOfSize:14] : [UIFont regularPingFangFontOfSize:14];
    self.contentLabel.font = !indexPath.section ? [UIFont boldPingFangFontOfSize:16] : [UIFont regularPingFangFontOfSize:14];
    self.titleLabel.textColor = ([titleString isEqualToString:@"维保均价"] || [titleString isEqualToString:@"电梯数量"] || [titleString isEqualToString:@"最终合计"]) ? [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] : [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    if (!indexPath.section && !indexPath.row) {
        self.titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    }else if (!indexPath.section && indexPath.row){
        self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    }else{
        self.titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    }
    self.contentLabel.textColor = !indexPath.section ? [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] : [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.lineView.hidden = (!indexPath.section && (indexPath.row == 1 || indexPath.row == 3)) || (indexPath.section && !indexPath.row);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.text = @"支付类型";
        _titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _titleLabel.font = [UIFont regularPingFangFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.text = @"维保支付";
        _contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _contentLabel.font = [UIFont regularPingFangFontOfSize:14];
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

- (WBPayManageOrderDetailCellView *)detailCellView {
    if (!_detailCellView) {
        _detailCellView = [[WBPayManageOrderDetailCellView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _detailCellView.backgroundColor = [UIColor whiteColor];
    }
    return _detailCellView;
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
