//
//  BLTAcceptModel.m
//  Warm
//
//  Created by 黄建华 on 15/8/11.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "BLTAcceptModel.h"
#import "BLTPeripheral.h"

@implementation BLTAcceptModel


DEF_SINGLETON(BLTAcceptModel)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        _lastSerial = -999;
//        _shakeArray = [[NSMutableArray alloc] init];
//        _syncData = [[NSMutableData alloc] init];
//        _indexArray = [[NSMutableArray alloc] init];
//        
        // 直接启动蓝牙
//        [BLTManager sharedInstance];
        
        // DEF_WEAKSELF_(BLTAcceptModel);
        
        /**
         *  普通数据得更新
         *
         *  @param data 传入得数据data
         *
         *  @return
         */
        
        [BLTPeripheral sharedInstance].updateBigDataBlock = ^(NSData *data)
        {
            [self updateBigData:data];
        };
        
        [BLTPeripheral sharedInstance].updateBlock = ^(NSData *data, CBPeripheral *peripheral)
        {
            [self acceptData:data withPeripheral:peripheral];
        };
        
    }
    return self;
}

- (void)updateBigData:(NSData *)data
{
    NSLog(@"接受大数据  >>>>%@",data);
}

- (void)acceptData:(NSData *)data withPeripheral:(CBPeripheral *)peripheral
{
//    NSLog(@"接受普通数据 >>>>%@",data);

    _type = BLTAcceptModelTypeSuccess;
    UInt8 val[20] = {0};
    [data getBytes:&val length:data.length];
    
    NSLog(@"接受普通数据 [ command_id: %x |key:%x ] %x..%x..%x..%x..%x..%x ..%x ..%x", val[0], val[1], val[2], val[3], val[4], val[5],val[6],val[7],val[8],val[9]);
    id object = nil;
    
    if (val[0] == 0x06) // 进入拍照模式
    {
        if (val[1] == 0x02)
        {
            _type = BLTAcceptModelPhotoControl;
            object = data;
        }
    }
    
    else if (val[0] == 0x04 ) // 绑定指令
    {
        if (val [2] == 0x00)
        {
            if (val[1] == 0x01)
            {
                _type = BLTAcceptModelTypeBindingSuccess;
            }
            else
            {
                _type = BLTAcceptModelTypeRemoveBindingSuccess;
            }
        }
        else
        {
            if (val[1] == 0x01)
            {
                _type = BLTAcceptModelTypeBindingFail;
            }
            else
            {
                _type = BLTAcceptModelTypeRemoveBindingFail;
            }
        }
    }
    else if(val[0] == 0x02 ) // 获取设备信息
    {
        if (val[1] == 0x01 ) // 基本信息
        {
            _type = BLTAcceptModelTypeDeviceInfo;
            
            int deviceId = val[2] + val[3] * 256;
            
            NSArray *array = [[NSArray alloc] initWithObjects:@(deviceId),@(val[4]),@(val[5]),@(val[6]),@(val[7]),@(val[8]), nil];
            object = array;
        }
        else if(val[1] == 0x03) // 设备时间
        {
            _type = BLTAcceptModelTypeDeviceTime;
            int year = val[2] + val[3] *256;
            int month = val[4];
            int day = val[5];
            int hour = val[6];
            int minute = val[7];
            int second = val[8];
            int week_day = val[9] + 1;
            
            NSString *time = [NSString stringWithFormat:@"%d-%d-%d %d-%d-%d",year,month,day,hour,minute,second];
            
            NSArray *array = [[NSArray alloc] initWithObjects:time,@(week_day), nil];
            object = array;
        }
    }
    else if (val[0] == 0x07) // 事件控制
    {
        if (val[1] == 0x01)
        {
            _type = BLTAcceptModelPhotoControlType;
            
            if (val[2] == 0x06)
            {
            [_BLTControlTDelegate bltControlTakePhoto];
            }
        }
    }
    else if (val[0] == 0x03) //设置时间
    {
        if(val[1] == 0x01)
        {
            _type = BLTAcceptModelTypeSetDateInfo;
        }
        else if (val[1] == 0x10)
        {
            if (val[2] == 0x00)
            {
                _type = BLTAcceptModelTypeSetUserInfo;
            }
            
        }
        else if (val[1] == 0x03)
        {
            _type = BLTAcceptModelTypeSetSportTarget;
        }
        else if (val[1] == 0x04)
        {
            _type = BLTAcceptModelTypeSetSleepTarget;
        }

    }
    
    if (_updateValue)
    {
        _updateValue(object, _type);
        _updateValue = nil;
    }

}

@end
