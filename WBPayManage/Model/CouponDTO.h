//
//  CouponDTO.h
//  YunTi-Weibao
//
//  Created by 杨天宇 on 2018/3/14.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponDTO : NSObject

@property (nonatomic, assign) NSInteger id;//优惠券主键
@property (nonatomic, copy) NSString *couponCode;//优惠券码
@property (nonatomic, assign) NSInteger type;//优惠类型 1打折 2减免
@property (nonatomic, assign) double rate;//优惠度
@property (nonatomic, copy) NSString *activeTime;//有效时间
@property (nonatomic, assign) NSInteger status;//状态 1：未使用 2：已使用
@property (nonatomic, copy) NSString *statusName;//状态名称
@property (nonatomic, copy) NSString *remark;//备注

@property (nonatomic, assign) BOOL isActive;//优惠券主键

@end
