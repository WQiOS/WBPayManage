//
//  WBPayManageNeedTrackTableViewCell.h
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/4.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBPayManageNeedTrackClick <NSObject>

//MARK: - 去反馈
-(void)goToFeedback:(NSInteger)index;
//MARK: - 取消报价
-(void)didClickCancelOffer:(NSInteger)index;
//MARK: - 去执行服务
-(void)toDoServices:(NSInteger)index;
//MARK: - 删除需求
-(void)deleteNeed:(NSInteger)index;

@end

@interface WBPayManageNeedTrackTableViewCell : UITableViewCell

@end
