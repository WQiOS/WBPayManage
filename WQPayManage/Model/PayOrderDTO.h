//
//  PayOrderDTO.h
//  YunTi-Weibao
//
//  Created by 杨天宇 on 2018/3/2.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayOrderDTO : NSObject

@property (nonatomic, assign) NSInteger orderId;//支付主键
@property (nonatomic, assign) NSInteger userCode;//用户账号
@property (nonatomic, strong) NSString *userName;//用户名称
@property (nonatomic, strong) NSString *orderNo;//订单号
@property (nonatomic, strong) NSString *totalMoney;//总金额
@property (nonatomic, assign) NSInteger maintClass;//维保种类
@property (nonatomic, strong) NSString *maintClassName;//维保种类名称
@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, assign) NSInteger payMoney;//支付金额
@property (nonatomic, strong) NSString *payOrder;//支付订单号
@property (nonatomic, assign) NSInteger payType;//支付方式
@property (nonatomic, strong) NSString *payTypeName;//支付方式
@property (nonatomic, strong) NSString *payTime;//支付时间
@property (nonatomic, assign) NSInteger serviceTime;//服务年限
@property (nonatomic, assign) NSInteger status;//状态 1:未支付 2：已支付
@property (nonatomic, strong) NSString *statusName;//状态名称
@property (nonatomic, strong) NSString *createTime;//下单时间
@property (nonatomic, strong) NSString *remark;//备注

@end
