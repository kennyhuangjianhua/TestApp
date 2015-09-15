//
//  BLTAcceptModel.h
//  Warm
//
//  Created by 黄建华 on 15/8/11.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLTControlTypeDelegate <NSObject>

- (void)bltControlTakePhoto;

@end

@interface BLTAcceptModel : NSObject

AS_SINGLETON(BLTAcceptModel)

typedef enum {                                     // 详细的看接口参数。
    BLTAcceptModelTypeUnKnown = 0,                 // 无状态
    BLTAcceptModelTypeBindingSuccess,
    BLTAcceptModelTypeBindingFail,
    BLTAcceptModelTypeRemoveBindingSuccess,
    BLTAcceptModelTypeRemoveBindingFail,
    
//    BLTAcceptModelTypeUnKnown = 0,               // 无状态
//    BLTAcceptModelTypeBindingSuccess,            // 绑定成功
//    BLTAcceptModelTypeBindingTimeout,            // 绑定超时
//    BLTAcceptModelTypeBindingError,              // 绑定错误
//    BLTAcceptModelTypeUnBindingSuccess,          // 解绑成功
//    BLTAcceptModelTypeUnBindingFail,             // 解绑失败
//    
      BLTAcceptModelTypeDeviceInfo,                // 设备信息
      BLTAcceptModelTypeDeviceFunction,            // 设备支持功能
      BLTAcceptModelTypeDeviceTime,                // 设备时间信息
      BLTAcceptModelTypeSetDateInfo,               // 设置时间信息
     
      BLTAcceptModelTypeSetUserInfo,               // 用户信息
//    BLTAcceptModelTypeSetAlarmClock,             // 设置闹钟
//    BLTAcceptModelTypeSetRemind,                 // 设置久坐提醒
//    
    BLTAcceptModelTypeSetSportTarget,            // 设置运动目标
    BLTAcceptModelTypeSetSleepTarget,            // 设置睡眠目标
//
//    BLTAcceptModelTypeDataRequestSuccess,        // 数据请求成功
//    BLTAcceptModelTypeDataTodaySport,            // 今天运动数据
//    BLTAcceptModelTypeDataTodaySleep,            // 今天睡眠数据
//    BLTAcceptModelTypeDataHistorySport,          // 历史运动数据
//    BLTAcceptModelTypeDataHistorySleep,          // 历史睡眠数据.
//    
//    BLTAcceptModelTypeDataRequestEnd,               // 数据请求结束
//    BLTAcceptModelTypeDataTodaySportEnd,            // 今天运动数据请求结束
//    BLTAcceptModelTypeDataTodaySleepEnd,            // 今天睡眠数据请求结束
//    BLTAcceptModelTypeDataHistorySportEnd,          // 历史运动数据请求结束
//    BLTAcceptModelTypeDataHistorySleepEnd,          // 历史睡眠数据请求结束.
//    
//    BLTAcceptModelTypeRestoreData,                  // 恢复数据
//    
//    BLTAcceptModelTypeSetLostModel,              // 丢失报警方式
//    BLTAcceptModelTypeSetAlertModel,             // 寻找报警方式
//    BLTAcceptModelTypeFindDevice,                // 寻找设备
//    BLTAcceptModelTypeLostEvent,                 // 防丢事件
//    BLTAcceptModelTypeKeyEvent,                  // 按键事件
//    BLTAcceptModelTypeNoMuchElec,                // 没有足够的电量
//    BLTAcceptModelTypeNoSupport,                 // 不支持
    
      BLTAcceptModelTypeSuccess,                   // 通讯成功
      BLTAcceptModelTypeError,                      // 通讯错误
    
     /*手环控制*/
     BLTAcceptModelPhotoControl,
     BLTAcceptModelPhotoControlFail,
     /*事件控制类型*/
     BLTAcceptModelPhotoControlType
    
    
} BLTAcceptModelType;

typedef enum {
    BLTAcceptModelDataTypeUnKnown = 0,
    BLTAcceptModelDataTypeTodaySport = 1,
    BLTAcceptModelDataTypeTodaySleep = 2,
    BLTAcceptModelDataTypeHistorySport = 3,
    BLTAcceptModelDataTypeHistorySleep = 4,
} BLTAcceptModelDataType;

typedef void(^BLTAcceptModelUpdateValue)(id object, BLTAcceptModelType type);
@property (nonatomic, strong) BLTAcceptModelUpdateValue updateValue;
@property (nonatomic, assign) BLTAcceptModelType type;
@property (nonatomic, assign) BLTAcceptModelDataType dataType;

@property (nonatomic, strong) id <BLTControlTypeDelegate> BLTControlTDelegate;

@end
