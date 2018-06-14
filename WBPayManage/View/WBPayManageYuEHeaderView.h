//
//  WBPayManageYuEHeaderView.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/5/31.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPayManageYuEHeaderView : UIView

@property (nonatomic, copy) NSString *yueNumberString;

//MARK: - 开始动画
- (void)startAnimation;
//MARK: - 结束动画
- (void)cancelAnimation;

@end
