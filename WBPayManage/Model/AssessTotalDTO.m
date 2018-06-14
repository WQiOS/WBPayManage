//
//  AssessTotalDTO.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/6.
//

#import "AssessTotalDTO.h"

@implementation AssessTotalDTO

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"assesses":[Assess class]};
}

-(int)totalNum
{
    int allElevatorNum = 0;
    for(Assess *oneAssess in self.assesses)
    {
        allElevatorNum = allElevatorNum + (int)oneAssess.num;
    }
    return allElevatorNum;
}

@end

@implementation Assess

@end
