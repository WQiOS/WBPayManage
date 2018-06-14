//
//  WBPayManageFastOfferTableViewCell.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/6.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

//MARK: - 快速报价

#import <UIKit/UIKit.h>

@protocol WBPayManageFastOfferClick <NSObject>

/**
 当维保单价和单次维保价格都填写了，才计算总价

 @param pricePerLift  维保单价
 @param pricePerTime  单次维保价格
 */
-(void)hasFinishFillIn:(NSInteger)pricePerLift pricePerTime:(NSInteger)pricePerTime;

@end

@interface WBPayManageFastOfferTableViewCell : UITableViewCell

@end
