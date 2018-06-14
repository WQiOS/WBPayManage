//
//  AssessTotalDTO.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/6.
//

#import <Foundation/Foundation.h>
//评估结果

@class Assess;
@interface AssessTotalDTO : NSObject <YYModel>

@property (nonatomic, copy) NSString *orderNo;                  //订单号
@property (nonatomic, copy) NSString *address;                  //详细地址
@property (nonatomic, copy) NSString *maintTypeName;            //维保种类名称
@property (nonatomic, copy) NSString *total;                    //维小保总价
@property (nonatomic, strong) NSArray<Assess *> *assesses;      //评估结果子项
@property (nonatomic, assign) int totalNum;

@end

//评估结果子项

@interface Assess : NSObject

@property (nonatomic, copy) NSString *avgPrice;                 //平均价格
@property (nonatomic, assign) NSInteger num;                    //电梯数量
@property (nonatomic, copy) NSString *sum;                      //合计

@end
