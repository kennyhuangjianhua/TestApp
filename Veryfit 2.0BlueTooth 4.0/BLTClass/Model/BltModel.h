//
//  BltModel.h
//  Warm
//
//  Created by 黄建华 on 15/8/10.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BltModel : NSObject

// 蓝牙硬件所涉及的数据
@property (nonatomic, strong) CBPeripheral *peripheral; // 蓝牙外设
@property (nonatomic, strong) NSString *bltName;        // 设备的名字
@property (nonatomic, strong) NSString *bltUUID;        // 设备的uuid
@property (nonatomic, strong) NSString *bltRSSI;        // 设备的信号
@property (nonatomic, assign) BOOL isBoind;             // 是否绑定

// 设备基本信息 command_id:0x02 Key:0x01
@property (nonatomic, strong) NSString *deviceID;       // 设备id
@property (nonatomic, strong) NSString *firmWare;       // 固件版本号
@property (nonatomic, strong) NSString *runType;        // 运行模式
@property (nonatomic, strong) NSString *batteryState;   // 电池状态
@property (nonatomic, strong) NSString *batteryValue;   // 电池电量
@property (nonatomic, strong) NSString *boindFlag;      // 绑定标志

// 设备时间 command_id:0x02 Key:0x03
@property (nonatomic, strong) NSString *time;             // 设备时间
@property (nonatomic, strong) NSString *weekDays;         // 设备星期

//@property (nonatomic, assign) BOOL isPhotoControl;        // 是否拍照模式

+ (instancetype)initWithUUID:(NSString *)uuid;

// 从数据库获取模型.
+ (BltModel *)getModelFromDBWtihUUID:(NSString *)uuid;

@end
