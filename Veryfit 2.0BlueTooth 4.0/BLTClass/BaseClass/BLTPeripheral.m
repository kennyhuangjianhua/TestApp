//
//  BLTPeripheral.m
//  Warm
//
//  Created by 黄建华 on 15/8/11.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "BLTPeripheral.h"
#import "BLTUUID.h"
#import "BLTAcceptModel.h"

@interface BLTPeripheral ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, assign) CBCharacteristicWriteType writeType;
@property (nonatomic, assign) CBCharacteristic *readCharac;

@end

@implementation BLTPeripheral

DEF_SINGLETON(BLTPeripheral)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _receiveData = [[NSMutableData alloc] init];
        _writeType = CBCharacteristicWriteWithResponse;
    }
    
    return self;
}

- (void)setPeripheral:(CBPeripheral *)peripheral
{
    _peripheral = peripheral;
}

- (void)startUpdateRSSI
{
    [self stopTimer];
    
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateRSSI) userInfo:nil repeats:YES];
    }
}

- (void)updateRSSI
{
    if (_peripheral)
    {
        [_peripheral readRSSI];
    }
}

- (void)stopUpdateRSSI
{
    [self stopTimer];
}

- (void)stopTimer
{
    if (_timer)
    {
        if ([_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

#pragma mark --- CBPeripheralDelegate 数据更新 ---
// 时时更新信号强度
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    if (_rssiBlock)
    {
        NSInteger rssi = ABS([RSSI integerValue]);
        _rssiBlock(rssi);
    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (_rssiBlock)
    {
        NSInteger rssi = ABS([peripheral.RSSI integerValue]);
        _rssiBlock(rssi);
    }
}

- (void)senderDataToPeripheral:(NSData *)data
{
    if (_peripheral.state == CBPeripheralStateConnected)
    {
        CBUUID *serviceUUID = BLTUUID.uartServiceUUID;
        CBUUID *charaUUID = BLTUUID.txCharacteristicUUID;
        UInt8 val[20] = {0};
        [data getBytes:&val length:data.length];
        if (val[0] == 0x08)
        {
            charaUUID = BLTUUID.bigDataWriteCharacteristicUUID;
        }
        
        CBService *service = [self searchServiceFromUUID:serviceUUID withPeripheral:_peripheral];
        
        if (!service)
        {
            NSLog(@"service有错误...");
            [[BLTManager sharedInstance] disConnectPeripheral];
            // SHOWMBProgressHUD(BL_Text(@"Error, reconnect"), nil, nil, NO, 3.0);
            return;
        }
        
        CBCharacteristic *chara = [self searchCharacteristcFromUUID:charaUUID withService:service];
        if (!chara)
        {
            NSLog(@"chara有错误...");
            [[BLTManager sharedInstance] disConnectPeripheral];
            // SHOWMBProgressHUD(BL_Text(@"Error, reconnect"), nil, nil, NO, 3.0);
            return;
        }
        
        NSLog(@"写入数据..%@..%@", data, [BLTAcceptModel sharedInstance].updateValue);
        [_peripheral writeValue:data forCharacteristic:chara type:_writeType];
    }
}


#pragma mark --- CBPeripheralDelegate ---
// 发现该设备所持有的所有服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"发生错误.");
//        [[BLTManager sharedInstance] dismissLinkAndRepeatConnect];
    }
    
    for (CBService *service in peripheral.services)
    {
        if ([service.UUID isEqual:BLTUUID.uartServiceUUID])
        {
            // self.blService = service;
            [_peripheral discoverCharacteristics:@[BLTUUID.txCharacteristicUUID,
                                                   BLTUUID.rxCharacteristicUUID,
                                                   BLTUUID.bigDataWriteCharacteristicUUID,
                                                   BLTUUID.bigDataReadCharacteristicUUID]
                                      forService:service];
        }
        else if ([service.UUID isEqual:BLTUUID.deviceInformationServiceUUID])
        {
            [_peripheral discoverCharacteristics:@[BLTUUID.hardwareRevisionStringUUID] forService:service];
        }
        else if ([service.UUID isEqual:BLTUUID.updateServiceUUID])
        {
            [_peripheral discoverCharacteristics:@[BLTUUID.controlPointCharacteristicUUID,
                                                   BLTUUID.packetCharacteristicUUID,
                                                   BLTUUID.versionCharacteristicUUID] forService:service];
        }
        // NSLog(@"service.UUID. = ...%@。%@", service, service.UUID.description);
    }
}

// 发现该服务所持有的所有特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"特征错误...");
//        [[BLTManager sharedInstance] dismissLinkAndRepeatConnect];
    }
    
    for (CBCharacteristic *charac in service.characteristics)
    {
        if ([charac.UUID isEqual:BLTUUID.rxCharacteristicUUID])
        {
            [_peripheral setNotifyValue:YES forCharacteristic:charac];
            
            if (_connectBlock)
            {
                _connectBlock();
            }
            
//            [[BLTSimpleSend sharedInstance] sendContinuousInstruction];
        }
        else if ([charac.UUID isEqual:BLTUUID.txCharacteristicUUID])
        {
            [self readBluetoothWrittenWay:charac.properties];
            // [_peripheral readValueForCharacteristic:charac];
            _readCharac = charac;
        }
        else if ([charac.UUID isEqual:BLTUUID.bigDataWriteCharacteristicUUID])
        {
        }
        else if ([charac.UUID isEqual:BLTUUID.bigDataReadCharacteristicUUID])
        {
            [_peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        else if ([charac.UUID isEqual:BLTUUID.hardwareRevisionStringUUID])
        {
        }
        else if ([charac.UUID isEqual:BLTUUID.controlPointCharacteristicUUID])
        {
            [_peripheral setNotifyValue:YES forCharacteristic:charac];
//            [BLTDFUHelper sharedInstance].controlPointChar = charac;
        }
        else if ([charac.UUID isEqual:BLTUUID.packetCharacteristicUUID])
        {
//            [BLTDFUHelper sharedInstance].packetChar = charac;
        }
        else if ([charac.UUID isEqual:BLTUUID.versionCharacteristicUUID])
        {
            [_peripheral readValueForCharacteristic:charac];
//            [BLTDFUHelper sharedInstance].versionChar = charac;
        }
        
        // NSLog(@"charac. = .%@...%@", charac.UUID, charac);
    }
}

// 外围设备数据有更新时会触发该方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"数据更新错误...");
//        [[BLTManager sharedInstance] dismissLinkAndRepeatConnect];
        // SHOWMBProgressHUD(BL_Text(@"Error, reconnect"), nil, nil, NO, 3.0);
    }
    else
    {
        // NSLog(@"..%@..%@", characteristic.value, characteristic.UUID);
        if ([characteristic.UUID isEqual:BLTUUID.rxCharacteristicUUID])
        {
            [self cleanMutableData:_receiveData];
            [_receiveData appendData:characteristic.value];
            
            if ([BLTAcceptModel sharedInstance].dataType == BLTAcceptModelDataTypeUnKnown)
            {
                if (_updateBlock)
                {
                    _updateBlock(_receiveData, peripheral);
                }
            }
            else
            {
                if (_updateBigDataBlock)
                {
                    _updateBigDataBlock(_receiveData);
                }
            }
        }
        else if ([characteristic.UUID isEqual:BLTUUID.bigDataReadCharacteristicUUID])
        {
            [self cleanMutableData:_receiveData];
            [_receiveData appendData:characteristic.value];
            
            if ([BLTAcceptModel sharedInstance].dataType == BLTAcceptModelDataTypeUnKnown)
            {
                if (_updateBlock)
                {
                    _updateBlock(_receiveData, peripheral);
                }
            }
            else
            {
                if (_updateBigDataBlock)
                {
                    _updateBigDataBlock(_receiveData);
                }
            }
        }
        else if ([characteristic.UUID isEqual:BLTUUID.controlPointCharacteristicUUID] ||
                 [characteristic.UUID isEqual:BLTUUID.packetCharacteristicUUID])
        {
//            [[BLTDFUHelper sharedInstance] processDFUResponse:(uint8_t *)(characteristic.value.bytes)];
        }
        else if ([characteristic.UUID isEqual:BLTUUID.versionCharacteristicUUID])
        {
//            const uint8_t *version = [characteristic.value bytes] ;
//            [[BLTDFUHelper sharedInstance] onReadDfuVersion:version[0]];
        }
    }
}

