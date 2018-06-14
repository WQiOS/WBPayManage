//
//  WBPayManageNeedTrackViewController.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/4.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageNeedTrackViewController.h"
#import "WBPayManageFastOfferViewController.h"
#import "WBPayManageNeedTrackViewModel.h"
#import "WBPayManageNeedTrackModel.h"
#import <MJRefresh/MJRefresh.h>

@interface WBPayManageNeedTrackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WBPayManageNeedTrackViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *needTrackListArray;
@property (nonatomic, assign) NSInteger pageCount;
@end

@implementation WBPayManageNeedTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"需求追踪";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.pageCount = 1;
    [self requestNeedTrackList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//MARK: - 数据请求
- (void)requestNeedTrackList {
    WEAKSELF;
    [self.viewModel requestNeedTrackListWithComId:self.comId ? self.comId : 4 index:self.pageCount size:10 block:^(NSArray<WBPayManageNeedTrackModel *> *array) {
        if (weakself.pageCount == 1) {
            [weakself.tableView.mj_header endRefreshing];
            [weakself.needTrackListArray removeAllObjects];
        }
        if (weakself.pageCount > 1) [weakself.tableView.mj_footer endRefreshing];
        [weakself.needTrackListArray addObjectsFromArray:array];
        [weakself.tableView reloadData];
        weakself.pageCount++;
    } error:^(NSString *errorMessage) {
        [[[ZLProgressHUD shared] showText:errorMessage mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }];
}

//MARK: - WBPayManageNeedTrackClick代理
//MARK: - 反馈
- (void)goToFeedback:(NSInteger)index {
    WEAKSELF;
    WBPayManageNeedTrackModel *model = self.needTrackListArray[index];
    WBPayManageFastOfferViewController *vc = [WBPayManageFastOfferViewController new];
    vc.canEdit = YES;
    vc.dataModel = model;
    vc.DemandTraceSucess = ^(BOOL isSucess) {
        //提交成功之后，刷新列表
        weakself.pageCount = 1;
        [weakself requestNeedTrackList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: - 取消报价
- (void)didClickCancelOffer:(NSInteger)index {
    if (index < self.needTrackListArray.count) {
        __block WBPayManageNeedTrackModel *model = self.needTrackListArray[index];
        WEAKSELF;
        [self.viewModel didClickCancelOffer:model.feedbackId sucessBlock:^(BOOL sucess) {
            if (sucess) {
                model.status = 0;
                model.createTime = nil;
                model.pricePerTime = 0;
                model.pricePerLift = 0;
                model.priceSum = 0;
                [weakself.needTrackListArray replaceObjectAtIndex:index withObject:model];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [[[ZLProgressHUD shared] showText:@"取消成功！" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
            }
        } error:^(NSString *errorMessage) {
            [[[ZLProgressHUD shared] showText:errorMessage mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
        }];
    }
}

//MARK: - 删除需求
-(void)deleteNeed:(NSInteger)index {
    if (index < self.needTrackListArray.count) {
        __block WBPayManageNeedTrackModel *model = self.needTrackListArray[index];
        WEAKSELF;
        [self.viewModel requestDeleteFeedbackWithFeedbackId:model.feedbackId sucessBlock:^(BOOL sucess) {
            if (sucess) {
                [weakself.needTrackListArray removeObjectAtIndex:index];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [[[ZLProgressHUD shared] showText:@"删除成功！" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
            }
        } error:^(NSString *errorMessage) {
            [[[ZLProgressHUD shared] showText:errorMessage mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
        }];
    }
}

//MARK: - 去执行服务
- (void)toDoServices:(NSInteger)index {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//MARK: - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.needTrackListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WBPayManageNeedTrackTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(identifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([cell respondsToSelector:NSSelectorFromString(@"bindCellModel:indexPath:delegate:")]) {
        SEL selector = NSSelectorFromString(@"bindCellModel:indexPath:delegate:");
        WBPayManageNeedTrackModel *model = self.needTrackListArray[indexPath.row];
        IMP imp = [cell methodForSelector:selector];
        void (*func)(id, SEL,WBPayManageNeedTrackModel *,NSIndexPath *,id) = (void *)imp;
        func(cell, selector,model,indexPath,self);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WBPayManageNeedTrackModel *model = self.needTrackListArray[indexPath.row];
    WBPayManageFastOfferViewController *vc = [WBPayManageFastOfferViewController new];
    vc.dataModel = model;
    vc.canEdit = !model.status.integerValue;
    [self.navigationController pushViewController:vc animated:YES];

}

//MARK: - setter / getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, WBPayManageScreenHeight - KNavBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.tableFooterView = [UIView new];
        __weak typeof(self) weakself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.pageCount = 1;
            [weakself requestNeedTrackList];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakself requestNeedTrackList];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)needTrackListArray {
    if (!_needTrackListArray) {
        _needTrackListArray = [NSMutableArray new];
    }
    return _needTrackListArray;
}

- (WBPayManageNeedTrackViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WBPayManageNeedTrackViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
