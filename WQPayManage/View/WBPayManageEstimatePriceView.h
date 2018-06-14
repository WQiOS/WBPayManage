//
//  WBPayManageEstimatePriceView.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/7.
//

#import <UIKit/UIKit.h>

@protocol WBPayManageEstimatePriceViewDelegate <NSObject>

-(void)WBPayManageEstimatePriceViewDidClickCancelButton;

@end

@interface WBPayManageEstimatePriceView : UIView

@property (nonatomic, weak) id<WBPayManageEstimatePriceViewDelegate> delegate;

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *estimatePriceTipLabel;
@property (nonatomic, strong) UIButton *cancleButton;

@end
