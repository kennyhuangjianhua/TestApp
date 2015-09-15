//
//  BLTManager.m
//  Warm
//
//  Created by 黄建华 on 15/8/10.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "BLTManager.h"
#import "BLTPeripheral.h"
#import "BLTUUID.h"
#import "BackGroundTaskView.h"
@interface BLTManager () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *discoverPeripheral;
@property (nonatomic, strong) NSTimer *scanDeviceTimer;    //扫描设备的定时器

@end

@implementation BLTManager

DEF_SINGLETON(BLTManager)

- (instancetype) init
{
    self = [super init];
    if (self)
    {
    _allWareArray = [[NSMutableArray alloc] initWithCapacity:0];
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _scanTime = CONNECTTIME;
    
    [self loadRssi];
        
    [BackGroundTaskView sharedInstance];
        
    }
    return self;
}

- (void)loadRssi
{
    DEF_WEAKSELF_(BLTManager)
    [BLTPeripheral sharedInstance].rssiBlock = ^(NSInteger RSSI) {
        [weakSelf updateRSSI:RSSI];
    };
}

- (void)updateRSSI:(NSInteger)RSSI
{
    _model.bltRSSI = [NSString stringWithFormat:@"%ld", (long)RSSI];
//    NSLog(@"更新信号强度:%@",_model.bltRSSI);
    NSString *rssiValue = [NSString stringWithFormat:@"%lu",RSSI];
    
    NSArray *getArray = [[NSArray alloc] initWithArray:_allWareArray];
    for (BltModel *model in getArray)
    {
        if ([model.bltUUID isEqualToString:_model.bltUUID])
        {
            [_allWareArray removeObject:model];
            [_allWareArray addObject:_model];
        }
    }
//    NSArray * Devices=[[NSMutableArray alloc]initWithArray:[self sortByNumberWithArray:_allWareArray withSEC:NO]];
//    _allWareArray = [[NSMutableArray alloc] initWithArray:Devices];
    [self updateViewsFromModel];
    
    if (_BLTManagerHandleBlock)
    {
        _BLTManagerHandleBlock (BLTModelRssi ,rssiValue);
    }
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        [self scanDevice:_scanTime];
        if (_BLTManagerHandleBlock)
        {
            _BLTManagerHandleBlock(BLTModelPowerOn,nil);
        }
    }
    else
    {
        if (_BLTManagerHandleBlock)
        {
            _BLTManagerHandleBlock(BLTModelPowerOff,nil);
        }
    }
}

- (void)scanDevice:(CGFloat)time
{
    _scanTime = time;
    
    SHOWMBProgressHUD(@"开始扫描",nil, nil, NO, 1.0);
    if (_scanDeviceTimer)
    {
        [_scanDeviceTimer invalidate];
        _scanDeviceTimer = nil;
    }
    _scanDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(stopScan) userInfo:nil repeats:NO];
    
    // 先停止扫描然后继续扫描. 避免因为多线程操作设备数组导致崩溃.
    [_centralManager stopScan];
    
    [_allWareArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BltModel *model = obj;
        switch (model.peripheral.state)
        {
            case CBPeripheralStateConnected:
                [_centralManager cancelPeripheralConnection:_discoverPeripheral];
                [_allWareArray removeObject:model];
                break;
                
            default:
            {
                [_allWareArray removeObject:model];
            }
                break;
        }
    }];
    [_centralManager scanForPeripheralsWithServices:@[BLTUUID.uartServiceUUID]
                                        options:nil];
}

- (BOOL)isConnect
{
    if (_discoverPeripheral.state == CBPeripheralStateConnected)
    {
        return YES;
    }
    
    return NO;
}

- (void)stopScan
{
    SHOWMBProgressHUD(@"停止扫描",nil, nil, NO, 1.0);
    [_scanDeviceTimer invalidate];
    _scanDeviceTimer = nil;
    [_centralManager stopScan];

    if (_lastUuid)
    {
        NSLog(@"绑定的设备 uuid>>>>%@",_lastUuid);
    }
    else
    {
        NSLog(@"没有绑定设备>>>>请选择设备>>%@",_allWareArray);
        SHOWMBProgressHUD(@"没有绑定设备,请去绑定设备", nil, nil, NO, 1.0);
    }
    
//        NSArray * Devices=[[NSMutableArray alloc]initWithArray:[self sortByNumberWithArray:_allWareArray withSEC:NO]];
    [self updateViewsFromModel];
}

#pragma mark --- 按RSSI排序 ---
- (NSArray *)sortByNumberWithArray:(NSArray *)array withSEC:(BOOL)sec
{
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:array];
    
    [muArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         BltModel *model1 = (BltModel *)obj1;
         BltModel *model2 = (BltModel *)obj2;
         
         if ((model1.bltRSSI > model2.bltRSSI ) == sec)
         {
             return NSOrderedAscending;
         }
         else
         {
             return NSOrderedDescending;
         }
     }];
    return muArray;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//     NSLog(@"..%@..%@..%@", advertisementData, [peripheral.identifier UUIDString], peripheral.name);
    
    NSString *deviceName1 = peripheral.name;
    NSString *deviceName2 = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    
    NSString *idString = [peripheral.identifier UUIDString];
    
    if (!idString)
    {
        return;
    }
    
    NSLog(@"Device >>>>..%@..%@..%@", advertisementData, [peripheral.identifier UUIDString], peripheral.name);
    
    if (!_isUpdateing)
    {
            BltModel *model = [self checkIsAddInAllWareWithID:idString];
        if (model)
        {
            NSLog(@"已经存在device >>更新设备信息>>>");
            model.bltRSSI = [NSString stringWithFormat:@"%d", ABS(RSSI.intValue)];
            model.peripheral = peripheral;
        }
        else
        {
            // 从数据库取当前设备的模型.
            model = [BltModel getModelFromDBWtihUUID:idString];
            model.bltName = deviceName1 ? deviceName1 : (deviceName2 ? deviceName2 : @"");
            model.bltRSSI = [NSString stringWithFormat:@"%d", ABS(RSSI.intValue)];
            model.peripheral = peripheral;
            
            [_allWareArray addObject:model];
            
        }
        
        _lastUuid = [ BOINDUUID getObjectValue];
        
        if ( [_lastUuid isEqualToString:model.bltUUID])
        {
            [self connectPeripheralWithModel:model];
//            [self connectPeripheralWithBoindModel];
            [self stopScan];
        }
        [self updateViewsFromModel];
        
//        if ([lastUUID isEqualToString:model.bltUUID] && model.isBinding)
//        {
//            // 如果该设备已经绑定并且没有连接设备时就直接连接.
//            [self connectPeripheralWithModel:model];
//        }
    }
}

