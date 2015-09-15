//
//  BltModel.m
//  Warm
//
//  Created by 黄建华 on 15/8/10.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "BltModel.h"

@implementation BltModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _bltName = @"";
        _bltUUID = @"";
        _bltRSSI = @"";
        _deviceID = @"";
        _firmWare = @"";
        _runType = @"";
        _batteryState = @"";
        _batteryValue = @"";
        _boindFlag = @"";
    }
    return self;
}

+ (void)initialize
{
    [self removePropertyWithColumnName:@"peripheral"];
    [self removePropertyWithColumnName:@"bltRSSI"];
    [self removePropertyWithColumnName:@"bltVersion"];

}

+ (instancetype)initWithUUID:(NSString *)uuid
{
    BltModel *model = [[BltModel alloc] init];
    
    model.bltUUID = uuid;
    
    return model;
}

+ (BltModel *)getModelFromDBWtihUUID:(NSString *)uuid
{
    // 避免数据库的循环使用.
    [ShareData sharedInstance].isAllowBLTSave = NO;
    
    NSString *where = [NSString stringWithFormat:@"bltUUID = '%@'", uuid];
    BltModel *model = [BltModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [BltModel initWithUUID:uuid];
        
        [model saveToDB];
    }

//    根据uuid获取闹钟模型
//    [model setAlarmArrayAndRemindArrayWithUUID:uuid];
    
    [ShareData sharedInstance].isAllowBLTSave = YES;
    
    return model;
}

// 更新当前模型到数据库.
- (void)updateCurrentModelToDB
{
    if ([ShareData sharedInstance].isAllowBLTSave)
    {
        [BltModel updateToDB:self where:nil];
    }
}

- (void)setBltRSSI:(NSString *)bltRSSI
{
    _bltRSSI = bltRSSI;
    [self updateCurrentModelToDB];
}

- (void)setIsBoind:(BOOL)isBoind
{
    _isBoind = isBoind;
    
    [self updateCurrentModelToDB];
}

- (void)setDeviceID:(NSString *)deviceID
{
    _deviceID = deviceID;
    [self updateCurrentModelToDB];
}

- (void)setFirmWare:(NSString *)firmWare
{
    _firmWare = firmWare;
    [self updateCurrentModelToDB];
}

- (void)setRunType:(NSString *)runType
{
    _runType = runType;
    [self updateCurrentModelToDB];
}

- (void)setBatteryState:(NSString *)batteryState
{
    _batteryState = batteryState;
    [self updateCurrentModelToDB];
}

- (void)setBatteryValue:(NSString *)batteryValue
{
    _batteryValue = batteryValue;
    [self updateCurrentModelToDB];
}

- (void)setBoindFlag:(NSString *)boindFlag
{
    _boindFlag = boindFlag;
    [self updateCurrentModelToDB];
}

- (void)setTime:(NSString *)time
{
    _time = time;
    [self updateCurrentModelToDB];
}

- (void)setWeekDays:(NSString *)weekDays
{
    _weekDays = weekDays;
    [self updateCurrentModelToDB];
}

//- (void)

// 主建
+ (NSString *)getPrimaryKey
{
    return @"bltUUID";
}

// 表名
+ (NSString *)getTableName
{
    return @"BLTModel";
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

@end
