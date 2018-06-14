//
//  LiftSceneDTO.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/6.
//

#import "LiftSceneDTO.h"




@implementation LiftSceneDTO

@synthesize orderNo;
@synthesize address;
@synthesize cityCode;
@synthesize adname;
@synthesize archiTypeName;
@synthesize archiTypeNo;
@synthesize archiTypeWt;
@synthesize floorNum;
@synthesize liftBrandName;
@synthesize liftBrandNo;
@synthesize liftBrandWt;
@synthesize serviceLife;
@synthesize serviceLifeNo;
@synthesize serviceLifeWt;
@synthesize capacity;
@synthesize capacityPrice;
@synthesize capacityNo;
@synthesize speedNo;
@synthesize speed;
@synthesize speedWt;
@synthesize num;

- (NSString *)WBPayManageEstimateViewType_archiContent {
    return [self.archiTypeName isEmpty] || !self.archiTypeName ? @"请选择": self.archiTypeName;
}

- (NSString *)WBPayManageEstimateViewType_brandContent {
    return [self.liftBrandName isEmpty] || !self.liftBrandName ? @"请选择": self.liftBrandName;
}

- (NSString *)WBPayManageEstimateViewType_capacityContent {
    return [self.capacityNo isEmpty] || !self.capacityNo ? @"请选择": self.capacity;
}

- (NSString *)WBPayManageEstimateViewType_floorContent {
    return self.floorNum == 0 ? @"请选择": [NSString stringWithFormat:@"%ld层",(long)self.floorNum];
}

- (NSString *)WBPayManageEstimateViewType_liftNumContent {
    return self.num == 0 ? @"请选择": [NSString stringWithFormat:@"%ld",(long)self.num];
}

- (NSString *)WBPayManageEstimateViewType_serviceContent {
    return [self.serviceLifeNo isEmpty] || !self.serviceLifeNo ? @"请选择": [NSString stringWithFormat:@"%ld年",(long)self.serviceLife];
}

- (NSString *)WBPayManageEstimateViewType_speedContent {
    return [self.speedNo isEmpty] || !self.speedNo ? @"请选择": self.speed;
}

- (NSString *)WBPayManageEstimateViewTypeInfoCell_liftNumContent {
    return [NSString stringWithFormat:@"数量：%ld",(long)self.num];
}


- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    LiftSceneDTO *copy = [[LiftSceneDTO allocWithZone:zone] init];
    copy->orderNo = [orderNo mutableCopy];
    copy->address = [address mutableCopy];
    copy->cityCode = [cityCode mutableCopy];
    copy->adname = [adname mutableCopy];
    copy->archiTypeName = [archiTypeName mutableCopy];
    copy->archiTypeNo = [archiTypeNo mutableCopy];
    copy->archiTypeWt = archiTypeWt;
    copy->floorNum = floorNum;
    copy->liftBrandName = [liftBrandName mutableCopy];
    copy->liftBrandNo = [liftBrandNo mutableCopy];
    copy->liftBrandWt = liftBrandWt;
    copy->serviceLife = serviceLife;
    copy->serviceLifeNo = [serviceLifeNo mutableCopy];
    copy->serviceLifeWt = serviceLifeWt;
    copy->capacityPrice = capacityPrice;
    copy->capacity = [capacity mutableCopy];
    copy->capacityNo = [capacityNo mutableCopy];
    copy->speedWt = speedWt;
    copy->num = num;
    copy->speed = [speed mutableCopy];
    copy->speedNo = [speedNo mutableCopy];
    return copy;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    LiftSceneDTO *copy = [[LiftSceneDTO allocWithZone:zone] init];
    copy->orderNo = [orderNo copy];
    copy->address = [address copy];
    copy->cityCode = [cityCode copy];
    copy->adname = [adname copy];
    copy->archiTypeName = [archiTypeName copy];
    copy->archiTypeNo = [archiTypeNo copy];
    copy->archiTypeWt = archiTypeWt;
    copy->floorNum = floorNum;
    copy->liftBrandName = [liftBrandName copy];
    copy->liftBrandNo = [liftBrandNo copy];
    copy->liftBrandWt = liftBrandWt;
    copy->serviceLife = serviceLife;
    copy->serviceLifeNo = [serviceLifeNo copy];
    copy->serviceLifeWt = serviceLifeWt;
    copy->capacityPrice = capacityPrice;
    copy->capacity = [capacity copy];
    copy->capacityNo = [capacityNo copy];
    copy->speedWt = speedWt;
    copy->num = num;
    copy->speed = [speed copy];
    copy->speedNo = [speedNo copy];
    return copy;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.orderNo forKey:@"orderNo"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.cityCode forKey:@"cityCode"];
    [aCoder encodeObject:self.adname forKey:@"adname"];
    [aCoder encodeObject:self.archiTypeName forKey:@"archiTypeName"];
    [aCoder encodeObject:self.archiTypeNo forKey:@"archiTypeNo"];
    [aCoder encodeDouble:self.archiTypeWt forKey:@"archiTypeWt"];
    [aCoder encodeInteger:self.floorNum forKey:@"floorNum"];
    [aCoder encodeObject:self.liftBrandName forKey:@"liftBrandName"];
    [aCoder encodeObject:self.liftBrandNo forKey:@"liftBrandNo"];
    [aCoder encodeDouble:self.liftBrandWt forKey:@"liftBrandWt"];
    [aCoder encodeInteger:self.serviceLife forKey:@"serviceLife"];
    [aCoder encodeDouble:self.serviceLifeWt forKey:@"serviceLifeWt"];
    [aCoder encodeObject:self.serviceLifeNo forKey:@"serviceLifeNo"];
    [aCoder encodeObject:self.capacity forKey:@"capacity"];
    [aCoder encodeObject:self.capacityNo forKey:@"capacityNo"];
    [aCoder encodeDouble:self.capacityPrice forKey:@"capacityPrice"];
    [aCoder encodeObject:self.speed forKey:@"speed"];
    [aCoder encodeObject:self.speedNo forKey:@"speedNo"];
    [aCoder encodeDouble:self.speedWt forKey:@"speedWt"];
    [aCoder encodeInteger:self.num forKey:@"num"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.orderNo = [aDecoder decodeObjectForKey:@"orderNo"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.cityCode = [aDecoder decodeObjectForKey:@"cityCode"];
        self.adname = [aDecoder decodeObjectForKey:@"adname"];
        self.archiTypeName = [aDecoder decodeObjectForKey:@"archiTypeName"];
        self.archiTypeNo = [aDecoder decodeObjectForKey:@"archiTypeNo"];
        self.archiTypeWt = [aDecoder decodeDoubleForKey:@"archiTypeWt"];
        self.floorNum = [aDecoder decodeIntegerForKey:@"floorNum"];
        self.liftBrandName = [aDecoder decodeObjectForKey:@"liftBrandName"];
        self.liftBrandNo = [aDecoder decodeObjectForKey:@"liftBrandNo"];
        self.liftBrandWt = [aDecoder decodeDoubleForKey:@"liftBrandWt"];
        self.serviceLife = [aDecoder decodeIntegerForKey:@"serviceLife"];
        self.serviceLifeWt = [aDecoder decodeDoubleForKey:@"serviceLifeWt"];
        self.serviceLifeNo = [aDecoder decodeObjectForKey:@"serviceLifeNo"];
        self.capacity = [aDecoder decodeObjectForKey:@"capacity"];
        self.capacityNo = [aDecoder decodeObjectForKey:@"capacityNo"];
        self.capacityPrice = [aDecoder decodeDoubleForKey:@"capacityPrice"];
        self.speed = [aDecoder decodeObjectForKey:@"speed"];
        self.speedNo = [aDecoder decodeObjectForKey:@"speedNo"];
        self.speedWt = [aDecoder decodeDoubleForKey:@"speedWt"];
        self.num = [aDecoder decodeIntegerForKey:@"num"];
    }
    return self;
}

-(void)saveLiftSceneDTO
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archivier = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archivier encodeObject:self forKey:@"liftScene"];
    [archivier finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%@_liftScene",[WBUserManager DefaultManager].userInfo.baseInfo.mobilephone]];
}

+(LiftSceneDTO *)getSaveLiftSceneDTO
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_liftScene",[WBUserManager DefaultManager].userInfo.baseInfo.mobilephone]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    LiftSceneDTO *liftDTO = [unarchiver decodeObjectForKey:@"liftScene"];
    [unarchiver finishDecoding];
    return liftDTO;
}

+(void)saveLiftSceneDTOArray:(NSArray *)sceneArray
{
    [NSKeyedArchiver archiveRootObject:sceneArray toFile:[LiftSceneDTO getSavePath]];
}

+(NSArray *)getSaveLiftSceneDTOArray
{
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[LiftSceneDTO getSavePath]];
    return array;
}

+(NSString *)getSavePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    NSString *savePathString = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_liftScene.plist",[WBUserManager DefaultManager].userInfo.baseInfo.mobilephone]];
    return savePathString;
}

+(void)clearSaveLiftScene
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_liftScene",[WBUserManager DefaultManager].userInfo.baseInfo.mobilephone]];
    
    NSFileManager *manager=[NSFileManager defaultManager]; //文件路径
    if ([manager removeItemAtPath:[LiftSceneDTO getSavePath] error:nil])
    {
        NSLog(@"文件删除成功");
    }
}

@end
