//
//  WBPayManageOrderDetailViewController.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

//MARK: - 订单详情，立即支付

#import <ZLUIKit/ZLUIKit.h>
#import "WBMineOrderBaseView.h"
@interface WBPayManageOrderDetailViewController : ZLBaseViewController

@property (nonatomic, assign) NSInteger requireId;
@property (nonatomic, assign) NSInteger feedbackId; //反馈单id
@property (nonatomic, assign) WBOrderInfo_Status orderStatus; //是否需要立即支付

@end
