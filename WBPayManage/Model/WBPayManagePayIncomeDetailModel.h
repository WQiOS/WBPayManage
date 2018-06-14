//
//  WBPayManagePayIncomeDetailModel.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/5.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

//MARK: - 收支详情

#import <Foundation/Foundation.h>

@interface WBPayManagePayIncomeDetailModel : NSObject

@property (nonatomic, copy) NSString *payNo;   //流水号
@property (nonatomic, assign) double payAmount;//交易金额
@property (nonatomic, copy) NSString *payType;    //交易类型1-充值，2-提现，3-冲销，4-支付
@property (nonatomic, copy) NSString *payTypeName; //交易类型名称
@property (nonatomic, copy) NSString *createTime;//交易时间
@property (nonatomic, assign) double currentBalance;//余额
@property (nonatomic, copy) NSString *payTarget; //支付对象
@property (nonatomic, copy) NSString *plotName;  //所在小区
@property (nonatomic, copy) NSString *liftName;  //电梯名称
@property (nonatomic, copy) NSString *registerCode;  //注册编码
@property (nonatomic, copy) NSString *typeCodeName;  //维保类型
@property (nonatomic, copy) NSString *maintDate;  //维保日期

@end
