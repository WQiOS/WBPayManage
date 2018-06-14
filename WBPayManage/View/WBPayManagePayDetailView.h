//
//  WBPayManagePayDetailView.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/8.
//

#import <UIKit/UIKit.h>

@protocol WBPayManagePayDetailViewDelegate <NSObject>

-(void)WBPayManagePayDetailViewDidClickConfirmButton;

@end

@interface WBPayManagePayDetailView : UIView

@property (nonatomic, weak) id<WBPayManagePayDetailViewDelegate> delegate;

@end
