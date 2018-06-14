//
//  WBPayManageEstimateViewController.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/6.
//

#import "WBPayManageEstimateViewController.h"
#import "WBPayManageViewModel.h"
#import "WBPayManageEstimatePriceViewController.h"
#import <Masonry/Masonry.h>
#import "LiftSceneDTO.h"
#import "WBPayManageEstimateView.h"
#import "AssessDataDictionary.h"

@interface WBPayManageEstimateViewController () <WBPayManageEstimateViewDelegate,WBPayManageViewModelDelegate>

@property (nonatomic, strong) WBPayManageEstimateView *basicView;
@property (nonatomic, strong) WBPayManageViewModel *viewModel;
@property (nonatomic, assign) NSInteger selectRow;

@end

@implementation WBPayManageEstimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
    if(self.dtoInfo)
    {
        self.basicView.currentLiftSceneDTO = self.dtoInfo;
        [self.basicView setUnenableChangeInfo];
    }else{
        LiftSceneDTO *saveDTO = [LiftSceneDTO getSaveLiftSceneDTO];
        if(saveDTO)
        {
            self.basicView.currentLiftSceneDTO = saveDTO;
        }
        NSArray *liftSceneArray = [LiftSceneDTO getSaveLiftSceneDTOArray];
        if(liftSceneArray.count)
        {
            [self.basicView.selectLiftSceneDTOList addObjectsFromArray:liftSceneArray];
            [self.basicView reloadInfoTableViewData];
        }
    }
}

