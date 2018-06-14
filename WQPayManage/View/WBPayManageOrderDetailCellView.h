//
//  WBPayManageOrderDetailCellView.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/7.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppMaintInfoDTO;

@interface WBPayManageOrderDetailCellView : UIView

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *serviceElevatorNumLabel;
@property (nonatomic, strong) UILabel *serviceYearLabel;
@property (nonatomic, strong) ZLStarRateView *starRateView;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) AppMaintInfoDTO *mainInfo;

@end
