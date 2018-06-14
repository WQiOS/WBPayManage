//
//  WBPayManageFastOfferViewController.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/5.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

//MARK: - 快速报价

#import <ZLUIKit/ZLUIKit.h>
@class WBPayManageNeedTrackModel;

@interface WBPayManageFastOfferViewController : ZLBaseViewController

@property (nonatomic, strong) WBPayManageNeedTrackModel *dataModel;
@property (nonatomic, assign) BOOL canEdit; //是否可以编辑（默认不允许编辑）
@property (nonatomic, copy) void(^DemandTraceSucess)(BOOL isSucess);

@end
