//
//  WBPayManageOrderView.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/7.
//

#import "WBPayManageOrderView.h"
#import "WBPayManageHelper.h"
#import <Masonry/Masonry.h>


@interface WBPayManageOrderView ()<UITableViewDelegate,UITableViewDataSource,WBPayManageOrderViewCellFooterViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) WBPayManageOrderViewCellHeaderView *headerView;
@property (nonatomic, strong) WBPayManageOrderViewCellFooterView *footerView;

@end

@implementation WBPayManageOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

//MARK: - getter/setter

-(void)setTotalDTO:(AssessTotalDTO *)totalDTO
{
    _totalDTO = totalDTO;
    self.headerView.priceLabel.text = [WBPayManageHelper getShowPrice:totalDTO.total];
    [self.infoTableView reloadData];
}

- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.showsVerticalScrollIndicator = false;
        if (@available (iOS 11, *)) {
            _infoTableView.estimatedRowHeight = 0;
            _infoTableView.estimatedSectionHeaderHeight = 0;
            _infoTableView.estimatedSectionFooterHeight = 0;
        }
        _infoTableView.rowHeight = 50;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_infoTableView registerClass:WBPayManageOrderViewCell.class forCellReuseIdentifier:NSStringFromClass(WBPayManageOrderViewCell.class)];
        _infoTableView.tableHeaderView = self.headerView;
        _infoTableView.tableFooterView = self.footerView;
    }
    return _infoTableView;
}

-(WBPayManageOrderViewCellHeaderView *)headerView
{
    if(!_headerView)
    {
        _headerView = [[WBPayManageOrderViewCellHeaderView alloc]initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, 60)];
    }
    return _headerView;
}

-(WBPayManageOrderViewCellFooterView *)footerView
{
    if(!_footerView)
    {
        _footerView = [[WBPayManageOrderViewCellFooterView alloc]initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, 330)];
        _footerView.delegate = self;
        _footerView.couponTextField.delegate = self;
    }
    return _footerView;
}

//MARK: - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isShowDetail)
    {
        return 4*self.totalDTO.assesses.count+1;
    }else
    {
        if(self.chooseCoupon)
        {
            return 9;
        }else{
            return 7;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBPayManageOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WBPayManageOrderViewCell.class)];
    [cell configDataWithIndexRow:indexPath.row totalDTO:self.totalDTO andCouponInfo:self.chooseCoupon isShowDetail:self.isShowDetail];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isShowDetail)
    {
        return indexPath.row%4 == 0 && indexPath.row != 4*self.totalDTO.assesses.count;
        
    }else
    {
        return indexPath.row ==4 || indexPath.row ==5;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(!self.isShowDetail)
    {
        [self.footerView.couponTextField resignFirstResponder];
        if([self.delegate respondsToSelector:@selector(WBPayManageOrderViewSeeOrderDetail)])
        {
            [self.delegate WBPayManageOrderViewSeeOrderDetail];
        }
    }else
    {
        NSInteger assessIndex = indexPath.row/4;
        if([self.delegate respondsToSelector:@selector(WBPayManageOrderViewDidChooseLiftSceneAtIndexRow:)])
        {
            [self.delegate WBPayManageOrderViewDidChooseLiftSceneAtIndexRow:assessIndex];
        }
    }
}

-(void)WBPayManageOrderViewCellFooterViewDidClickFunctionBtn:(UIButton *)button
{
    [self.footerView.couponTextField resignFirstResponder];
    if([self.delegate respondsToSelector:@selector(WBPayManageOrderViewDidClickFunctionButton:)])
    {
        [self.delegate WBPayManageOrderViewDidClickFunctionButton:button.tag];
    }
}

-(void)setCouponTextFieldHidden
{
    [self.footerView.couponTextField resignFirstResponder];
}

-(void)setCouponCode:(NSString *)couponCode
{
    self.footerView.couponTextField.text = couponCode;
}

-(void)setChooseCoupon:(CouponDTO *)chooseCoupon
{
    _chooseCoupon = chooseCoupon;
    [self.infoTableView reloadData];
}

