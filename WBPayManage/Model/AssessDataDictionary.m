//
//  AssessDataDictionary.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/7.
//

#import "AssessDataDictionary.h"

@interface AssessDataDictionary ()

@property (nonatomic, strong) NSDictionary *nameDic;//因为dictItemName返回的是json,再做一次解析

@end

@implementation AssessDataDictionary

-(NSDictionary *)nameDic
{
    if(!_nameDic)
    {
        NSData *jsonData = [self.dictItemName dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *err;
        
        _nameDic = [NSJSONSerialization JSONObjectWithData:jsonData  options:NSJSONReadingMutableContainers error:&err];
    }
    return _nameDic;
}

-(NSString *)assessName
{
    return [self.nameDic objectForKey:@"name"];
}

-(NSString *)assessWeight
{
    return [self.nameDic objectForKey:@"weight"];
}

@end
