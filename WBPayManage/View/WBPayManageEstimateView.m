//
//  WBPayManageEstimateView.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/6.
//

#import "WBPayManageEstimateView.h"
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import <Masonry/Masonry.h>

@interface WBPayManageEstimateView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *selectTableView;//评估页面选择大项
@property (nonatomic, strong) WBPayManageEstimateViewSelectFooterView *selectFooterView;

@property (nonatomic, strong) UITableView *infoTableView;//评估页面已选择
@property (nonatomic, strong) UIView *seeInfoTableBackView;
@property (nonatomic, assign) BOOL isShowInfoTableViewDetail;

@property (nonatomic, strong) UITableView *assesInfoTableView;//评估页面选择小项
@property (nonatomic, strong) UIView *assesInfoChooseBackView;

@property (nonatomic, strong) UIButton *estimateButton;
@property (nonatomic, strong) UILabel *haveChoosedLabel;
@property (nonatomic, strong) UIButton *seeChooseInfoBtn;


@end

@implementation WBPayManageEstimateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.selectTableView];
    [self.selectTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(WBPayManageScreenWidth);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self addSubview:self.estimateButton];
    [self.estimateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(116);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
    }];
    
    [self addSubview:self.haveChoosedLabel];
    [self.haveChoosedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.estimateButton.mas_left);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
    }];
    
    self.assesInfoChooseBackView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.assesInfoChooseBackView];
    
    [self.assesInfoChooseBackView addSubview:self.assesInfoTableView];
    
    self.seeInfoTableBackView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.seeInfoTableBackView];
    
    [self addSubview:self.infoTableView];
    
    [self addSubview:self.seeChooseInfoBtn];
    [self.seeChooseInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-6);
        make.width.height.mas_equalTo(48);
    }];
}

//MARK: - getter/setter

-(void)setAssesInfoList:(NSArray *)assesInfoList
{
    _assesInfoList = assesInfoList;
    [self.assesInfoTableView reloadData];
    self.assesInfoChooseBackView.hidden = NO;
    self.assesInfoTableView.contentOffset = CGPointMake(0, 0);
    int height = assesInfoList.count >= 5 ? 300 : (int)assesInfoList.count *60;
    [UIView animateWithDuration:0.25 animations:^{
        self.assesInfoTableView.frame = CGRectMake(10, WBPayManageScreenHeight-height-10, WBPayManageScreenWidth-20, height);
    }];
}

-(void)setCurrentLiftSceneDTO:(LiftSceneDTO *)currentLiftSceneDTO
{
    _currentLiftSceneDTO = currentLiftSceneDTO;
    [self.selectTableView reloadData];
}

-(void)setIsShowInfoTableViewDetail:(BOOL)isShowInfoTableViewDetail
{
    _isShowInfoTableViewDetail = isShowInfoTableViewDetail;
    if(isShowInfoTableViewDetail)
    {
        [self.seeChooseInfoBtn setImage:[UIImage imageNamed:@"evaluate_choosen"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.infoTableView.frame = CGRectMake(0, WBPayManageScreenHeight- (iPhoneX ? 494 :470),WBPayManageScreenWidth, 366);
            self.seeInfoTableBackView.hidden = NO;
        } completion:^(BOOL finished) {
        }];
    }else
    {
        [self.seeChooseInfoBtn setImage:[UIImage imageNamed:@"evaluate_unchoosen"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.infoTableView.frame = CGRectMake(0, WBPayManageScreenHeight- (iPhoneX ? 128 :104),WBPayManageScreenWidth, 0);
            self.seeInfoTableBackView.hidden = YES;
        } completion:^(BOOL finished) {
        }];
    }
}

-(NSMutableArray<LiftSceneDTO *> *)selectLiftSceneDTOList
{
    if(!_selectLiftSceneDTOList)
    {
        _selectLiftSceneDTOList = [NSMutableArray array];
    }
    return _selectLiftSceneDTOList;
}

