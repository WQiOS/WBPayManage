//
//  WBPayManageOrderView.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/7.
//

#import <UIKit/UIKit.h>
#import "LiftSceneDTO.h"
#import "AssessTotalDTO.h"
#import "CouponDTO.h"

@protocol WBPayManageOrderViewDelegate <NSObject>

@optional

-(void)WBPayManageOrderViewDidChooseLiftSceneAtIndexRow:(NSInteger)row;
-(void)WBPayManageOrderViewSeeOrderDetail;
-(void)WBPayManageOrderViewDidClickFunctionButton:(NSInteger)buttonTag;
-(void)WBPayManageOrderViewGetCouponCode:(NSString *)couponCode;

@end

@interface WBPayManageOrderView : UIView

@property (nonatomic, weak) id<WBPayManageOrderViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<LiftSceneDTO *> *selectLiftSceneDTOList;
@property (nonatomic, strong) AssessTotalDTO *totalDTO;
@property (nonatomic, strong) CouponDTO *chooseCoupon;
@property (nonatomic, assign) BOOL isShowDetail;
-(void)setCouponTextFieldHidden;
-(void)setCouponCode:(NSString *)couponCode;

@end

@interface WBPayManageOrderViewCell: UITableViewCell

- (void)configDataWithIndexRow:(NSInteger)row totalDTO:(AssessTotalDTO *)totalDTO andCouponInfo:(CouponDTO *)couponInfo isShowDetail:(BOOL)isShowDetail;

@end

@interface WBPayManageOrderViewCellHeaderView: UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@protocol WBPayManageOrderViewCellFooterViewDelegate <NSObject>

-(void)WBPayManageOrderViewCellFooterViewDidClickFunctionBtn:(UIButton *)button;

@end

@interface WBPayManageOrderViewCellFooterView: UITableViewHeaderFooterView

@property (nonatomic, weak) id<WBPayManageOrderViewCellFooterViewDelegate> delegate;

@property (nonatomic, strong) UITextField *couponTextField;

@end
