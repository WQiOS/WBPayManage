//
//  WBPayManageEstimateViewController.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/6.
//

#import <UIKit/UIKit.h>
#import "WBPayManageEstimateView.h"
@class LiftSceneDTO;

@interface WBPayManageEstimateViewController : ZLBaseViewController

@property (nonatomic, strong) LiftSceneDTO *dtoInfo;//订单详情点进来的 只能看不能操作
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *adName;

@end
