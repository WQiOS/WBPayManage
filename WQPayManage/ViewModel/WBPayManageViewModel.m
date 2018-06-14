//
//  WBPayManageViewModel.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/7.
//

#import "WBPayManageViewModel.h"
#import "AssessTotalDTO.h"
#import "AssessDataDictionary.h"
#import "PayOrderDTO.h"
#import "CouponDTO.h"
#import "PaymentDetailDTO.h"
#import "AppMaintInfoDTO.h"
#import "ServiceInfoDTO.h"
#import "PlatformAccountDTO.h"

@interface WBPayManageViewModel ()

@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) WBHttpAPI *estimateApi;
@property (nonatomic, copy) RequestFailure errorBlock;
@property (nonatomic, copy) OrderDetailRequestSucess orderDetailSucess;
@property (nonatomic, copy) PlatformAccountInformationSucess platformAccountInformationSucess;
@end

@implementation WBPayManageViewModel

- (void)requestDataDictionaryWithIndex:(NSInteger)row {
    WBHttpAPI *api = [WBHttpAPI requestDictListWithType:self.typeArray[row]];
    api.success(^(id obj){
        NSDictionary *dictionaries = [(NSDictionary *)obj dictionaryForKey:@"data"];
        NSArray *dicArray = [dictionaries arrayForKey:@"dictionaries"];
        [self configDataArray:dicArray andRowIndex:row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelLoadDataDictionarySuccess)]) {
            [self.delegate WBPayManageViewModelLoadDataDictionarySuccess];
        }
    }).fail(^(HttpError *error){
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelLoadDataDictionaryFailed:)]) {
            [self.delegate WBPayManageViewModelLoadDataDictionaryFailed:error];
        }
    });
    
    [api sendRequest];
}

- (void)requestEstimatePriceWithDicArray:(NSArray *)dicArray {
    self.estimateApi = [WBHttpAPI evaluateMaintenancePriceOfLifts:dicArray];
    self.estimateApi.success(^(id obj){
        NSDictionary *json = [(NSDictionary *)obj dictionaryForKey:@"data"];
        AssessTotalDTO *totalDTO = [AssessTotalDTO yy_modelWithJSON:json];
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelEstimatePriceSuccess:)]) {
            [self.delegate WBPayManageViewModelEstimatePriceSuccess:totalDTO];
        }
    }).fail(^(HttpError *error){
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelEstimatePriceFailed:)]) {
            [self.delegate WBPayManageViewModelEstimatePriceFailed:error];
        }
    });
    
    [self.estimateApi sendRequest];
}

- (void)requestSubmitOrderWithResult:(NSInteger)result withType:(NSInteger)type payOrder:(NSString *)payOrderNo ofOrder:(NSString *)orderNo {
    WBHttpAPI *api = [WBHttpAPI feedbackPayResult:result withType:type payOrder:payOrderNo ofOrder:orderNo];
    api.success(^(id obj){
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelSubmitOrderSuccess)]) {
            [self.delegate WBPayManageViewModelSubmitOrderSuccess];
        }
    }).fail(^(HttpError *error){
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelSubmitOrderFailed:)]) {
            [self.delegate WBPayManageViewModelSubmitOrderFailed:error];
        }
    });

    [api sendRequest];
}

- (void)requestGetSignPayInfoWithOrderNo:(NSString *)orderNo couponCode:(NSString *)couponCode {
    WBHttpAPI *api = [WBHttpAPI getSignPayInfoWithPayOrder:orderNo couponCode:couponCode];
    api.success(^(id obj){
        NSString *paySignInfo = [(NSDictionary *)obj objectForKey:@"data"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelGetSignPayInfoSuccess:)]) {
            [self.delegate WBPayManageViewModelGetSignPayInfoSuccess:paySignInfo];
        }
    }).fail(^(HttpError *error){
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelGetSignPayInfoFailed:)]) {
            [self.delegate WBPayManageViewModelGetSignPayInfoFailed:error];
        }
    });
    [api sendRequest];
}

