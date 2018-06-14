//
//  WBPayManageFastOfferTableViewCell.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/6.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageFastOfferTableViewCell.h"
#import "WBPayManageNeedTrackModel.h"

@interface WBPayManageFastOfferTableViewCell ()<UITextFieldDelegate>

/** title */
@property (nonatomic,strong) UILabel *titleLabel;
/** 内容 */
@property (nonatomic,strong) UILabel *contentLabel;
/** 横线 */
@property (nonatomic,strong) UIView *lineView;
/** 背景 */
@property (nonatomic,strong) UITextField *bgLabel;
/** 数据 */
@property (nonatomic,strong) WBPayManageNeedTrackModel *cellModel;
/** delegate */
@property (nonatomic, weak) id<WBPayManageFastOfferClick> delegate;

@end

@implementation WBPayManageFastOfferTableViewCell

#pragma mark - init
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bgLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [self.bgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(160, 40));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.top.mas_equalTo(self).offset(5);
        make.height.mas_equalTo(40);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self.mas_bottom).offset(-1);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 1));
    }];
}

//MARK: - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger index = textField.tag;
    NSString *str = textField.text;
    //当维保单价和单次维保价格都填写了，才计算总价
    if ([self.delegate respondsToSelector:@selector(hasFinishFillIn:pricePerTime:)]) {
        [self.delegate hasFinishFillIn:(index == 101 && str) ? str.integerValue : 0 pricePerTime:(index == 102 && str) ? str.integerValue : 0];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger index = textField.tag;
    NSString *str = textField.text;
    if (index == 101 && [str containsString:@"元/台/年"]) {
        //维保单价
        NSRange range = [str rangeOfString:@" 元/台/年"];
        str = [str substringToIndex:range.location];
        textField.text = str;
    }else if (index == 102 && [str containsString:@"元/次"]) {
        //单次维保价格
        NSRange range = [str rangeOfString:@" 元/次"];
        str = [str substringToIndex:range.location];
        textField.text = str;
    }
    return YES;
}

//MARK: - bind cellModel
- (void)bindCellModel:(WBPayManageNeedTrackModel *)cellModel indexPath:(NSIndexPath *)indexPath canEdit:(BOOL)canEdit delegate:(id)delegate {
    self.delegate = delegate;
    self.cellModel = cellModel;
    NSString *titleString,*contentString;
    if (!indexPath.section && !indexPath.row) {
        titleString = @"使用单位";
        contentString = cellModel.propertyComName;
    } else if (!indexPath.section && indexPath.row == 1){
        titleString = @"所在小区";
        contentString = cellModel.plotName;
    } else if (!indexPath.section && indexPath.row == 2){
        titleString = @"小区地址";
        contentString = cellModel.plotAddress;
    } else if (!indexPath.section && indexPath.row == 3){
        titleString = @"服务类型";
        contentString = cellModel.maintTypeName;
    } else if (!indexPath.section && indexPath.row == 4){
        titleString = @"服务对象";
        NSString *diantiType = [NSString stringWithFormat:@"%@(%ld)",cellModel.liftTypeName,cellModel.num];
        contentString = diantiType;
    } else if (!indexPath.section && indexPath.row == 5){
        titleString = @"服务期限";
        contentString = [NSString stringWithFormat:@"%@ 个月",cellModel.period];
    } else if (!indexPath.section && indexPath.row == 6){
        titleString = @"联系人";
        contentString = cellModel.chargePeople;
    } else if (!indexPath.section && indexPath.row == 7){
        titleString = @"联系电话";
        contentString = [cellModel.phone phoneNumberHandle];
    } else if (indexPath.section && !indexPath.row){
        NSString *diantiType = [NSString stringWithFormat:@"%@(%ld)",cellModel.liftTypeName,cellModel.num];
        titleString = diantiType;
        contentString = @"";
    } else if (indexPath.section && indexPath.row == 1){
        titleString = @"维保单价";
        contentString = [NSString stringWithFormat:@"%.f 元/台/年",!cellModel.pricePerLift ? 0.00 : cellModel.pricePerLift];
        if (cellModel.pricePerLift) {
            self.bgLabel.text = contentString;
        }else{
            self.bgLabel.placeholder = @"0.0 元/台/年";
        }
    } else if (indexPath.section && indexPath.row == 2){
        titleString = @"单次维保价格";
        contentString = [NSString stringWithFormat:@"%.f 元/次",!cellModel.pricePerTime ? 0.00 : cellModel.pricePerTime];
        if (cellModel.pricePerTime) {
            self.bgLabel.text = contentString;
        }else{
            self.bgLabel.placeholder = @"0.0 元/次";
        }
    } else if (indexPath.section && indexPath.row == 3){
        titleString = @"总额";
        contentString = [NSString stringWithFormat:@"%.f 元/年",!cellModel.priceSum ? 0.00 : cellModel.priceSum];
        if (cellModel.priceSum) {
            self.bgLabel.text = contentString;
        }else{
            self.bgLabel.placeholder = @"0.0 元/年";
        }
    } else if (indexPath.section && indexPath.row == 4){
        titleString = @"服务开始时间";
        contentString = cellModel.startTime && cellModel.startTime.length ? [cellModel.startTime timeHandleReturnType:TimeHandleYMDType] : @"请选择开始时间";
        self.bgLabel.text = contentString;
    }

    self.titleLabel.text = titleString;
    self.contentLabel.text = contentString;
    self.lineView.hidden = (!indexPath.section && indexPath.row == 7) || indexPath.section;
    self.bgLabel.hidden = !indexPath.section || (indexPath.section && !indexPath.row);
    self.contentLabel.hidden = !self.bgLabel.hidden;
    self.bgLabel.enabled = ((indexPath.section && indexPath.row == 1) || (indexPath.section && indexPath.row == 2)) && canEdit;
    self.bgLabel.tag = 100 + indexPath.row;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _titleLabel.font = [UIFont regularPingFangFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _contentLabel.font = [UIFont regularPingFangFontOfSize:16.0];
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

- (UITextField *)bgLabel {
    if (!_bgLabel) {
        _bgLabel = [[UITextField alloc]init];
        _bgLabel.keyboardType = UIKeyboardTypeNumberPad;
        _bgLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _bgLabel.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        _bgLabel.font = [UIFont regularPingFangFontOfSize:14.0];
        _bgLabel.textAlignment = NSTextAlignmentCenter;
        _bgLabel.delegate = self;
    }
    return _bgLabel;
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
