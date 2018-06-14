//
//  WBPayManageNeedTrackModel.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/5.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

//MARK: - 需求追踪

#import <Foundation/Foundation.h>

@interface WBPayManageNeedTrackModel : NSObject

@property (nonatomic, assign) NSInteger requireId;   //需求单id
@property (nonatomic, assign) NSInteger feedbackId;//反馈单id
@property (nonatomic, copy) NSString *propertyComName;    //物业公司
@property (nonatomic, copy) NSString *chargePeople; //物业人员/联系人
@property (nonatomic, copy) NSString *phone;//电话
@property (nonatomic, copy) NSString *plotName;//小区名字
@property (nonatomic, copy) NSString *plotAddress; //小区地址
@property (nonatomic, copy) NSString *liftTypeName;  //电梯类型名称
@property (nonatomic, assign) NSInteger num;  //数量
@property (nonatomic, copy) NSString *maintTypeName;  //维保类型
@property (nonatomic, copy) NSString *period;  //服务期限
@property (nonatomic, copy) NSString *status;  //状态 见3.3需求单状态编码
@property (nonatomic, copy) NSString *createTime;  //yyyy-MM-dd HH:mm:ss
@property (nonatomic, assign) NSInteger pricePerTime; //单次价格
@property (nonatomic, assign) NSInteger pricePerLift; //单台价格
@property (nonatomic, assign) NSInteger priceSum; //总额
@property (nonatomic, copy) NSString *startTime; //开始时间

@end