-(WBPayManageEstimateViewSelectFooterView *)selectFooterView
{
    if(!_selectFooterView)
    {
        _selectFooterView = [[WBPayManageEstimateViewSelectFooterView alloc]initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, 120)];
        [_selectFooterView.addAssesButton addTarget:self action:@selector(addSceneDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectFooterView;
}

- (UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.showsVerticalScrollIndicator = false;
        _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available (iOS 11, *)) {
            _selectTableView.estimatedRowHeight = 0;
            _selectTableView.estimatedSectionHeaderHeight = 0;
            _selectTableView.estimatedSectionFooterHeight = 0;
        }
        _selectTableView.rowHeight = 40;
        _selectTableView.sectionHeaderHeight = 0;
        _selectTableView.sectionFooterHeight = 0;
        [_selectTableView registerClass:WBPayManageEstimateViewSelectCell.class forCellReuseIdentifier:NSStringFromClass(WBPayManageEstimateViewSelectCell.class)];
        _selectTableView.tableFooterView = self.selectFooterView;
    }
    return _selectTableView;
}

- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WBPayManageScreenHeight- (iPhoneX ? 128 : 104),WBPayManageScreenWidth, 0) style:UITableViewStylePlain];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.showsVerticalScrollIndicator = false;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available (iOS 11, *)) {
            _infoTableView.estimatedRowHeight = 0;
            _infoTableView.estimatedSectionHeaderHeight = 0;
            _infoTableView.estimatedSectionFooterHeight = 0;
        }
        _infoTableView.rowHeight = 168;
        _infoTableView.sectionHeaderHeight = 0;
        _infoTableView.sectionFooterHeight = 0;
        [_infoTableView registerClass:WBPayManageEstimateViewInfoCell.class forCellReuseIdentifier:NSStringFromClass(WBPayManageEstimateViewInfoCell.class)];
    }
    return _infoTableView;
}

-(UITableView *)assesInfoTableView
{
    if (!_assesInfoTableView) {
        _assesInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, WBPayManageScreenHeight-10, WBPayManageScreenWidth-20, 0) style:UITableViewStylePlain];
        _assesInfoTableView.delegate = self;
        _assesInfoTableView.dataSource = self;
        _assesInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _assesInfoTableView.showsVerticalScrollIndicator = false;
        if (@available (iOS 11, *)) {
            _assesInfoTableView.estimatedRowHeight = 0;
            _assesInfoTableView.estimatedSectionHeaderHeight = 0;
            _assesInfoTableView.estimatedSectionFooterHeight = 0;
        }
        _assesInfoTableView.layer.cornerRadius = 10;
        _assesInfoTableView.rowHeight = 60;
        _assesInfoTableView.sectionHeaderHeight = 0;
        _assesInfoTableView.sectionFooterHeight = 0;
        [_assesInfoTableView registerClass:WBPayManageEstimateViewAssesInfoCell.class forCellReuseIdentifier:NSStringFromClass(WBPayManageEstimateViewAssesInfoCell.class)];
    }
    return _assesInfoTableView;
}

-(UIView *)assesInfoChooseBackView
{
    if(!_assesInfoChooseBackView)
    {
        _assesInfoChooseBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, WBPayManageScreenHeight)];
        _assesInfoChooseBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        WEAKSELF;
        UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [UIView animateWithDuration:0.25 animations:^{
                
                weakself.assesInfoTableView.frame = CGRectMake(10, WBPayManageScreenHeight-10, WBPayManageScreenWidth-20, 0);
                
            } completion:^(BOOL finished) {
                [weakself.assesInfoChooseBackView setHidden:YES];
            }];
        }];
        tap.delegate = self;
        [_assesInfoChooseBackView addGestureRecognizer:tap];
    }
    return _assesInfoChooseBackView;
}

-(UIView *)seeInfoTableBackView
{
    if(!_seeInfoTableBackView)
    {
        _seeInfoTableBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, WBPayManageScreenHeight-406)];
        _seeInfoTableBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        WEAKSELF;
        UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [weakself.seeInfoTableBackView setHidden:YES];
            weakself.isShowInfoTableViewDetail = NO;
        }];
        tap.delegate = self;
        [_seeInfoTableBackView addGestureRecognizer:tap];
    }
    return _seeInfoTableBackView;
}

