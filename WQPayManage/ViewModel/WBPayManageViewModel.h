//
//  WBPayManageViewModel.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/7.
//

#import <Foundation/Foundation.h>
@class AssessTotalDTO;
@class AssessDataDictionary;
@class PayOrderDTO;
@class CouponDTO;
@class PaymentDetailDTO;
@class AppMaintInfoDTO;
@class ServiceInfoDTO;
@class PlatformAccountDTO;

@protocol WBPayManageViewModelDelegate<NSObject>

@optional
- (void)WBPayManageViewModelLoadDataDictionarySuccess;
- (void)WBPayManageViewModelLoadDataDictionaryFailed:(NSObject *)error;
- (void)WBPayManageViewModelEstimatePriceSuccess:(AssessTotalDTO *)data;
- (void)WBPayManageViewModelEstimatePriceFailed:(NSObject *)error;
- (void)WBPayManageViewModelSubmitOrderSuccess;
- (void)WBPayManageViewModelSubmitOrderFailed:(NSObject *)error;
- (void)WBPayManageViewModelGetSignPayInfoSuccess:(NSString *)signPayInfo;
- (void)WBPayManageViewModelGetSignPayInfoFailed:(NSObject *)error;
- (void)WBPayManageViewModelGetPayOrderInfoSuccess:(PayOrderDTO *)payOrderInfo;
- (void)WBPayManageViewModelGetPayOrderInfoFailed:(NSObject *)error;
- (void)WBPayManageviewModelGetCouponInfoSuccess:(CouponDTO *)couponInfo;
- (void)WBPayManageViewModelGetCouponInfoFailed:(NSObject *)error;

@end

typedef void (^RequestFailure)(NSString *errorMessage);
typedef void (^OrderDetailRequestSucess)(PaymentDetailDTO *detailModel,AppMaintInfoDTO *mainInfo,ServiceInfoDTO *serviceInfo,NSString *agreementUrl);
typedef void (^PlatformAccountInformationSucess)(PlatformAccountDTO *infoModel);

@interface WBPayManageViewModel : NSObject

@property (nonatomic, weak) id<WBPayManageViewModelDelegate> delegate;
- (void)requestDataDictionaryWithIndex:(NSInteger)row;
- (void)requestEstimatePriceWithDicArray:(NSArray *)dicArray;
- (void)requestSubmitOrderWithResult:(NSInteger)result withType:(NSInteger)type payOrder:(NSString *)payOrderNo ofOrder:(NSString *)orderNo;
- (void)requestGetSignPayInfoWithOrderNo:(NSString *)orderNo couponCode:(NSString *)couponCode;
- (void)requestGetPayOrderInfoWithOrderNo:(NSString *)orderNo;
- (void)requestGetCouponInfoWithCouponCode:(NSString *)couponCode;

- (void)cancleAllRequest;

@property (nonatomic, strong) NSArray<NSString *> *liftNumArray;
@property (nonatomic, strong) NSArray<AssessDataDictionary *> *archiArray;
@property (nonatomic, strong) NSArray<AssessDataDictionary *> *speedArray;
@property (nonatomic, strong) NSArray<AssessDataDictionary *> *brandArray;
@property (nonatomic, strong) NSArray<AssessDataDictionary *> *floorArray;
@property (nonatomic, strong) NSArray<AssessDataDictionary *> *capacityArray;
@property (nonatomic, strong) NSArray<AssessDataDictionary *> *serviceArray;

-(NSArray *)getShowArrayWithIndex:(NSInteger)row;

//MARK: - 获取订单详情
- (void)requestOrderDetailWithFeedbackId:(NSInteger)feedbackId sucess:(OrderDetailRequestSucess)sucess error:(RequestFailure)error;

//MARK: - 更新订单状态
- (void)updateStateWithFeedbackId:(NSInteger)feedbackId status:(NSString *)status sucess:(OrderDetailRequestSucess)sucess error:(RequestFailure)error;

//MARK: - 获取平台账户信息
- (void)getPlatformAccountInformationSucess:(PlatformAccountInformationSucess)sucess error:(RequestFailure)error;

@end