// 绑定已经连接过的设备
- (void)connectPeripheralWithBoindModel
{
    [_centralManager connectPeripheral:_model.peripheral options:nil];
}

- (void)connectPeripheralWithModel:(BltModel *)model
{
    if (model == nil)
    {
        return;
    }
    
    if ([_model.bltUUID isEqualToString:model.bltUUID])
    {
//        SHOWMBProgressHUD(@"同一个设备", nil, nil, NO, 1.0);
        if (model.peripheral.state != CBPeripheralStateConnected)
        {
            [_centralManager connectPeripheral:model.peripheral options:nil];
        }
    }
    else
    {
//        SHOWMBProgressHUD(@"不同一个设备", nil, nil, NO, 1.0);
        // 保存最后一次连接的设备
        if (_model.peripheral.state == CBPeripheralStateConnected)
        {
             [_centralManager cancelPeripheralConnection:_model.peripheral];
             _model = model;
             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectDevice) object:nil];
             [self performSelector:@selector(connectDevice) withObject:nil afterDelay:3.0];
//             SHOWMBProgressHUD(@"先断开之前设备", nil, nil, NO, 3.0);
        }
        else
        {
             _model = model;
            [self connectDevice];
        }
        
    }
    
//    if (model.peripheral.state == CBPeripheralStateConnected)
//    {
//        // 已经连接不作处理
//    }
//    
//    if (model.peripheral.state != CBPeripheralStateConnected)
//    {
//        if (_model)
//        {
//            // 将当前连接的模型干掉...
//            NSLog(@"准备连接新的设备...");
//          [_centralManager cancelPeripheralConnection:model.peripheral];
//        }
//        
//        _model = model;
//        _discoverPeripheral = model.peripheral;
//        [_centralManager connectPeripheral:_model.peripheral options:nil];
//
//        
//        [_centralManager stopScan];
//    }
}

// 断开当前连接设备
- (void)disConnectPeripheral
{
    if (_discoverPeripheral.state == CBPeripheralStateConnected)
    {
        [_centralManager cancelPeripheralConnection:_discoverPeripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _discoverPeripheral = peripheral;
    _discoverPeripheral.delegate = [BLTPeripheral sharedInstance];
    [BLTPeripheral sharedInstance].peripheral = _discoverPeripheral;
    NSLog(@"peripheral>>>>uuid>>>%@",[peripheral.identifier UUIDString]);
    
    if (!_isUpdateing)
    {
        [_discoverPeripheral discoverServices:@[BLTUUID.uartServiceUUID]];
        
        [[BLTPeripheral sharedInstance]startUpdateRSSI];
    }
    else
    {
        [_discoverPeripheral discoverServices:@[BLTUUID.updateServiceUUID]];
        
//        [BLTDFUHelper sharedInstance].updatePeripheral = _discoverPeripheral;
    }

    if (_BLTManagerHandleBlock)
    {
        _BLTManagerHandleBlock(BLTModelDidConnect,nil);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (_BLTManagerHandleBlock)
    {
        _BLTManagerHandleBlock(BLTModelDisConnect,nil);
    }
    
    if (!_isUpdateing)
    {
        [[BLTPeripheral sharedInstance]stopUpdateRSSI];
        [[BLTManager sharedInstance]connectDevice];
    }
    else
    {
        
    }
}

// 连接设备并停止扫描
- (void)connectDevice
{   SHOWMBProgressHUD(@"连接设备", nil, nil, NO, 1.0);
    [_centralManager connectPeripheral:_model.peripheral options:nil];
    _discoverPeripheral = _model.peripheral;
    [_centralManager stopScan];
}

// 检查设备是否存在
- (BltModel *)checkIsAddInAllWareWithID:(NSString *)idString
{
    for (BltModel *model in _allWareArray)
    {
        if ([model.bltUUID isEqualToString:idString])
        {
            return model;
        }
    }
    
    return nil;
}

// 只要外围设备发生变化了就通知刷新
- (void)updateViewsFromModel
{
    // 冒泡排序
    for (int i = 0; i < _allWareArray.count - 1; i++)
    {
        for (int j = 0; j < _allWareArray.count - 1 - i; j++)
        {
            BltModel *model1 = _allWareArray[j];
            BltModel *model2 = _allWareArray[j +1];
            
            if (model1.bltRSSI.intValue > model2.bltRSSI.intValue)
            {
                BltModel *temp = _allWareArray[j];
                _allWareArray[j] = _allWareArray[j + 1];
                _allWareArray[j + 1] = temp;
            }
        }
    }
    
    if (_BLTManagerHandleBlock)
    {
        _BLTManagerHandleBlock(BLTModelUpdateValue,_allWareArray);
    }
}

- (BOOL)checkBoind
{
    if ([BOINDUUID getObjectValue])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
