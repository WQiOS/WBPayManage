//
//  PaymentDetailDTO.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentDetailDTO : NSObject

@property (nonatomic, assign) NSInteger pricePerLift; //维保单价/台/年
@property (nonatomic, assign) NSInteger num; //数量
@property (nonatomic, assign) NSInteger priceSum; //合计，总额

@end