-(void)setIsShowDetail:(BOOL)isShowDetail
{
    _isShowDetail = isShowDetail;
    if(isShowDetail)
    {
        self.infoTableView.tableHeaderView = nil;
        self.infoTableView.tableFooterView = nil;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length + string.length <= 16 || [string isEqualToString:@""])
    {
        return YES;
    }else
    {
        return NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length > 0)
    {
        if([self.delegate respondsToSelector:@selector(WBPayManageOrderViewGetCouponCode:)])
        {
            [self.delegate WBPayManageOrderViewGetCouponCode:textField.text];
        }
    }else
    {
        self.chooseCoupon = nil;
    }
}

@end

@interface WBPayManageOrderViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *line;

@end

@implementation WBPayManageOrderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)setupSubviews {

    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(100);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-25);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self).offset(20);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

//MARK: - getter/setter

-(UIImageView *)line
{
    if(!_line){
        _line = [[UIImageView alloc]init];
    }
    return _line;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UILabel *)contentLabel
{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

-(void)configDataWithIndexRow:(NSInteger)row totalDTO:(AssessTotalDTO *)totalDTO andCouponInfo:(CouponDTO *)couponInfo isShowDetail:(BOOL)isShowDetail
{
    if(isShowDetail)
    {
        if(row == 4*totalDTO.assesses.count)
        {
            self.titleLabel.text = @"维小保合计";
            self.titleLabel.textColor = ColorFromRGB(0x333333, 1.0);
            self.contentLabel.textColor = ColorFromRGB(0x333333, 1.0);
            self.titleLabel.font = [UIFont boldPingFangFontOfSize:14];
            self.contentLabel.font = [UIFont boldPingFangFontOfSize:16];
            self.contentLabel.text = [WBPayManageHelper getShowPrice:totalDTO.total];
            self.line.hidden = YES;
            self.accessoryType = UITableViewCellAccessoryNone;
        }else
        {
            NSInteger assessIndex = row/4;
            Assess *asses = totalDTO.assesses[assessIndex];
            switch (row%4) {
                case 0:
                {
                    self.titleLabel.text = [NSString stringWithFormat:@"电梯场景%d",(int)assessIndex+1];
                    self.titleLabel.textColor = ColorFromRGB(0x333333, 1.0);
                    self.titleLabel.font = [UIFont boldPingFangFontOfSize:14];
                    self.contentLabel.text = @"";
                    self.line.hidden = NO;
                    self.line.image = [UIImage imageNamed:@"dotted_line"];
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case 1:
                {
                    self.titleLabel.text = @"维保均价";
                    self.titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
                    self.contentLabel.textColor = ColorFromRGB(0x666666, 1.0);
                    self.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
                    self.contentLabel.font = [UIFont regularPingFangFontOfSize:16];
                    self.contentLabel.text = [WBPayManageHelper getShowPrice:asses.avgPrice];
                    self.line.hidden = YES;
                    self.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case 2:
                {
                    self.titleLabel.text = @"电梯数量";
                    self.titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
                    self.contentLabel.textColor = ColorFromRGB(0x666666, 1.0);
                    self.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
                    self.contentLabel.font = [UIFont regularPingFangFontOfSize:16];
                    self.contentLabel.text = [NSString stringWithFormat:@"x %d",(int)asses.num];
                    self.line.hidden = YES;
                    self.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case 3:
                {
                    self.titleLabel.text = @"合计";
                    self.titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
                    self.contentLabel.textColor = ColorFromRGB(0x666666, 1.0);
                    self.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
                    self.contentLabel.font = [UIFont regularPingFangFontOfSize:16];
                    self.contentLabel.text = [WBPayManageHelper getShowPrice:asses.sum];
                    self.line.hidden = NO;
                    self.line.image = [UIImage imageNamed:@"dotted_line"];
                    self.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                default:
                    break;
            }
        }
    }else
    {
        switch (row) {
            case 0:
            {
                self.titleLabel.text = @"服务明细";
                self.titleLabel.textColor = ColorFromRGB(0x999999, 1.0);
                self.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.text = @"";
                self.line.image = [UIImage imageNamed:@"full_line"];
                self.line.hidden = NO;
                self.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 1:
            {
                self.titleLabel.text = @"维保种类";
                self.titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
                self.contentLabel.textColor = ColorFromRGB(0x999999, 1.0);
                self.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.text = @"全包";
                self.line.hidden = YES;
                self.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 2:
            {
                self.titleLabel.text = @"服务时间";
                self.titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
                self.contentLabel.textColor = ColorFromRGB(0x999999, 1.0);
                self.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.text = @"一年";
                self.line.hidden = YES;
                self.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 3:
            {
                self.titleLabel.text = @"详细地址\n";
                self.titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
                self.contentLabel.textColor = ColorFromRGB(0x999999, 1.0);
                self.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.text = totalDTO.address;
                self.line.hidden = NO;
                self.line.image = [UIImage imageNamed:@"dotted_line"];
                self.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 4:
            {
                NSString *averPrice = [NSString stringWithFormat:@"%.2f",totalDTO.total.floatValue/totalDTO.totalNum];
                
                self.titleLabel.text = @"维保均价";
                self.titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
                self.contentLabel.textColor = ColorFromRGB(0x666666, 1.0);
                self.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.font = [UIFont regularPingFangFontOfSize:16];
                self.contentLabel.text = [WBPayManageHelper getShowPrice:averPrice];
                self.line.hidden = YES;
                self.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 5:
            {
                self.titleLabel.text = @"电梯数量";
                self.titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
                self.contentLabel.textColor = ColorFromRGB(0x666666, 1.0);
                self.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
                self.contentLabel.font = [UIFont regularPingFangFontOfSize:16];
                self.contentLabel.text = [NSString stringWithFormat:@"x %d",totalDTO.totalNum];
                self.line.hidden = NO;
                self.line.image = [UIImage imageNamed:@"dotted_line"];
                self.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 6:
            {
                self.titleLabel.text = @"维小保总价";
                self.titleLabel.textColor = ColorFromRGB(0x333333, 1.0);
                self.contentLabel.textColor = ColorFromRGB(0x333333, 1.0);
                self.titleLabel.font = [UIFont boldPingFangFontOfSize:14];
                self.contentLabel.font = [UIFont boldPingFangFontOfSize:16];
                self.contentLabel.text = [WBPayManageHelper getShowPrice:totalDTO.total];
                self.line.hidden = YES;
                self.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 7:
            {
                self.titleLabel.text = @"商品优惠";
                self.titleLabel.textColor = ColorFromRGB(0x333333, 1.0);
                self.contentLabel.textColor = ColorFromRGB(0x333333, 1.0);
                self.titleLabel.font = [UIFont boldPingFangFontOfSize:14];
                self.contentLabel.font = [UIFont boldPingFangFontOfSize:16];
                if(couponInfo.type == 1)
                {
                    int rate = 100 - couponInfo.rate * 100;
                    self.contentLabel.text = [NSString stringWithFormat:@"- %d%%",rate];
                }else{
                    self.contentLabel.text = [NSString stringWithFormat:@"- %.2f",couponInfo.rate];
                }
                self.line.hidden = NO;
                self.line.image = [UIImage imageNamed:@"dotted_line"];
                self.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 8:
            {
                self.titleLabel.text = @"最终合计";
                self.titleLabel.textColor = ColorFromRGB(0x333333, 1.0);
                self.contentLabel.textColor = ColorFromRGB(0x333333, 1.0);
                self.titleLabel.font = [UIFont boldPingFangFontOfSize:14];
                self.contentLabel.font = [UIFont boldPingFangFontOfSize:16];
                if(couponInfo.type == 1)
                {
                    NSString *realPrice = [NSString stringWithFormat:@"%.2f",totalDTO.total.floatValue*couponInfo.rate];
                    self.contentLabel.text = [WBPayManageHelper getShowPrice:realPrice];
                }else{
                    NSString *realPrice = [NSString stringWithFormat:@"%.2f",totalDTO.total.floatValue-couponInfo.rate];
                    self.contentLabel.text = [WBPayManageHelper getShowPrice:realPrice];
                }
                self.line.hidden = YES;
                self.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
        }
    }
}

@end

@implementation WBPayManageOrderViewCellHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        self.contentView.backgroundColor = ColorFromRGB(0xF9F9F9, 1.0);
    }
    return self;
}

-(void)setupSubviews
{
    [self addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.detailView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(200);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.detailView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(200);
        make.top.bottom.mas_equalTo(0);
    }];
}

-(UIView *)detailView
{
    if(!_detailView)
    {
        _detailView = [[UIView alloc]init];
        _detailView.backgroundColor = [UIColor whiteColor];
    }
    return _detailView;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ColorFromRGB(0x333333, 1.0);
        _titleLabel.font = [UIFont boldPingFangFontOfSize:14];
        _titleLabel.text = @"应付金额";
    }
    return _titleLabel;
}

-(UILabel *)priceLabel
{
    if(!_priceLabel){
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = ColorFromRGB(0x333333, 1.0);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [UIFont boldPingFangFontOfSize:16];
    }
    return _priceLabel;
}

@end

@interface WBPayManageOrderViewCellFooterView ()

@property (nonatomic, strong)UIView *couponView;
@property (nonatomic, strong)UILabel *couponTitleLabel;
@property (nonatomic, strong)UIButton *couponScanBtn;

@property (nonatomic, strong)UIView *otherView;
@property (nonatomic, strong)UILabel *otherTitleLabel;
@property (nonatomic, strong)UIImageView *downLine;
@property (nonatomic, strong)UILabel *upLabel;
@property (nonatomic, strong)UILabel *downLabel;
@property (nonatomic, strong)UIImageView *upImageView;
@property (nonatomic, strong)UIImageView *downImageView;
@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIButton *payButton;

@end

@implementation WBPayManageOrderViewCellFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        self.contentView.backgroundColor = ColorFromRGB(0xF9F9F9, 1.0);
    }
    return self;
}

-(void)setupSubviews
{
    [self addSubview:self.couponView];
    [self.couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(60);
    }];
    
    [self.couponView addSubview:self.couponTitleLabel];
    [self.couponTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.left.top.height.mas_equalTo(20);
    }];
    
    [self.couponView addSubview:self.couponScanBtn];
    [self.couponScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.couponView addSubview:self.couponTextField];
    [self.couponTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.couponTitleLabel.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.couponScanBtn.mas_left).offset(-10);
    }];
    
    [self addSubview:self.otherView];
    [self.otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.couponView.mas_bottom).offset(10);
    }];
    
    [self.otherView addSubview:self.otherTitleLabel];
    [self.otherTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [self.otherView addSubview:self.downLine];
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(50);
    }];
    
    [self.otherView addSubview:self.upLabel];
    [self.upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.downLine.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.upImageView];
    [self.upImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-30);
        make.centerY.equalTo(self.upLabel);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(8);
    }];
    
    [self addSubview:self.upButton];
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.upLabel);
    }];
    
    [self.otherView addSubview:self.downLabel];
    [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.upLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.downImageView];
    [self.downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-30);
        make.centerY.equalTo(self.downLabel);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(8);
    }];
    
    [self addSubview:self.downButton];
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.downLabel);
    }];
    
    [self addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.downLabel.mas_bottom).offset(60);
        make.height.mas_equalTo(40);
    }];
}

