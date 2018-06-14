//
//  WBPayManageEstimateView.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/6.
//

#import <UIKit/UIKit.h>
#import "LiftSceneDTO.h"

@protocol WBPayManageEstimateViewDelegate <NSObject>

-(void)WBPayManageEstimateViewTableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)WBPayManageEstimateViewDidClickEstimateButton;
-(void)WBPayManageEstimateViewDidClickAddSceneButton;
-(void)WBPayManageEstimateViewTableViewDidAssesInfoRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WBPayManageEstimateView : UIView

@property (nonatomic, weak) id<WBPayManageEstimateViewDelegate> delegate;
@property (nonatomic, strong)NSMutableArray<LiftSceneDTO *> *selectLiftSceneDTOList;
@property (nonatomic, strong)LiftSceneDTO *currentLiftSceneDTO;
@property (nonatomic, strong) NSArray *assesInfoList;

-(void)reloadSelectTableViewCellWithIndexRow:(NSInteger)row;
-(void)reloadInfoTableViewData;
-(void)setUnenableChangeInfo;

@end

@interface WBPayManageEstimateViewSelectCell: UITableViewCell

- (void)configData:(id<WBPayManageEstimateViewType>)data WithIndexRow:(NSInteger)row canEdit:(BOOL)canEdit;

@end

@interface WBPayManageEstimateViewSelectFooterView: UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *addAssesButton;
@property (nonatomic, strong) UIImageView *addAssesImageView;
@property (nonatomic, strong) UILabel *addAssesTitle;
@property (nonatomic, strong) UILabel *remarkLabel;

@end

@interface WBPayManageEstimateViewInfoCell: UITableViewCell

@property (nonatomic, strong) UIButton *deleteButton;
- (void)configData:(id<WBPayManageEstimateViewType>)data withIndexPath:(NSIndexPath *)index;

@end

@interface WBPayManageEstimateViewAssesInfoCell: UITableViewCell

- (void)configData:(NSString *)infoName;

@end

