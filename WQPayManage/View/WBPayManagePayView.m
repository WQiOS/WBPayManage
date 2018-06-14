//
//  WBPayManagePayView.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/8.
//

#import "WBPayManagePayView.h"
#import "WBPayManageHelper.h"
#import <Masonry/Masonry.h>


@interface WBPayManagePayView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *payTypeTableView;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *moneyImageView;

@end

@implementation WBPayManagePayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectPayType = 1;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.upView];
    [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(187);
    }];
    
    [self.upView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.upView);
        make.bottom.mas_equalTo(-50);
        make.height.mas_equalTo(37);
    }];
    
    [self.upView addSubview:self.moneyImageView];
    [self.moneyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.bottom.equalTo(self.moneyLabel.mas_top).offset(-10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self).offset(-100);
    }];
    
    [self addSubview:self.payTypeTableView];
    [self.payTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.payButton.mas_top);
        make.left.right.equalTo(self);
        make.top.equalTo(self.upView.mas_bottom);
    }];
}

-(void)payDidClicked
{
    if([self.delegate respondsToSelector:@selector(WBPayManagePayViewDidClickPayButton)])
    {
        [self.delegate WBPayManagePayViewDidClickPayButton];
    }
}

//MARK: - getter/setter

-(void)setTotalPrice:(NSString *)totalPrice{
    _totalPrice = totalPrice;
    self.moneyLabel.text = [WBPayManageHelper getShowPrice:totalPrice];
}

- (UITableView *)payTypeTableView {
    if (!_payTypeTableView) {
        _payTypeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payTypeTableView.delegate = self;
        _payTypeTableView.dataSource = self;
        _payTypeTableView.showsVerticalScrollIndicator = false;
        _payTypeTableView.scrollEnabled = NO;
        _payTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available (iOS 11, *)) {
            _payTypeTableView.estimatedRowHeight = 0;
            _payTypeTableView.estimatedSectionHeaderHeight = 0;
            _payTypeTableView.estimatedSectionFooterHeight = 0;
        }
        _payTypeTableView.rowHeight = 48;
        [_payTypeTableView registerClass:WBPayManagePayViewCell.class forCellReuseIdentifier:NSStringFromClass(WBPayManagePayViewCell.class)];
        
    }
    return _payTypeTableView;
}

-(UIButton *)payButton
{
    if(!_payButton)
    {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setBackgroundColor:ColorFromRGB(0x2389E8, 1.0)];
        _payButton.titleLabel.font = [UIFont regularPingFangFontOfSize:18];
        _payButton.layer.cornerRadius = 4;
        _payButton.clipsToBounds = YES;
        [_payButton addTarget:self action:@selector(payDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

-(UIView *)upView
{
    if(!_upView){
        _upView = [[UIView alloc]init];
        _upView.backgroundColor = ColorFromRGB(0x2389E8, 1.0);
    }
    return _upView;
}

-(UIImageView *)moneyImageView
{
    if(!_moneyImageView)
    {
        _moneyImageView = [[UIImageView alloc]init];
        _moneyImageView.image = [UIImage imageNamed:@"evaluate_wallet"];
    }
    return _moneyImageView;
}

-(UILabel *)moneyLabel
{
    if(!_moneyLabel)
    {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = [UIFont semiboldPingFangFontOfSize:26];
        _moneyLabel.textColor = [UIColor whiteColor];
    }
    return _moneyLabel;
}

//MARK: - UITableViewDelegate, UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBPayManagePayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WBPayManagePayViewCell.class)];
    [cell configDataWithIndexRow:indexPath.row andPayType:(int)self.selectPayType];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.row +1 != self.selectPayType)
    {
        self.selectPayType = indexPath.row + 1 ;
        [tableView reloadData];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.font = [UIFont regularPingFangFontOfSize:14];
    headerLabel.textColor = ColorFromRGB(0x999999, 1.0);
    headerLabel.text = @"请选择支付方式：";
    headerLabel.frame = CGRectMake(30, 20, 200, 20);
    [headerView addSubview:headerLabel];
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
}

@end

@interface WBPayManagePayViewCell ()

@property (nonatomic, strong) UIImageView *typeIconImageView;
@property (nonatomic, strong) UILabel *typeNameLabel;
@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) UIImageView *upLine;
@property (nonatomic, strong) UIImageView *downLine;

@end

@implementation WBPayManagePayViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupSubviews {

    [self.contentView addSubview:self.typeIconImageView];
    [self.typeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(30);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.typeNameLabel];
    [self.typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeIconImageView.mas_right).offset(12);
        make.centerY.height.equalTo(self.contentView);
        make.width.mas_equalTo(200);
    }];

    [self.contentView addSubview:self.checkImageView];
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(17);
        make.right.mas_equalTo(-30);
    }];
    
    [self.contentView addSubview:self.upLine];
    [self.upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.contentView addSubview:self.downLine];
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

-(void)configDataWithIndexRow:(NSInteger)row andPayType:(int)type
{
    if(row)
    {
        self.upLine.hidden = YES;
        self.typeIconImageView.image = [UIImage imageNamed:@"evaluate_pay_weixin"];
        self.checkImageView.highlighted = type==2;
        self.typeNameLabel.text = @"微信支付";
        
    }else
    {
        self.upLine.hidden = NO;
        self.typeIconImageView.image = [UIImage imageNamed:@"evaluate_pay_ali"];
        self.checkImageView.highlighted = type==1;
        self.typeNameLabel.text = @"支付宝";
    }
}

-(UIImageView *)typeIconImageView
{
    if(!_typeIconImageView)
    {
        _typeIconImageView = [[UIImageView alloc]init];
    }
    return _typeIconImageView;
}

-(UILabel *)typeNameLabel
{
    if (!_typeNameLabel) {
        _typeNameLabel = [[UILabel alloc] init];
        _typeNameLabel.textColor = ColorFromRGB(0x666666, 1.0);
        _typeNameLabel.font = [UIFont regularPingFangFontOfSize:16];
    }
    return _typeNameLabel;
}

-(UIImageView *)checkImageView
{
    if(!_checkImageView)
    {
        _checkImageView = [[UIImageView alloc]init];
        [_checkImageView setImage:[UIImage imageNamed:@"evaluate_pay_choosen"]];
        [_checkImageView setHighlightedImage:[UIImage imageNamed:@"evaluate_pay_choosen"]];
    }
    return _checkImageView;
}

-(UIImageView *)upLine
{
    if(!_upLine)
    {
        _upLine = [[UIImageView alloc]init];
        _upLine.backgroundColor = ColorFromRGB(0xF1F1F1, 1.0);
    }
    return _upLine;
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

@end
