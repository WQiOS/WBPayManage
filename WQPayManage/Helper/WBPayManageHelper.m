//
//  WBPayManageHelper.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/8.
//

#import "WBPayManageHelper.h"

@implementation WBPayManageHelper

+(NSString *)getShowPrice:(NSString *)price
{
    float priceTotal = price.floatValue;
    return [NSString stringWithFormat:@"￥%.2f",priceTotal];
}



@end
