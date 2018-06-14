//
//  WBPayManageEstimatePriceViewController.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/7.
//

#import "WBPayManageEstimatePriceViewController.h"
#import "WBPayManageEstimatePriceView.h"
#import "WBPayManageOrderViewController.h"
#import "WBPayManageViewModel.h"
#import <Masonry/Masonry.h>

@interface WBPayManageEstimatePriceViewController ()<WBPayManageViewModelDelegate,WBPayManageEstimatePriceViewDelegate>

@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) WBPayManageEstimatePriceView *basicView;
@property (nonatomic, strong) WBPayManageViewModel *viewModel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AssessTotalDTO *successData;

@end

@implementation WBPayManageEstimatePriceViewController

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
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"评估服务价格";
    
    [self.view addSubview:self.basicView];
    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.basicView.progressView setProgress:0 animated:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

-(void)getEstimatePrice
{
    NSMutableArray *dicArray = [NSMutableArray array];
    for(LiftSceneDTO *scene in self.selectLiftSceneDTOList)
    {
        NSDictionary *assessDic = [NSJSONSerialization JSONObjectWithData:scene.yy_modelToJSONData options:kNilOptions error:NULL];
        [dicArray addObject:assessDic];
    }
    [self.viewModel requestEstimatePriceWithDicArray:dicArray.copy];
}

-(WBPayManageEstimatePriceView *)basicView
{
    if(!_basicView)
    {
        _basicView = [[WBPayManageEstimatePriceView alloc]init];
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

- (void)updateProgress
{
    self.progress += 0.2f;
    [self.basicView.progressView setProgress:self.progress animated:YES];
    
    if (self.progress > 1.0f) {
        [self.timer invalidate];
        [self getEstimatePrice];
    }
}

-(void)WBPayManageViewModelEstimatePriceSuccess:(AssessTotalDTO *)data
{
    [[ZLProgressHUD shared]hide:YES];
    
    self.successData = data;
    self.basicView.estimatePriceTipLabel.text = @"评估已完成";
    [self.basicView.cancleButton setTitle:@"查看评估详情" forState:UIControlStateNormal];
    
    [LiftSceneDTO clearSaveLiftScene];
    WBPayManageOrderViewController *orderVC = [[WBPayManageOrderViewController alloc]init];
    orderVC.selectLiftSceneDTOList = self.selectLiftSceneDTOList;
    orderVC.totalDTO = data;
    [self.navigationController pushViewController:orderVC animated:YES];
}

-(void)WBPayManageViewModelEstimatePriceFailed:(NSObject *)error
{
    [self.timer invalidate];
    [[[ZLProgressHUD shared] showText:@"评估价格失败，请重新尝试" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    [self performSelector:@selector(navigationBarBackButtonAction) withObject:nil afterDelay:1.5f];
}

-(void)WBPayManageEstimatePriceViewDidClickCancelButton
{
    if(self.successData)
    {
        WBPayManageOrderViewController *orderVC = [[WBPayManageOrderViewController alloc]init];
        orderVC.selectLiftSceneDTOList = self.selectLiftSceneDTOList;
        orderVC.totalDTO = self.successData;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else
    {
        [self navigationBarBackButtonAction];
    }
}

@end
