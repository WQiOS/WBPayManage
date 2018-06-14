//
//  LiftSceneDTO.h
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/6.
//

#import <Foundation/Foundation.h>

@protocol WBPayManageEstimateViewType <NSObject>

- (NSString *)WBPayManageEstimateViewType_archiContent;
- (NSString *)WBPayManageEstimateViewType_floorContent;
- (NSString *)WBPayManageEstimateViewType_brandContent;
- (NSString *)WBPayManageEstimateViewType_serviceContent;
- (NSString *)WBPayManageEstimateViewType_capacityContent;
- (NSString *)WBPayManageEstimateViewType_speedContent;
- (NSString *)WBPayManageEstimateViewType_liftNumContent;
- (NSString *)WBPayManageEstimateViewTypeInfoCell_liftNumContent;

@end

@interface LiftSceneDTO : NSObject <WBPayManageEstimateViewType,NSCopying,NSMutableCopying,NSCoding>

@property (nonatomic, copy) NSString *orderNo;          //订单编号
@property (nonatomic, copy) NSString *address;          //详细地址
@property (nonatomic, copy) NSString *cityCode;         //城市编码
@property (nonatomic, copy) NSString *adname;           //区域名称（浙江省-杭州市-滨江区）
@property (nonatomic, copy) NSString *archiTypeName;    //建筑类型名称
@property (nonatomic, copy) NSString *archiTypeNo;      //建筑种类编码
@property (nonatomic, assign) double archiTypeWt;       //建筑权重
@property (nonatomic, assign) NSInteger floorNum;       //楼层数量
@property (nonatomic, copy) NSString *liftBrandName;    //电梯品牌名称
@property (nonatomic, copy) NSString *liftBrandNo;      //电梯种类编码
@property (nonatomic, assign) double liftBrandWt;       //电梯权重
@property (nonatomic, assign) NSInteger serviceLife;    //使用年限
@property (nonatomic, assign) double serviceLifeWt;     //使用年限权重
@property (nonatomic, copy) NSString *serviceLifeNo;    //使用年限编码
@property (nonatomic, copy) NSString *capacity;         //载重量
@property (nonatomic, copy) NSString *capacityNo;       //载重编码
@property (nonatomic, assign) double capacityPrice;     //载重价格
@property (nonatomic, copy) NSString *speed;            //速度
@property (nonatomic, copy) NSString *speedNo;          //速度编码
@property (nonatomic, assign) double speedWt;           //速度权重
@property (nonatomic, assign) NSInteger num;            //电梯数量

-(void)saveLiftSceneDTO;
+(LiftSceneDTO *)getSaveLiftSceneDTO;

+(void)saveLiftSceneDTOArray:(NSArray *)sceneArray;
+(NSArray *)getSaveLiftSceneDTOArray;
+(NSString *)getSavePath;
+(void)clearSaveLiftScene;
@end