- (void)requestGetPayOrderInfoWithOrderNo:(NSString *)orderNo {
    WBHttpAPI *api = [WBHttpAPI getPayOrderInfoWithOrderName:orderNo];
    api.success(^(id obj){
        NSDictionary *json = [(NSDictionary *)obj dictionaryForKey:@"data"];
        PayOrderDTO *payOrderInfo = [PayOrderDTO yy_modelWithJSON:json];
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelGetPayOrderInfoSuccess:)]) {
            [self.delegate WBPayManageViewModelGetPayOrderInfoSuccess:payOrderInfo];
        }
    }).fail(^(HttpError *error){
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelGetPayOrderInfoFailed:)]) {
            [self.delegate WBPayManageViewModelGetPayOrderInfoFailed:error];
        }
    });
    [api sendRequest];
}

- (void)requestGetCouponInfoWithCouponCode:(NSString *)couponCode {
    WBHttpAPI *api = [WBHttpAPI getCouponInfoWithCouponCode:couponCode];
    api.success(^(id obj){
        NSDictionary *json = [(NSDictionary *)obj dictionaryForKey:@"data"];
        CouponDTO *couponInfo = [CouponDTO yy_modelWithJSON:json];
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageviewModelGetCouponInfoSuccess:)]) {
            [self.delegate WBPayManageviewModelGetCouponInfoSuccess:couponInfo];
        }
    }).fail(^(HttpError *error){
        if (self.delegate && [self.delegate respondsToSelector:@selector(WBPayManageViewModelGetCouponInfoFailed:)]) {
            [self.delegate WBPayManageViewModelGetCouponInfoFailed:error];
        }
    });
    [api sendRequest];
}

- (void)cancleAllRequest {
    [self.estimateApi cancelRequest];
}

