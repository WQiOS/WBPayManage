//
//  WBPayManagePayIncomeDetailViewController.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/4.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManagePayIncomeDetailViewController.h"
#import "WBPayManageYuEViewModel.h"
#import "WBPayManagePayIncomeDetailModel.h"

@interface WBPayManagePayIncomeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WBPayManageYuEViewModel *yuEViewModel;
@property (nonatomic, strong) WBPayManagePayIncomeDetailModel *viewModel;

@end

@implementation WBPayManagePayIncomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"收支详情";
    [self.view addSubview:self.tableView];

    //请求数据
    [self requestYuEList];
}

//MARK: - 请求收支详情
- (void)requestYuEList {
    WEAKSELF;
    [self.yuEViewModel requestTradeDetailWithTradeId:self.tradeId block:^(WBPayManagePayIncomeDetailModel *model) {
        weakself.viewModel = model;
        [weakself.tableView reloadData];
    }error:^(NSString *errorMessage) {
        [[[ZLProgressHUD shared] showText:errorMessage mode:MBProgressHUDModeText] hide:YES afterDelay:1.5] ;
    }];
}

//MARK: - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.viewModel.createTime) return 0;
    if (!self.viewModel.typeCodeName) return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.viewModel.createTime) return 0;
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WBPayManagePayIncomeDetailTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(identifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([cell respondsToSelector:NSSelectorFromString(@"bindCellModel:indexPath:")]) {
        SEL selector = NSSelectorFromString(@"bindCellModel:indexPath:");
        IMP imp = [cell methodForSelector:selector];
        void (*func)(id, SEL,WBPayManagePayIncomeDetailModel*,NSIndexPath *) = (void *)imp;
        func(cell, selector,self.viewModel,indexPath);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!section) {
        return 10;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

//MARK: - setter / getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, WBPayManageScreenHeight - KNavBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 20, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.tableHeaderView = [UIView new];
    }
    return _tableView;
}

- (WBPayManageYuEViewModel *)yuEViewModel {
    if (!_yuEViewModel) {
        _yuEViewModel = [[WBPayManageYuEViewModel alloc] init];
    }
    return _yuEViewModel;
}

@end
