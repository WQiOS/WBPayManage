//
//  WBPayManageYuEViewModel.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/1.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

//MARK: - 余额

#import <Foundation/Foundation.h>
@class WBPayManageAccountInfoModel;
@class WBPayManageYuEListModel;
@class WBPayManagePayIncomeDetailModel;

typedef void (^YuElistRequestSucessList)(WBPayManageAccountInfoModel *model,WBPayManageYuEListModel *list);
typedef void (^TradeDetailRequestSucess)(WBPayManagePayIncomeDetailModel *model);
typedef void (^RequestFailure)(NSString *errorMessage);

@interface WBPayManageYuEViewModel : NSObject

//MARK: - 余额列表
- (void)requestYuElistWithPlotId:(NSInteger)plotId index:(NSInteger)index size:(NSInteger)size block:(YuElistRequestSucessList)block error:(RequestFailure)error;

//MARK: - 收支详情
- (void)requestTradeDetailWithTradeId:(NSInteger)tradeId block:(TradeDetailRequestSucess)block error:(RequestFailure)error;

@end
