//
//  WBPayManageNeedTrackViewModel.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/5.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageNeedTrackViewModel.h"
#import "WBPayManageNeedTrackModel.h"

@interface WBPayManageNeedTrackViewModel ()

@property (nonatomic, copy) NeedTrackRequestSucess needTrackBlock;
@property (nonatomic, copy) RequestFailure errorBlock;
@property (nonatomic, copy) CancelOfferRequestSucess cancelSucess;

@end

@implementation WBPayManageNeedTrackViewModel

//MARK: - 需求追踪列表
- (void)requestNeedTrackListWithComId:(NSInteger)comId index:(NSInteger)index size:(NSInteger)size block:(NeedTrackRequestSucess)block error:(RequestFailure)error {
    WEAKSELF;
    self.needTrackBlock = block;
    self.errorBlock = error;
    WBHttpAPI *api = [WBHttpAPI requestDemandTraceWithComId:comId index:index size:size];
    api.success(^(id obj){
        NSDictionary *dataDic = [(NSDictionary *)obj dictionaryForKey:@"data"];
        NSArray *dataArray = [dataDic arrayForKey:@"list"];
        NSArray *needTrackListArray = [NSArray yy_modelArrayWithClass:WBPayManageNeedTrackModel.class json:dataArray];
        if (weakself.needTrackBlock) {
            weakself.needTrackBlock(needTrackListArray);
        }
    }).fail(^(HttpError *error){
        if (weakself.errorBlock) {
            weakself.errorBlock(error.message);
        }
    });
    [api sendRequest];
}

//MARK: - 快速报价
- (void)requestDemandTraceWithRequireId:(NSInteger)requireId feedbackId:(NSInteger)feedbackId pricePerLift:(NSInteger)pricePerLift pricePerTime:(NSInteger)pricePerTime priceSum:(NSInteger)priceSum startTime:(NSString *)startTime sucessBlock:(CancelOfferRequestSucess)sucessBlock error:(RequestFailure)error {
    WEAKSELF;
    self.cancelSucess = sucessBlock;
    self.errorBlock = error;
    WBHttpAPI *api = [WBHttpAPI requestDemandTraceWithRequireId:requireId feedbackId:feedbackId pricePerLift:pricePerLift pricePerTime:pricePerTime priceSum:priceSum startTime:startTime];
    api.success(^(id obj){
        NSString *code = [(NSDictionary *)obj stringForKey:@"code"];
        if (weakself.cancelSucess && code.integerValue == 200) {
            weakself.cancelSucess(YES);
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

//MARK: - 取消报价
- (void)didClickCancelOffer:(NSInteger)feedbackId sucessBlock:(CancelOfferRequestSucess)sucessBlock error:(RequestFailure)error {
    WEAKSELF;
    self.cancelSucess = sucessBlock;
    self.errorBlock = error;
    WBHttpAPI *api = [WBHttpAPI didClickCancelOffer:feedbackId];
    api.success(^(id obj){
        NSString *code = [(NSDictionary *)obj stringForKey:@"code"];
        if (weakself.cancelSucess && code.integerValue == 200) {
            weakself.cancelSucess(YES);
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

//MARK: - 删除获反馈单
- (void)requestDeleteFeedbackWithFeedbackId:(NSInteger)feedbackId sucessBlock:(CancelOfferRequestSucess)sucessBlock error:(RequestFailure)error {
    WEAKSELF;
    self.cancelSucess = sucessBlock;
    self.errorBlock = error;
    WBHttpAPI *api = [WBHttpAPI requestDeleteFeedbackWithFeedbackId:feedbackId];
    api.success(^(id obj){
        NSString *code = [(NSDictionary *)obj stringForKey:@"code"];
        if (weakself.cancelSucess && code.integerValue == 200) {
            weakself.cancelSucess(YES);
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

@end