-(UIButton *)estimateButton
{
    if(!_estimateButton)
    {
        _estimateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_estimateButton setTitle:@"开始评估" forState:UIControlStateNormal];
        [_estimateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_estimateButton setBackgroundColor:[UIColor colorWithARGB:0xFF4CD964]];
        _estimateButton.titleLabel.font = [UIFont boldPingFangFontOfSize:14];
        [_estimateButton addTarget:self action:@selector(estimateDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _estimateButton;
}

-(UILabel *)haveChoosedLabel
{
    if(!_haveChoosedLabel)
    {
        _haveChoosedLabel = [[UILabel alloc]init];
        _haveChoosedLabel.textAlignment = NSTextAlignmentCenter;
        _haveChoosedLabel.font = [UIFont boldPingFangFontOfSize:14];
        _haveChoosedLabel.textColor = [UIColor whiteColor];
        _haveChoosedLabel.text = @"已选择(0)";
        _haveChoosedLabel.userInteractionEnabled = YES;
        _haveChoosedLabel.backgroundColor = ColorFromRGB(0x505051, 1.0);
        WEAKSELF;
        UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [weakself seeChooseInfoBtnDidClicked];
        }];
        [_haveChoosedLabel addGestureRecognizer:tap];
    }
    return _haveChoosedLabel;
}

-(UIButton *)seeChooseInfoBtn
{
    if(!_seeChooseInfoBtn)
    {
        _seeChooseInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seeChooseInfoBtn setImage:[UIImage imageNamed:@"evaluate_unchoosen"] forState:UIControlStateNormal];
        [_seeChooseInfoBtn addTarget:self action:@selector(seeChooseInfoBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeChooseInfoBtn;
}

-(void)estimateDidClicked
{
    self.isShowInfoTableViewDetail = NO;
    if([self.delegate respondsToSelector:@selector(WBPayManageEstimateViewDidClickEstimateButton)])
    {
        [self.delegate WBPayManageEstimateViewDidClickEstimateButton];
    }
}

-(void)addSceneDidClicked
{
    if([self.delegate respondsToSelector:@selector(WBPayManageEstimateViewDidClickAddSceneButton)])
    {
        [self.delegate WBPayManageEstimateViewDidClickAddSceneButton];
    }
}

-(void)infoTableViewCellDeleteBtnClicked:(UIButton *)button
{
    [self.selectLiftSceneDTOList removeObjectAtIndex:button.tag];
    [self reloadInfoTableViewData];
}

-(void)seeChooseInfoBtnDidClicked
{
    if(self.selectLiftSceneDTOList.count)
    {
        self.isShowInfoTableViewDetail = !self.isShowInfoTableViewDetail;
    }else{
        [[[ZLProgressHUD shared] showText:@"您还没有添加任何电梯场景" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }
}

-(void)reloadInfoTableViewData
{
    NSInteger liftNum = 0;
    for(LiftSceneDTO *scene in self.selectLiftSceneDTOList)
    {
        liftNum = liftNum + scene.num;
    }
    self.haveChoosedLabel.text = [NSString stringWithFormat:@"已选择(%ld)",liftNum];
    [self.infoTableView reloadData];
}

-(void)setUnenableChangeInfo
{
    self.estimateButton.hidden = YES;
    self.seeChooseInfoBtn.hidden = YES;
    self.haveChoosedLabel.hidden = YES;
    self.selectTableView.allowsSelection = NO;
    self.selectFooterView.hidden = YES;
}

//MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

//MARK: - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.selectTableView)
    {
        return 7;
    }else if(tableView == self.infoTableView){
        return self.selectLiftSceneDTOList.count;
    }else{
        return self.assesInfoList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.selectTableView)
    {
        WBPayManageEstimateViewSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WBPayManageEstimateViewSelectCell.class)];
        [cell configData:self.currentLiftSceneDTO WithIndexRow:indexPath.row canEdit:tableView.allowsSelection];
        return cell;
        
    }else if(tableView == self.infoTableView)
    {
        id<WBPayManageEstimateViewType> model = self.selectLiftSceneDTOList[indexPath.row];
        
        WBPayManageEstimateViewInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WBPayManageEstimateViewInfoCell.class)];
        [cell configData:model withIndexPath:indexPath];
        cell.deleteButton.tag = indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(infoTableViewCellDeleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else
    {
        NSString *content = self.assesInfoList[indexPath.row];
        WBPayManageEstimateViewAssesInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WBPayManageEstimateViewAssesInfoCell.class)];
        [cell configData:content];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == self.selectTableView)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageEstimateViewTableViewDidSelectedRowAtIndexPath:)]) {
            [self.delegate WBPayManageEstimateViewTableViewDidSelectedRowAtIndexPath:indexPath];
        }
    }else if(tableView == self.infoTableView){
        LiftSceneDTO *model = self.selectLiftSceneDTOList[indexPath.row];
        self.currentLiftSceneDTO = model.mutableCopy;
        self.isShowInfoTableViewDetail = NO;
    }else
    {
        WEAKSELF;
        [UIView animateWithDuration:0.25 animations:^{
            
            weakself.assesInfoTableView.frame = CGRectMake(10, WBPayManageScreenHeight-10, WBPayManageScreenWidth-20, 0);
            
        } completion:^(BOOL finished) {
            weakself.assesInfoChooseBackView.hidden = YES;
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageEstimateViewTableViewDidAssesInfoRowAtIndexPath:)]) {
            [self.delegate WBPayManageEstimateViewTableViewDidAssesInfoRowAtIndexPath:indexPath];
        }
    }
}

