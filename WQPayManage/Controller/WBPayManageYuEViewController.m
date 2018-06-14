//
//  WBPayManageYuEViewController.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/5/30.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageYuEViewController.h"
#import "WBPayManageYuENavSelectView.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import "WBConditionRootViewModel.h"
#import "WBChangePlotController.h"
#import "WBPayManageYuEHeaderView.h"
#import "WBPayManageYuEViewModel.h"
#import "WBPayManagePayIncomeDetailViewController.h"
#import "WBPayManageAccountInfoModel.h"
#import <MJRefresh/MJRefresh.h>

//MARK: - 当前滑动的状态
typedef NS_ENUM(NSUInteger, WBScrollViewState) {
    WBScrollViewStateInDown,
    WBScrollViewStateInUp,
};

@interface WBPayManageYuEViewController ()<WBConditionRootViewModelDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WBPayManageYuENavSelectView *navSelectView;
@property (nonatomic, strong) WBConditionRootViewModel *viewModel;
@property (nonatomic, strong) WBPayManageYuEViewModel *yuEViewModel;
@property (nonatomic, strong) WBPayManageYuEHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger yuEListIndex;
@property (nonatomic, strong) PlotDTO *currentPlotDTO;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) BOOL hasToUpAnimation; //是否已经向上滑动了
@property (nonatomic, assign) BOOL hasToDownAnimation; //是否已经向下滑动了
@property (nonatomic, assign) CGFloat oldY;
@property (nonatomic, assign) WBScrollViewState currentState; //当前滑动的状态
@property (nonatomic, strong) WBPayManageAccountInfoModel *currentModel; //当前账户信息
@property (nonatomic, strong) UIView *nodateView; //没有数据的占位图
@property (nonatomic, strong) UIImageView *nodateImageView; //没有数据的占位图
@property (nonatomic, strong) UILabel *nodateLabel; //没有数据的占位图

@end

@implementation WBPayManageYuEViewController

//MARK: - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"余额";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.viewModel requestPlotList];
    [[ZLProgressHUD shared] showText:nil mode:MBProgressHUDModeIndeterminate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithARGB:0xFF2389E8];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar addSubview:self.navSelectView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.barTintColor = nil;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    [self.navSelectView removeFromSuperview];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//MARK: - 请求小区列表回调
- (void)conditionRootViewModelDidGetPlotList:(NSArray<PlotDTO *> *)plotList {
    [[ZLProgressHUD shared] hide:YES];
    if (plotList && plotList.count) {
        PlotDTO *plot = plotList[0];
        self.navSelectView.xiaoquName = plot.plotName;
        self.currentPlotDTO = plot;
        self.yuEListIndex = 1;
        [self requestYuEList];
    }
    if (!plotList.count) {
        [self.tableView addSubview:self.nodateView];
    }
}

- (void)conditionRootViewModelFailGetPlotList:(HttpError *)error
{
    [[[ZLProgressHUD shared] showText:error.message mode:MBProgressHUDModeText] hide:YES afterDelay:1.5] ;
}

//MARK: - 请求余额列表数据
- (void)requestYuEList {
    WEAKSELF;
    [self.yuEViewModel requestYuElistWithPlotId:self.currentPlotDTO.plotId index:self.yuEListIndex size:10 block:^(WBPayManageAccountInfoModel *model, WBPayManageYuEListModel *list) {
        weakself.headerView.yueNumberString = [NSString stringWithFormat:@"%.2f",model.totalBalance];
        [weakself.listArray addObjectsFromArray:list.list];
        [weakself.tableView reloadData];
        if (!weakself.listArray.count) {
            [weakself.tableView addSubview:weakself.nodateView];
        }else if (weakself.nodateView){
            [weakself.nodateView removeFromSuperview];
        }
        weakself.tableView.mj_footer.hidden = list.list.count < 10;
        weakself.yuEListIndex ++;
    } error:^(NSString *errorMessage) {
        if (!weakself.listArray.count) {
            [weakself.tableView addSubview:weakself.nodateView];
        }else if (weakself.nodateView){
            [weakself.nodateView removeFromSuperview];
            weakself.nodateView = nil;
        }
        [[[ZLProgressHUD shared] showText:errorMessage mode:MBProgressHUDModeText] hide:YES afterDelay:1.5] ;
    }];
}