-(void)navigationBarBackButtonAction
{
    [self.basicView.currentLiftSceneDTO saveLiftSceneDTO];
    if(self.basicView.selectLiftSceneDTOList.count)
    {
        [LiftSceneDTO saveLiftSceneDTOArray:self.basicView.selectLiftSceneDTOList];
    }
    [super navigationBarBackButtonAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"电梯场景信息";
    
    [self.view addSubview:self.basicView];
    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(WBPayManageEstimateView *)basicView
{
    if(!_basicView)
    {
        _basicView = [[WBPayManageEstimateView alloc]init];
        _basicView.delegate = self;
        _basicView.currentLiftSceneDTO = [[LiftSceneDTO alloc]init];
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

-(BOOL)checkDTOInfoIsFull
{
    if(![self.basicView.currentLiftSceneDTO.WBPayManageEstimateViewType_archiContent isEqualToString:@"请选择"] && ![self.basicView.currentLiftSceneDTO.WBPayManageEstimateViewType_floorContent isEqualToString:@"请选择"] && ![self.basicView.currentLiftSceneDTO.WBPayManageEstimateViewType_brandContent isEqualToString:@"请选择"] && ![self.basicView.currentLiftSceneDTO.WBPayManageEstimateViewType_serviceContent isEqualToString:@"请选择"] && ![self.basicView.currentLiftSceneDTO.WBPayManageEstimateViewType_capacityContent isEqualToString:@"请选择"] && ![self.basicView.currentLiftSceneDTO.WBPayManageEstimateViewType_speedContent isEqualToString:@"请选择"] && ![self.basicView.currentLiftSceneDTO.WBPayManageEstimateViewType_liftNumContent isEqualToString:@"请选择"])
    {
        return YES;
    }else
    {
        return NO;
    }
}

//MARK: - delegate

-(void)WBPayManageEstimateViewDidClickEstimateButton
{
    if(self.basicView.selectLiftSceneDTOList.count)
    {
        WBPayManageEstimatePriceViewController *estimatePriceVC = [[WBPayManageEstimatePriceViewController alloc]init];
        estimatePriceVC.selectLiftSceneDTOList = self.basicView.selectLiftSceneDTOList;
        [self.navigationController pushViewController:estimatePriceVC animated:YES];
    }else
    {
        [[[ZLProgressHUD shared] showText:@"请选择至少一个电梯场景" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }
}

-(void)WBPayManageEstimateViewDidClickAddSceneButton
{
    if([self checkDTOInfoIsFull])
    {
        self.basicView.currentLiftSceneDTO.address = self.address;
        self.basicView.currentLiftSceneDTO.cityCode = self.cityCode;
        self.basicView.currentLiftSceneDTO.adname = self.adName;
        BOOL haveSame = NO;
        for(LiftSceneDTO *sceneDTO in self.basicView.selectLiftSceneDTOList)
        {
            if([sceneDTO.archiTypeNo isEqualToString:self.basicView.currentLiftSceneDTO.archiTypeNo] &&  sceneDTO.floorNum == self.basicView.currentLiftSceneDTO.floorNum && [sceneDTO.liftBrandNo isEqualToString:self.basicView.currentLiftSceneDTO.liftBrandNo] && [sceneDTO.serviceLifeNo isEqualToString:self.basicView.currentLiftSceneDTO.serviceLifeNo] && [sceneDTO.capacityNo isEqualToString:self.basicView.currentLiftSceneDTO.capacityNo] && [sceneDTO.speedNo isEqualToString:self.basicView.currentLiftSceneDTO.speedNo])
            {
                haveSame = YES;
                sceneDTO.num = sceneDTO.num + self.basicView.currentLiftSceneDTO.num;
                break;
            }
        }
        if(!haveSame)
        {
           [self.basicView.selectLiftSceneDTOList addObject:self.basicView.currentLiftSceneDTO.mutableCopy];
        }
        [self.basicView reloadInfoTableViewData];        
    }else
    {
        [[[ZLProgressHUD shared] showText:@"请完善当前的电梯场景" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }
}

-(void)WBPayManageEstimateViewTableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectRow = indexPath.row;
    
    NSArray *selectionArray = indexPath.row == 6 ? self.viewModel.liftNumArray : [self.viewModel getShowArrayWithIndex:indexPath.row];
    if(selectionArray.count)
    {
        self.basicView.assesInfoList = selectionArray;
    }else
    {
        [[ZLProgressHUD shared] showText:nil mode:MBProgressHUDModeIndeterminate];
        [self.viewModel requestDataDictionaryWithIndex:indexPath.row];
    }
}

-(void)WBPayManageEstimateViewTableViewDidAssesInfoRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectRow == 6)
    {
        self.basicView.currentLiftSceneDTO.num = [self.viewModel.liftNumArray[indexPath.row] integerValue];
    }
    switch (self.selectRow) {
        case 0:
        {
            AssessDataDictionary *assess = self.viewModel.archiArray[indexPath.row];
            self.basicView.currentLiftSceneDTO.archiTypeName = assess.assessName;
            self.basicView.currentLiftSceneDTO.archiTypeNo = assess.dictItemCode;
            self.basicView.currentLiftSceneDTO.archiTypeWt = [assess.assessWeight doubleValue];
        }
            break;
        case 1:
        {
            AssessDataDictionary *assess = self.viewModel.floorArray[indexPath.row];
            self.basicView.currentLiftSceneDTO.floorNum = assess.assessName.integerValue;
        }
            break;
        case 2:
        {
            AssessDataDictionary *assess = self.viewModel.brandArray[indexPath.row];
            self.basicView.currentLiftSceneDTO.liftBrandName = assess.assessName;
            self.basicView.currentLiftSceneDTO.liftBrandNo = assess.dictItemCode;
            self.basicView.currentLiftSceneDTO.liftBrandWt = [assess.assessWeight doubleValue];
        }
            break;
        case 3:
        {
            AssessDataDictionary *assess = self.viewModel.serviceArray[indexPath.row];
            self.basicView.currentLiftSceneDTO.serviceLife = assess.assessName.integerValue;
            self.basicView.currentLiftSceneDTO.serviceLifeNo = assess.dictItemCode;
            self.basicView.currentLiftSceneDTO.serviceLifeWt = [assess.assessWeight doubleValue];
        }
            break;
        case 4:
        {
            AssessDataDictionary *assess = self.viewModel.capacityArray[indexPath.row];
            self.basicView.currentLiftSceneDTO.capacity = assess.assessName;
            self.basicView.currentLiftSceneDTO.capacityNo = assess.dictItemCode;
            self.basicView.currentLiftSceneDTO.capacityPrice = [assess.assessWeight doubleValue];

        }
            break;
        case 5:
        {
            AssessDataDictionary *assess = self.viewModel.speedArray[indexPath.row];
            self.basicView.currentLiftSceneDTO.speed = assess.assessName;
            self.basicView.currentLiftSceneDTO.speedNo = assess.dictItemCode;
            self.basicView.currentLiftSceneDTO.speedWt = [assess.assessWeight doubleValue];
        }
            break;
        default:
            break;
    }
    [self.basicView reloadSelectTableViewCellWithIndexRow:self.selectRow];
}

-(void)WBPayManageViewModelLoadDataDictionarySuccess
{
    NSArray *selectionArray = [self.viewModel getShowArrayWithIndex:self.selectRow];
    if(selectionArray.count)
    {
        [[ZLProgressHUD shared] hide:YES];
        self.basicView.assesInfoList = selectionArray;
    }else
    {
        [[[ZLProgressHUD shared] showText:@"获取详情失败，请重新尝试" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }
}

-(void)WBPayManageViewModelLoadDataDictionaryFailed:(NSObject *)error
{
    HttpError *theError = (HttpError *)error;
    [[[ZLProgressHUD shared] showText:theError.message mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
}

@end
