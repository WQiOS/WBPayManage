//
//  WBPayManageFastOfferDatePickerView.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/6.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPayManageFastOfferDatePickerView : UIView

//MARK: - 初始化
- (instancetype)initWithFrame:(CGRect)frame clickSure:(void(^)(NSString *string))clickSure clickCancel:(void(^)(void))clickCancel;

//MARK: - 开始动画
- (void)startAnimationDatePickerView;

@end
