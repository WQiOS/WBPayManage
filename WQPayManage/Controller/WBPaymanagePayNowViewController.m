//
//  WBPaymanagePayNowViewController.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPaymanagePayNowViewController.h"
#import "WBPayManageViewModel.h"
#import "PlatformAccountDTO.h"
#import "WBPaymanagePayNowTableViewCell.h"
#import "UIButton+Category.h"
#import <WQRoundedCorner/WQRoundedCorner.h>

@interface WBPaymanagePayNowViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WBPayManageViewModel *viewModel;
@property (nonatomic, strong) PlatformAccountDTO *platformAccountDTO;

@end

@implementation WBPaymanagePayNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"支付账号";
    [self.view addSubview:self.tableView];

    //请求数据
    [self requestYuEList];
}

//MARK: - 获取平台账户信息
- (void)requestYuEList {
    WEAKSELF;
    [self.viewModel getPlatformAccountInformationSucess:^(PlatformAccountDTO *infoModel) {
        weakself.platformAccountDTO = infoModel;
        weakself.platformAccountDTO.payMoney = weakself.payMoney;
        [weakself.tableView reloadData];
    } error:^(NSString *errorMessage) {
        [[[ZLProgressHUD shared] showText:errorMessage mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }];
}

//MARK: - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.platformAccountDTO) return 0;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WBPaymanagePayNowTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(identifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([cell respondsToSelector:NSSelectorFromString(@"bindCellModel:indexPath:")]) {
        SEL selector = NSSelectorFromString(@"bindCellModel:indexPath:");
        IMP imp = [cell methodForSelector:selector];
        void (*func)(id, SEL,PlatformAccountDTO*,NSIndexPath *) = (void *)imp;
        func(cell, selector,self.platformAccountDTO,indexPath);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 10)];
    view0.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    [view addSubview:view0];

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(view0.frame) + 20, SCREEN_WIDTH - 40, 40)];
    contentLabel.text = @"*请将订单金额打入上诉指定账号，维小保会在24小时内确认收款后，并会反映在您的余额里";
    contentLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont regularPingFangFontOfSize:12];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:contentLabel];

    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont regularPingFangFontOfSize:18];
    sureButton.frame = CGRectMake(20, 160, SCREEN_WIDTH -40, 40);
    [sureButton setCornerRadius:4 backgroundColor:[UIColor colorWithRed:35/255.0 green:137/255.0 blue:232/255.0 alpha:1]];
    WEAKSELF;
    [sureButton addBlock:^(id obj) {
        [weakself.navigationController popViewControllerAnimated:YES];
    } for:UIControlEventTouchUpInside];
    [view addSubview:sureButton];

    return view;
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (WBPayManageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WBPayManageViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