-(void)reloadSelectTableViewCellWithIndexRow:(NSInteger)row
{
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.selectTableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end

@interface WBPayManageEstimateViewSelectCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *downLine;

@end

@implementation WBPayManageEstimateViewSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
    }];

    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.width.mas_equalTo(80);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.downLine];
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
    }];
}

//MARK: - getter/setter

-(UIImageView *)iconImageView
{
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
        _titleLabel.font = [UIFont regularPingFangFontOfSize:16];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel
{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.font = [UIFont regularPingFangFontOfSize:16];
    }
    return _contentLabel;
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

-(void)configData:(id<WBPayManageEstimateViewType>)data WithIndexRow:(NSInteger)row canEdit:(BOOL)canEdit
{
    self.accessoryType = canEdit ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    switch (row) {
        case 0:
        {
            self.iconImageView.image = [UIImage imageNamed:@"evaluate_building_type"];
            self.titleLabel.text = @"建筑类型";
            self.contentLabel.text = data.WBPayManageEstimateViewType_archiContent;
        }
            break;
        case 1:
        {
            self.iconImageView.image = [UIImage imageNamed:@"evaluate_floor_count"];
            self.titleLabel.text = @"楼层数量";
            self.contentLabel.text = data.WBPayManageEstimateViewType_floorContent;
        }
            break;
        case 2:
        {
            self.iconImageView.image = [UIImage imageNamed:@"evaluate_elevator_brand"];
            self.titleLabel.text = @"电梯品牌";
            self.contentLabel.text = data.WBPayManageEstimateViewType_brandContent;
        }
            break;
        case 3:
        {
            self.iconImageView.image = [UIImage imageNamed:@"evaluate_elevator_age"];
            self.titleLabel.text = @"使用年限";
            self.contentLabel.text = data.WBPayManageEstimateViewType_serviceContent;
        }
            break;
        case 4:
        {
            self.iconImageView.image = [UIImage imageNamed:@"evaluate_elevator_load"];
            self.titleLabel.text = @"载 重 量";
            self.contentLabel.text = data.WBPayManageEstimateViewType_capacityContent;
        }
            break;
        case 5:
        {
            self.iconImageView.image = [UIImage imageNamed:@"evaluate_elevator_speed"];
            self.titleLabel.text = @"电梯速度";
            self.contentLabel.text = data.WBPayManageEstimateViewType_speedContent;
        }
            break;
        case 6:
        {
            self.iconImageView.image = [UIImage imageNamed:@"evaluate_elevator_count"];
            self.titleLabel.text = @"电梯数量";
            self.contentLabel.text = data.WBPayManageEstimateViewType_liftNumContent;
        }
            break;
        default:
            break;
    }
    self.contentLabel.textColor = [self.contentLabel.text isEqualToString:@"请选择"] ? [UIColor lightGrayColor] : ColorFromRGB(0x666666, 1.0) ;
}

@end

@implementation WBPayManageEstimateViewSelectFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self addSubview:self.addAssesImageView];
    [self.addAssesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(20);
    }];
    
    [self addSubview:self.addAssesTitle];
    [self.addAssesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addAssesImageView.mas_right).offset(12);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(self.addAssesImageView);
    }];
    
    [self addSubview:self.addAssesButton];
    [self.addAssesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(39);
        make.top.mas_equalTo(20);
    }];
    
    [self addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addAssesButton.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(17);
    }];
}

