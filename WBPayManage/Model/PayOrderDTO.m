//
//  PayOrderDTO.m
//  YunTi-Weibao
//
//  Created by 杨天宇 on 2018/3/2.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "PayOrderDTO.h"

@implementation PayOrderDTO

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"orderId": @"id",
             };
}

@end
