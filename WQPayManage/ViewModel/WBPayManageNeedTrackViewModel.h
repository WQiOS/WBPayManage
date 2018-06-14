//
//  WBPayManageNeedTrackViewModel.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/5.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

//MARK: - 需求追踪

#import <Foundation/Foundation.h>
@class WBPayManageNeedTrackModel;

typedef void (^RequestFailure)(NSString *errorMessage);
typedef void (^NeedTrackRequestSucess)(NSArray<WBPayManageNeedTrackModel *> *array);
typedef void (^CancelOfferRequestSucess)(BOOL sucess);

@interface WBPayManageNeedTrackViewModel : NSObject

//MARK: - 需求追踪列表
- (void)requestNeedTrackListWithComId:(NSInteger)comId index:(NSInteger)index size:(NSInteger)size block:(NeedTrackRequestSucess)block error:(RequestFailure)error;

/**
 @brief 快速报价

 @param requireId      需求单Id
 @param feedbackId     反馈单id
 @param pricePerLift   维保单价/台/年
 @param pricePerTime   单次价格
 @param priceSum       总额
 @param startTime      开始时间
 @param sucessBlock    成功回调
 @param error          失败回调

 */
- (void)requestDemandTraceWithRequireId:(NSInteger)requireId feedbackId:(NSInteger)feedbackId pricePerLift:(NSInteger)pricePerLift pricePerTime:(NSInteger)pricePerTime priceSum:(NSInteger)priceSum startTime:(NSString *)startTime sucessBlock:(CancelOfferRequestSucess)sucessBlock error:(RequestFailure)error;

//MARK: - 取消报价
- (void)didClickCancelOffer:(NSInteger)index sucessBlock:(CancelOfferRequestSucess)sucessBlock error:(RequestFailure)error;

//MARK: - 删除获反馈单
- (void)requestDeleteFeedbackWithFeedbackId:(NSInteger)feedbackId sucessBlock:(CancelOfferRequestSucess)sucessBlock error:(RequestFailure)error;

@end
