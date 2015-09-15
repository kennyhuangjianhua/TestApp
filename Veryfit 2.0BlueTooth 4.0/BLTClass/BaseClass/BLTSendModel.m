//
//  BLTSendModel.m
//  PlaneCup
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTSendModel.h"
#import "BLTManager.h"

@implementation BLTSendModel

DEF_SINGLETON(BLTSendModel)

// 拍照控制
+ (void)sendControlTakePhotoState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UInt8 ControlType = 0x00;
    if(type)
    {
        ControlType = 0x00;
    }
    else
    {
        ControlType = 0x01;
    }
    UInt8 val[3] = {0x06, 0x02,ControlType};
    [self sendDataToWare:val
              withLength:3
              withUpdate:block];
}

// 绑定指令 type:yes为绑定 no 为解绑
+ (void)sendBoindDeviceState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    if (type)
    {
        UInt8 val[6] = {0x04, 0x01, 0x01, 83, 0x55, 0xaa};
        [self sendDataToWare:val
                  withLength:6
                  withUpdate:block];
    }
    else
    {
        UInt8 val[6] = {0x04, 0x02, 0x55, 0xaa, 0x55, 0xaa};
        [self sendDataToWare:val
                  withLength:6
                  withUpdate:block];
    }
}

// 获取设备信息 1 基本信息 2 支持功能 3 设备时间 4 获取mac地址 5 获取电池信息
+ (void)sendDeviceInfo:(BLTsendDeviceInfoType)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UInt8 val[2] = {0x02,type};
    if (type == BLTsendDeviceBasicInfo)
    {
        
    }
    else if (type == BLTsendDeviceBasicFunction)
    {
        
    }
    else if (type == BLTsendDeviceBasicTime)
    {
        
    }
    else if (type == BLTsendDeviceBasicMacAddress)
    {
        
    }
    else if (type == BLTsendDeviceBasicBattery)
    {
        
    }
    
    [self sendDataToWare:val
              withLength:2
              withUpdate:block];
}

// 设置用户信息
+ (void)sendSetUserInfoWithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    UserInfoModel *model = [UserInfoHelper sharedInstance].userModel;
    NSDate *date = [NSDate dateByString:model.birthDay];
    
    UInt8 val[10] = {0x03, 0x10, (NSInteger)model.height, (UInt8)(model.weight * 100), (UInt8)((NSInteger)(model.weight * 100) >> 8),
        model.genderSex, (UInt8)(date.year), (UInt8)(date.year >> 8), date.month, date.day};
    [self sendDataToWare:val
              withLength:10
              withUpdate:block];
}

// 时间设置.
+ (void)sendSetDeviceTimeWithUpdateBlock:(BLTAcceptModelUpdateValue)block
{
    NSDate *date = [NSDate date];
    NSInteger weekDay = (date.weekday == 1) ? 6 : date.weekday - 2;
    
    UInt8 val[10] = {0x03, 0x01, (UInt8)date.year, date.year >> 8, date.month,
        date.day, date.hour, date.minute, date.second, weekDay};
    
    [self sendDataToWare:val
              withLength:10
              withUpdate:block];
}

// 设置运动目标. 0722改一起设置睡眠
+ (void)sendSetSportTargetWithUpdateBlock:(BLTAcceptModelUpdateValue)block;
{
    NSInteger steps = [UserInfoHelper sharedInstance].userModel.targetSteps;
    NSInteger sleep = [UserInfoHelper sharedInstance].userModel.targetSleep;
    
    UInt8 val[9] = {0x03, 0x03, 0x00, (UInt8)steps, (UInt8)(steps >> 8),
        (UInt8)(steps >> 16), (UInt8)(steps >> 24), sleep / 60, sleep % 60};
    [self sendDataToWare:val
              withLength:9
              withUpdate:block];
}


+ (void)sendDataToWare:(UInt8 *)val
            withLength:(NSInteger)length
            withUpdate:(BLTAcceptModelUpdateValue)block
{
    usleep(2500);
    [BLTAcceptModel sharedInstance].updateValue = block;
    [BLTAcceptModel sharedInstance].type = BLTAcceptModelTypeUnKnown;
    [BLTAcceptModel sharedInstance].dataType = BLTAcceptModelDataTypeUnKnown;
    
    NSData *sData = [[NSData alloc] initWithBytes:val length:length];
    [[BLTPeripheral sharedInstance] senderDataToPeripheral:sData];
}



@end