-(UIButton *)addAssesButton
{
    if(!_addAssesButton)
    {
        _addAssesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _addAssesButton;
}

-(UILabel *)remarkLabel
{
    if(!_remarkLabel)
    {
        _remarkLabel = [[UILabel alloc]init];
        _remarkLabel.textColor = ColorFromRGB(0x999999, 1.0);
        _remarkLabel.font = [UIFont regularPingFangFontOfSize:12];
        _remarkLabel.text = @"*备注：请确保填写信息的准确性";
    }
    return _remarkLabel;
}

-(UILabel *)addAssesTitle
{
    if(!_addAssesTitle)
    {
        _addAssesTitle = [[UILabel alloc]init];
        _addAssesTitle.textColor = ColorFromRGB(0x4CD964, 1.0);
        _addAssesTitle.font = [UIFont regularPingFangFontOfSize:16];
        _addAssesTitle.text = @"添加";
    }
    return _addAssesTitle;
}

-(UIImageView *)addAssesImageView
{
    if(!_addAssesImageView)
    {
        _addAssesImageView = [[UIImageView alloc]init];
        _addAssesImageView.image = [UIImage imageNamed:@"evaluate_add"];
    }
    return _addAssesImageView;
}

@end

@interface WBPayManageEstimateViewInfoCell ()

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *liftNumLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WBPayManageEstimateViewInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupSubviews {
    
    [self.contentView addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(148);
    }];
    
    [self.detailView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.detailView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailView.mas_centerX).offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-30);
    }];
    
    [self.detailView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.right.equalTo(self.rightLabel.mas_left).offset(-5);
        make.bottom.mas_equalTo(-30);
    }];
    
    [self.detailView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.top.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.detailView addSubview:self.liftNumLabel];
    [self.liftNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-10);
    }];
}

-(void)configData:(id<WBPayManageEstimateViewType>)data withIndexPath:(NSIndexPath *)index
{
    self.leftLabel.text = [NSString stringWithFormat:@"建筑类型：%@\n楼层数量：%@\n载 重 量 ：%@",data.WBPayManageEstimateViewType_archiContent,data.WBPayManageEstimateViewType_floorContent,data.WBPayManageEstimateViewType_capacityContent];
    self.rightLabel.text = [NSString stringWithFormat:@"电梯品牌：%@\n使用年限：%@\n电梯速度：%@",data.WBPayManageEstimateViewType_brandContent,data.WBPayManageEstimateViewType_serviceContent,data.WBPayManageEstimateViewType_speedContent];
    self.titleLabel.text = [NSString stringWithFormat:@"选择%ld",index.row+1];
    self.liftNumLabel.text = data.WBPayManageEstimateViewTypeInfoCell_liftNumContent;
}

-(UIView *)detailView
{
    if(!_detailView)
    {
        _detailView = [[UIView alloc]init];
        _detailView.backgroundColor = ColorFromRGB(0xFCFCFC, 1.0);
    }
    return _detailView;
}

-(UILabel *)leftLabel
{
    if(!_leftLabel)
    {
        _leftLabel = [self getShowLabel];
    }
    return _leftLabel;
}

-(UILabel *)rightLabel
{
    if(!_rightLabel)
    {
        _rightLabel = [self getShowLabel];
    }
    return _rightLabel;
}

-(UILabel *)liftNumLabel
{
    if(!_liftNumLabel)
    {
        _liftNumLabel = [[UILabel alloc] init];
        _liftNumLabel.font = [UIFont boldPingFangFontOfSize:14];
        _liftNumLabel.textColor = ColorFromRGB(0x333333, 1.0);
    }
    return _liftNumLabel;
}

-(UIButton *)deleteButton
{
    if(!_deleteButton)
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"x" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:ColorFromRGB(0x8F8E94, 1.0) forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
    }
    return _deleteButton;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = ColorFromRGB(0xF9F9F9, 1.0);
        _titleLabel.font = [UIFont regularPingFangFontOfSize:14];
        _titleLabel.textColor = ColorFromRGB(0x666666, 1.0);
    }
    return _titleLabel;
}

-(UILabel *)getShowLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont regularPingFangFontOfSize:14];
    label.textColor = ColorFromRGB(0x666666, 1.0);
    label.numberOfLines = 0;
    return label;
}

@end

@interface WBPayManageEstimateViewAssesInfoCell ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *downLine;

@end

@implementation WBPayManageEstimateViewAssesInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)configData:(NSString *)infoName
{
    self.contentLabel.text = infoName;
}

- (void)setupSubviews {
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.downLine];
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
}

-(UILabel *)contentLabel
{
    if(!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont regularPingFangFontOfSize:20];
        _contentLabel.textColor = ColorFromRGB(0x4169E1, 1.0);
    }
    return _contentLabel;
}

-(UIImageView *)downLine
{
    if(!_downLine)
    {
        _downLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"full_line"]];
    }
    return _downLine;
}

@end


