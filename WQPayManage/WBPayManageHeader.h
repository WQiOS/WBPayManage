//
//  WBPayManageHeader.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/6.
//

#ifndef WBPayManageHeader_h
#define WBPayManageHeader_h

#define AppDidReceivePayResult @"AppDidReceivePayResult"

#define WBPayManageScreenWidth  [UIScreen mainScreen].bounds.size.width
#define WBPayManageScreenHeight [UIScreen mainScreen].bounds.size.height

#define ColorFromRGB(rgbValue,alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define kRGBColor(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

//weakself
#define WEAKSELF __weak typeof(self) weakself = self

// 导航栏的最大Y
#define KIphoneXSafeArea 34.0
#define kOnlyNavBarHeight 44.0

//MARK: - 屏幕高度、宽度
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//MARK: - 适配刘海儿
#define KNavgiationBarHeight CGRectGetHeight(self.navigationController.navigationBar.frame)
#define kTabBarHeight (iPhoneX ? 83.0 : 49.0)
#define KNavBarHeight (iPhoneX ? 88.0 : 64.0)

//MARK: - 判断iphoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)

#endif /* WBPayManageHeader_h */