-(void)functionBtnDicClicked:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(WBPayManageOrderViewCellFooterViewDidClickFunctionBtn:)])
    {
        [self.delegate WBPayManageOrderViewCellFooterViewDidClickFunctionBtn:button];
    }
}

-(UIView *)couponView
{
    if(!_couponView)
    {
        _couponView = [[UIView alloc]init];
        _couponView.backgroundColor = [UIColor whiteColor];
    }
    return _couponView;
}

-(UILabel *)couponTitleLabel
{
    if(!_couponTitleLabel)
    {
        _couponTitleLabel = [[UILabel alloc]init];
        _couponTitleLabel.textColor = ColorFromRGB(0x666666, 1.0);
        _couponTitleLabel.text = @"优惠码";
        _couponTitleLabel.font = [UIFont regularPingFangFontOfSize:14];
    }
    return _couponTitleLabel;
}

-(UITextField *)couponTextField
{
    if(!_couponTextField)
    {
        _couponTextField = [[UITextField alloc]init];
        _couponTextField.textAlignment = NSTextAlignmentRight;
        _couponTextField.textColor = ColorFromRGB(0x666666, 1.0);
        _couponTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _couponTextField.font = [UIFont regularPingFangFontOfSize:14];
        _couponTextField.placeholder = @"扫码/输入优惠码";
        _couponTextField.textAlignment = NSTextAlignmentRight;
        [_couponTextField setValue:ColorFromRGB(0x666666, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _couponTextField;
}

-(UIButton *)couponScanBtn
{
    if(!_couponScanBtn)
    {
        _couponScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_couponScanBtn setImage:[UIImage imageNamed:@"navibar_scan"] forState:UIControlStateNormal];
        _couponScanBtn.tintColor = ColorFromRGB(0x666666, 1.0);
        _couponScanBtn.tag = 0;
        [_couponScanBtn addTarget:self action:@selector(functionBtnDicClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _couponScanBtn;
}

-(UIView *)otherView
{
    if(!_otherView)
    {
        _otherView = [[UIView alloc]init];
        _otherView.backgroundColor = [UIColor whiteColor];
    }
    return _otherView;
}

-(UILabel *)otherTitleLabel
{
    if(!_otherTitleLabel){
        _otherTitleLabel = [[UILabel alloc] init];
        _otherTitleLabel.textColor = ColorFromRGB(0x999999, 1.0);
        _otherTitleLabel.font = [UIFont regularPingFangFontOfSize:14];
        _otherTitleLabel.text = @"其他";
    }
    return _otherTitleLabel;
}

-(UIImageView *)downLine
{
    if(!_downLine)
    {
        _downLine = [[UIImageView alloc]init];
        _downLine.backgroundColor = ColorFromRGB(0xF1F1F1, 1.0);
    }
    return _downLine;
}

-(UILabel *)upLabel
{
    if(!_upLabel)
    {
        _upLabel = [[UILabel alloc]init];
        _upLabel.textColor = ColorFromRGB(0x666666, 1.0);
//        _upLabel.text = @"再了解了解维小保。";
        _upLabel.text = @"联系客服";
        _upLabel.font = [UIFont regularPingFangFontOfSize:14];
    }
    return _upLabel;
}

-(UILabel *)downLabel
{
    if(!_downLabel)
    {
        _downLabel = [[UILabel alloc]init];
        _downLabel.textColor = ColorFromRGB(0x666666, 1.0);
//        _downLabel.text = @"想要先体验维小保？";
        _downLabel.font = [UIFont regularPingFangFontOfSize:14];
    }
    return _downLabel;
}

-(UIImageView *)upImageView
{
    if(!_upImageView)
    {
        _upImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dynamic_elevator_detail_next"]];
    }
    return _upImageView;
}

-(UIImageView *)downImageView
{
    if(!_downImageView)
    {
        _downImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dynamic_elevator_detail_next"]];
        _downImageView.hidden = YES;
    }
    return _downImageView;
}

-(UIButton *)upButton
{
    if(!_upButton)
    {
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _upButton.tag = 1;
        [_upButton addTarget:self action:@selector(functionBtnDicClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upButton;
}

-(UIButton *)downButton
{
    if(!_downButton)
    {
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downButton.tag = 2;
        [_downButton addTarget:self action:@selector(functionBtnDicClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downButton;
}

-(UIButton *)payButton
{
    if(!_payButton)
    {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setBackgroundColor:[UIColor colorWithARGB:0xFF2389E8]];
        _payButton.titleLabel.font = [UIFont regularPingFangFontOfSize:18];
        _payButton.layer.cornerRadius = 4;
        _payButton.clipsToBounds = YES;
        _payButton.tag = 3;
        [_payButton addTarget:self action:@selector(functionBtnDicClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}



@end