//MARK: - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WBPayManageYuETableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(identifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TradeInfoDto *model = self.listArray[indexPath.row];
    if ([cell respondsToSelector:NSSelectorFromString(@"bindCellModel:indexPath:")]) {
        SEL selector = NSSelectorFromString(@"bindCellModel:indexPath:");
        IMP imp = [cell methodForSelector:selector];
        void (*func)(id, SEL,TradeInfoDto*,NSIndexPath *) = (void *)imp;
        func(cell, selector,model,indexPath);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeInfoDto *model = self.listArray[indexPath.row];
    WBPayManagePayIncomeDetailViewController *vc = [WBPayManagePayIncomeDetailViewController new];
    vc.tradeId = model.tradeId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yy = scrollView.contentOffset.y;
    if (yy > self.oldY && !self.hasToUpAnimation && self.currentState == WBScrollViewStateInDown) {
        // 上滑
        self.hasToUpAnimation = YES;
        [self.headerView startAnimation];
        [UIView animateWithDuration:0.45 animations:^{
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
            self.tableView.frame = CGRectMake(0, 60, WBPayManageScreenWidth, WBPayManageScreenHeight - KNavBarHeight - 60);
        } completion:^(BOOL finished) {
            self.currentState = WBScrollViewStateInUp;
            self.hasToUpAnimation = NO;
        }];
    }else if(yy < self.oldY && yy < -5 && !self.hasToDownAnimation && self.currentState == WBScrollViewStateInUp){
        // 下滑
        self.hasToDownAnimation = YES;
        [self.headerView cancelAnimation];
        [UIView animateWithDuration:0.45 animations:^{
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
            self.tableView.frame = CGRectMake(0, 150, WBPayManageScreenWidth, WBPayManageScreenHeight - KNavBarHeight - 150);
        } completion:^(BOOL finished) {
            self.hasToDownAnimation = NO;
            self.currentState = WBScrollViewStateInDown;
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    self.oldY = scrollView.contentOffset.y;
}

//MARK: - setter / getter
- (WBPayManageYuENavSelectView *)navSelectView {
    if (!_navSelectView) {
        _navSelectView = [[WBPayManageYuENavSelectView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 0, 100, 44)];
        _navSelectView.backgroundColor = [UIColor clearColor];
        //MARK: - 选择小区
        [_navSelectView bk_addEventHandler:^(id sender) {
            [[ZLProgressHUD shared]hide:YES];
            WBChangePlotController *vc = [[WBChangePlotController alloc] init];
            vc.currentPlot = self.viewModel.currentPlot;
            vc.plots = self.viewModel.plotList;
            WEAKSELF;
            [vc setChangePlotCallBack:^(PlotDTO *plot) {
                weakself.navSelectView.xiaoquName = plot.plotName;
                weakself.currentPlotDTO = plot;
                [weakself requestYuEList];
            }];
            [self.navigationController pushViewController:vc animated:true];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _navSelectView;
}

- (WBConditionRootViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WBConditionRootViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

- (WBPayManageYuEViewModel *)yuEViewModel {
    if (!_yuEViewModel) {
        _yuEViewModel = [[WBPayManageYuEViewModel alloc] init];
    }
    return _yuEViewModel;
}

- (WBPayManageYuEHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WBPayManageYuEHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, WBPayManageScreenWidth, WBPayManageScreenHeight - KNavBarHeight - 150) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.tableFooterView = [UIView new];
        __weak typeof(self) weakself = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakself requestYuEList];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (UIView *)nodateView {
    if (!_nodateView) {
        _nodateView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 140, CGRectGetHeight(self.tableView.frame)/2 - 110, 280, 165)];
        _nodateView.backgroundColor = [UIColor whiteColor];
        [_nodateView addSubview:self.nodateImageView];
        [_nodateView addSubview:self.nodateLabel];
    }
    return _nodateView;
}

- (UIImageView *)nodateImageView {
    if (!_nodateImageView) {
        _nodateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 125)];
        _nodateImageView.image = [UIImage imageNamed:@"mine_yue_nodata"];
    }
    return _nodateImageView;
}

- (UILabel *)nodateLabel {
    if (!_nodateLabel) {
        _nodateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nodateImageView.frame) + 10, 280, 30)];
        _nodateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _nodateLabel.text = @"暂无收支明细记录";
        _nodateLabel.font = [UIFont regularPingFangFontOfSize:14];
        _nodateLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _nodateLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
