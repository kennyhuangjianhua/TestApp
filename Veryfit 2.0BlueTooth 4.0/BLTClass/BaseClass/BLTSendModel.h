//
//  BLTSendModel.h
//  PlaneCup
//
//  Created by zorro on 15/3/19.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#define BLT_Binding @"BLT_Binding"
#define BLT_InfoDelayTime 0.1 // 蓝牙通信间隔 避免造成堵塞.

#import <Foundation/Foundation.h>
#import "BLTAcceptModel.h"

@interface BLTSendModel : NSObject

//typedef void(^BLTSendDataBackUpdate)(NSDate *date);

AS_SINGLETON(BLTSendModel)

typedef enum
{
   BLTsendDeviceBasicInfo = 0x01,
   BLTsendDeviceBasicFunction = 0x02,
   BLTsendDeviceBasicTime = 0x03,
   BLTsendDeviceBasicMacAddress = 0x04,
   BLTsendDeviceBasicBattery = 0x05
    
}BLTsendDeviceInfoType;

// 拍照控制
+ (void)sendControlTakePhotoState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 绑定指令 type:yes为绑定 no 为解绑
+ (void)sendBoindDeviceState:(BOOL)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 获取设备信息 1 基本信息 2 支持功能 3 设备时间 4 获取mac地址 5 获取电池信息
+ (void)sendDeviceInfo:(BLTsendDeviceInfoType)type WithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 时间设置.
+ (void)sendSetDeviceTimeWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 设置用户信息
+ (void)sendSetUserInfoWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 设置运动目标. 0722改一起设置睡眠
+ (void)sendSetSportTargetWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

// 设置睡眠目标.
+ (void)sendSetSleepTargetWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

- (void)updateDevice;

@end
