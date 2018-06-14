//
//  PlatformAccountDTO.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlatformAccountDTO : NSObject

@property (nonatomic, copy) NSString *depositName; //开户名称
@property (nonatomic, copy) NSString *depositBank; //开户银行
@property (nonatomic, copy) NSString *bankAccount; //银行账号
@property (nonatomic, assign) NSInteger payMoney; //支付金额

@end
