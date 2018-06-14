//
//  WBPayManagePayViewController.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/8.
//

#import "WBPayManagePayViewController.h"
#import "WBPayManagePayView.h"
#import "WBPayManagePayDetailViewController.h"
#import "WBPayManageViewModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import <Masonry/Masonry.h>
#import "PayOrderDTO.h"
@interface WBPayManagePayViewController ()<WBPayManagePayViewDelegate,WBPayManageViewModelDelegate>

@property (nonatomic, strong) WBPayManagePayView *basicView;
@property (nonatomic, strong) WBPayManageViewModel *viewModel;

@end

@implementation WBPayManagePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.titleLabel.text = @"选择支付方式";
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithARGB:0xFF2389E8];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithARGB:0xFF2389E8];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithARGB:0xFFFAFAFA];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AppDidReceivePayResult object:nil];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidReceivePayResultNotification:) name:AppDidReceivePayResult object:nil];
    
    self.view = self.basicView;
    
    self.basicView.totalPrice = self.totalPrice;
}

-(WBPayManagePayView *)basicView
{
    if(!_basicView)
    {
        _basicView = [[WBPayManagePayView alloc]init];
        _basicView.delegate = self;
    }
    return _basicView;
}

-(WBPayManageViewModel *)viewModel
{
    if(!_viewModel)
    {
        _viewModel = [[WBPayManageViewModel alloc]init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

-(void)WBPayManagePayViewDidClickPayButton
{
    [[[ZLProgressHUD shared] showText:@"支付功能暂未开放，请联系客服" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    
//    [[ZLProgressHUD shared] showText:nil mode:MBProgressHUDModeIndeterminate];
//    [self.viewModel requestGetSignPayInfoWithOrderNo:self.orderNo couponCode:self.couponCode];
}

-(void)appDidReceivePayResultNotification:(NSNotification *)noti
{
    NSDictionary *resultAll = noti.userInfo;
    
    int resultStatus = [[resultAll objectForKey:@"resultStatus"] intValue];
    if(resultStatus == 9000)
    {
        NSString *jsonStr = [resultAll objectForKey:@"result"];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData  options:NSJSONReadingMutableContainers error:&err];
        NSDictionary *tradeAppPayDic = [resultDic objectForKey:@"alipay_trade_app_pay_response"];
        
        [self.viewModel requestSubmitOrderWithResult:1 withType:self.basicView.selectPayType payOrder:[tradeAppPayDic objectForKey:@"trade_no"] ofOrder:self.orderNo];
        
        WBPayManagePayDetailViewController *payDetailVC = [[WBPayManagePayDetailViewController alloc]init];
        payDetailVC.orderPayNo = [tradeAppPayDic objectForKey:@"trade_no"];
        payDetailVC.orderNo = self.orderNo;
        [self.navigationController pushViewController:payDetailVC animated:YES];
    }else
    {
        [[ZLProgressHUD shared] showText:nil mode:MBProgressHUDModeIndeterminate];
        [self.viewModel requestGetPayOrderInfoWithOrderNo:self.orderNo];
    }
}

//MARK: - delegate

-(void)WBPayManageViewModelGetSignPayInfoSuccess:(NSString *)signPayInfo
{
    [[ZLProgressHUD shared] hide:YES];
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:signPayInfo fromScheme:@"yuntiWeiBao" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:AppDidReceivePayResult object:nil userInfo:resultDic];
    }];
}

-(void)WBPayManageViewModelGetSignPayInfoFailed:(NSObject *)error
{
    HttpError *theError = (HttpError *)error;
    [[[ZLProgressHUD shared] showText:theError.message mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
}

-(void)WBPayManageViewModelGetPayOrderInfoSuccess:(PayOrderDTO *)payOrderInfo {
    if(payOrderInfo.status == 2)
    {
        [[[ZLProgressHUD shared] showText:@"该订单已支付" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
        
        [self.viewModel requestSubmitOrderWithResult:1 withType:self.basicView.selectPayType payOrder:payOrderInfo.payOrder ofOrder:self.orderNo];
        
        WBPayManagePayDetailViewController *payDetailVC = [[WBPayManagePayDetailViewController alloc]init];
        payDetailVC.orderPayNo = payOrderInfo.payOrder;
        payDetailVC.orderNo = self.orderNo;
        [self.navigationController pushViewController:payDetailVC animated:YES];
    }else
    {
        [[[ZLProgressHUD shared] showText:@"支付失败，请重新尝试" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }
}

-(void)WBPayManageViewModelGetPayOrderInfoFailed:(NSObject *)error
{
    [[[ZLProgressHUD shared] showText:@"支付失败，请重新尝试" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
}

@end
