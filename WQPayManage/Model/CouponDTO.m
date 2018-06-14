//
//  CouponDTO.m
//  YunTi-Weibao
//
//  Created by 杨天宇 on 2018/3/14.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "CouponDTO.h"

@implementation CouponDTO

-(BOOL)isActive
{
    NSDate *activeDate = [[[NSDateFormatter shared] defaultFormatter] dateFromString:self.activeTime];
    if([activeDate isLaterThanDate:[NSDate date]])
    {
        return YES;
    }else
    {
        return NO;
    }
}

@end
