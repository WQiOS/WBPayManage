//
//  WBPayManageAccountInfoModel.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/5.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//MARK: - 账户信息
@interface WBPayManageAccountInfoModel : NSObject

@property (nonatomic, assign) NSInteger accountId; //主键
@property (nonatomic, copy) NSString *accountNo;   //账户
@property (nonatomic, assign) NSInteger unitId;    //单位ID
@property (nonatomic, assign) double totalSubsidyAmount; //应补助总金额
@property (nonatomic, copy) NSString *accountLevel; //账号级别（1-总账号，2-分账号）
@property (nonatomic, assign) double actualSubsidyAmount; //已补助总金额
@property (nonatomic, assign) double principalAmount; //入金总额
@property (nonatomic, copy) NSString *accountType; //账号类别（1-维保，2-物业,3-平台）
@property (nonatomic, copy) NSString *unitName;    //单位名称
@property (nonatomic, copy) NSString *plotId;      //小区ID
@property (nonatomic, assign) double totalBalance;//总余额
@property (nonatomic, assign) double principalBalance; //入金余额
@property (nonatomic, copy) NSString *plotName;     //小区名称

@end

//MARK: - 分页对象
@class TradeInfoDto;
@interface WBPayManageYuEListModel : NSObject

@property (nonatomic, strong) NSArray<TradeInfoDto *> *list; //工单列表
@property (nonatomic, assign) NSInteger index; //第几页
@property (nonatomic, assign) NSInteger size;  //每页大小
@property (nonatomic, assign) NSInteger total; //总页数

@end

//MARK: - 工单对象
@interface TradeInfoDto : NSObject

@property (nonatomic, assign) NSInteger tradeId;//主键
@property (nonatomic, copy) NSString *payNo;    //流水号
@property (nonatomic, copy) NSString *orderNo;  //工单号
@property (nonatomic, assign) double payAmount;//交易金额
@property (nonatomic, copy) NSString *payTypeName; //交易类型名称
@property (nonatomic, copy) NSString *payType; //交易类型  1：充值 2：体现 3：冲销 4：支付 5：补助
@property (nonatomic, copy) NSString *typeName;  //维保类型
@property (nonatomic, copy) NSString *createTime;//交易时间
@property (nonatomic, assign) double currentBalance;//余额

@end