// 向设备写数据时会触发该代理...
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"写数据时发生错误...");
//        [[BLTManager sharedInstance] dismissLinkAndRepeatConnect];
        // SHOWMBProgressHUD(BL_Text(@"Error, reconnect"), nil, nil, NO, 3.0);
    }
    
    if ([BLTManager sharedInstance].isUpdateing)
    {
//        if (characteristic == [BLTDFUHelper sharedInstance].controlPointChar)
//        {
//            
//        }
    }
}

#pragma mark --- receiveData 数据清空 ---
- (void)cleanMutableData:(NSMutableData *)data
{
    [data resetBytesInRange:NSMakeRange(0, data.length)];
    [data setLength:0];
}

// 读取当前设备蓝牙写入的方式.
- (void)readBluetoothWrittenWay:(NSInteger)properties
{
    NSInteger val[8] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};
    for (int i = 7; i >= 0; i--)
    {
        if (properties >= val[i])
        {
            if (val[i] >= 0x04)
            {
                if (val[i] == 0x08)
                {
                    _writeType = CBCharacteristicWriteWithResponse;
                    break;
                }
                else if (val[i] == 0x04)
                {
                    NSLog(@"...非响应式回复.");
                    _writeType = CBCharacteristicWriteWithoutResponse;
                    break;
                }
                else
                {
                    NSInteger tmp = properties - val[i];
                    if (tmp > 0x08)
                    {
                        [self readBluetoothWrittenWay:val[i]];
                    }
                    else
                    {
                        [self readBluetoothWrittenWay:tmp];
                    }
                    break;
                }
            }
            else
            {
                break;
            }
        }
    }
}

// 匹配相应的服务
- (CBService *)searchServiceFromUUID:(CBUUID *)uuid withPeripheral:(CBPeripheral *)peripheral
{
    for (int i = 0; i < peripheral.services.count; i++)
    {
        CBService *service = peripheral.services[i];
        if ([service.UUID isEqual:uuid])
        {
            return service;
        }
    }
    
    return  nil;
}

// 匹配相应的具体特征
- (CBCharacteristic *)searchCharacteristcFromUUID:(CBUUID *)uuid withService:(CBService *)service
{
    for (int i = 0; i < service.characteristics.count; i++)
    {
        CBCharacteristic *chara = service.characteristics[i];
        if ([chara.UUID isEqual:uuid])
        {
            return chara;
        }
    }
    
    return nil;
}

@end
