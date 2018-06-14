//
//  WBPayManageYuEViewModel.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/1.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageYuEViewModel.h"
#import "WBHttpAPI.h"
#import "WBPayManageAccountInfoModel.h"
#import "WBPayManagePayIncomeDetailModel.h"

@interface WBPayManageYuEViewModel ()

@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) WBHttpAPI *estimateApi;
@property (nonatomic, copy) YuElistRequestSucessList listBlock;
@property (nonatomic, copy) TradeDetailRequestSucess detailBlock;
@property (nonatomic, copy) RequestFailure errorBlock;

@end
@implementation WBPayManageYuEViewModel

- (void)requestYuElistWithPlotId:(NSInteger)plotId index:(NSInteger)index size:(NSInteger)size block:(YuElistRequestSucessList)block error:(RequestFailure)error {
    WEAKSELF;
    self.listBlock = block;
    self.errorBlock = error;
    WBHttpAPI *api = [WBHttpAPI requestYuElistWithPlotId:plotId index:index size:size];
    api.success(^(id obj){
        NSDictionary *dataDic = [(NSDictionary *)obj dictionaryForKey:@"data"];
        NSDictionary *pager = [dataDic dictionaryForKey:@"pager"];
        NSDictionary *accountInfo = [dataDic dictionaryForKey:@"accountInfo"];
        WBPayManageAccountInfoModel *accountInfoModel = [WBPayManageAccountInfoModel new];
        WBPayManageYuEListModel *yuEListModel = [WBPayManageYuEListModel new];

        if (accountInfo) {
            accountInfoModel = [WBPayManageAccountInfoModel yy_modelWithJSON:accountInfo];
        }
        if (pager) {
            yuEListModel = [WBPayManageYuEListModel yy_modelWithJSON:pager];
        }
        if (weakself.listBlock) {
            weakself.listBlock(accountInfoModel,yuEListModel);
        }
    }).fail(^(HttpError *error){
        if (weakself.errorBlock) {
            weakself.errorBlock(error.message);
        }
    });
    [api sendRequest];
}

- (void)requestTradeDetailWithTradeId:(NSInteger)tradeId block:(TradeDetailRequestSucess)block error:(RequestFailure)error {
    WEAKSELF;
    self.detailBlock = block;
    self.errorBlock = error;
    WBHttpAPI *api = [WBHttpAPI requestTradeDetailWithTradeId:tradeId];
    api.success(^(id obj){
        NSDictionary *dataDic = [(NSDictionary *)obj dictionaryForKey:@"data"];
        WBPayManagePayIncomeDetailModel *model = [WBPayManagePayIncomeDetailModel yy_modelWithJSON:dataDic];
        if (weakself.detailBlock) {
            weakself.detailBlock(model);
        }
    }).fail(^(HttpError *error){
        if (weakself.errorBlock) {
            weakself.errorBlock(error.message);
        }
    });
    [api sendRequest];
}

@end
