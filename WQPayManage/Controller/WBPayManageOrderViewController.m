//
//  WBPayManageOrderViewController.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/8.
//

#import "WBPayManageOrderViewController.h"
#import "WBPayManageOrderView.h"
#import "WBPayManageEstimateViewController.h"
#import "WBPayManagePayViewController.h"
#import "WBPayManageViewModel.h"

@interface WBPayManageOrderViewController ()<WBPayManageOrderViewDelegate,WBPayManageViewModelDelegate,ZLQRCodeScannerControllerDelegate>

@property (nonatomic, strong) WBPayManageOrderView *basicView;
@property (nonatomic, strong) WBPayManageViewModel *viewModel;

@end

@implementation WBPayManageOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.basicView setCouponTextFieldHidden];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"订单详情";
    
    [self.view addSubview:self.basicView];
    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(WBPayManageOrderView *)basicView
{
    if(!_basicView)
    {
        _basicView = [[WBPayManageOrderView alloc]init];
        _basicView.delegate = self;
        _basicView.selectLiftSceneDTOList = self.selectLiftSceneDTOList;
        _basicView.isShowDetail = self.isShowDetail;
        _basicView.totalDTO = self.totalDTO;
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

-(void)WBPayManageOrderViewDidClickFunctionButton:(NSInteger)buttonTag
{
    switch (buttonTag) {
        case 0:
        {
            [self.basicView setCouponTextFieldHidden];
            
            ZLQRScannerController *qrScanner = [[ZLQRScannerController alloc]init];
            qrScanner.title = @"优惠券扫码";
            qrScanner.delegate = self;
            [self.navigationController pushViewController:qrScanner animated:YES];
        }
            break;
        case 1:
        {
            [AppUtil call:@"4001081833"];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            NSString *realPrice;
            if(self.basicView.chooseCoupon.type == 1)
            {
                realPrice = [NSString stringWithFormat:@"%d",(int)(self.totalDTO.total.integerValue*self.basicView.chooseCoupon.rate)];
            }else{
                realPrice = [NSString stringWithFormat:@"%d",(int)(self.totalDTO.total.integerValue-self.basicView.chooseCoupon.rate)];
            }
            
            WBPayManagePayViewController *payVC = [[WBPayManagePayViewController alloc] init];
            payVC.orderNo = self.totalDTO.orderNo;
            payVC.totalPrice = realPrice;
            payVC.couponCode = self.basicView.chooseCoupon.couponCode;
            [self.navigationController pushViewController:payVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)WBPayManageOrderViewDidChooseLiftSceneAtIndexRow:(NSInteger)row
{
    LiftSceneDTO *scene = self.selectLiftSceneDTOList[row];
    WBPayManageEstimateViewController *estimateVC = [[WBPayManageEstimateViewController alloc]init];
    estimateVC.dtoInfo = scene;
    [self.navigationController pushViewController:estimateVC animated:YES];
}

-(void)WBPayManageOrderViewGetCouponCode:(NSString *)couponCode
{
    [[ZLProgressHUD shared] showText:@"获取优惠券信息中" mode:MBProgressHUDModeIndeterminate];
    [self.viewModel requestGetCouponInfoWithCouponCode:couponCode];
}

-(void)WBPayManageOrderViewSeeOrderDetail
{
    WBPayManageOrderViewController *orderVC = [[WBPayManageOrderViewController alloc]init];
    orderVC.selectLiftSceneDTOList = self.selectLiftSceneDTOList;
    orderVC.totalDTO = self.totalDTO;
    orderVC.isShowDetail = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

-(void)QRCodeScannerController:(ZLQRScannerController *)controller didGetCodeValue:(NSString *)value
{
    [controller.navigationController popViewControllerAnimated:YES];
    if(![NSString isEmpty:value])
    {
        [self.basicView setCouponCode:value];
        [[ZLProgressHUD shared] showText:@"获取优惠券信息中" mode:MBProgressHUDModeIndeterminate];
        [self.viewModel requestGetCouponInfoWithCouponCode:value];
    }else{
        [[[ZLProgressHUD shared] showText:@"二维码信息有误" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }
}

-(void)WBPayManageviewModelGetCouponInfoSuccess:(CouponDTO *)couponInfo
{
    if(couponInfo.status == 2)
    {
        [[[ZLProgressHUD shared] showText:@"该优惠券已使用" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
        self.basicView.chooseCoupon = nil;
    }else if(couponInfo.status == 1)
    {
        if(couponInfo.isActive)
        {
            if(couponInfo.type == 2 && couponInfo.rate >= self.totalDTO.total.floatValue)
            {
                [[[ZLProgressHUD shared] showText:@"当前的优惠券不适用于当前订单" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
                self.basicView.chooseCoupon = nil;
            }else{
                [[ZLProgressHUD shared] hide:YES];
                self.basicView.chooseCoupon = couponInfo;
            }
        }else
        {
            [[[ZLProgressHUD shared] showText:@"该优惠券已过期" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
            self.basicView.chooseCoupon = nil;
        }
    }else
    {
        [[[ZLProgressHUD shared] showText:@"请输入正确的优惠券信息" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
        self.basicView.chooseCoupon = nil;
    }
}

-(void)WBPayManageViewModelGetCouponInfoFailed:(NSObject *)error
{
    HttpError *theError = (HttpError *)error;
    [[[ZLProgressHUD shared] showText:theError.message mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
}

@end
