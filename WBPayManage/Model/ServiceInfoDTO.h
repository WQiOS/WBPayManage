//
//  ServiceInfoDTO.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceInfoDTO : NSObject

@property (nonatomic, copy) NSString *plotName; //小区名字
@property (nonatomic, copy) NSString *plotAddress; //小区地址
@property (nonatomic, copy) NSString *liftTypeName; //电梯类型名称
@property (nonatomic, assign) NSInteger num; //数量
@property (nonatomic, copy) NSString *maintTypeName; //维保类型
@property (nonatomic, copy) NSString *period;    //服务期限

@end
