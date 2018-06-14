//
//  WBPayManageOrderViewController.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/8.
//

#import <UIKit/UIKit.h>

#import "LiftSceneDTO.h"
#import "AssessTotalDTO.h"

@interface WBPayManageOrderViewController : ZLBaseViewController

@property (nonatomic, strong)NSMutableArray<LiftSceneDTO *> *selectLiftSceneDTOList;
@property (nonatomic, strong) AssessTotalDTO *totalDTO;
@property (nonatomic, assign) BOOL isShowDetail;

@end
