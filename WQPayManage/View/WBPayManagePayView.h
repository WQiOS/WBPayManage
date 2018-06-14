//
//  WBPayManagePayView.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/8.
//

#import <UIKit/UIKit.h>

@protocol WBPayManagePayViewDelegate <NSObject>

-(void)WBPayManagePayViewDidClickPayButton;

@end

@interface WBPayManagePayView : UIView

@property (nonatomic, weak) id<WBPayManagePayViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectPayType;//1代表支付宝2代表微信
@property (nonatomic, copy) NSString *totalPrice;

@end

@interface WBPayManagePayViewCell: UITableViewCell

- (void)configDataWithIndexRow:(NSInteger)row andPayType:(int)type;

@end