- (NSArray<NSString *> *)liftNumArray {
    if(!_liftNumArray)
    {
        NSMutableArray *temArray = [NSMutableArray array];
        for(int i=1;i<=150;i++)
        {
            [temArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _liftNumArray = temArray.copy;
    }
    return _liftNumArray;
}

- (NSArray *)typeArray {
    if(!_typeArray)
    {
        _typeArray = @[@"HJZSQZ",@"CZJGQZ",@"PPZSQZ",@"NXZSQZ",@"ZZJGQZ",@"SDZSQZ"];
    }
    return _typeArray;
}

- (void)configDataArray:(NSArray *)dataArray andRowIndex:(NSInteger)row {
    NSArray *dataDicArray = [NSArray yy_modelArrayWithClass:AssessDataDictionary.class json:dataArray];
    switch (row) {
        case 0:
        {
            self.archiArray = dataDicArray.copy;
        }
            break;
        case 1:
        {
            self.floorArray = dataDicArray.copy;
        }
            break;
        case 2:
        {
            self.brandArray = dataDicArray.copy;
        }
            break;
        case 3:
        {
            self.serviceArray = dataDicArray.copy;
        }
            break;
        case 4:
        {
            self.capacityArray = dataDicArray.copy;
        }
            break;
        case 5:
        {
            self.speedArray = dataDicArray.copy;
        }
            break;
        default:
            break;
    }
}

- (NSArray *)getShowArrayWithIndex:(NSInteger)row {
    NSMutableArray *temArray = [NSMutableArray array];
    switch (row) {
        case 0:
        {
            for(AssessDataDictionary *assess in self.archiArray)
            {
                [temArray addObject:assess.assessName];
            }
        }
            break;
        case 1:
        {
            for(AssessDataDictionary *assess in self.floorArray)
            {
                [temArray addObject:assess.assessName];
            }
        }
            break;
        case 2:
        {
            for(AssessDataDictionary *assess in self.brandArray)
            {
                [temArray addObject:assess.assessName];
            }
        }
            break;
        case 3:
        {
            for(AssessDataDictionary *assess in self.serviceArray)
            {
                [temArray addObject:assess.assessName];
            }
        }
            break;
        case 4:
        {
            for(AssessDataDictionary *assess in self.capacityArray)
            {
                [temArray addObject:assess.assessName];
            }
        }
            break;
        case 5:
        {
            for(AssessDataDictionary *assess in self.speedArray)
            {
                [temArray addObject:assess.assessName];
            }
        }
            break;
        default:
            break;
    }
    return temArray.copy;
}


//MARK: - 获取订单详情
- (void)requestOrderDetailWithFeedbackId:(NSInteger)feedbackId sucess:(OrderDetailRequestSucess)sucess error:(RequestFailure)error {
    WEAKSELF;
    self.orderDetailSucess = sucess;
    self.errorBlock = error;
    WBHttpAPI *api = [WBHttpAPI requestOrderDetailWithFeedbackId:feedbackId];
    api.success(^(id obj){
        NSDictionary *dataDic = [(NSDictionary *)obj dictionaryForKey:@"data"];
        PaymentDetailDTO *detailModel = [PaymentDetailDTO yy_modelWithJSON:[dataDic dictionaryForKey:@"paymentDetail"]];
        AppMaintInfoDTO *mainInfo = [AppMaintInfoDTO yy_modelWithJSON:[dataDic dictionaryForKey:@"maintenanceInfo"]];
        ServiceInfoDTO *serviceInfo = [ServiceInfoDTO yy_modelWithJSON:[dataDic dictionaryForKey:@"serviceInfo"]];
        NSString *agreementUrl = [dataDic stringForKey:@"agreementUrl"];
        NSString *code = [(NSDictionary *)obj stringForKey:@"code"];
        if (weakself.orderDetailSucess && code.integerValue == 200) {
           weakself.orderDetailSucess(detailModel,mainInfo,serviceInfo,agreementUrl);
        }else if (weakself.errorBlock) {
            weakself.errorBlock([(NSDictionary *)obj stringForKey:@"message"]);
        }
    }).fail(^(HttpError *error){
        if (weakself.errorBlock) {
            weakself.errorBlock(error.message);
        }
    });
    [api sendRequest];
}

//MARK: - 更新订单状态
- (void)updateStateWithFeedbackId:(NSInteger)feedbackId status:(NSString *)status sucess:(OrderDetailRequestSucess)sucess error:(RequestFailure)error {
    WEAKSELF;
    self.orderDetailSucess = sucess;
    self.errorBlock = error;
    WBHttpAPI *api = [WBHttpAPI updateStateWithFeedbackId:feedbackId status:status];
    api.success(^(id obj){
        NSDictionary *dataDic = [(NSDictionary *)obj dictionaryForKey:@"data"];
        PaymentDetailDTO *detailModel = [PaymentDetailDTO yy_modelWithJSON:[dataDic dictionaryForKey:@"paymentDetail"]];
        AppMaintInfoDTO *mainInfo = [AppMaintInfoDTO yy_modelWithJSON:[dataDic dictionaryForKey:@"maintenanceInfo"]];
        ServiceInfoDTO *serviceInfo = [ServiceInfoDTO yy_modelWithJSON:[dataDic dictionaryForKey:@"serviceInfo"]];
        NSString *agreementUrl = [dataDic stringForKey:@"agreementUrl"];
        NSString *code = [(NSDictionary *)obj stringForKey:@"code"];
        if (weakself.orderDetailSucess && code.integerValue == 200) {
            weakself.orderDetailSucess(detailModel,mainInfo,serviceInfo,agreementUrl);
        }else if (weakself.errorBlock) {
            weakself.errorBlock([(NSDictionary *)obj stringForKey:@"message"]);
        }
    }).fail(^(HttpError *error){
        if (weakself.errorBlock) {
            weakself.errorBlock(error.message);
        }
    });
    [api sendRequest];
}

//MARK: - 获取平台账户信息
- (void)getPlatformAccountInformationSucess:(PlatformAccountInformationSucess)sucess error:(RequestFailure)error {
    WEAKSELF;
    self.platformAccountInformationSucess = sucess;
    self.errorBlock = error;
    WBHttpAPI *api = [WBHttpAPI getPlatformAccountInformation];
    api.success(^(id obj){
        NSDictionary *dataDic = [(NSDictionary *)obj dictionaryForKey:@"data"];
        PlatformAccountDTO *detailModel = [PlatformAccountDTO yy_modelWithJSON:dataDic];
        if (weakself.platformAccountInformationSucess) {
            weakself.platformAccountInformationSucess(detailModel);
        }
    }).fail(^(HttpError *error){
        if (weakself.errorBlock) {
            weakself.errorBlock(error.message);
        }
    });
    [api sendRequest];
}


@end
