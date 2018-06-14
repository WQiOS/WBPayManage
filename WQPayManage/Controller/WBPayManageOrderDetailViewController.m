//
//  WBPayManageOrderDetailViewController.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageOrderDetailViewController.h"
#import "WBPayManageOrderDetailTableViewCell.h"
#import "WBPaymanagePayNowViewController.h"
#import "WBHtml5ViewController.h"
#import "WBPayManageViewModel.h"
#import "PaymentDetailDTO.h"
#import "AppMaintInfoDTO.h"
#import "ServiceInfoDTO.h"
#import "UIButton+Category.h"

@interface WBPayManageOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WBPayManageViewModel *viewModel;
@property (nonatomic, strong) PaymentDetailDTO *paymentDetailModel;
@property (nonatomic, strong) AppMaintInfoDTO *mainInfo;
@property (nonatomic, strong) ServiceInfoDTO *serviceInfo;
@property (nonatomic, copy) NSString *agreementUrl;
@property (nonatomic, strong) UIButton *payNowButton,*agreeButton,*readButton;
@property (nonatomic, strong) UILabel *moneyLabel,*readLabel;
@property (nonatomic, assign) BOOL hasAgree; //是否已同意
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation WBPayManageOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"订单详情";
    [self.view addSubview:self.tableView];
    if (self.orderStatus == 200) {
        [self.view addSubview:self.moneyLabel];
        [self.view addSubview:self.payNowButton];
    }
    //请求数据
    [self requestYuEList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    if (self.orderStatus == 200) {
        UIButton *rightNaviBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
        [rightNaviBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [rightNaviBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:137/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];
        rightNaviBtn.titleLabel.font = [UIFont regularPingFangFontOfSize:16];
        [rightNaviBtn addTarget:self action:@selector(naviBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNaviBtn];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.orderStatus == 200) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//MARK: - 取消订单
- (void)naviBtnClicked {
    [self presentViewController:self.alertController animated:YES completion:nil];
}

//MARK: - 取消订单成功之后
- (void)changeOrderSuccessFunction {
    [[NSNotificationCenter defaultCenter] postNotificationName:AppDidInquireWeibaoSuccess object:[NSString stringWithFormat:@"%d",(int)self.requireId]];
     [[NSNotificationCenter defaultCenter] postNotificationName:AppDidOrderStatusChangeSuccess object:nil];
    [self navigationBarBackButtonAction];
}

//MARK: - 请求收支详情
- (void)requestYuEList {
    WEAKSELF;
    [self.viewModel requestOrderDetailWithFeedbackId:self.feedbackId sucess:^(PaymentDetailDTO *detailModel, AppMaintInfoDTO *mainInfo, ServiceInfoDTO *serviceInfo, NSString *agreementUrl) {
        weakself.paymentDetailModel = detailModel;
        weakself.mainInfo = mainInfo;
        weakself.serviceInfo = serviceInfo;
        weakself.agreementUrl = agreementUrl;
        if (weakself.orderStatus == 200) {
            weakself.moneyLabel.text = [NSString stringWithFormat:@"￥ %@",[[NSString stringWithFormat:@"%ld",detailModel.priceSum] moneyNumberHandle]];
        }
        [weakself.tableView reloadData];
    } error:^(NSString *errorMessage) {
        [[[ZLProgressHUD shared] showText:errorMessage mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }];
}

//MARK: - payNowButtonAction
- (void)payNowButtonAction {
    if (!self.hasAgree) {
        [[[ZLProgressHUD shared] showText:@"请遵守服务协议" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }else{
        WBPaymanagePayNowViewController *vc = [WBPaymanagePayNowViewController new];
        vc.payMoney = self.paymentDetailModel.priceSum;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//MARK: - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.paymentDetailModel) return 0;
    if (self.orderStatus < 100) return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.paymentDetailModel) return 0;
    if (!section && self.orderStatus >= 100) {
        return 4;
    }
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section && self.orderStatus >= 100) {
        return 50;
    }else if ((indexPath.section && !indexPath.row && self.orderStatus >= 100) || (!indexPath.row && self.orderStatus < 100)){
        return 100;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WBPayManageOrderDetailTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(identifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([cell respondsToSelector:NSSelectorFromString(@"bindCellModel:mainInfo:serviceInfo:indexPath:hasPayDetail:")]) {
        SEL selector = NSSelectorFromString(@"bindCellModel:mainInfo:serviceInfo:indexPath:hasPayDetail:");
        IMP imp = [cell methodForSelector:selector];
        void (*func)(id, SEL,PaymentDetailDTO*,AppMaintInfoDTO*,ServiceInfoDTO*,NSIndexPath *,BOOL) = (void *)imp;
        func(cell, selector,self.paymentDetailModel,self.mainInfo,self.serviceInfo,indexPath,self.orderStatus >= 100);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!section) return 10;
    if (self.orderStatus == 200 || self.orderStatus == 300) return 80;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        return view;
    }else if (self.orderStatus == 200 || self.orderStatus == 300){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        CGFloat maxY;
        if (self.orderStatus == 200) {
            maxY = 95;
            //添加我已同意的点击按钮
            [view addSubview:self.agreeButton];
        }else{
            maxY = 35;
            [view addSubview:self.readLabel];
        }
        //添加我已同意的点击按钮
        self.readButton.frame = CGRectMake(maxY, 20, 150, 20);
        [view addSubview:self.readButton];
        return view;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

//MARK: - setter / getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, WBPayManageScreenHeight - KNavBarHeight - (self.orderStatus == 200 ? 40 : 0)) style:UITableViewStyleGrouped];
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
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
    }
    return _tableView;
}

- (WBPayManageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WBPayManageViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)payNowButton {
    if (!_payNowButton) {
        _payNowButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _payNowButton.frame = CGRectMake(SCREEN_WIDTH/2, WBPayManageScreenHeight - KNavBarHeight - 40, SCREEN_WIDTH/2, 40);
        [_payNowButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payNowButton setBackgroundColor:[UIColor colorWithRed:76/255.0 green:217/255.0 blue:100/255.0 alpha:1]];
        _payNowButton.titleLabel.font = [UIFont regularPingFangFontOfSize:14];
        [_payNowButton addTarget:self action:@selector(payNowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payNowButton;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.frame = CGRectMake(0, WBPayManageScreenHeight - KNavBarHeight - 40, SCREEN_WIDTH/2, 40);
        _moneyLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _moneyLabel.backgroundColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:81/255.0 alpha:1];
        _moneyLabel.font = [UIFont regularPingFangFontOfSize:14];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeButton.frame = CGRectMake(20, 20, 80, 20);
        WEAKSELF;
        [_agreeButton addBlock:^(id obj) {
            weakself.hasAgree = !weakself.hasAgree;
            if (!weakself.hasAgree) {
                [weakself.agreeButton setImage:[UIImage imageNamed:@"wbpm_orderdetail_nocheck"] forState:UIControlStateNormal];
            }else{
                [weakself.agreeButton setImage:[UIImage imageNamed:@"wbpm_orderdetail_normalcheck"] forState:UIControlStateNormal];
            }
        } for:UIControlEventTouchUpInside];
        _agreeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 60);
        _agreeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _agreeButton.titleLabel.font = [UIFont regularPingFangFontOfSize:12];
        [_agreeButton setTitle:@"我已同意" forState:UIControlStateNormal];
        [_agreeButton setImage:[UIImage imageNamed:@"wbpm_orderdetail_nocheck"] forState:UIControlStateNormal];
        [_agreeButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    }
    return _agreeButton;
}

- (UIButton *)readButton {
    if (!_readButton) {
        _readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        WEAKSELF;
        [_readButton addBlock:^(id obj) {
            if (weakself.agreementUrl && weakself.agreementUrl.length) {
                WBHtml5ViewController *vc = [WBHtml5ViewController new];
                vc.titleStr = @"维小保三方服务协议";
                vc.urlStr = weakself.agreementUrl;
                [weakself presentViewController:vc animated:YES completion:nil];
            }
        } for:UIControlEventTouchUpInside];
        [_readButton setTitle:@"《维小保三方服务协议》" forState:UIControlStateNormal];
        [_readButton setTitleColor:[UIColor colorWithRed:35/255.0 green:137/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];
        _readButton.titleLabel.font = [UIFont regularPingFangFontOfSize:12];
        _readButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _readButton;
}

- (UILabel *)readLabel {
    if (!_readLabel) {
        _readLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 20)];
        _readLabel.text = @"查看";
        _readLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _readLabel.font = [UIFont regularPingFangFontOfSize:12];
        _readLabel.textAlignment = NSTextAlignmentLeft;
        _readLabel.backgroundColor = [UIColor whiteColor];
    }
    return _readLabel;
}

- (UIAlertController *)alertController {
    if(!_alertController) {
        WEAKSELF;
        _alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消当前选择的订单么？" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"确 定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[ZLProgressHUD shared] showText:nil mode:MBProgressHUDModeIndeterminate];
            [weakself.viewModel updateStateWithFeedbackId:weakself.feedbackId status:@"400" sucess:^(PaymentDetailDTO *detailModel, AppMaintInfoDTO *mainInfo, ServiceInfoDTO *serviceInfo, NSString *agreementUrl) {
                [[[ZLProgressHUD shared] showText:@"已为您成功取消该订单" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
                [weakself performSelector:@selector(changeOrderSuccessFunction) withObject:nil afterDelay:1.5];
            } error:^(NSString *errorMessage) {
                [[[ZLProgressHUD shared] showText:errorMessage mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:nil];
        [cancelAction setValue:ColorFromRGB(0xFF3B30, 1.0) forKey:@"titleTextColor"];
        
        [_alertController addAction:editAction];
        [_alertController addAction:cancelAction];
    }
    return _alertController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
