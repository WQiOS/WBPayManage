//
//  WBPayManageAccountInfoModel.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/5.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageAccountInfoModel.h"

@implementation WBPayManageAccountInfoModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"tradeId": @"id",
             };
}
@end

@implementation WBPayManageYuEListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list": [TradeInfoDto class],
             };
}
@end

@implementation TradeInfoDto

@end
